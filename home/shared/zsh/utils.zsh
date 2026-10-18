env-cleanup() {
  if [[ -n "$TMUX" ]]; then
    touch "$HOME/.user-env-cleanup"
    tmux kill-session -t user-env 2>/dev/null
  else
    exit
  fi
}
