#!/bin/bash

# Detect the operating system
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unsupported"
    fi
}

# Install Stow based on the operating system
install_stow() {
    os=$(detect_os)

    case $os in
        "linux")
            echo "Installing Stow on Linux..."
            if command -v apt &> /dev/null; then
                sudo apt update && sudo apt install stow -y
            elif command -v yum &> /dev/null; then
                sudo yum install stow -y
            elif command -v pacman &> /dev/null; then
                sudo pacman -S stow --noconfirm
            elif command -v dnf &> /dev/null; then
                sudo dnf install stow -y
            else
                echo "Unsupported package manager. Please install Stow manually."
                exit 1
            fi
            ;;
        "macos")
            echo "Installing Stow on macOS..."
            if command -v brew &> /dev/null; then
                brew install stow
            else
                echo "Homebrew is not installed. Please install Homebrew manually:"
                echo "Visit https://brew.sh or run:"
                echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
                echo "Then run this script again."
                exit 1
            fi
            ;;
        "unsupported")
            echo "Unsupported operating system: $OSTYPE"
            echo "Please install Stow manually and run this script again."
            exit 1
            ;;
    esac
}

# Prepare dotfiles before installation
prepare_dotfiles() {
    # Fetch and update submodules
    git submodule update --init --recursive
}

# Install dotfiles using Stow
install_dotfiles() {
    echo "Stowing dotfiles to $HOME..."

    # Stow the entire dotfiles directory
    stow --target="$HOME" -D .
    stow --target="$HOME" -S .
}

# Main script execution
os=$(detect_os)
echo "Detected OS: $os"
echo "Installing dotfiles using Stow..."

# Check if Stow is installed
if ! command -v stow &> /dev/null; then
    echo "Stow is not installed. Installing..."
    install_stow

    # Verify installation was successful
    if ! command -v stow &> /dev/null; then
        echo "Failed to install Stow. Please install it manually and run this script again."
        exit 1
    fi
fi

# Prepare dotfiles
prepare_dotfiles

# Install dotfiles
install_dotfiles

echo "Dotfiles installation completed."
