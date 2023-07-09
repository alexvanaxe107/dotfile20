# We will not include the env bash because it will be executed in the nix install
# But it can be executed at any moment, when we want to override the unchangable files
# for new ones. Here must have only 'static' files.
NIX_PROFILE_DIR="$NIX_USER_PROFILE_DIR/profile"
AVA_TEMPLATES="$NIX_PROFILE_DIR/share/avatemplates"

USER_TEMPLATE="$HOME/templates"

if [ -f "$USER_TEMPLATE" ]; then
    echo "Template already exists. Not touching it."
else
    echo "Creating symlink to template"
    ln -s $AVA_TEMPLATES $USER_TEMPLATE
fi

echo "Copying the configuration files"
#cp -rf $HOME/configs/* $HOME
#cp -rf $HOME/configs/.* $HOME
