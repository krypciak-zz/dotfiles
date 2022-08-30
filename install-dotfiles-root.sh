#!/bin/sh
DOTFILES_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

mkdir -p /root/.config/nvim
cp -r $DOTFILES_DIR/dotfiles/root-files/nvim /root/.config/
chown -R root:root /root/.config/nvim

# Update nvim plugins
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' > /dev/null 2>&1
