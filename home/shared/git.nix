{ ... }: {
  programs.git = {
    enable = true;

    aliases = {
      undo = "reset HEAD~";
    };
  };
}
