Usage Notes
------------
* Set up git 
   <pre>
git config --global user.name "Lorrin Nelson"
git config --global user.email "foo@lorrin.org"
</pre>
* Pull in vim submodules
   <pre>
cd vim 
git submodule init
git submodule update
</pre>
* Update submodules from upstream
    <pre>
git submodule foreach git pull origin master‧
git commit -a
</pre>
