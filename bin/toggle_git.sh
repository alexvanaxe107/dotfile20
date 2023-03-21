#!/usr/bin/env bash

[[ -f $HOME/.gitignore ]] &&  mv $HOME/.gitignore $HOME/.gitignore_bkp && mv $HOME/.git $HOME/.git_bkp && exit 0
[[ ! -f $HOME/.gitignore ]] && mv $HOME/.gitignore_bkp $HOME/.gitignore && mv $HOME/.git_bkp $HOME/.git && exit 0
