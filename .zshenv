alias ls='ls -h --color'
alias fdir='$HOME/.fdir/fdir.sh'
alias fuck='sudo $(fc -ln -1)'
alias todo.sh='todo.sh -d ~/.config/todo/config'

export EDITOR=vim
#export XDG_SESSION_DESKTOP=i3
#export XDG_CURRENT_DESKTOP=i3

export SUDO_ASKPASS=/usr/bin/lxqt-openssh-askpass
typeset -U path
path=(~/.local/bin $HOME/bin $HOME/.gem/ruby/2.5.0/bin $path[@])

export PYENV_VIRTUALENV_DISABLE_PROMPT=1

alias fvim="vim -u $HOME/.vimfullrc"
# Pacman alias examples

alias subliminal="subliminal --opensubtitles nightwalker107 naovoudizer"

# alias clear="clear;echo;spark.sh"
alias clear="clear;echo"

#alias i3cheatsheet='egrep ^bind ~/.config/i3/config | cut -d '\'' '\'' -f 2- | sed '\''s/ /\t/'\'' | column -ts $'\''\t'\'' | pr -2 -w 145 -t | less'
export _JAVA_AWT_WM_NONREPARENTING=1
export FZF_DEFAULT_COMMAND='fd -I --type f'
export HISTCONTROL=ignoreboth

source ~/.profile
