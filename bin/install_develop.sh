#!/usr/bin/env bash

# Install and configure the node.
# Node itself should already be installed on home-manager
#
# Here we add the npm path and install the language servers.

echo "Configuring the npm"
export NPM_ROOT=$HOME/Documents/npm
export npm_config_prefix="$HOME/Documents/npm/"

npm -g install bash-language-server
npm -g install pyright
npm -g install typescript-language-server
npm -g install vue-language-server
npm -g install svelte-language-server
