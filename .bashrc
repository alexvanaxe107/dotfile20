#
# ~/.bashrc
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export DMENU_COLOR=(-nb "#05080F" -nf "#EAF2EF" -sb "#040C38" -sf "#EAF2EF")

#-------------------------------------------------------------
# Source global definitions (if any)
#-------------------------------------------------------------
if [ -f /etc/bashrc ]; then
      . /etc/bashrc   # --> Read /etc/bashrc, if present.
fi

#set -o nounset     # These  two options are useful for debugging.
#set -o xtrace
alias debug="set -o nounset; set -o xtrace"
alias day.sh='todo.sh -d /home/media/todos/day/config/config'

ulimit -S -c 0      # Don't want coredumps.
set -o noclobber # Dont override the file on the > operator
set -o ignoreeof

# Enable options:
shopt -s cdspell
shopt -s cdable_vars
shopt -s checkhash
shopt -s checkwinsize
shopt -s sourcepath
shopt -s no_empty_cmd_completion
shopt -s cmdhist
shopt -s histappend histreedit histverify
shopt -s extglob       # Necessary for programmable completion.

# Disable options:
shopt -u mailwarn
unset MAILCHECK        # Don't want my shell to warn me of incoming mail.

if [ -x /usr/bin/fortune ]; then
    /usr/bin/fortune -s     # Makes our day a bit more fun.... :-)
fi

export PATH="$HOME/bin:$PATH"

function _exit()              # Function to run upon exit of shell.
{
    echo -e "${BRed}Hasta la vista, baby${NC}"
}
trap _exit EXIT

# Test user type:
#if [[ ${USER} == "root" ]]; then
#    SU=${Red}           # User is root.
#elif [[ ${USER} != $(logname) ]]; then
#    SU=${BRed}          # User is not login user.
#else
#    SU=${BCyan}         # User is normal (well ... most of us are).
#fi

#export PS1="\[\e[00;36m\][\[\e[0m\]\[\e[01;34m\]\u\[\e[0m\]\[\e[00;34m\]@\h\[\e[0m\]\[\e[00;37m\] \[\e[0m\]\[\e[00;36m\]\W]\\$\[\e[0m\] "
export PS1="\[\e[36m\]\u\[\e[m\]@\[\e[36m\]\h\[\e[m\] \A [\[\e[36m\]\W\[\e[m\]] "

#------------------------------
# Personnal Aliases and exports
#------------------------------
alias path='echo -e ${PATH//:/\\n}'

#-----------------------------
# npm configs
#-----------------------------
#export PATH="$HOME/Documents/npm/bin:$HOME/.local/bin/:$PATH"
# The config below is not used, and it will be linked bellow
#export npm_config_prefix="$HOME/Documents/npm/bin"
# source /usr/share/nvm/init-nvm.sh

#[ -z "$NVM_DIR" ] && export NVM_DIR="$HOME/Documents/.nvm"
#source /usr/share/nvm/nvm.sh
#source /usr/share/nvm/bash_completion
#source /usr/share/nvm/install-nvm-exec

#-----------------------------
# Pyenv configs
#-----------------------------
# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$HOME/bin:$PYENV_ROOT/bin:$HOME/.gem/ruby/2.5.0/bin:$PATH"
# eval "$(pyenv init -)"


# Add colors for filetype and  human-readable sizes by default on 'ls':
alias ls='ls -h --color'
alias lsx='ls -lXB'         #  Sort by extension.
alias lssize='ls -lSr'         #  Sort by size, biggest last.
alias lsdate='ls -ltr'         #  Sort by date, most recent last.
alias lschange='ls -ltcr'        #  Sort by/show change time,most recent last.
alias lsaccess='ls -ltur'        #  Sort by/show access time,most recent last.


#-------------------------------------------------------------
# Tailoring 'less'
#-------------------------------------------------------------

#alias more='less'
export PAGER=less
export LESSCHARSET='latin1'
export LESSOPEN='|/usr/bin/lesspipe.sh %s 2>&-'
                # Use this if lesspipe.sh exists.
export LESS='-i -N -w  -z-4 -g -e -M -X -F -R -P%t?f%f \
:stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'

# LESS man page colors (makes Man pages more readable).
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

complete -A hostname   rsh rcp telnet rlogin ftp ping disk
complete -A export     printenv
complete -A variable   export local readonly unset
complete -A enabled    builtin
complete -A alias      alias unalias
complete -A function   function
complete -A user       su mail finger

complete -A helptopic  help     # Currently same as builtins.
complete -A shopt      shopt
complete -A stopped -P '%' bg
complete -A job -P '%'     fg jobs disown

complete -A directory  mkdir rmdir
complete -A directory   -o default cd

# Compression
complete -f -o default -X '*.+(zip|ZIP)'  zip
complete -f -o default -X '!*.+(zip|ZIP)' unzip
complete -f -o default -X '*.+(z|Z)'      compress
complete -f -o default -X '!*.+(z|Z)'     uncompress
complete -f -o default -X '*.+(gz|GZ)'    gzip
complete -f -o default -X '!*.+(gz|GZ)'   gunzip
complete -f -o default -X '*.+(bz2|BZ2)'  bzip2
complete -f -o default -X '!*.+(bz2|BZ2)' bunzip2
complete -f -o default -X '!*.+(zip|ZIP|z|Z|gz|GZ|bz2|BZ2)' extract


