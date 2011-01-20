. ~/.profile
# This file is for configuring Bash itself. 
# See http://stefaanlippens.net/bashrc_and_others

#JRuby FFI doesn't like the - Mac OS ncurses for some reason.)
export RUBY_FFI_NCURSES_LIB=/opt/local/lib/libncurses.5.dylib

# Custom completions
# This directory isn't magic; see ~/.bash_completion for where it gets picked up
export USER_BASH_COMPLETION_DIR=~/.bash_completion.d
# Common completions
if [ -f /opt/local/etc/bash_completion ]; then
	. /opt/local/etc/bash_completion
fi

# vi mode
set -o vi

# See what size the window is before every time you display the prompt. This
# avoids the annoying behavior in which if you change the Terminal.app window
# size while an app (e.g. vim) is running, then when you return to your shell
# and try to Ctrl-R to edit a command from the history, the cursor is in the 
# wrong column.
# http://hintsforums.macworld.com/showthread.php?t=17068
shopt -s checkwinsize

# history
# suppress duplicate commands, plain ls, bg, fg, exit
# suppress lines that begin with whitespace
# Note these aren't regexes, [ \t] means space or tab, but the following * is not a quantifier
# of how many spaces/tabs but rather matches any following characters
export HISTIGNORE="&:ls:[bf]g:exit:[ ]*"
# Store multi-line commands as single history entry
shopt -s cmdhist

# Prompt
# Wrapping \[ and \] around ANSI escapes prevents Bash from line-wrapping in
# the middle of your ANSI escape and creating junk rather than colors.
#PS1="[\t][\u@\h:\w]\$ "
#PS1='\[\e[0;31m\][\u@\h \[\e[1;31m\]\w\e[0;31m\] \t]\n\[\e[1;31m\]\$\[\e[0m\] '
#PS1='\[\e[0;31m\][\u@\h \[\e[1;31m\]\w\e[0;31m\]]\[\e[1;31m\]\$\[\e[0m\] '
#export PS1='\h:\w\[\033[32m\]$(__git_ps1) \[\033[0m\]$ '
[[ $- == *i* ]]   && [ -e ~/Code/git-prompt/git-prompt.sh ] &&  . ~/Code/git-prompt/git-prompt.sh

# Can I show the insert/edit vi state in the prompt? No.
# http://stackoverflow.com/questions/1039713/different-bash-prompt-for-different-vi-editing-mode

# Enable colors
export CLICOLOR=true

