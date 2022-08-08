#!/bin/sh

USER1="krypek"

useradd -m -G tty,ftp,games,network,scanner,libvirt,users,video,audio,wheel -s /bin/zsh $USER1
echo "Password for $USER1:"
n=0
until [ "$n" -ge 5 ]
do
   passwd $USER1 && break
   n=$((n+1)) 
   sleep 15
done
chown -R $USER1:$USER1 /home/$USER1
