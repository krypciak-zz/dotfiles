#!/bin/sh
cp $DOTFILES_DIR/root-files/.zshrc /root/.zshrc
chown root:root /root/.zshrc

mkdir -p /root/.config/nvim
cp -r $DOTFILES_DIR/root-files/nvim /root/.config/
chown -R root:root /root/.config/nvim
