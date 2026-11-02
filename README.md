# dotfiles

My personal development configuration built around the terminal.

## Pre-requisites

- macOS (see [`linux`](https://github.com/dedumets/dotfiles/tree/main) for Linux setup)
- [Homebrew](https://brew.sh/)
- CaskaydiaMono Nerd Font
- Cloned repository with included submodules (for TPM)

## Setup

Install [Homebrew](https://brew.sh/) dependencies:

```sh
brew install bat delta eza fzf neovim ripgrep starship tmux tree-sitter-cli zoxide zk
brew install --cask ghostty nikitabobko/tap/aerospace
# To replace Xcode with Neovim
brew install xcode-build-server xcp xcbeautify
```

Most of these should work right away, after cloning the repository into `~/.config`,
and sym-linking `.zshrc` to `~/.zshrc`.

Some apps must be installed and configured through a GUI:

- [SaneScroll](https://github.com/dyarfaradj/SaneScroll)
