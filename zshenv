# This file is for setting up environment variables needed regardless of whether
# interactive or not.

# MacPorts Installer addition on 2010-07-20_at_21:55:31: adding an appropriate PATH variable for use with MacPorts.
PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.
PATH=~/bin:$PATH

# Java
export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/1.6/Home
export CLOJURE_HOME=/Applications/clojure-1.2.0
export JLINE_HOME=/Applications/jline-0.9.5

# Maven (note Maven 3 is still using M2_* variables)
export M2_HOME=/Applications/apache-maven-3.0.1
export MAVEN_OPTS="-Xms256m -Xmx768m"

# RVM per http://rvm.beginrescueend.com/rvm/install/
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
