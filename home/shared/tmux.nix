{ ... }: {
  programs.tmux = {
    enable = true;
    prefix = "C-Space";
    extraConfig = ''
      unbind-key -a
      bind-key : command-prompt
      bind-key C-Space send-prefix
    '';
  };
}
