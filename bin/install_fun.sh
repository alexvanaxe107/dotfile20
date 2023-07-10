# We will not include the env bash because it will be executed in the nix install
# But it can be executed at any moment, when we want to override the unchangable files
# for new ones. Here must have only 'static' files.

umask 022 # NIX_PROFILE_DIR="$NIX_USER_PROFILE_DIR/profile"

force="$1"

if [ "$force" == "force" ];  then
    echo "Force is enabled"
fi

# Allow unfree
NIXPKGS_ALLOW_UNFREE=1

NIX_PROFILE_DIR="$HOME/.nix-profile"
AVA_TEMPLATES="$NIX_PROFILE_DIR/share/avatemplates"
AVA_CONFIGS="$NIX_PROFILE_DIR/share/configs"
USER_CONFIGS="$HOME/.configs"

echo "Copying the configuration files"
if [ ! -f $HOME/.config/home-manager/ava.nix ]; then
    cp --no-preserve=all $AVA_TEMPLATES/home-manager/fun.nix $HOME/.config/home-manager/ava.nix
    cp --no-preserve=all $AVA_CONFIGS/.config/home-manager/home.nix $HOME/.config/home-manager/
else
    if [ "$force" == "force" ];  then
        cp --no-preserve=all $AVA_TEMPLATES/home-manager/fun.nix $HOME/.config/home-manager/ava.nix
        cp --no-preserve=all $AVA_CONFIGS/.config/home-manager/home.nix $HOME/.config/home-manager/
    fi
fi

# Configuring settings
# -- Configurar git para global store
git config --global credential.helper store
# -- Ele trava as vezes quando o comit é grande. Entao fazemos:
git config --global http.postBuffer 157286400

