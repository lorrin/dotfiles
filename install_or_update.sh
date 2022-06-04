#!/usr/bin/env zsh
set -euo pipefail

function notice {
    echo "$(tput setaf 6)--> $(tput sgr0) $@"
}

function section {
    tput setaf 6
    echo ----------------------------------------------------------------------------------
    echo $@
    tput sgr0
}

function warning {
    tput bold
    tput setaf 1
    echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    echo WARNING: $@
    echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    tput sgr0
}

if ! which stow >/dev/null; then
    warning "GNU stow is required to proceed."
    exit 1
fi

# ${o:a:h} is Zsh magic for directory where script resides
# 0 (path to script), :a (absolute path), :h (head (drop filename))
# See http://zsh.sourceforge.net/Doc/Release/Expansion.html#Modifiers
DOTFILES_DIR=${0:a:h}

# Install Prezto per https://github.com/kishansundar/zprezto
if [ ! -d "${ZDOTDIR:-$HOME}/.zprezto" ]; then
	section Installing Prezto
	git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
else
	section Updating Prezto
	cd "${ZDOTDIR:-$HOME}/.zprezto"
	git pull --ff-only
	git submodule sync
	git submodule update --init --recursive
fi
section Linking Zsh RC files
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    # if target already exists and isn't equivalent to the link we want to create and isn't an override from the stows
    # directory, then alert.
    if [ -e "${ZDOTDIR:-$HOME}/.${rcfile:t}" ]; then
        if [[ ! "${ZDOTDIR:-$HOME}/.${rcfile:t}" -ef  $rcfile ]]; then
            if [ ! -e ${DOTFILES_DIR}/stows/.${rcfile:t} ]; then
                warning "${ZDOTDIR:-$HOME}/.${rcfile:t} already exists, will not create link to $rcfile.\nUnless this file is intentionally present, delete and re-run."
            fi
        fi
    else
        notice "Linking ${ZDOTDIR:-$HOME}/.${rcfile:t} -> $rcfile"
        ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    fi
done
# Remove stock .zshrc and .zpreztorc to enable stowing of custom one below.
rm "${ZDOTDIR:-$HOME}/.zshrc"
rm "${ZDOTDIR:-$HOME}/.zpreztorc"

# Install Prezto-Contrib per https://github.com/belak/prezto-contrib
if [ ! -d "${ZPREZTODIR:-$HOME/.zprezto}/contrib" ]; then
	section Installing Prezto-Contrib
	git clone --recurse-submodules https://github.com/belak/prezto-contrib contrib
else
	section Updating Prezto-Contrib
    cd "${ZPREZTODIR:-$HOME/.zprezto}/contrib"
	git pull --ff-only
	git submodule sync
	git submodule update --init --recursive
fi

if [ ! -d "$HOME/.vim_runtime" ]; then
	section Installing Ultimate vimrc
	git clone https://github.com/amix/vimrc.git "$HOME/.vim_runtime"
    # Enable persistent undo
    mkdir -p "$HOME/.vim_runtime/temp_dirs/undodir"
    chmod 700 "$HOME/.vim_runtime/temp_dirs/undodir"
else
	section Updating Ultimate vimrc
	cd "${ZDOTDIR:-$HOME}/.vim_runtime"
	git pull --ff-only
	python3 update_plugins.py
fi
cd "${ZDOTDIR:-$HOME}/.vim_runtime"
./install_awesome_vimrc.sh


if which tmux >/dev/null; then
    # Install Tmux Plugin Manager per https://github.com/tmux-plugins/tpm
    if [ ! -d "${ZDOTDIR:-$HOME}/.tmux/plugins/tpm" ]; then
            section Installing Tmux Plugin Manager
            git clone https://github.com/tmux-plugins/tpm "${ZDOTDIR:-$HOME}/.tmux/plugins/tpm"
    else
            section Updating Tmux Plugin Manager
            cd "${ZDOTDIR:-$HOME}/.tmux/plugins/tpm"
            git pull --ff-only
    fi
else
    section tmux not installed; skipping Tmux Plugin Manager
fi

# Make a symlink in $HOME to each of the .dotfiles in stows/
section Installing dotfiles.
if stow --version | grep 2.3.1 > /dev/null; then
    notice "Detected stow version 2.3.1. Ignore spurious 'BUG in find_stowed_path?' warnings.\nSee https://github.com/aspiers/stow/issues/65"
fi
stow --override=".*" --verbose --restow --target=$HOME --dir="$DOTFILES_DIR" stows

if [ -d "$DOTFILES_DIR/local_$(hostname -s)" ]; then
	notice "Using local overrides ($DOTFILES_DIR/local_$(hostname -s))"
	stow --override=".*" --verbose --restow --target=$HOME --dir="$DOTFILES_DIR" "local_$(hostname -s)"
else
	notice "No local overrides found ($DOTFILES_DIR/local_$(hostname -s))"
fi

if type tmux >/dev/null && tmux server-info 2>/dev/null; then
    section Updating Tmux Plugins
    tmux source ~/.tmux.conf
    ~/.tmux/plugins/tpm/bin/install_plugins
    ~/.tmux/plugins/tpm/bin/update_plugins all
else
    section "tmux not installed or not running; skipping Tmux Plugin update"
fi

section "checking for required tools"
if ! type delta  > /dev/null; then
    warning delta not installed, git diffs will not work properly
fi

section "checking for optional tools"
for OPTIONAL in bat duf dust fd rg exa; do
    if type $OPTIONAL  > /dev/null; then
        notice $OPTIONAL found
    else
        notice $OPTIONAL not installed
    fi
done;
