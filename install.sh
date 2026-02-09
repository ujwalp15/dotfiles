#!/bin/bash

# Whether to skip package installation (e.g. when no sudo on Linux)
SKIP_PACKAGES=0

# List of additional packages to install
PACKAGES=(
    "neovim"
    "tmux"
    "stow"
    "eza"
    "zoxide"
    "fd-find"
    "ripgrep"
    "bat"
    "fzf"
    "starship"
    "lazygit"
    "lazydocker"
)

# Check if running as root
is_root() {
    [[ "$EUID" -eq 0 ]]
}

# Check if sudo is available (root or sudo command exists)
has_sudo() {
    if is_root; then
        return 0
    fi
    command -v sudo &>/dev/null
}

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
            "apt") $SUDO apt install "$actual_package" -y &>/dev/null || echo "Warning: Failed to install $actual_package" ;;
            "yum") $SUDO yum install "$actual_package" -y &>/dev/null || echo "Warning: Failed to install $actual_package" ;;
            "dnf") $SUDO dnf install "$actual_package" -y &>/dev/null || echo "Warning: Failed to install $actual_package" ;;
            "pacman") $SUDO pacman -S "$actual_package" --noconfirm &>/dev/null || echo "Warning: Failed to install $actual_package" ;;
            "brew") brew install "$actual_package" &>/dev/null || echo "Warning: Failed to install $actual_package" ;;
        esac
    done
}

# Install packages based on the operating system
install_packages() {
    [[ "$SKIP_PACKAGES" -eq 1 ]] && echo "Skipping package installation (run with sudo or install packages manually)." && return

    local os=$(detect_os)
    local packages_to_install=("${PACKAGES[@]}")

    echo "Checking for missing packages on $os..."

    # On Linux without sudo, only Homebrew (user-space) can install packages
    if [[ "$os" == "linux" ]] && ! has_sudo && ! command -v brew &>/dev/null; then
        echo "No sudo access and Homebrew not found. Skipping package installation."
        echo "Install packages manually: ${PACKAGES[*]}"
        echo "Or use Homebrew on Linux: https://docs.brew.sh/Homebrew-on-Linux"
        return
    fi

    # Get missing packages
    local missing_packages
    missing_packages=()
    while IFS= read -r line; do
        missing_packages+=("$line")
    done < <(get_missing_packages "${packages_to_install[@]}")

    if [ ${#missing_packages[@]} -eq 0 ]; then
        echo "All packages are already installed!"
        return
    fi

    case $os in
        "linux")
            if command -v apt &> /dev/null && has_sudo; then
                echo "Using apt package manager..."
                install_with_manager "apt" "${missing_packages[@]}"
            elif command -v yum &> /dev/null && has_sudo; then
                echo "Using yum package manager..."
                install_with_manager "yum" "${missing_packages[@]}"
            elif command -v pacman &> /dev/null && has_sudo; then
                echo "Using pacman package manager..."
                install_with_manager "pacman" "${missing_packages[@]}"
            elif command -v dnf &> /dev/null && has_sudo; then
                echo "Using dnf package manager..."
                install_with_manager "dnf" "${missing_packages[@]}"
            elif command -v brew &> /dev/null; then
                echo "Using Homebrew (Linux) - no sudo required..."
                install_with_manager "brew" "${missing_packages[@]}"
            else
                echo "No supported package manager with sufficient privileges."
                echo "Install packages manually: ${PACKAGES[*]}"
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
# Parse --skip-packages flag
for arg in "$@"; do
    case $arg in
        --skip-packages) SKIP_PACKAGES=1; break ;;
    esac
done

# Use sudo for system package managers only when not root
SUDO=""
is_root || SUDO="sudo "

os=$(detect_os)
echo "Detected OS: $os"
echo "Installing dotfiles and essential packages..."

# Warn if running as root - dotfiles will go to /root
if is_root; then
    echo "Note: Running as root. Dotfiles will be installed to /root."
    echo "For your user account, run this script as your regular user instead."
fi

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
