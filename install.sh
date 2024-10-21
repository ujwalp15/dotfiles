#!/bin/bash

# Set the dotfiles directory
dotfiles_dir="$PWD/dotfiles"

# Prepare dotfiles before installation
prepare_dotfiles() {
    # Fetch and update submodules
    git submodule update --init --recursive
}

# Install dotfiles using Stow
install_dotfiles() {
    stow --target $HOME
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
