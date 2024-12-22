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

# The root-user highlighter (using "standout") is hard to read. Change to bold
# https://github.com/sorin-ionescu/prezto/issues/1773
export ZSH_HIGHLIGHT_STYLES[root]='bold'

export EDITOR=vim

# Allow ctrl-r / ctrl-f to cycle through history matches.
# Note in vicmd mode ? and / are bound to these, and ctrl-r is bound to redo.
bindkey -M viins '^R' history-incremental-pattern-search-backward
bindkey -M viins '^F' history-incremental-pattern-search-forward
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# Prefer Homebrew installed GNU toolchain over BSD if present
[[ -d /opt/homebrew/opt/gnu-sed/libexec/gnubin ]] && export PATH=/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH
# Prefer MacPorts installed GNU toolchain over BSD if present
[[ -d /opt/local/libexec/gnubin ]] && export PATH=/opt/local/libexec/gnubin:$PATH

# Set JAVA_HOME on macOS
if [ -e /usr/libexec/java_home ]; then
    # Do nothing if no Java JVMs are installed
    if /usr/libexec/java_home --failfast > /dev/null 2>&1; then
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
# git log mine
alias glm="git branch | grep $USER | sed -e 's/[ *]*//' | paste -s -d ' ' - | xargs git log --graph --pretty=format:'%Cred%h%Creset - %Cgreen%ci%x08%x08%x08%x08%x08%x08%x08%x08%x08%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit HEAD"

# Git origin/main|master -- figure out if origin uses main or master
function gom(){
    echo -n $(git branch --remote --list "origin/main"; git branch --remote --list "origin/master") | head -n1
}

# More git aliases
# git branch origin main
function gbom(){
    git checkout -b $1 $(gom)
}

# Gall's where-the-fork git_wft_* aliases. Diff against where branch split from main.
alias gwtf='git merge-base $(gom) HEAD' # where-the-fork
alias gwtfd='git diff `gwtf`' #where-the-fork diff
alias gwtff='git diff `gwtf` --name-only' # where-the-fork [changed] files

# Safe incarnation, equivalent to gbxm below:
# alias git-branch-clean="git branch --merged | grep -vE '^\* ' | xargs -r git branch -d"
# Dangerous incarnation to work with the horrid GitHub squash merge feature. Assume branches whose upstream is gone are
# OK to delete. "git branch gone" and "git branch delete gone"
alias gbg="gb | grep '\[origin/.*: gone\]'"
alias gbxg="gbg | grep -v '^*' | awk '{print \$1}' | xargs -r git branch -D"
# git branch delete merged
alias gbxm="git branch --merged | grep -vP '^\* ' | xargs -r git branch -d"
# git fetch (all)
alias gfa="git fetch --all --prune"
alias gf="git fetch --prune"
# git commit in progress
alias gcip='git commit -a -m "$((git diff --name-only; git diff --staged --name-only) | sort | uniq | wc -l | xargs) files in progress on $(git branch --show-current) at $(date "+%Y-%m-%d %H:%M")" --no-verify'
# git branch
alias gb="git --no-pager branch -vv"

