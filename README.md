Installation
------------
* Install zsh, git, ruby, vim. On Linux use `vim-nox` or `vim-gnome`. On OS X use `sudo port install vim +perl +python27 +tcl +ruby`
* Configure git.
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
* Change shell to zsh in `/etc/passwd`. On OS X use `sudo chsh -s /opt/local/bin/zsh <user>` (for MacPorts ZSH; can also just use `/bin/zsh`). Alternately in GUI: System Preferences -> Users & Groups -> Right Click -> Advanced Options...
* Pull in submodules.
   <pre>
cd ~/dotfiles
git submodule init
git submodule update
</pre>
* Install dotfiles into `~`
   <pre>
cd ~/dotfiles
./install.rb
</pre>

Updates
-------
Update submodules from upstream with `./update.sh`
