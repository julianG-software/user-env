# Plugin paths injected by wrapper script via env vars
source "$ZSH_AUTOSUGGESTIONS_PLUGIN"
ZSH_AUTOSUGGEST_STRATEGY=(history)

source "$ZSH_OMZ_SUDO_PLUGIN"
source "$ZSH_OMZ_EXTRACT_PLUGIN"

autoload -U compinit && compinit

# History
HISTSIZE="10000"
SAVEHIST="10000"
# HISTFILE is set by the wrapper script (permanent: ~/.zsh_history, ephemeral: /dev/null)
setopt HIST_FCNTL_LOCK HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY
setopt NO_APPEND_HISTORY NO_EXTENDED_HISTORY

# fzf
eval "$(fzf --zsh)"

source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/prompt.zsh"
source "$ZDOTDIR/utils.zsh"

# Syntax highlighting (must be loaded last)
source "$ZSH_SYNTAX_HIGHLIGHTING_PLUGIN"
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)
