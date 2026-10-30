{ lib, pkgs, neovimPkg, ... }: {
  imports = [ ../shared ../shared/tmux.nix ];

  home.packages = with pkgs; [
    neovimPkg
    ripgrep
    fd
    yq-go
    delta
    nix-tree
    nix-diff
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.sessionVariables.EDITOR = lib.mkDefault neovimPkg.name;

  programs.zsh.shellAliases = lib.mapAttrs (_: lib.mkDefault) {
    vi  = neovimPkg.name;
    vim = neovimPkg.name;
  };
}
