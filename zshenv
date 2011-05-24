# This file is for setting up environment variables needed regardless of whether
# interactive or not.

export MAVEN_OPTS="-Xms256m -Xmx768m"

# Load machine-local config
[[ -e ~/.zshenv.local ]] && source ~/.zshenv.local
