{ ... }: {
  programs.git = {
    enable = true;

    settings.alias = {
      undo = "reset HEAD~";
    };
  };
}
