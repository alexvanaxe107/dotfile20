#! /bin/dash

teste() {
    for theme in ~/bin/themes/*
    do
        basename -s .cfg  $theme
    done
}

chosen=$(teste | dmenu)