# https://stackoverflow.com/a/21302474
git-rename-remote-branch() {
  if [ $# -ne 3 ]; then
    echo "Rationale : Rename a branch on the server without checking it out."
    echo "Usage     : ${FUNCNAME[0]} <remote> <old name> <new name>"
    echo "Example   : ${FUNCNAME[0]} origin master release"
    return 1
  fi

  git push $1 $1/$2\:refs/heads/$3 :$2
}


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

    if python3 -m pip 2>&1 > /dev/null && python3 -m pip --disable-pip-version-check list | grep -E '^virtualenv\s' > /dev/null; then
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
    export BAT_THEME='Solarized (dark)'
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

# Eza alternative to ls. Note that it is not a drop-in replacement. https://eza.rocks/
if type eza > /dev/null; then
    alias ls='eza --all --long --classify --header --group --git --icons --color-scale'
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

export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc

# OS-specific
OS=$(uname -o | tr '[:upper:]' '[:lower:]')
if [[ "$OS" == "darwin" ]]; then

    # Note: as of MacOS 15, base station SSID is redacted unless an app has access to Location Services.
    # However, you can only grant Location Services access to GUI apps. https://github.com/noperator/wifi-unredactor
    # is a tool to get permission granted and then wrap wdutil.
    function wifi_check() {
        if [ -f ~/Applications/wifi-unredactor.app/Contents/MacOS/wifi-unredactor ]; then
            WIFI=$(~/Applications/wifi-unredactor.app/Contents/MacOS/wifi-unredactor)
            ERROR=$(echo $WIFI | jq -r .error)
            if [[ "$ERROR" == null ]]; then
                BSSID=$(echo $WIFI | jq -r .bssid | tr '[:lower:]' '[:upper:]')
                STATION=$(echo '{"C0:25:E9:83:B6:A0": "Basement 5GHz 802.11nac", "C0:25:E9:83:B6:A1": "Basement 2.4GHz 802.11bgn", "78:D2:94:4A:A5:B9": "Media room 5GHz 802.11nac", "78:D2:94:4A:A5:BA": "Media room 2.4GHz 802.11bgn", "B0:BE:76:77:46:52": "Attic 5GHz 802.11nac", "B0:BE:76:77:46:53": "Attic 2.4GHz 802.11bgn"}' | jq -r .\"$BSSID\")
                # use xargs to trim whitespace
                SPEED=$(sudo wdutil info | grep 'Tx Rate' | cut -d: -f2 | xargs)
                # https://www.lifewire.com/wireless-standards-802-11a-802-11b-g-n-and-802-11ac-816553
                declare -A MODES
                MODES=( \
                    [11b]="Wi-Fi 1 (b; max 11Mbps)" \
                    [11a]="Wi-Fi 2 (a; max 11Mbps)" \
                    [11g]="Wi-Fi 3 (g; max 54Mbps)" \
                    [11n]="Wi-Fi 4 (n; max 600Mbps)" \
                    [11ac]="Wi-Fi 5 (ac; max 1300Mbps)" \
                    [11ax]="Wi-Fi 6 (ax; max 10Gbps)" \
                    [11be]="Wi-Fi 7 (be; max 46Gbps)" \
                )
                MODE=$(sudo wdutil info | grep PHY | cut -d: -f2 | xargs)
                echo "$STATION via ${MODES[$MODE]:-$MODE} @ $SPEED"
            else
                echo "Error accessing BSSID ('$ERROR'). Ensure Location Services enabled for wifi-unredactor."
            fi
        else
            echo 'https://github.com/noperator/wifi-unredactor is required to retrieve BSSID'
        fi
        #echo '{"C0:25:E9:83:B6:A0": "Basement 5GHz 802.11nac", "C0:25:E9:83:B6:A1": "Basement 2.4GHz 802.11bgn", "78:D2:94:4A:A5:B9": "Media room 5GHz 802.11nac", "78:D2:94:4A:A5:BA": "Media room 2.4GHz 802.11bgn", "B0:BE:76:77:46:52": "Attic 5GHz 802.11nac", "B0:BE:76:77:46:53": "Attic 2.4GHz 802.11bgn"}' | jq ".\"$(sudo /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep BSSID | awk '{print $2}'| tr "[:lower:]" "[:upper:]")\" + \" @ $(sudo /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep lastTxRate | awk '{print $2}') Mbps\""
    }

    # grep for listening processes
    # https://stackoverflow.com/a/30029855
    portgrep() {
        if [ $# -eq 0 ]; then
            sudo lsof -iTCP -sTCP:LISTEN -n -P
        elif [ $# -eq 1 ]; then
            sudo lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color $1
        else
            echo "Usage: listening [pattern]"
        fi
    }

    portkill() {
        # Extract PID from: ruby      38103 lorrin   12u  IPv4 0x4f0bb1f421af2e1b      0t0  TCP *:3000 (LISTEN)
        PIDS=$(portgrep $1 | awk '{print $2}' | tr '\n' ' ')
        sudo kill $PIDS
    }

    # Convert macOS Quicktime .mov to animated GIF (https://gist.github.com/baumandm/1dba6a055356d183bbf7)
    # Dropbox Paper makes static preview for images that are 8.9 MB. 7.3 MB gets actual image (and hence animation)
    function movtogif () {
      width=1600
      fps=5
      loop=0
      tempfile=.mov-to-gif-$(date +"%s").png
      ffmpeg -i $1 -vf "scale=${width}:-2" "${1%.mov}-resized.mov"
      ffmpeg -stats -y -i "${1%.mov}-resized.mov" -vf fps=${fps},palettegen -loop $loop $tempfile
      ffmpeg -stats -i "${1%.mov}-resized.mov" -i $tempfile -filter_complex "fps=${fps},paletteuse" -loop $loop "${1%.mov}.gif"
      rm $tempfile "${1%.mov}-resized.mov"
    }
fi

if type fastfetch > /dev/null; then
    alias neofetch=fastfetch
fi
