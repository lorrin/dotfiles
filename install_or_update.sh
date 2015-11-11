#!/usr/bin/env zsh

# ${o:a:h} is Zsh magic for directory where script resides
# 0 (path to script), :a (absolute path), :h (head (drop filename))
# See http://zsh.sourceforge.net/Doc/Release/Expansion.html#Modifiers
DOTFILES_DIR=${0:a:h}

# Install Prezto per https://github.com/kishansundar/zprezto
if [ ! -d "${ZDOTDIR:-$HOME}/.zprezto" ]; then
	echo Installing Prezto
	git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
	setopt EXTENDED_GLOB
	for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
	  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
	done
	# Remove stock .zpreztorc to enable stowing of custom one below.
	rm "${ZDOTDIR:-$HOME}/.zpreztorc"
else
	echo Updating Prezto
	cd "${ZDOTDIR:-$HOME}/.zprezto"
	git pull
	git submodule sync
	git submodule update --init --recursive
fi

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
