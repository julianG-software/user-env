{ lib, ... }: {
  programs.zsh.shellAliases = lib.mapAttrs (_: lib.mkDefault) {
    # eza (ls replacement)
    ls   = "eza --icons --git --long";
    ll   = "eza --icons --git --long";
    la   = "eza --icons --git --long -a";
    l    = "eza --icons --git";
    lt   = "eza --icons --git --long --sort=modified";
    tree = "eza --tree --icons";

    # Claude
    cc     = "claude";
    cc_res = "claude --resume";
  };
}
