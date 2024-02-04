#!/bin/bash

# Set the dotfiles directory
dotfiles_dir="$HOME/dotfiles"

# Prepare dotfiles before installation
prepare_dotfiles() {
    # Cleanup custom directory
    rm -rf $dotfiles_dir/.config/nvim/lua/custom

    # Fetch and update submodules
    git submodule update --init --recursive

    # Symlink nvim custom conf
    ln -s $dotfiles_dir/.config/nvim_custom $dotfiles_dir/.config/nvim/lua/custom
}

# Install dotfiles using Stow
install_dotfiles() {
    stow .
}

# Main script execution
echo "Installing dotfiles using Stow..."

# Check if Stow is installed
if ! command -v stow &> /dev/null; then
    echo "Stow is not installed. Installing..."
    apt install stow -y
    exit 1
fi

# Check if dotfiles directory exists
if [ ! -d "$dotfiles_dir" ]; then
    echo "Dotfiles directory not found. Please set the correct path in the script."
    exit 1
fi

# Change to dotfiles directory
cd "$dotfiles_dir" || exit

# Prepare dotfiles
prepare_dotfiles

# Install dotfiles
install_dotfiles

echo "Dotfiles installation completed."

