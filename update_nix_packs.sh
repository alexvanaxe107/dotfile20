#!/usr/bin/env bash

cd ..
for file in */; do
    cd $file
    nix flake update
    git add --all
    git commit -m "Updating nix"
    git push
    cd ..
done
