#!/bin/sh

export DOTFILES_DIR="~/.config/dotfiles"
export USER1="krypek"
export REGION="Europe"
export CITY="Warsaw"
export HOSTNAME="krypekartix"
export LANG="en_US.UTF-8"

# Time
ln -sf /usr/share/zoneinfo/$REGION/$CITY /etc/localtime
hwclock --systohc
# Locale
cp $DOTFILES_DIR/config-files/locale.gen /etc/locale.gen
locale-gen
echo "LANG=\"$LANG\"" > /etc/locale.conf
export LC_COLLATE="C"
# Hostname
echo "$HOSTNAME" > /etc/hostname
echo "hostname=\'$HOSTNAME\'" >> /etc/conf.d/hostname
# Hosts
cp $DOTFILES_DIR/config-files/hosts /etc/hosts
chown root:root /etc/hosts

# Set password for root
echo "Password for root:"
n=0
until [ "$n" -ge 5 ]
do
   passwd root && break
   n=$((n+1)) 
   sleep 15
done


# Add user
useradd -m -G tty ftp games network scanner libvirt users video audio wheel -s /bin/zsh $USER1
echo "Password for $USER1:"
n=0
until [ "$n" -ge 5 ]
do
   passwd $USER1 && break
   n=$((n+1)) 
   sleep 15
done
chown -R $USER1:$USER1 /home/$USER1

# steam (not nessesery if you want steam dotfiles in your $HOME)
cp $DOTFILES_DIR/config-files/steam /bin/steam
chown root:root /bin/steam


# services
rc-update add NetworkManager default
rc-update add device-mapper boot
rc-update add lvm boot
rc-update add dmcrypt boot
rc-update add dbus default
rc-update add elogind boot

rc-update add libvirtd default
cp $DOTFILES_DIR/config-files/libvirtd.conf /etc/libvirt/libvirtd.conf
chown root:root /etc/libvirt/libvirtd.conf
cp $DOTFILES_DIR/config-files/qemu.conf /etc/libvirt/qemu.conf
sed -i "s/USER/${USER1}/g" /etc/libvirt/qemu.conf
chown root:root /etc/libvirt/qemu.conf


# autologin
cp $DOTFILES_DIR/config-files/agetty-autologin* /etc/init.d/
sed -i "s/USER/${USER1}/g" /etc/init.d/agetty-autologin*
#sed -i "s/USER/${USER1}/g" /etc/init.d/agetty-autologin.tty1
chown root:root /etc/init.d/agetty-autologin*

rc-update del agetty.tty1 default
rc-update add agetty-autologin.tty1 default

