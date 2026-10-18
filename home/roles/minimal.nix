{ lib, neovimPkg, ... }: {
  imports = [ ../shared ];

  home.packages = [ neovimPkg ];

  home.sessionVariables.EDITOR = lib.mkDefault neovimPkg.pname;

  programs.zsh.shellAliases = lib.mapAttrs (_: lib.mkDefault) {
    vi  = neovimPkg.pname;
    vim = neovimPkg.pname;
  };
}
