#!/usr/bin/env bash

# Install and configure the node. For this we will use the nvm.
# https://github.com/nvm-sh/nvm
#
# Running either of the above commands downloads a script and runs it. 
# The script clones the nvm repository to ~/.nvm, and attempts to add the 
# source lines from the snippet below to the correct profile 
# file (~/.bash_profile, ~/.zshrc, ~/.profile, or ~/.bashrc).


curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash


