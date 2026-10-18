{ pkgs, ... }: {
  programs.zsh = {
    enable = true;

    history = {
      size       = 10000;
      save       = 10000;
      ignoreDups = true;
      ignoreSpace = true;
      share      = true;
    };

    initExtra = ''
      setopt HIST_FCNTL_LOCK

      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      ZSH_AUTOSUGGEST_STRATEGY=(history)

      source ${pkgs.oh-my-zsh}/share/oh-my-zsh/plugins/sudo/sudo.plugin.zsh
      source ${pkgs.oh-my-zsh}/share/oh-my-zsh/plugins/extract/extract.plugin.zsh

      eval "$(${pkgs.fzf}/bin/fzf --zsh)"

      eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init zsh \
        --config ${pkgs.oh-my-posh}/share/oh-my-posh/themes/catppuccin_frappe.omp.json)"

      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)
    '';
  };
}
