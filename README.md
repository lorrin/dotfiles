Installation
------------
1. Install zsh, git, ruby, vim, stow.
  * vim on Linux: use `vim-nox` or `vim-gnome`.
  * vim on Mac OS X: use `sudo port install vim +perl +python27 +tcl +ruby`
  * zsh on Mac OS X: use older stock zsh or `sudo port install zsh`
1. Change default shell to zsh
  * Linux: `chsh -s /usr/bin/zsh`
  * Mac OS X with MacPorts zsh: `sudo chsh -s /opt/local/bin/zsh <user>`
  * Mac OS X with stock zsh: `chsh -s /bin/zsh`
1. Clone dotfiles repo:
  * `cd ~`
  * for read-only use: `git clone https://github.com/lorrin/dotfiles.git`
  * for read-write use:
      * install GitHub SSH keys
      * `~/.ssh/config` contains:
        <pre>
            Host github.com
              IdentityFile ~/.ssh/keyfile_name
</pre>
      * `git clone git@github.com:lorrin/dotfiles.git`
      * Adjust git config:
       <pre>
    cd ~/dotfiles
    git config user.name "echo $(cat /etc/passwd | grep $USER | cut -d: -f 5 | cut -d, -f1)"
    git config user.email "$USER@lorrin.org"
</pre>
  * Update submodule:
    <pre>
    cd ~/dotfiles
    git submodule init
    git submodule update
</pre>
1. Use `stow` to install symlinks for desired items. Do not use oh-my-zsh and zprezto together.
  <pre>
cd ~/dotfiles
for item in git oh-my-zsh readline screen spf13-vim-3 vim; do stow $item; done;
</pre>
1. Install vim bundles: `vim +BundleInstall! +BundleClean +q`

Updates
-------
<pre>
cd ~/dotfiles
git pull
git submodule update

cd ~/.oh-my-zsh
git pull --no-rebase upstream master

cd ~/.zprezto
git pull --no-rebase upstream master

cd ~/.spf13-vim-3
git pull --no-rebase upstream 3.0
vim +BundleInstall! +BundleClean +q
</pre>
