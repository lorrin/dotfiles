# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#   Lorrin Nelson <https://github.com/lorrin>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

# Turn off SHARE_HISTORY, which jumbles together the history of each
# open session and works against having task-specific shells in long-
# running tmux sessions.
# http://zsh.sourceforge.net/Guide/zshguide02.html#l18
# INC_APPEND_HISTORY is the good one, and that's already enabled too.
# https://github.com/sorin-ionescu/prezto/blob/master/modules/history/init.zsh
unsetopt SHARE_HISTORY

# Change the prompt character back to standard $ rather than giddie default.
# (skip now; using power10k instead)
# PROMPT='%(?..%F{red}%B-> [%?]%b%f
# )%F{magenta}%n%f@%F{yellow}%m%f|%F{green}${_prompt_giddie_pwd}%f${vcs_info_msg_0_}
# %F{blue}$%f '

export EDITOR=vim

# Allow ctrl-r / ctrl-f to cycle through history matches.
# Note in vicmd mode ? and / are bound to these, and ctrl-r is bound to redo.
bindkey -M viins '^R' history-incremental-pattern-search-backward
bindkey -M viins '^F' history-incremental-pattern-search-forward
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# Prefer MacPorts installed GNU toolchain over BSD if present
[[ -d /opt/local/libexec/gnubin ]] && export PATH=/opt/local/libexec/gnubin:$PATH

# Set JAVA_HOME on OS X
if [ -e /usr/libexec/java_home ]; then
   function setjdk {
      local ver=${1?Usage: setjdk <version>}
      export JAVA_HOME=$(/usr/libexec/java_home -v $ver)
      PATH=$(echo $PATH | tr ':' '\n' | grep -v Java | tr '\n' ':')
      export PATH=$JAVA_HOME/bin:$PATH
   }
   setjdk 1.8
fi

alias ssh_noauth="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
alias scp_noauth="scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

# Josh's git aliases. Prefer these over prezto's git module
# git log
alias gl="git log --graph --pretty=format:'%Cred%h%Creset - %Cgreen%ci%x08%x08%x08%x08%x08%x08%x08%x08%x08%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
# git log all
alias gla="git log --all --graph --pretty=format:'%Cred%h%Creset - %Cgreen%ci%x08%x08%x08%x08%x08%x08%x08%x08%x08%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
# More git aliases
# git branch upstream master
function gbum(){
    git checkout -b $1 upstream/master
}
# git branch origin master
function gbom(){
    git checkout -b $1 origin/master
}
alias git-branch-clean="git branch --merged | grep -vP '^\* ' | xargs git branch -d"
# git branch delete merged
alias gbxm="git branch --merged | grep -vP '^\* ' | xargs git branch -d"


# GPG_TTY for git code signing
export GPG_TTY=$(tty)

# Add iTerm shell integration, if available
[[ -e ${ZDOTDIR:-$HOME}/.iterm2_shell_integration.`basename $SHELL` ]] && source ${ZDOTDIR:-$HOME}/.iterm2_shell_integration.`basename $SHELL`

PATH=$PATH:$HOME/bin

# Node.js / npm
if [[ -d  $HOME/node_modules/.bin ]]; then
    export PATH=$PATH:$HOME/node_modules/.bin
fi

# Drop-in replacements for standard commands
if type bat > /dev/null; then
    alias cat='bat'
fi

alias preview="fzf --preview 'bat --color \"always\" {}'"

# If setxkbmap exists, use it to change capslock to escape
if setxkbmap_path="$(type -p setxkbmap)" && [[ ! -z $setxkbmap_path  ]]; then
    # https://askubuntu.com/a/830343
    setxkbmap -option caps:escape
fi

# Source machine-specific .zshrc
[[ -e ${ZDOTDIR:-$HOME}/.zshrc.local ]] && source ${ZDOTDIR:-$HOME}/.zshrc.local

# https://unix.stackexchange.com/questions/424602/is-it-possible-to-set-a-constant-lowest-cpu-frequency-under-the-modern-pstate
alias silent="echo 25 | sudo tee /sys/devices/system/cpu/intel_pstate/max_perf_pct"
alias quiet="echo 50 | sudo tee /sys/devices/system/cpu/intel_pstate/max_perf_pct"
alias fast="echo 100 | sudo tee /sys/devices/system/cpu/intel_pstate/max_perf_pct"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
