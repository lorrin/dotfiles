# Installation

1. Install zsh, git, vim, stow, git-delta.
    - vim on Linux: use `vim-nox` or `vim-gnome`, [get git-delta here](https://github.com/dandavison/delta/releases)
    - git, vim and zsh on macOS: stock versions are relatively current. Alternatively `sudo port install` or `brew install`
        them.
1. Change default shell to zsh
    - Linux: `chsh -s /usr/bin/zsh`
    - macOS with MacPorts or Homebrew zsh: `sudo chsh -s /opt/local/bin/zsh <user>`
1. Clone dotfiles repo:
    - `cd ~`
    - for read-only use: `git clone https://github.com/lorrin/dotfiles.git`
    - for read-write use:
        - install GitHub SSH keys or [enable 1Password SSH agent](https://developer.1password.com/docs/ssh/get-started#step-3-turn-on-the-1password-ssh-agent)
        - `~/.ssh/config` contains:
           ```
            Host github.com
              IdentityFile ~/.ssh/keyfile_name
            ```
        - `git clone git@github.com:lorrin/dotfiles.git`
1. `dotfiles/install_or_update.sh`
1. `p10k configure`

# Getting Updates
1. `cd ~/dotfiles`
1. `git pull`
1. `./install_or_update.sh`

# Machine-specific configuration
1. Create new directory `~/dotfiles/local_$(hostname -s)`
1. Add dot-files into directory
1. `./install_or_update.sh`

# iTerm2 Configuration
Under **Preferences -> General**, enabled **Load preferences from a custom folder or URL**, select
**~/dotfiles/iterm2**, and set to Save changes automatically.
