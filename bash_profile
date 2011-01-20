# http://stefaanlippens.net/bashrc_and_others

# ~/.profile for things every login shell needs, independant of Bash. E.g.
# PATH and other environment variables. Terminal.app opens login shells.

# ~/.bashrc for Bash configuration. By default only non-login interactive
# shells look at ~/.bashrc, whereas interative login shells look here in
# ~/.bash_profile. Starting a screen session creates a non-login shell.

# This file ensures that login Bash shells include the bash configuration in
# ~/.bashrc

. ~/.bashrc
