export EDITOR=vim

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="robbyrussell"
# dieter theme has nice config of how hosts are represented, but no vi-mode indication
# host_repr=('kale-wired' "%($fg_bold[green]kale")
# flazz has good vi-mode indication
ZSH_THEME="lorrin"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"


# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git mvn vagrant vi-mode zsh-syntax-highlighting)

# Customize to your needs...

# See https://github.com/zsh-users/zsh-syntax-highlighting/tree/master/highlighters
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

# Modify locally by putting a list (space-separated) of additional plugins in ~/.zshrc.local.plugins
if [[ -e ~/.zshrc.local.plugins ]]; then
  for plugin in $(cat ~/.zshrc.local.plugins); do
    plugins+=$plugin
  done;
fi;

source $ZSH/oh-my-zsh.sh

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

alias ssh_unsafe="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
alias scp_unsafe="scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

function papert () {
    if [ $# -eq 0 ]; then
        echo Select a configuration: $(ls ~/.papertrail.*.yml | sed -e 's/.*papertrail.\(.*\).yml/\1/g')
        echo 'Configuration files are in ~/.papertrail.<name>.yml'
    else
        CFG=~/.papertrail.$1.yml
        shift
        papertrail -c "$CFG" "$@"
    fi
}
