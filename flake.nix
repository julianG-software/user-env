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

      # TODO: ephemeral packages for nix profile install / nix run
      # packages = forAllSystems (system: { ... });
    };
}
