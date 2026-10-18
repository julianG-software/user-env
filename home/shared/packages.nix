{ pkgs, ... }: {
  home.packages = with pkgs; [
    eza
    oh-my-posh
    fzf
    btop
    jq
  ];
}
