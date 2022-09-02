#!/bin/sh
DOTFILES_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Prepare gnupg
GNUPG_DIR=~/.local/share/gnupg
mkdir -p ~/.local/share/gnupg
find $GNUPG_DIR -type f -exec chmod 600 {} \; # Set 600 for files
find $GNUPG_DIR -type d -exec chmod 700 {} \; # Set 700 for directories


PRIV_DIR=$DOTFILES_DIR/dotfiles/private
ENCRYPTED_ARCHIVE=$DOTFILES_DIR/dotfiles/private.tar.gz.gpg

cd $DOTFILES_DIR/dotfiles/
# Check archive
sha512sum --check $ENCRYPTED_ARCHIVE.sha512
if [[ $? == 1 ]]; then
	echo Encrypted archive is corrupted!
	echo $ENCRYPTED_ARCHIVE
	exit 1
fi

# Backup $PRIV_DIR if it exists
if [ -d $PRIV_DIR ]; then
	if [ -d $PRIV_DIR.old ]; then
		rm -rf $PRIV_DIR.old
	fi
	mv $PRIV_DIR $PRIV_DIR.old
fi
# Decrypt
gpg --output /tmp/private.tar.gz --decrypt --pinentry-mode=loopback $ENCRYPTED_ARCHIVE 
tar -xf /tmp/private.tar.gz 
rm -f /tmp/private.tar.gz
sh $PRIV_DIR/install.sh
