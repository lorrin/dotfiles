#!/usr/bin/env zsh

if ! which stow 2>/dev/null; then
    echo "GNU stow is required to proceed."
    exit 1
fi

# ${o:a:h} is Zsh magic for directory where script resides
# 0 (path to script), :a (absolute path), :h (head (drop filename))
# See http://zsh.sourceforge.net/Doc/Release/Expansion.html#Modifiers
DOTFILES_DIR=${0:a:h}

# Install Prezto per https://github.com/kishansundar/zprezto
if [ ! -d "${ZDOTDIR:-$HOME}/.zprezto" ]; then
	echo Installing Prezto
	git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
	setopt EXTENDED_GLOB
else
	echo Updating Prezto
	cd "${ZDOTDIR:-$HOME}/.zprezto"
	git pull
	git submodule sync
	git submodule update --init --recursive
fi
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    # if target already exists and isn't equivalent to the link we want to create and isn't an override from the stows
    # directory, then alert.
    if [ -e "${ZDOTDIR:-$HOME}/.${rcfile:t}" ]; then
        if [[ ! "${ZDOTDIR:-$HOME}/.${rcfile:t}" -ef  $rcfile ]]; then
            if [ ! -e ${DOTFILES_DIR}/stows/.${rcfile:t} ]; then
                echo "WARN: ${ZDOTDIR:-$HOME}/.${rcfile:t} already exists, will not create link to $rcfile."
            fi
        fi
    else
        echo "Linking ${ZDOTDIR:-$HOME}/.${rcfile:t} -> $rcfile"
        ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    fi
done
# Remove stock .zshrc and .zpreztorc to enable stowing of custom one below.
rm "${ZDOTDIR:-$HOME}/.zshrc"
rm "${ZDOTDIR:-$HOME}/.zpreztorc"

if [ ! -d "$HOME/.vim_runtime" ]; then
	echo Installing Ultimate vimrc
	git clone https://github.com/amix/vimrc.git "$HOME/.vim_runtime"
    # Enable persistent undo
    mkdir -p "$HOME/.vim_runtime/temp_dirs/undodir"
    chmod 700 "$HOME/.vim_runtime/temp_dirs/undodir"
else
	echo Updating Ultimate vimrc
	cd "${ZDOTDIR:-$HOME}/.vim_runtime"
	git pull
        python3 update_plugins.py
fi
cd "${ZDOTDIR:-$HOME}/.vim_runtime"
./install_awesome_vimrc.sh


if which tmux 2>/dev/null; then
    # Install Tmux Plugin Manager per https://github.com/tmux-plugins/tpm
    if [ ! -d "${ZDOTDIR:-$HOME}/.tmux/plugins/tpm" ]; then
            echo Installing Tmux Plugin Manager
            git clone https://github.com/tmux-plugins/tpm "${ZDOTDIR:-$HOME}/.tmux/plugins/tpm"
    else
            echo Updating Tmux Plugin Manager
            cd "${ZDOTDIR:-$HOME}/.tmux/plugins/tpm"
            git pull
    fi
else
    echo "tmux not installed; skipping Tmux Plugin Manager"
fi

# Make a symlink in $HOME to each of the .dotfiles in stows/
echo Installing dotfiles.
stow --override=".*" --restow --target=$HOME --dir="$DOTFILES_DIR" stows

if [ -d "$DOTFILES_DIR/local_$(hostname -s)" ]; then
	echo "Using local overrides ($DOTFILES_DIR/local_$(hostname -s))"
	stow --override=".*" --restow --target=$HOME --dir="$DOTFILES_DIR" "local_$(hostname -s)"
else
	echo "No local overrides found ($DOTFILES_DIR/local_$(hostname -s))"
fi

if which tmux 2>/dev/null; then
    echo Updating Tmux Plugins
    tmux source ~/.tmux.conf
    ~/.tmux/plugins/tpm/bin/install_plugins
    ~/.tmux/plugins/tpm/bin/update_plugins all
else
    echo "tmux not installed; skipping Tmux Plugin update"
fi
