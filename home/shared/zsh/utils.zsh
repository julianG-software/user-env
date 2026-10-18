env-cleanup() {
  if [[ -n "$TMUX" ]]; then
    touch "$HOME/.user-env-cleanup"
    tmux kill-server 2>/dev/null
  else
    exit
  fi
}