# Documents - Postscript,pdf,dvi.....
complete -f -o default -X '!*.+(ps|PS)'  gs ghostview ps2pdf ps2ascii
complete -f -o default -X \
'!*.+(dvi|DVI)' dvips dvipdf xdvi dviselect dvitype
complete -f -o default -X '!*.+(pdf|PDF)' acroread pdf2ps
complete -f -o default -X '!*.@(@(?(e)ps|?(E)PS|pdf|PDF)?\
(.gz|.GZ|.bz2|.BZ2|.Z))' gv ggv
complete -f -o default -X '!*.texi*' makeinfo texi2dvi texi2html texi2pdf
complete -f -o default -X '!*.tex' tex latex slitex
complete -f -o default -X '!*.lyx' lyx
complete -f -o default -X '!*.+(htm*|HTM*)' lynx html2ps
complete -f -o default -X \
'!*.+(doc|DOC|xls|XLS|ppt|PPT|sx?|SX?|csv|CSV|od?|OD?|ott|OTT)' soffice

# Multimedia
complete -f -o default -X \
'!*.+(gif|GIF|jp*g|JP*G|bmp|BMP|xpm|XPM|png|PNG)' xv gimp ee gqview
complete -f -o default -X '!*.+(mp3|MP3)' mpg123 mpg321
complete -f -o default -X '!*.+(ogg|OGG)' ogg123
complete -f -o default -X \
'!*.@(mp[23]|MP[23]|ogg|OGG|wav|WAV|pls|\
m3u|xm|mod|s[3t]m|it|mtm|ult|flac)' xmms
complete -f -o default -X '!*.@(mp?(e)g|MP?(E)G|wma|avi|AVI|\
asf|vob|VOB|bin|dat|vcd|ps|pes|fli|viv|rm|ram|yuv|mov|MOV|qt|\
QT|wmv|mp3|MP3|ogg|OGG|ogm|OGM|mp4|MP4|wav|WAV|asx|ASX)' xine


# Pacman alias examples
alias pacupg='sudo pacman -Syu'		# Synchronize with repositories and then upgrade packages that are out of date on the local system.
alias pacin='sudo pacman -S'		# Install specific package(s) from the repositories
alias pacins='sudo pacman -U'		# Install specific package not from the repositories but from a file 
alias pacre='sudo pacman -R'		# Remove the specified package(s), retaining its configuration(s) and required dependencies
alias pacrem='sudo pacman -Rns'		# Remove the specified package(s), its configuration(s) and unneeded dependencies
alias pacrep='pacman -Si'		# Display information about a given package in the repositories
alias pacreps='pacman -Ss'		# Search for package(s) in the repositories
alias pacloc='pacman -Qi'		# Display information about a given package in the local database
alias paclocs='pacman -Qs'		# Search for package(s) in the local database
alias paclo="pacman -Qdt"		# List all packages which are orphaned
alias pacc="sudo pacman -Scc"		# Clean cache - delete all not currently installed package files
alias paclf="pacman -Ql"		# List all files installed by a given package
alias pacexpl="pacman -D --asexp"	# Mark one or more installed packages as explicitly installed 
alias pacimpl="pacman -D --asdep"	# Mark one or more installed packages as non explicitly installed

# '[r]emove [o]rphans' - recursively remove ALL orphaned packages
alias pacro="pacman -Qtd > /dev/null && sudo pacman -Rns \$(pacman -Qtdq | sed -e ':a;N;$!ba;s/\n/ /g')"

#Completion do Django
source ~/.django_bash_completion
source ~/.ng-completion

#Configuration for the powerline
#powerline-daemon -q
#POWERLINE_BASH_CONTINUATION=1
#POWERLINE_BASH_SELECT=1
#. /usr/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh

export EDITOR=nvim

alias dmenu=ava_dmenu
alias fuck='sudo $(fc -ln -1)'
alias tmuxa='tmux attach-session -t shell'
export FZF_DEFAULT_COMMAND='fd -I --type f'
set -o vi

#export SUDO_ASKPASS=/usr/bin/lxqt-openssh-askpass
export _JAVA_AWT_WM_NONREPARENTING=1
#export XDG_SESSION_DESKTOP=i3
#export XDG_CURRENT_DESKTOP=i3

#alias dmenu='dmenu -nb "#1B2040" -nf "#ffffff" -sb "#005577" -fn "Envy Code R:size=10"'

#[[ $XDG_VTNR -le 2 ]] && tbsm
#alias i3cheatsheet='egrep ^bind ~/.config/i3/config | cut -d '\'' '\'' -f 2- | sed '\''s/ /\t/'\'' | column -ts $'\''\t'\'' | pr -2 -w 145 -t | less'
source $HOME/.profile

alias tdm="tdm --disable-xrunning-check"

# Sound issues on steam no more?
PULSE_LATENCY_MSEC=60

#Use the amd vulkan
AMD_VULKAN_ICD=RADV

# AMDGPU 16x anisotropic filtering
#export R600_TEX_ANISO=16

#No MSAA
#export EQAA=0,0,0

#2x MSAA
#export EQAA=2,2,2

#2f4x EQAA
#export EQAA=4,2,2

#4x MSAA
#export EQAA=4,4,4

#2f8x EQAA
#export EQAA=8,2,2

#4f8x EQAA
#export EQAA=8,4,4

#4f16x EQAA
#export EQAA=16,4,4

#8x MSAA
#export EQAA=8,8,8

#8f16x EQAA
#export EQAA=16,8,8

# Config for emacs vterm
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

# Nix configurations
export NIXPKGS_ALLOW_UNFREE=1

clear

spark.sh

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
