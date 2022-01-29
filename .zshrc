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


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

setopt COMPLETE_ALIASES
#setopt correctall
autoload -Uz compinit;
compinit

#prompt default

# Configs for emacs vterm
vterm_printf(){
    if [ -n "$TMUX" ] && ([ "${TERM%%-*}" = "tmux" ] || [ "${TERM%%-*}" = "screen" ] ); then
        # Tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}


### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light "zpm-zsh/colors"

### End of Zinit's installer chunk
#
# Load the pure theme, with zsh-async library that's bundled with it.
#zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure
#zinit light "denysdovhan/spaceship-prompt"

zinit light "zsh-users/zsh-syntax-highlighting"
zinit light agkozak/zsh-z
#Muda a cor do autosuggestion
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE
zinit light "zsh-users/zsh-autosuggestions"
zinit light "Aloxaf/fzf-tab"
zinit light "IngoMeyer441/zsh-easy-motion"

zinit snippet "https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/archlinux/archlinux.plugin.zsh"

bindkey '^ ' autosuggest-accept
bindkey '^o' autosuggest-toggle
bindkey ^f forward-word
bindkey -M vicmd ' ' vi-easy-motion

#colorscript -r
#eval "$(pyenv init -)"
