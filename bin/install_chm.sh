# We will not include the env bash because it will be executed in the nix install
# But it can be executed at any moment, when we want to override the unchangable files
# for new ones. Here must have only 'static' files.

umask 022

# NIX_PROFILE_DIR="$NIX_USER_PROFILE_DIR/profile"
NIX_PROFILE_DIR="$HOME/.nix-profile"
AVA_TEMPLATES="$NIX_PROFILE_DIR/share/avatemplates"
AVA_CONFIGS="$NIX_PROFILE_DIR/share/configs"

USER_TEMPLATE="$HOME/templates"
USER_CONFIGS="$HOME/configs"
USER_DOCS_NIX="$HOME/Documents/Projects/nixconfs/"

if [ -L "$USER_TEMPLATE" ]; then
    echo "Template already exists. Not touching it."
else
    echo "Creating symlink to template"
    ln -s $AVA_TEMPLATES $USER_TEMPLATE
fi

if [ -L "$USER_CONFIGS" ]; then
    echo "Config already exists. Not touching it."
else
    echo "Creating symlink to configs"
    ln -s $AVA_CONFIGS $USER_CONFIGS
fi

echo "Copying the configuration files"
cp --no-preserve=all -rf $HOME/configs/* $HOME
cp --no-preserve=all -rf $HOME/configs/.* $HOME
chmod 700 $HOME/.config/bspwm/bspwmrc

echo "Cloning nixos conigs"
if [ ! -d "$USER_DOCS_NIX" ]; then
    git clone "https://github.com/alexvanaxe107/nixconfs.git" "$USER_DOCS_NIX"
fi

echo "installing the packages"
#nix-env -f '<nixpkgs>' -r -iA userPackages
