# We will not include the env bash because it will be executed in the nix install
# But it can be executed at any moment, when we want to override the unchangable files
# for new ones. Here must have only 'static' files.

umask 022 # NIX_PROFILE_DIR="$NIX_USER_PROFILE_DIR/profile"
nix_release="release-23.11"

force="$1"

if [ "$force" == "force" ];  then
    echo "Force is enabled"
fi

# Allow unfree
NIXPKGS_ALLOW_UNFREE=1

NIX_PROFILE_DIR="$HOME/.nix-profile"
AVA_TEMPLATES="$NIX_PROFILE_DIR/share/avatemplates"
AVA_CONFIGS="$NIX_PROFILE_DIR/share/configs"
USER_CONFIGS="$HOME/configs"

ln -s $AVA_CONFIGS $USER_CONFIGS

#nix run home-manager/${nix_release} -- init --switch

# Configuring settings
# -- Configurar git para global store
git config --global credential.helper store
# -- Ele trava as vezes quando o comit é grande. Entao fazemos:
git config --global http.postBuffer 157286400

