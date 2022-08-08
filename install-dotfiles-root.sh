#!/bin/sh
ROOTDIR="/root"
THISDIR="/home/krypek/.config/dotfiles"

cp root-files/.zshrc $ROOTDIR/.zshrc
chown root:root $ROOTDIR/.zshrc

mkdir -p $ROOTFIR/.config/nvim
cp -r root-files/nvim $ROOTDIR/.config/nvim/
chown -R root:root $ROOTDIR/.config/nvim
