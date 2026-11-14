# DotFiles

Settings for an agentic development environment using Zsh, lazygit, and Neovim.

## Accountability

> "A computer can never be held accountable, therefore a computer must never make a management decision."
> — IBM Training Manual, 1979

- If a human committed it, it's their responsibility instead of the agent's.
- The agent is a collaborative partner tool, similar to a rubber duck that can code.

## Clone the repository

```bash
git clone git@github.com:mauroporras/dotfiles.git ~/dotfiles
```

## Install Homebrew

### Step 1

[https://brew.sh](https://brew.sh)

### Step 2

```bash
brew bundle --file ~/dotfiles/Brewfile
```

## Install the Nix package manager

[https://nixos.org/download](https://nixos.org/download)

## Neovim

If you are new to Neovim: `:h nvim`

If you're transitioning from Vim: `:h nvim-from-vim`

To optimize Neovim: `:checkhealth`

## Finally, bootstrap DotFiles

```bash
~/dotfiles/bootstrap
~/dotfiles/git-config
```

## FAQ

[FAQ.md](FAQ.md)
