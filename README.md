# Dotfiles

Personal configuration files managed with GNU Stow.

## Structure

- `fish/`: Shell configuration, aliases, and functions.
- `nvim/`: Neovim configuration and plugins.
- `git/`: Global git settings (.gitconfig, .gitignore_global).
- `scripts/`: Custom executable scripts mapped to ~/.local/bin.

## Installation

1. Clone the repository into your home directory:
   git clone https://github.com/USERNAME/dotfiles.git ~/dotfiles

2. Navigate to the directory:
   cd ~/dotfiles

3. Use Stow to create symlinks for the desired packages:
   stow fish
   stow nvim
   stow git
   stow scripts

Note: Ensure no conflicting default configuration files exist in the target directories before running stow.

## Requirements

- Arch Linux
- GNU Stow
- Fish Shell
- Neovim
