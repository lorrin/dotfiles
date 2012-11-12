#!/usr/bin/env ruby

# originally adapted from http://errtheblog.com/posts/89-huba-huba
# spf13-vim bits extracted from https://raw.github.com/spf13/spf13-vim/3.0/bootstrap.sh


def symlink(source, target_relative_path, target_filename)
  home = File.expand_path('~')
  source = File.expand_path(source)
  target = File.join(home, target_relative_path, target_filename)
  if File.symlink? target
    if File.readlink(target) == source
      # nothing to do
    else
      puts "Removing stale symlink #{target} -> #{File.readlink(target)}"
      `rm #{target}` if File.symlink? target
    end
  end

  if not File.symlink? target
    if File.exists? target
      puts "#{target} exists locally, will not overwrite."
    else
      `mkdir -p #{home}/#{target_relative_path} &2>/dev/null`
      puts "Linking #{target} -> #{source}"
      `ln -s #{source} #{target}`
    end
  end
end


Dir['simple/*'].each { |file| symlink(file, "", "." + File.basename(file)) }
symlink("oh-my-zsh", "", ".oh-my-zsh")
symlink("zsh-syntax-highlighting", ".oh-my-zsh/custom/plugins", "zsh-syntax-highlighting")
symlink("oh-my-zsh-custom/lorrin.zsh-theme", ".oh-my-zsh/themes", "lorrin.zsh-theme")
symlink("spf13-vim", "", ".spf13-vim-3")
symlink("vundle", ".vim/bundle", "vundle")
[".vimrc", ".vimrc.fork", ".vimrc.bundles", ".vimrc.bundles.fork"].each { |file|
    symlink(File.join("spf13-vim", file), "", file)
}

puts "Now run: vim -u spf13-vim/.vimrc +BundleInstall! +BundleClean +qall"


#`mkdir -p $HOME/.oh-my-zsh/custom/plugins &2>/dev/null`
#file = 'zsh-syntax-highlighting'
#target = File.join(home, '.oh-my-zsh/custom/plugins', "#{File.basename(file)}")
#if File.exists? target or File.symlink? target
#    puts "#{target} exists, will not overwrite."
#else  
#    puts "Linking #{target} -> #{File.expand_path file}"
#    `ln -s #{File.expand_path file} #{target}`
#end
#
#
#
#file = 'spf13-vim-3'
#target = File.join(home, ".#{File.basename(file)}")
#if File.exists? target or File.symlink? target
#    puts "#{target} exists, will not overwrite."
#else  
#    puts "Linking #{target} -> #{File.expand_path file}"
#    `ln -s #{File.expand_path 'spf13-vim'} #{target}`
#end

# git push on commit
`echo 'git push' > .git/hooks/post-commit`
`chmod 755 .git/hooks/post-commit`
