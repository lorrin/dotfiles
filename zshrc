# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Set to the name theme to load.
# Look in ~/.oh-my-zsh/themes/
export ZSH_THEME="flazz"
# dieter theme has nice config of how hosts are represented. Stick with 
# flazz for now for vi-mode indication
#host_repr=('kale-wired' "%($fg_bold[green]kale")

# Set to this to use case-sensitive completion
# export CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# export DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# export DISABLE_LS_COLORS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git vi-mode)
# others to try:
# command-not-found -- needs fixing to work when not on Ubuntu
# dirpersist looks interesting

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# Some history settings missing from lib/history.zsh
setopt inc_append_history # Each instance has its own history at run time, but global history file (for future invocations) is appended in real-time
#setopt share_history # Share history real-time between instances.              
setopt hist_ignore_dups # Don't store sequential duplicate lines                
setopt hist_find_no_dups # Don't cycle through dupes during history search      
setopt hist_reduce_blanks # Trim before saving                                  
setopt hist_no_store # Don't save invocation of history itself                  
setopt hist_no_functions # Don't save ZSH function definitions   
setopt inc_append_history # Each instance has its own history at run time, but global history file (for future invocations) is appended in real-time

#JRuby FFI doesn't like the - Mac OS ncurses for some reason.)                  
export RUBY_FFI_NCURSES_LIB=/opt/local/lib/libncurses.5.dylib

alias clojure='java -cp $JLINE_HOME/jline.jar:$CLOJURE_HOME/clojure.jar jline.ConsoleRunner clojure.main'
[[ -e ~/.zshlocal ]] && source ~/.zshlocal
