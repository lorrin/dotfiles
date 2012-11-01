#!/usr/bin/env ruby

# from http://errtheblog.com/posts/89-huba-huba

home = File.expand_path('~')

Dir['symlink/*'].each do |file|
  target = File.join(home, ".#{File.basename(file)}")
  if File.exists? target or File.symlink? target
    puts "#{target} exists, will not overwrite."
  else  
    puts "Linking #{target} -> #{File.expand_path file}"
    `ln -s #{File.expand_path file} #{target}`
  end
end

# git push on commit
`echo 'git push' > .git/hooks/post-commit`
`chmod 755 .git/hooks/post-commit`
