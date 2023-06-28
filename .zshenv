# --------------------------------------------------------
# Usual configs
# --------------------------------------------------------
source ~/.profile

alias ls='ls -h --color'
alias fuck='sudo $(fc -ln -1)'
alias todo.sh='todo.sh -d /home/media/todos/general/config/config'
alias day.sh='todo.sh -d /home/media/todos/day/config/config'
alias long.sh='todo.sh -d /home/media/todos/long/config/config'

#export SUDO_ASKPASS=/usr/bin/lxqt-openssh-askpass
#typeset -U path
export EDITOR=vim
export XDG_SESSION_DESKTOP=i3
export XDG_CURRENT_DESKTOP=i3

# alias clear="clear;echo;spark.sh"
# alias clear="clear;echo"

# --------------------------------------------------------
# npm configs
# --------------------------------------------------------
# Set up Node Version Manager
# source /usr/share/nvm/init-nvm.sh
# Will be used the nvm, and the bin will be linked to it
# export npm_config_prefix="$HOME/Documents/npm/bin"

# export NVM_DIR="$HOME/Documents/.nvm"
# source /usr/share/nvm/nvm.sh
# source /usr/share/nvm/bash_completion
# source /usr/share/nvm/install-nvm-exec

# --------------------------------------------------------
# python configs
# --------------------------------------------------------
# export PYENV_ROOT="$HOME/.pyenv"
# eval "$(pyenv init -)"
# 
# export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# --------------------------------------------------------
# Simple configs
# --------------------------------------------------------
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export HISTCONTROL=ignoreboth

# --------------------------------------------------------
# Simple configs
# --------------------------------------------------------
export _JAVA_AWT_WM_NONREPARENTING=1
alias subliminal="subliminal --opensubtitles nightwalker107 naovoudizer"

path=(~/.local/bin $HOME/bin $HOME/.gem/ruby/2.5.0/bin $PYENV_ROOT/bin ~/Documents/npm/bin $path[@])
