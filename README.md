# Installation

1. Install zsh, git, vim, stow.
    - vim on Linux: use vim-nox or vim-gnome.
    - vim on Mac OS X: use sudo port install vim
    - zsh on Mac OS X: use older stock zsh or sudo port install zsh
1. Install the Python requests module
1. Change default shell to zsh
    - Linux: `chsh -s /usr/bin/zsh`
    - Mac OS X with MacPorts zsh: `sudo chsh -s /opt/local/bin/zsh <user>`
    - Mac OS X with stock zsh: `chsh -s /bin/zsh`
1. Clone dotfiles repo:
    - `cd ~`
    - for read-only use: `git clone https://github.com/lorrin/dotfiles.git`
    - for read-write use:
        - install GitHub SSH keys
        - `~/.ssh/config` contains:
           ```
            Host github.com
              IdentityFile ~/.ssh/keyfile_name
            ```
        - `git clone git@github.com:lorrin/dotfiles.git`
1. `dotfiles/install_or_update.sh`

# Getting Updates
1. `cd ~/dotfiles`
1. `git pull`
1. `./install_or_update.sh`

# Machine-specific configuration
1. Create new directory `~/dotfiles/local_$(hostname -s)`
1. Add dot-files into directory
1. `./install_or_update.sh`
