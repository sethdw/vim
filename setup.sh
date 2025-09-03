#!/bin/bash

# TODO:
# - Check for sudo
#   - apt install nvim/wezterm rather than appimage
#   - install rg
# - Check OS installing on (currently ubuntu only)

NEOVIM_VERSION="v0.11.3"
WEZTERM_VERSION="20240203-110809-5046fc22"
FORCE_INSTALL=""

COLOUR_RESET='\e[0m'
COLOUR_YELLOW='\e[38;5;228m'
COLOUR_ORANGE='\e[38;5;208m'

help () {
    echo "Usage: setup.sh [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help        Show this help message and exit"
    echo "  -n, --nvim        Install Neovim version (Default is $NEOVIM_VERSION)"
    echo "  -w, --wezterm     Install Wezterm version (Default is $WEZTERM_VERSION)"
    echo "  -f, --force       Force installation despite checks"
    echo ""
}

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help) help; exit 0 ;;
        -n|--nvim) NEOVIM_VERSION="$2"; shift ;;
        -w|--wezterm) WEZTERM_VERSION="$2"; shift ;;
        -f|--force) FORCE_INSTALL=true ;;
        *) echo "Unknown parameter passed: $1"; help; exit 1 ;;
    esac
    shift
done

banner () {
    # banner with yellow (i like yellow)
    echo -e ""
    echo -e "${COLOUR_YELLOW}============= $1 =============${COLOUR_RESET}"
    echo -e ""
}

warn () {
    # warn with orange (i hate orange)
    echo -e "${COLOUR_ORANGE}WARNING: $1${COLOUR_RESET}"
}

# check we cloned to the right place - pwd should be ~/.config/dotfiles
if [ "$(realpath $(pwd))" != "$(realpath $HOME/.config/dotfiles)" ] && [ -z "$FORCE_INSTALL" ]; then
    warn "This script assumes you've cloned the repo to and are running from ~/.config/dotfiles, but I don't think you have."
    warn "Rerun with --force to continue anyway."
    exit 1
fi

banner "Starting setup"
mkdir -p ~/bin
mkdir -p ~/code
ln -s ~/.config/dotfiles/.gitconfig ~/.gitconfig

banner "Installing nvim from appimage"
wget -O ~/bin/nvim.appimage https://github.com/neovim/neovim/releases/download/$NEOVIM_VERSION/nvim-linux-arm64.appimage
chmod u+x ~/bin/nvim.appimage
ln -s ~/bin/nvim.appimage ~/bin/nvim

# symlink config to dotfiles
ln -s ~/.config/dotfiles/nvim ~/.config/nvim

~/bin/nvim --version
if [ $? -ne 0 ]; then
    warn "Neovim installation failed"
fi

banner "Installing wezterm from appimage"
wget -O ~/bin/wezterm.appimage https://github.com/wezterm/wezterm/releases/download/$WEZTERM_VERSION/WezTerm-$WEZTERM_VERSION-Ubuntu20.04.AppImage
chmod u+x ~/bin/wezterm.appimage
ln -s ~/bin/wezterm.appimage ~/bin/wezterm

# symlink config to dotfiles
ln -s ~/.config/dotfiles/wezterm ~/.config/wezterm

~/bin/wezterm --version
if [ $? -ne 0 ]; then
    warn "Wezterm installation failed"
fi

banner "Installing fzf from git"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --no-update-rc --key-bindings --completion

banner "Writing .bashrc redirect"
if [ -f ~/.bashrc ]; then
    mv ~/.bashrc ~/.bashrc.bak
    warn "Existing .bashrc moved to .bashrc.bak"
fi
cat << EOF > ~/.bashrc
# My .bashrc is stored in .config/dotfiles/.bashrc
if [ -f "$HOME/.config/dotfiles/.bashrc" ]; then
    source "$HOME/.config/dotfiles/.bashrc"
fi
EOF
