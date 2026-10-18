{ ... }: {
  programs.tmux = {
    enable = true;
    extraConfig = ''
      unbind-key -a
      bind-key -n C-] command-prompt
    '';
  };
}
