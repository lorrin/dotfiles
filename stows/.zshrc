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

[[ -e ${ZDOTDIR:-$HOME}/.zshrc.local ]] && source ${ZDOTDIR:-$HOME}/.zshrc.local
