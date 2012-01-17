export EDITOR=vim

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

# Uncomment following line if you want to disable autosetting terminal title.   
export DISABLE_AUTO_TITLE="true" 

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git vi-mode command-not-found)

# Modify locally by putting a list (space-separated) of additional plugins in ~/.zshrc.local.plugins
if [[ -e ~/.zshrc.local.plugins ]]; then
  for plugin in $(cat ~/.zshrc.local.plugins); do
    plugins+=$plugin
  done;
fi;

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# Add some emacs-mode bindings I've gotten used to
for mode in vicmd viins; do 
    bindkey -M $mode "^A" beginning-of-line
    bindkey -M $mode "^E" end-of-line
    bindkey -M $mode "^R" history-incremental-search-backward
done;

# Prefer inc_append_history of share_history for consistent per-window behavior
unsetopt share_history # Don't share history real-time between instances.
setopt inc_append_history # Each instance has its own history at run time, but global history file (for future invocations) is appended in real-time

# Some history settings missing from lib/history.zsh
setopt hist_ignore_dups # Don't store sequential duplicate lines
setopt hist_find_no_dups # Don't cycle through dupes during history search
setopt hist_reduce_blanks # Trim before saving
setopt hist_no_store # Don't save invocation of history itself
setopt hist_no_functions # Don't save ZSH function definitions

unsetopt correct_all # Turn off the after-the-fact spelling correction prompts

# Load machine-local config
[[ -e ~/.zshrc.local ]] && source ~/.zshrc.local
