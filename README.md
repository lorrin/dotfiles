Installation
------------
* Install zsh, git, vim, ruby.
* Configure git.
 * GitHub SSH keys
 * `~/.ssh/config` contains:
    <pre>
        Host github.com
          IdentityFile ~/.ssh/keyfile_name
</pre>
* Change shell to zsh in `/etc/passwd`
* Pull in vim submodules.
   <pre>
cd ~/dotfiles
git submodule init
git submodule update
</pre>
* Install dotfiles into `~`
   <pre>
cd ~/dotfiles
./install
</pre>
* Adjust git global config:
   <pre>
git config --global user.name "First Last"
git config --global user.email "foo@bar.org"
</pre>

### VIM Command-T support
* Need Vim with Ruby bindings. Get either `vim-nox` or `vim-gnome` package. Check with `vim --version`; should show `+ruby`.
* In `~/.vim/bundle/command-t` run `bundle install`
 * presumes bundler is installed
 * TODO: rvm steps, `libxml2 is missing` errors ...

Updates
-------
* Update submodules from upstream
    <pre>
git submodule foreach git pull origin master
git commit -a
</pre>
