# 🏠 Personal Dotfiles

A curated collection of dotfiles for a consistent development environment across multiple systems. This repository makes it easy to sync configurations between different machines and VMs.

## ✨ Features

- **Cross-platform support**: Works on both Linux and macOS
- **Easy installation**: Single script setup with automatic dependency management
- **Essential tools**: Installs modern CLI tools like `eza`, `zoxide`, `ripgrep`, and more
- **Modular configuration**: Organized structure for easy customization
- **Version controlled**: Track changes and roll back if needed

## 📋 Prerequisites

### Linux
No prerequisites needed! The installation script will automatically detect your Linux distribution and install all required packages using your system's package manager (apt, yum, dnf, or pacman).

### macOS
You'll need [Homebrew](https://brew.sh) installed first:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## 🚀 Installation

### 1. Clone the Repository

**Important**: Clone this repository to your home directory (`$HOME`):

```bash
cd $HOME
git clone https://github.com/ujwalp15/dotfiles.git
```

### 2. Run the Installation Script

Navigate to the dotfiles directory and run the installation script:

```bash
cd dotfiles
./install.sh
```

The script will:
- Detect your operating system
- Install Stow and essential CLI tools if not already present
- Initialize git submodules
- Create symlinks for all configuration files

## 📁 What's Included

### Configuration Files
- **Shell configuration**: `.bashrc`
- **Git configuration**: `.gitconfig`
- **Application configs**: `.config/` directory with:
  - Neovim configuration
  - Tmux configuration
  - Ghostty terminal configuration

### Essential CLI Tools
The installation script automatically installs these modern CLI tools:

- **[eza](https://github.com/eza-community/eza)**: Modern replacement for `ls` with colors and icons
- **[zoxide](https://github.com/ajeetdsouza/zoxide)**: Smart directory navigator (`cd` replacement)
- **[ripgrep](https://github.com/BurntSushi/ripgrep)**: Fast text search tool (`grep` replacement)
- **[fd](https://github.com/sharkdp/fd)**: Simple, fast alternative to `find`
- **[bat](https://github.com/sharkdp/bat)**: Cat clone with syntax highlighting
- **[fzf](https://github.com/junegunn/fzf)**: Command-line fuzzy finder
- **[stow](https://www.gnu.org/software/stow/)**: Symlink farm manager for dotfiles

## 🔧 Customization

To add your own dotfiles:

1. Add your configuration files to the appropriate location
2. Update `.stow-local-ignore` if you want to exclude certain files
3. Run `./install.sh` again to apply changes

## 🗂️ Repository Structure

```
dotfiles/
├── .config/              # Application-specific configs
│   ├── nvim/            # Neovim configuration
│   ├── tmux/            # Tmux configuration
│   └── ghostty/         # Ghostty terminal config
├── .bashrc              # Bash shell configuration
├── .gitconfig           # Git configuration
├── .gitignore           # Git ignore rules
├── .gitmodules          # Git submodules configuration
├── .stow-local-ignore   # Files to exclude from stowing
├── LICENSE              # MIT license
├── README.md            # This file
└── install.sh           # Installation script
```

## 🔄 Updating

To update your dotfiles:

```bash
cd ~/dotfiles
git pull origin main
./install.sh
```

## 🧹 Uninstalling

To remove the symlinks created by Stow:

```bash
cd ~/dotfiles
stow --target="$HOME" -D .
```

## 🐛 Troubleshooting

### Common Issues

**"No packages to stow or unstow"**
- Make sure you're running the script from the dotfiles directory
- Ensure the repository structure is intact

**Permission denied errors**
- The script may need to install packages with `sudo`
- Make sure your user has appropriate permissions

**Homebrew not found (macOS)**
- Install Homebrew manually following the instructions above
- Restart your terminal and try again

## 📄 License

[MIT](https://choosealicense.com/licenses/mit/)

## 🤝 Contributing

Feel free to fork this repository and customize it for your own needs. If you have suggestions for improvements, please open an issue or submit a pull request.

---

*Happy dotfile management! 🎉*
