{ ... }: {
  programs.tmux = {
    enable = true;
    prefix = "C-]";
    extraConfig = ''
      unbind-key -a
      bind-key : command-prompt
      bind-key C-] send-prefix
    '';
  };
}
