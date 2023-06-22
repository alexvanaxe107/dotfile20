#!/usr/bin/env bash

cols="$(tput cols)"
cols="$((cols-1))"

seq 0 $cols | sort -R | spark
