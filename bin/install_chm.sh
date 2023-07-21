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

USER_TEMPLATE="$HOME/templates"
USER_CONFIGS="$HOME/configs"
USER_DOCS_NIX="$HOME/Documents/Projects/nixconfs/"

VIDEO_DIR="$HOME/Videos" # This is for the lockscreen

if [ -L "$USER_TEMPLATE" ]; then
    echo "Template already exists. Not touching it."
    if [ "$force" == "force" ];  then
        ln -s $AVA_TEMPLATES $USER_TEMPLATE
    fi
else
    echo "Creating symlink to template"
    ln -s $AVA_TEMPLATES $USER_TEMPLATE
fi

if [ -L "$USER_CONFIGS" ]; then
    echo "Config link already exists. Not touching it."
    if [ "$force" == "force" ];  then
        ln -s $AVA_CONFIGS $USER_CONFIGS
    fi
else
    echo "Creating symlink to configs"
    ln -s $AVA_CONFIGS $USER_CONFIGS
fi


if [ ! -f $HOME/.config/bspwm/bspwmrc ]; then
    echo "Copying the configuration files"
    cp --no-preserve=all -rf $HOME/configs/* $HOME
    cp --no-preserve=all -rf $HOME/configs/.* $HOME
    chmod 700 $HOME/.config/bspwm/bspwmrc
    chmod 700 $HOME/.config/sxiv/exec/*
else
    echo "Config exists. Try with force to override it"
    if [ "$force" == "force" ];  then
        cp --no-preserve=all -rf $HOME/configs/* $HOME
        cp --no-preserve=all -rf $HOME/configs/.* $HOME
        chmod 700 $HOME/.config/bspwm/bspwmrc
        chmod 700 $HOME/.config/sxiv/exec/*
    fi
fi

if [ ! -d "$USER_DOCS_NIX" ]; then
    echo "Cloning nixos conigs"
    git clone "https://github.com/alexvanaxe107/nixconfs.git" "$USER_DOCS_NIX"
else
    if [ "$force" == "force" ];  then
        git clone "https://github.com/alexvanaxe107/nixconfs.git" "$USER_DOCS_NIX"
    fi
fi

mkdir $VIDEO_DIR

# Configuring settings
# -- Configurar git para global store
git config --global credential.helper store
# -- Ele trava as vezes quando o comit é grande. Entao fazemos:
git config --global http.postBuffer 157286400

# -- configurar o packer. Rodar:
if [ ! -d ~/.local/share/nvim/site/pack/packer/start/packer.nvim ]; then
    echo "configuring packer"
    git clone --depth 1 https://github.com/wbthomason/packer.nvim\
     ~/.local/share/nvim/site/pack/packer/start/packer.nvim
else
    if [ "$force" == "force" ];  then
        echo "Configuring packer"
        git clone --depth 1 https://github.com/wbthomason/packer.nvim\
         ~/.local/share/nvim/site/pack/packer/start/packer.nvim
    fi
fi

# -- configurar o tmux
if [ ! -d ~/.tmux/plugins/tpm ]; then
    echo "Configuring tmux"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    if [ "$force" == "force" ];  then
        echo "Configuring tmux"
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
fi

if [ ! -f $HOME/.config/home-manager/ava.nix ]; then
    cp --no-preserve=all $HOME/templates/home-manager/ava.nix $HOME/.config/home-manager/
    nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager
    nix-channel --update
    # -- Configurar home-manager
    nix-shell '<home-manager>' -A install
else
    if [ "$force" == "force" ];  then
        cp --no-preserve=all $HOME/templates/home-manager/ava.nix $HOME/.config/home-manager/
        nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager
        nix-channel --update
        # -- Configurar home-manager
        nix-shell '<home-manager>' -A install
    fi
fi
