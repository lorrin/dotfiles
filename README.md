Installation
------------
1. Install zsh, git, ruby, vim.
  * Linux: use `vim-nox` or `vim-gnome`.
  * Mac OS X: use `sudo port install vim +perl +python27 +tcl +ruby zsh`
    * Also fine to just use older stock zsh
1. *Optional, if editing dotfiles required*: Configure git.
 * GitHub SSH keys
 * `~/.ssh/config` contains:
   <pre>
        Host github.com
          IdentityFile ~/.ssh/keyfile_name
</pre>
 * Adjust git global config:
   <pre>
git config --global user.name "Lorrin Nelson"
git config --global user.email "spam@lorrin.org"
</pre>
1. Change shell to zsh
  * Linux: `chsh -s /usr/bin/zsh`
  * Mac OS X with MacPorts zsh: `sudo chsh -s /opt/local/bin/zsh <user>`
  * Mac OS X with stock zsh: `chsh -s /bin/zsh`
1. Grab dotfiles:
  * with unconfigured git: `git clone https://github.com/lorrin/dotfiles.git`
  * with configured git: `git clone git@github.com:lorrin/dotfiles.git`
1. Pull in submodules.
   <pre>
cd dotfiles
git submodule init
git submodule update
</pre>
1. Install dotfiles into `~`
   <pre>
cd ~/dotfiles
./install.rb
</pre>
1. Follow on-screen instructions. Something like: `vim -u spf13-vim/.vimrc +BundleInstall! +BundleClean +qall`

Updates
-------
Update submodules from upstream with `./update.sh`
