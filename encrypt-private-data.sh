#!/bin/sh

DOTFILES_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Prepare gnupg
GNUPG_DIR=~/.local/share/gnupg
mkdir -p ~/.local/share/gnupg
find $GNUPG_DIR -type f -exec chmod 600 {} \; # Set 600 for files
find $GNUPG_DIR -type d -exec chmod 700 {} \; # Set 700 for directories


PRIV_DIR=$DOTFILES_DIR/dotfiles/private
ENCRYPTED_ARCHIVE=$DOTFILES_DIR/dotfiles/private.tar.gz.gpg

tar --exclude=\
{} \
-cz $PRIV_DIR | gpg --symmetric --output $ENCRYPTED_ARCHIVE
sha512sum $ENCRYPTED_ARCHIVE > ${ENCRYPTED_ARCHIVE}.sha512


