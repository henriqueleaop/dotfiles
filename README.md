# Dotfiles

This repository contains the configuration files (dotfiles) for my personal development environment, designed for productivity, minimalism, and a seamless workflow.

## 🛠 Tech Stack

- **OS:** Arch Linux
- **Display Server:** Wayland
- **Desktop Environment:** KDE Plasma
- **Text Editor:** Neovim (Kickstart-based modular configuration)
- **Shell:** Fish Shell

## 📂 Repository Structure

The repository is organized to be managed with [GNU Stow](https://www.gnu.org/software/stow/), where each top-level directory represents a package.

- **`aichat/`**: Configuration for AI CLI integration.
- **`fish/`**: Fish shell configuration, including custom functions for package management and hardware control (webcam).
- **`git/`**: Global Git configuration and ignore rules.
- **`nvim/`**: A modular Neovim setup including LSP, treesitter, and custom plugins.
- **`packages/`**: Text files containing lists of installed packages via `pacman`, `yay`, and `flatpak` for easy system replication.
- **`scripts/`**: Custom binaries and utility scripts located in `~/.local/bin`.
- **`system/`**: System-level configurations, such as Pacman hooks.
- **`task/`**: Configuration for Taskwarrior (`.taskrc`).
- **`wallpapers/`**: A collection of personal desktop wallpapers.
- **`install.sh`**: Entry point script for environment setup.

## 🚀 Installation

This setup uses **GNU Stow** to symlink configurations to the home directory.

### Prerequisites

Ensure you have `stow` installed:

```bash
# On Arch Linux
sudo pacman -S stow
```

### Setup

1. Clone the repository to your home directory:
   ```bash
   git clone https://github.com/your-username/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. Use `stow` to link the desired modules:
   ```bash
   # Link all modules
   stow fish nvim git scripts aichat task
   ```

3. (Optional) Make scripts executable:
   ```bash
   chmod +x scripts/.local/bin/*
   ```

### Package Synchronization

To restore packages listed in the `packages/` directory:
```bash
# Example for pacman
sudo pacman -S --needed - < packages/pacman_list.txt
```
