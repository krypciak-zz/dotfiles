#!/bin/sh

DOTFILES_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cp $DOTFILES_DIR/dotfiles/root-files/.zshrc /root/.zshrc
chown root:root /root/.zshrc

mkdir -p /root/.config/nvim
cp -r $DOTFILES_DIR/dotfiles/root-files/nvim /root/.config/
chown -R root:root /root/.config/nvim
