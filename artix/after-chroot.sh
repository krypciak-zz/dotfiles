#!/bin/sh

ARTIXD_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DOTFILES_DIR=$ARTIXD_DIR/..
CONFIGD_DIR=$DOTFILES_DIR/config-files

source "$ARTIXD_DIR/vars.sh"

pri "Setting time"
ln -sf /usr/share/zoneinfo/$REGION/$CITY /etc/localtime
hwclock --systohc

pri "Setting the locale"
cp $CONFIGD_DIR/locale.gen /etc/locale.gen
locale-gen
echo "LANG=\"$LANG\"" > /etc/locale.conf
export LC_COLLATE="C"

pri "Setting the hostname"
echo "$HOSTNAME" > /etc/hostname
echo "hostname=\'$HOSTNAME\'" >> /etc/conf.d/hostname

pri "Setting hosts"
cp $CONFIGD_DIR/hosts /etc/hosts
chown root:root /etc/hosts

pri "Copying pacman configuration"
cp $CONFIGD_DIR/pacman.conf /etc/pacman.conf
chown root:root /etc/pacman.conf
cp -r $CONFIGD_DIR/pacman.d /etc/
chown -R root:root /etc/pacman.d

pri "Updating keyring"
pacman-key --init
pacman-key --populate

confirm "" "ignore"

confirm "Install base packages?"
find /var/cache/pacman/pkg/ -iname "*.part" -delete
sh $ARTIXD_DIR/install-base.sh

pri "Adding user $USER1"
useradd -m -s /bin/bash $USER1
chown $USER1:$USER1 $USER_HOME/
chown -R $USER1:$USER1 $ARTIXD_DIR

pri "Copying temporary doas config"
echo "permit nopass root" > /etc/doas.conf
echo "permit nopass $USER1" >> /etc/doas.conf

sed -i 's/#PACMAN_AUTH=()/PACMAN_AUTH=(doas)/' /etc/makepkg.conf

pri "Installing paru (AUR manager)"
if [ -d /tmp/paru ]; then rm -rf /tmp/paru; fi

git clone https://aur.archlinux.org/paru-bin.git /tmp/paru
chown -R $USER1:$USER1 /tmp/paru
chmod +wrx /tmp/paru
cd /tmp/paru
doas -u $USER1 makepkg -si --noconfirm --needed

# Set paru auth method to doas
sed -i 's/#\[bin\]/\[bin\]/g' /etc/paru.conf
sed -i 's/#Sudo = doas/Sudo = doas/g' /etc/paru.conf

confirm "Install packages?"
find /var/cache/pacman/pkg/ -iname "*.part" -delete
doas -u $USER1 sh $ARTIXD_DIR/install-packages.sh

confirm "" "ignore"

pri "Installing GPU drivers"
doas -u $USER1 sh $ARTIXD_DIR/install-gpudrivers.sh

confirm "" "ignore"

pri "Adding user $USER1 to groups"
usermod -aG tty,ftp,games,network,scanner,libvirt,users,video,audio,wheel $USER1

confirm "" "ignore"

pri "Enabling services"
rc-update add NetworkManager default
rc-update add device-mapper boot
rc-update add lvm boot
rc-update add dmcrypt boot
rc-update add dbus default
rc-update add elogind boot

confirm "" "ignore"

pri "Configuring qemu"
rc-update add libvirtd default
cp $CONFIGD_DIR/libvirtd.conf /etc/libvirt/libvirtd.conf
chown root:root /etc/libvirt/libvirtd.conf

cp $CONFIGD_DIR/qemu.conf /etc/libvirt/qemu.conf
sed -i "s/USER/${USER1}/g" /etc/libvirt/qemu.conf
chown root:root /etc/libvirt/qemu.conf

pri "Deploying autologin service"
cp $CONFIGD_DIR/agetty-autologin* /etc/init.d/
sed -i "s/USER/${USER1}/g" /etc/init.d/agetty-autologin*
#sed -i "s/USER/${USER1}/g" /etc/init.d/agetty-autologin.tty1
chown root:root /etc/init.d/agetty-autologin*

rc-update del agetty.tty1 default
rc-update add agetty-autologin.tty1 default

confirm "" "ignore"

pri "Installing dotfiles for user $USER1"
USER1=$USER1 sh $DOTFILES_DIR/install-dotfiles.sh

pri "Installing dotfiles for root"
sh $DOTFILES_DIR/install-dotfiles-root.sh

pri "Copying doas configuration"
cp $CONFIGD_DIR/doas.conf /etc/doas.conf
chown root:root /etc/doas.conf
chmod -rw /etc/doas.conf

pri "Cleaning up"
rm -rf $USER_HOME/.cargo
find /var/cache/pacman/pkg/ -iname "*.part" -delete

confirm "" "ignore"

pri "Set password for user $USER1"

if [ "$USER_PASSWORD" != "" ]; then
    pri "${NC}Automaticly filling password..."
    ( echo $USER_PASSWORD; echo $USER_PASSWORD; ) | passwd $USER1
else
    n=0
    until [ "$n" -ge 5 ]; do
        passwd $USER1 && break
        n=$((n+1)) 
        sleep 15
    done
fi
chown -R $USER1:$USER1 $USER_HOME

pri "Set password for root"
if [ "$ROOT_PASSWORD" != "" ]; then
    pri "${NC}Automaticly filling password..."
    ( echo $ROOT_PASSWORD; echo $ROOT_PASSWORD; ) | passwd root
else
    n=0
    until [ "$n" -ge 5 ]; do
        passwd root && break
        n=$((n+1)) 
        sleep 15
    done
fi
chsh -s /bin/bash root

pri "grub fsadf"
