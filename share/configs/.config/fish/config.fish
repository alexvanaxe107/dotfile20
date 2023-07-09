
############     ALIASES     #############
alias pacupg='sudo pacman -Syu'		# Synchronize with repositories and then upgrade packages that are out of date on the local system.
alias pacre='sudo pacman -R'		# Remove the specified package(s), retaining its configuration(s) and required dependencies

alias fdir='fdir.sh'
alias fvim="vim -u $HOME/.vimfullrc"

############     SETS     #############
set -gx PATH "$HOME/bin" "$PYENV_ROOT/bin" $PATH
set -x EDITOR vim
set -x SUDO_ASKPASS "/usr/bin/lxqt-openssh-askpass"
set -x FZF_DEFAULT_COMMAND 'fd -I --type f'

############     SOURCES     #############
source $HOME/.fdirrc
source $HOME/.config/fish/space.fish
source $HOME/.config/fish/completions/ng.fish
source $HOME/.config/fish/completions/django.fish
source $HOME/.config/fish/completions/theme_select.fish

###########     INIT PYENV     ###########
pyenv init - | source

###########     CONFIGS        ###########
fish_vi_key_bindings

