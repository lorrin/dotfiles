# This file is for configuring Bash itself. 
# See http://stefaanlippens.net/bashrc_and_others

#JRuby FFI doesn't like the - Mac OS ncurses for some reason.)
export RUBY_FFI_NCURSES_LIB=/opt/local/lib/libncurses.5.dylib

# Custom completions

# vi mode
bindkey -v

# Show vi-mode in prompt:
# http://pthree.org/2009/03/28/add-vim-editing-mode-to-your-zsh-prompt/

# If I am using vi keys, I want to know what mode I'm currently using.
# zle-keymap-select is executed every time KEYMAP changes.
# From http://zshwiki.org/home/examples/zlewidgets
function zle-keymap-select {
    VIMODE="${${KEYMAP/vicmd/ M:command}/(main|viins)/}"
    #VIMODE="${${KEYMAP/(main|viins)/ -- INSERT --}/vicmd/}"
    zle reset-prompt
}

zle -N zle-keymap-select

# Reset vimode variable when <enter> is pressed.
# http://pthree.org/2009/03/28/add-vim-editing-mode-to-your-zsh-prompt/
function accept_line {
    VIMODE=''
    builtin zle .accept-line
}
zle -N accept_line
bindkey -M vicmd "^M" accept_line

# Alternate show-vi-mode-solution
#function zle-line-init zle-keymap-select {
#    RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
#    RPS2=$RPS1
#    zle reset-prompt
#}
#
#zle -N zle-line-init
#zle -N zle-keymap-select

# Prompt
source ~/.zsh/git-prompt/zshrc.sh
# configure the following, or leave it commented out:
# PROMPT='%B%m%~%b$(prompt_git_info) %# 
RPROMPT='${VIMODE}'

# History 
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh/history
# Ctrl-r for reverse history search
# Apply both in vi-insert mode (v) and vi-command mode (a for alternate binding set)
for keymap in v a; do
   bindkey -$keymap "^r"  history-incremental-search-backward
done
setopt inc_append_history # Each instance has its own history at run time, but global history file (for future invocations) is appended in real-time
#setopt share_history # Share history real-time between instances.
setopt extended_history # Store metadata about each entry
setopt hist_ignore_dups # Don't store sequential duplicate lines
setopt hist_expire_dups_first # Drop duplicate from history first when limit is hit
setopt hist_find_no_dups # Don't cycle through dupes during history search
setopt hist_reduce_blanks # Trim before saving
setopt hist_ignore_space # Don't save if prefixed by space
setopt hist_no_store # Don't save invocation of history itself
setopt hist_no_functions # Don't save ZSH function definitions

alias clojure='java -cp $JLINE_HOME/jline.jar:$CLOJURE_HOME/clojure.jar jline.ConsoleRunner clojure.main'
source ~/.zshlocal
