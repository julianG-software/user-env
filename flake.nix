{
  description = "Portable personal environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-config = {
      url = "github:julianG-software/neovim-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      neovim-config,
      ...
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      mkHomeModule =
        role: neovimPreset:
        { pkgs, ... }:
        {
          imports = [ ./home/roles/${role}.nix ];
          _module.args.neovimPkg =
            neovim-config.packages.${pkgs.stdenv.hostPlatform.system}.${neovimPreset};
        };
    in
    {
      # Permanent install — import into homelab repo per host:
      #   imports = [ inputs.user-env.homeModules.development ];
      homeModules = {
        minimal = mkHomeModule "minimal" "basic";
        admin = mkHomeModule "admin" "config";
        development = mkHomeModule "development" "coding";
        full = mkHomeModule "full" "full";
      };

      # Ephemeral install — nix run github:julianG-software/user-env#<role>
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          nvimPkg = preset: neovim-config.packages.${system}.${preset};
          zdotdir = ./home/shared/zsh;

          mkPkg =
            {
              name,
              nvimPreset,
              extraPackages ? [ ],
              withTmux ? false,
            }:
            let
              tmuxPkgs = if withTmux then [ pkgs.tmux ] else [ ];
            in
            pkgs.writeShellApplication {
              inherit name;
              runtimeInputs =
                (with pkgs; [
                  pkgs.zsh
                  eza
                  oh-my-posh
                  fzf
                  btop
                  jq
                  (nvimPkg nvimPreset)
                ])
                ++ extraPackages
                ++ tmuxPkgs;
              text = ''
                export ZDOTDIR="${zdotdir}"
                export HISTFILE="/dev/null"
                export USER_ENV_EPHEMERAL=1
                export ZSH_AUTOSUGGESTIONS_PLUGIN="${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
                export ZSH_SYNTAX_HIGHLIGHTING_PLUGIN="${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
                export ZSH_OMZ_SUDO_PLUGIN="${pkgs.oh-my-zsh}/share/oh-my-zsh/plugins/sudo/sudo.plugin.zsh"
                export ZSH_OMZ_EXTRACT_PLUGIN="${pkgs.oh-my-zsh}/share/oh-my-zsh/plugins/extract/extract.plugin.zsh"
                export OMP_THEME_PATH="${pkgs.oh-my-posh}/share/oh-my-posh/themes/catppuccin_frappe.omp.json"

                ${
                  if withTmux then
                    ''
                      export SHELL="${pkgs.zsh}/bin/zsh"
                      if tmux has-session -t user-env 2>/dev/null; then
                        tmux attach-session -t user-env || true
                      else
                        tmux new-session -s user-env || true
                      fi
                      if [[ -f "$HOME/.user-env-cleanup" ]]; then
                        rm "$HOME/.user-env-cleanup"
                        nix profile wipe-history || true
                        nix-collect-garbage -d || true
                      fi
                    ''
                  else
                    ''
                      ${pkgs.zsh}/bin/zsh || true
                      nix profile wipe-history || true
                      nix-collect-garbage -d || true
                    ''
                }
              '';
            };
        in
        {
          minimal = mkPkg {
            name = "minimal";
            nvimPreset = "basic";
          };
          admin = mkPkg {
            name = "admin";
            nvimPreset = "config";
            extraPackages = with pkgs; [
              ripgrep
              fd
              yq-go
              delta
              nix-tree
              nix-diff
              direnv
            ];
            withTmux = true;
          };
          development = mkPkg {
            name = "development";
            nvimPreset = "coding";
            extraPackages = with pkgs; [
              ripgrep
              fd
              yq-go
              delta
              nix-tree
              nix-diff
              direnv
              lazygit
            ];
            withTmux = true;
          };
          full = mkPkg {
            name = "full";
            nvimPreset = "full";
            extraPackages = with pkgs; [
              ripgrep
              fd
              yq-go
              delta
              nix-tree
              nix-diff
              direnv
              lazygit
              wl-clipboard
              xclip
            ];
            withTmux = true;
          };
          default = self.packages.${system}.full;
        }
      );
    };
}
