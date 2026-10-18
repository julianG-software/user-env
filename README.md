# user-env

Portable personal environment — ZSH, neovim, and tools — deployable on any machine running Nix.

## Roles

| Role | Neovim preset | Target |
|---|---|---|
| `minimal` | basic | VMs, throwaway shells |
| `admin` | config | Servers, homelab hosts |
| `development` | coding | Dev machines |
| `full` | full | Primary workstation |

## Permanent install (home-manager)

For machines you own. Add as a flake input and import the module for the relevant role:

```nix
# flake.nix
inputs.user-env.url = "github:julianG-software/user-env";
inputs.user-env.inputs.nixpkgs.follows = "nixpkgs";

# home.nix
{ inputs, ... }: {
  imports = [ inputs.user-env.homeModules.development ];
}
```

Home-manager manages ZSH, aliases, git config, packages, and neovim. Any value set by user-env uses `lib.mkDefault` and can be overridden in your own config.

## Ephemeral install (work servers)

For machines you don't own. No install required — just run:

```bash
nix run github:julianG-software/user-env#minimal
```

On first run the session starts fresh. On subsequent runs it reattaches to the existing tmux session (admin/development/full roles). Shell history is disabled (`HISTFILE=/dev/null`).

### tmux controls (admin / development / full)

| Action | Command |
|---|---|
| Open command prompt | `C-]` `C-]` |
| Detach (session stays alive) | `C-]` `:detach-client` |
| Check session from outer shell | `tmux -L user-env ls` |
| Full teardown | `env-cleanup` (from inside session) |

`env-cleanup` kills the tmux server and runs `nix-collect-garbage` from the outer shell after the session exits.

## What's included

**All roles:** ZSH + oh-my-posh (catppuccin frappe), zsh-autosuggestions, zsh-syntax-highlighting, sudo + extract plugins, fzf, eza (aliased to `ls`), btop, jq, git `undo` alias, neovim

**admin+:** ripgrep, fd, yq, delta, nix-tree, nix-diff, direnv, tmux

**development+:** lazygit

**full+:** wl-clipboard, xclip, JetBrains Mono Nerd Font

## Aliases

```zsh
ls / ll    eza --icons --git --long
la         eza --icons --git --long -a
l          eza --icons --git
lt         eza --icons --git --long --sort=modified
tree       eza --tree --icons
cc         claude
cc_res     claude --resume
vi / vim   role's neovim preset
```
