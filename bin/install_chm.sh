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
    echo "Config already exists. Not touching it."
    if [ "$force" == "force" ];  then
        ln -s $AVA_CONFIGS $USER_CONFIGS
    fi
else
    echo "Creating symlink to configs"
    ln -s $AVA_CONFIGS $USER_CONFIGS
fi

echo "Copying the configuration files"
if [ ! -f $HOME/.config/home-manager/ava.nix ]; then
    cp --no-preserve=all $HOME/template/home-manager/ava.nix $HOME/.config/home-manager/
else
    if [ "$force" == "force" ];  then
        cp --no-preserve=all $HOME/template/home-manager/ava.nix $HOME/.config/home-manager/
    fi
fi

cp --no-preserve=all -rf $HOME/configs/* $HOME
cp --no-preserve=all -rf $HOME/configs/.* $HOME
chmod 700 $HOME/.config/bspwm/bspwmrc
chmod 700 $HOME/.config/sxiv/exec/*

if [ ! -d "$USER_DOCS_NIX" ]; then
    echo "Cloning nixos conigs"
    git clone "https://github.com/alexvanaxe107/nixconfs.git" "$USER_DOCS_NIX"
else
    if [ "$force" == "force" ];  then
        git clone "https://github.com/alexvanaxe107/nixconfs.git" "$USER_DOCS_NIX"
    fi
fi


if [ ! -f $HOME/.config/wm/install.lock ]; then
    echo "installing the packages"
    nix-env -f '<nixpkgs>' -r -iA userPackages
else
    if [ "$force" == "force" ];  then
        echo "installing the packages"
        nix-env -f '<nixpkgs>' -r -iA userPackages
    fi
fi
echo "install.lock" > $HOME/.config/wm/install.lock

# Configuring settings
# -- Configurar git para global store
git config --global credential.helper store
# -- Ele trava as vezes quando o comit é grande. Entao fazemos:
git config --global http.postBuffer 157286400

# -- configurar o packer. Rodar:
if [ ! -d ~/.local/share/nvim/site/pack/packer/start/packer.nvim ]; then
    echo "oOnfiguring packer"
    git clone --depth 1 https://github.com/wbthomason/packer.nvim\
     ~/.local/share/nvim/site/pack/packer/start/packer.nvim
else
    if [ "$force" == "force" ];  then
        echo "oOnfiguring packer"
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

# -- Configurar home-manager
nix-shell '<home-manager>' -A install
