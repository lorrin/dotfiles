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

# Set JAVA_HOME on macOS
if [ -e /usr/libexec/java_home ]; then
    # Do nothing if no Java JVMs are installed
    if /usr/libexec/java_home --failfast > /dev/null; then
        function setjdk {
           local ver=${1:?Usage: setjdk <version> [architecture]}
           local arch=${2:-$(uname -m)}
           export JAVA_HOME="$(/usr/libexec/java_home --failfast --version $ver -V 2>&1 | grep "($arch)" | awk '{print $(NF)}')"
           if [ -n "$JAVA_HOME" ]; then
               export PATH="${JAVA_HOME}/bin:$(echo $PATH | tr ':' '\n' | grep -v Java | sed -e '/^$/d' | tr '\n' ':' | sed -e 's/:$//')"
           fi
        }
        setjdk 11
    fi
# Set JAVA_HOME otherwise
elif which java > /dev/null; then
    export JAVA_HOME=$(dirname $(dirname $(realpath $(which java))))
fi

alias ssh_noauth="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
alias scp_noauth="scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

# Install direnv hook for directory-based .envrc loading
if which direnv > /dev/null; then
    eval "$(direnv hook zsh)"
fi

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
alias git-branch-clean="git branch --merged | grep -vE '^\* ' | xargs -r git branch -d"
# git branch delete merged
alias gbxm="git branch --merged | grep -vP '^\* ' | xargs -r git branch -d"
# git fetch (all)
alias gfa="git fetch --all --prune"
alias gf="git fetch --prune"
# git commit in progress
alias gcip='git commit -a -m "$((git diff --name-only; git diff --staged --name-only) | sort | uniq | wc -l) files in progress on $(git branch --show-current) at $(date "+%Y-%m-%d %H:%M")" --no-verify'


# GPG_TTY for git code signing
export GPG_TTY=$(tty)

# Add iTerm shell integration, if available
if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
    INTEGRATION="${ZDOTDIR:-$HOME}/.iterm2_shell_integration.`basename $SHELL`"
    if ! [[ -e "${INTEGRATION}" ]]; then
        echo "Fetching iTerm shell integration"
        curl -L https://iterm2.com/shell_integration/zsh -o "$INTEGRATION"
    fi
    source ${ZDOTDIR:-$HOME}/.iterm2_shell_integration.`basename $SHELL`
fi

# Python
if which python3 > /dev/null; then
    PYTHON_SYSTEM_SCRIPTS="$(python3 -c "import sysconfig; print(sysconfig.get_path('scripts'))")"
    export PATH=$PATH:"$PYTHON_SYSTEM_SCRIPTS"
    PYTHON_USER_SCRIPTS="$(python3 -c "import os; import sysconfig; print(sysconfig.get_path('scripts', f'{os.name}_user'))")"
    export PATH=$PATH:"$PYTHON_USER_SCRIPTS"

    # Somewhat bogus to assume virtualenvwrapper was installed to Python 3; could have been Python 2
    # Proper thing to do would be to see which one has the virtualenvwrapper module available.
    # This is even more bogus if a virtualenv is already active and .zshrc is re-sourced.
    export VIRTUALENVWRAPPER_PYTHON=$(which python3)

    if python3 -m pip 2>&1 > /dev/null && python3 -m pip list | grep -E '^virtualenv\s' > /dev/null; then
        for P in "$PYTHON_SYSTEM_SCRIPTS" "$PYTHON_USER_SCRIPTS"; do
            if [ -e "${P}/virtualenvwrapper.sh" ]; then
                export WORKON_HOME=$HOME/.virtualenvs
                mkdir -p $WORKON_HOME
                # Work around GNU grep now issuing warnings when egrep is invoked. https://lists.gnu.org/archive/html/info-gnu/2022-09/msg00001.html
                source <(< "${P}/virtualenvwrapper.sh" sed -e 's/egrep/grep -E/')
                break
            fi
        done
        if which virtualenvwrapper.sh > /dev/null && ! which mkvirtualenv > /dev/null; then
            echo not found use $(which virtualenvwrapper.sh)
            export WORKON_HOME=$HOME/.virtualenvs
            mkdir -p $WORKON_HOME
            source <(< "$(which virtualenvwrapper.sh)" sed -e 's/egrep/grep -E/')
        fi
    fi
fi
if which poetry > /dev/null; then
    POETRY_COMPLETIONS="$HOME/.zprezto/modules/completion/external/src/_poetry"
    if ! [ -e "$POETRY_COMPLETIONS" ]; then
        echo "Installing poetry tab completions to $POETRY_COMPLETIONS"
        poetry completions zsh > "$POETRY_COMPLETIONS"
    fi
fi

export PATH=$PATH:$HOME/bin

# Rust
if [[ -d $HOME/.cargo/bin ]]; then
    export PATH=$PATH:$HOME/.cargo/bin
fi

# Node.js / npm
if [[ -d  $HOME/node_modules/.bin ]]; then
    export PATH=$PATH:$HOME/node_modules/.bin
fi

# bat is a cat(1) clone with syntax highlighting and Git integration.
if type bat > /dev/null; then
    alias cat='bat'
    export PAGER="`which bat` --style plain"
fi

alias preview="fzf --preview 'bat --color \"always\" {}'"

# If setxkbmap exists, use it to change capslock to escape
if setxkbmap_path="$(type -p setxkbmap)" && [[ ! -z $setxkbmap_path  ]]; then
    # https://askubuntu.com/a/830343
    setxkbmap -option caps:escape
fi

# Wait for TCP port to be open. https://stackoverflow.com/a/70975182
function wait-port {
    for _ in $(seq 1 40); do
        nc -z localhost $1 2>/dev/null && return
        sleep 0.25
    done;
    echo "⌛ Timeout awaiting port $1" >&2
    return 1
}

# Source machine-specific .zshrc
[[ -e ${ZDOTDIR:-$HOME}/.zshrc.local ]] && source ${ZDOTDIR:-$HOME}/.zshrc.local

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

function title {
    if { [ "$TERM" = "screen" ] && [ -n "$TMUX" ] }; then 
        # Usually in tmux you just do prefix-r (e.g. ctrl-b-r) to change the title, but
        # with iTerm2 tmux integration it is not possible to directly issue tmux commands.
        # Hence the need for this alias.
        tmux rename-window "$*"
    else
        # For use without tmux; see https://superuser.com/a/599156
        echo -ne "\033]0;"$*"\007"
    fi
}

# Open a new iTerm tab. https://apple.stackexchange.com/a/360827
function ttab {
  osascript \
    -e 'tell application "iTerm2" to tell current window to set newWindow to (create tab with default profile)'\
    -e "tell application \"iTerm2\" to tell current session of newWindow to write text \"$*\""
}

# https://gitlab.com/gnachman/iterm2/-/wikis/tmux-Integration-Best-Practices#how-do-i-use-shell-integration
export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES

# Exa alternative to ls. Note that it is not a drop-in replacement. https://the.exa.website/
if type exa > /dev/null; then
    alias ls='exa --all --long --classify --header --group --git --icons --color-scale'
fi

# pgcli is a postgres client that does auto-completion and syntax highlighting
if type pgcli > /dev/null; then
    alias psql=pgcli
fi

# viddy alternative to watch that does diff highlighting, change tracking
if type viddy > /dev/null; then
    alias watch=viddy
fi

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
