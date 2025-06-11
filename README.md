# 🏠 Personal Dotfiles

A curated collection of dotfiles for a consistent development environment across multiple systems. This repository makes it easy to sync configurations between different machines and VMs.

## ✨ Features

- **Cross-platform support**: Works on both Linux and macOS
- **Easy installation**: Single script setup with automatic dependency management
- **Modular configuration**: Organized structure for easy customization
- **Version controlled**: Track changes and roll back if needed

## 📋 Prerequisites

### Linux
The installation script will automatically install Stow using your system's package manager:

**Ubuntu/Debian:**
```bash
sudo apt install stow -y
```

**RHEL/CentOS:**
```bash
sudo yum install stow -y
```

**Fedora:**
```bash
sudo dnf install stow -y
```

**Arch Linux:**
```bash
sudo pacman -S stow --noconfirm
```

### macOS
You'll need [Homebrew](https://brew.sh) installed first:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

The script will then use Homebrew to install Stow automatically.

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
- Install Stow if not already present
- Initialize git submodules
- Create symlinks for all configuration files

## 📁 What's Included

- **Shell configuration**: `.bashrc`
- **Git configuration**: `.gitconfig`
- **Application configs**: `.config/` directory with:
  - Neovim configuration
  - Tmux configuration
  - Ghostty terminal configuration

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
├── .stow-local-ignore   # Files to exclude from stowing
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
