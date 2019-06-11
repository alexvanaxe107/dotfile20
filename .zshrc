# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v

zstyle :compinstall filename '$HOME/.zshrc'
zstyle ':completion:*' menu select
zstyle ':completion:*:pacman:*' force-list always
zstyle ':completion:*:*:pacman:*' menu yes select

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always

zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*'   force-list always
#zstyle ':completion::complete:*' gain-privileges 1
#

source $HOME/.fdirrc
source $HOME/.zplug/init.zsh
export ZPLUG_HOME=$HOME/.zplug


zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-autosuggestions"

zplug "zsh-users/zsh-syntax-highlighting"

bindkey '^ ' autosuggest-accept

zplug "zsh-users/zsh-history-substring-search"

zplug denysdovhan/spaceship-prompt, use:spaceship.zsh, from:github, as:theme

zplug mafredri/zsh-async, from:github
#zplug sindresorhus/pure, use:pure.zsh, from:github, as:theme

zplug "plugins/z",   from:oh-my-zsh

zplug load

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

setopt COMPLETE_ALIASES
setopt correctall
autoload -Uz compinit;
compinit

#prompt default

