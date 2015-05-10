#!/bin/bash

# Vim
mkdir -p ~/.vim/backup ~/.vim/tmp
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

