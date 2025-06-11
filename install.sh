#!/bin/bash

# List of additional packages to install
PACKAGES=(
    "stow"
    "eza"
    "zoxide"
    "fd-find"
    "ripgrep"
    "bat"
    "fzf"
    "starship"
)

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

# Check if a command exists with alternative names
command_exists() {
    local cmd="$1"
    case $cmd in
        "fd-find") command -v fd &> /dev/null || command -v fdfind &> /dev/null ;;
        *) command -v "$cmd" &> /dev/null ;;
    esac
}

# Get missing packages from the provided list
get_missing_packages() {
    local packages=("$@")
    local missing=()

    for package in "${packages[@]}"; do
        if ! command_exists "$package"; then
            missing+=("$package")
        else
            echo "✓ $package already installed" >&2
        fi
    done

    printf '%s\n' "${missing[@]}"
}

# Install packages using specified package manager
install_with_manager() {
    local manager="$1"
    shift
    local packages=("$@")

    for package in "${packages[@]}"; do
        local actual_package="$package"

        # Handle package name mappings
        case $manager in
            "pacman")
                case $package in
                    "fd-find") actual_package="fd" ;;
                esac
                ;;
            "brew")
                case $package in
                    "fd-find") actual_package="fd" ;;
                esac
                ;;
        esac

        # Install the package quietly, ignore errors
        echo "Installing $actual_package..."
        case $manager in
            "apt") sudo apt install "$actual_package" -y &>/dev/null || echo "Warning: Failed to install $actual_package" ;;
            "yum") sudo yum install "$actual_package" -y &>/dev/null || echo "Warning: Failed to install $actual_package" ;;
            "dnf") sudo dnf install "$actual_package" -y &>/dev/null || echo "Warning: Failed to install $actual_package" ;;
            "pacman") sudo pacman -S "$actual_package" --noconfirm &>/dev/null || echo "Warning: Failed to install $actual_package" ;;
            "brew") brew install "$actual_package" &>/dev/null || echo "Warning: Failed to install $actual_package" ;;
        esac
    done
}

# Install packages based on the operating system
install_packages() {
    local os=$(detect_os)
    local packages_to_install=("${PACKAGES[@]}")

    echo "Checking for missing packages on $os..."

    # Get missing packages
    local missing_packages
    readarray -t missing_packages < <(get_missing_packages "${packages_to_install[@]}")

    if [ ${#missing_packages[@]} -eq 0 ]; then
        echo "All packages are already installed!"
        return
    fi

    case $os in
        "linux")
            if command -v apt &> /dev/null; then
                echo "Using apt package manager..."
                install_with_manager "apt" "${missing_packages[@]}"
            elif command -v yum &> /dev/null; then
                echo "Using yum package manager..."
                install_with_manager "yum" "${missing_packages[@]}"
            elif command -v pacman &> /dev/null; then
                echo "Using pacman package manager..."
                install_with_manager "pacman" "${missing_packages[@]}"
            elif command -v dnf &> /dev/null; then
                echo "Using dnf package manager..."
                install_with_manager "dnf" "${missing_packages[@]}"
            else
                echo "Unsupported package manager. Please install packages manually."
                exit 1
            fi
            ;;
        "macos")
            if command -v brew &> /dev/null; then
                echo "Using Homebrew package manager..."
                install_with_manager "brew" "${missing_packages[@]}"
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
            echo "Please install packages manually and run this script again."
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
echo "Installing dotfiles and essential packages..."

# Install all packages
install_packages

# Prepare dotfiles
prepare_dotfiles

# Install dotfiles
install_dotfiles

echo "Dotfiles and packages installation completed."
echo ""
echo "Package status:"
for package in "${PACKAGES[@]}"; do
    if command_exists "$package"; then
        echo "✓ $package"
    else
        echo "✗ $package (not found - may have different command name)"
    fi
done
