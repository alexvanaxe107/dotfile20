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

USER_TEMPLATE="$HOME/templates"
USER_CONFIGS="$HOME/configs"

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

echo "Pointing to the config files. Probably you can ignore any error."
sleep 3
manage_configs.sh -l

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

if [ ! -z "$(command -v home-manager)" ]; then
    echo
    echo "Skiping installing home manager. To install or update the programs, please run:"
    echo "nix run home-manager/$nix_release -- switch"
    echo
else
    nix run home-manager/$nix_release -- switch
fi

echo
echo "Installing and fixing the tdm permissions"
tdmctl init
chmod 700 $HOME/.config/tdm
chmod 700 $HOME/.config/tdm/sessions

tdmctl add ava $NIX_PROFILE_DIR/bin/wms/start-bspwm.sh
tdmctl add focus $NIX_PROFILE_DIR/bin/wms/start-emacs.sh

echo "Configuration is done. Next steps:"
echo "You can run theme_select.sh -t light to copy the default templates"
echo "Install the tmux plugins with ctl+a +I"
echo "Install neovim plugins with PackerInstall (dont forget to nix shell nixpkgs#gcc before)"
echo "I think that it's it. Enjoy"
