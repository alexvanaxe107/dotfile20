# We will not include the env bash because it will be executed in the nix install
# But it can be executed at any moment, when we want to override the unchangable files
# for new ones. Here must have only 'static' files.

INSTALL_DIR="$0"

echo $INSTALL_DIR

echo "Copying the configuration files"
#cp -rf $HOME/configs/* $HOME
#cp -rf $HOME/configs/.* $HOME
