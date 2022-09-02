#!/bin/bash

ARTIXD_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DOTFILES_DIR=$ARTIXD_DIR/..
CONFIGD_DIR=$DOTFILES_DIR/config-files

source "$ARTIXD_DIR/vars.sh"
export PACMAN_ARGUMENTS
export PARU_ARGUMENTS

pri "Setting time"
ln -sf /usr/share/zoneinfo/$REGION/$CITY /etc/localtime
hwclock --systohc

pri "Setting the locale"
cp $CONFIGD_DIR/locale.gen /etc/locale.gen
locale-gen
echo "LANG=\"$LANG\"" > /etc/locale.conf
export LANG
export LC_COLLATE="C"

pri "Setting the hostname"
echo "$HOSTNAME" > /etc/hostname
echo "hostname=\'$HOSTNAME\'" > /etc/conf.d/hostname

pri "Setting hosts"
cp $CONFIGD_DIR/hosts /etc/hosts
chown root:root /etc/hosts


sed -i 's/#Color/Color/g' /etc/pacman.conf
sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/g' /etc/pacman.conf


pri "Disabling mkinitcpio"
mv /usr/share/libalpm/hooks/90-mkinitcpio-install.hook /90-mkinitcpio-install.hook 
#sed -i '1s/^/exit\n/' $INSTALL_DIR/bin/mkinitcpio

pri "Copying temporary doas config"
echo "permit nopass setenv { USER1 PACMAN_ARGUMENTS PARU_ARGUMENTS } root" > /etc/doas.conf
echo "permit nopass setenv { USER1 PACMAN_ARGUMENTS PARU_ARGUMENTS } $USER1" >> /etc/doas.conf

confirm "Install base packages?"
pacman $PACMAN_ARGUMENTS -S lvm2 cryptsetup glibc mkinitcpio grub efibootmgr dosfstools freetype2 fuse2 mtools device-mapper-openrc lvm2-openrc cryptsetup-openrc networkmanager-openrc git neovim neofetch wget


pri "Updating keyring"
# Disable package signature verification
sed -i 's/SigLevel    = Required DatabaseOptional/SigLevel = Never/g' /etc/pacman.conf
sed -i 's/LocalFileSigLevel = Optional/#LocalFileSigLevel = Optional/g' /etc/pacman.conf
# Add lib32 repo
printf '[lib32]\nInclude = /etc/pacman.d/mirrorlist\n' >> /etc/pacman.conf
# Add universe repo
printf '[universe]\nServer = https://universe.artixlinux.org/$arch\nServer = https://mirror1.artixlinux.org/universe/$arch\nServer = https://mirror.pascalpuffke.de/artix-universe/$arch\nServer = https://artixlinux.qontinuum.space/artixlinux/universe/os/$arch\nServer = https://mirror1.cl.netactuate.com/artix/universe/$arch\nServer = https://ftp.crifo.org/artix-universe/\n' >> /etc/pacman.conf

pacman $PACMAN_ARGUMENTS -Sy artix-archlinux-support lib32-artix-archlinux-support
pacman-key --init
pacman-key --populate
pri "Copying pacman configuration"
cp $CONFIGD_DIR/pacman.conf /etc/pacman.conf
chown root:root /etc/pacman.conf
cp -r $CONFIGD_DIR/pacman.d /etc/
chown -R root:root /etc/pacman.d


pri "Adding user $USER1"
useradd -s /bin/bash $USER1
chown -R $USER1:$USER1 $USER_HOME/
chown -R $USER1:$USER1 $ARTIXD_DIR

sed -i 's/#PACMAN_AUTH=()/PACMAN_AUTH=(doas)/' /etc/makepkg.conf

pri "Installing paru (AUR manager)"
if [ -d /tmp/paru ]; then rm -rf /tmp/paru; fi
pacman $PACMAN_ARGUMENTS -Sy git
git clone https://aur.archlinux.org/paru-bin.git /tmp/paru
chown -R $USER1:$USER1 /tmp/paru
chmod +wrx /tmp/paru
cd /tmp/paru
doas -u $USER1 makepkg -si --noconfirm --needed

# Set paru auth method to doas

sed -i 's/#\[bin\]/\[bin\]/g' /etc/paru.conf
sed -i 's/#Sudo = doas/Sudo = doas/g' /etc/paru.conf


confirm "Install packages?"
doas -u $USER1 paru $PARU_ARGUMENTS $PACMAN_ARGUMENTS -S opendoas-sudo nvim-packer-git
PACKAGE_LIST=''
for group in "${PACKAGE_GROUPS[@]}"; do
    source $ARTIXD_DIR/packages/install-${group}.sh
    pri "Installing $group"
    PACKAGE_LIST="$PACKAGE_LIST $(install_${group}) "
done

doas -u $USER1 paru $PARU_ARGUMENTS $PACMAN_ARGUMENTS -S $PACKAGE_LIST

for group in "${PACKAGE_GROUPS[@]}"; do
    source $ARTIXD_DIR/packages/configure-${group}.sh
    pri "Configuring $group"
    install_${group}
done

confirm "" "ignore"

pri "Adding user $USER1 to groups"
usermod -aG tty,ftp,games,network,scanner,libvirt,users,video,audio,wheel $USER1


pri "Enabling services"
rc-update add NetworkManager default
rc-update add device-mapper boot
rc-update add lvm boot
rc-update add dmcrypt boot
rc-update add dbus default
rc-update add elogind boot



pri "Deploying autologin service"
cp $CONFIGD_DIR/agetty-autologin* /etc/init.d/
sed -i "s/USER/${USER1}/g" /etc/init.d/agetty-autologin*
#sed -i "s/USER/${USER1}/g" /etc/init.d/agetty-autologin.tty1
chown root:root /etc/init.d/agetty-autologin*

rc-update del agetty.tty1 default
rc-update add agetty-autologin.tty1 default
pri "$CONFIGD_DIR"
confirm "" "ignore"

if [ $INSTALL_DOTFILES -eq 1 ]; then
    pri "Installing dotfiles for user $USER1"
    rm -rf $USER_HOME/.config
    export USER1
    doas -u $USER1 sh $DOTFILES_DIR/install-dotfiles.sh

    pri "Installing dotfiles for root"
    sh $DOTFILES_DIR/install-dotfiles-root.sh
fi
pri "Copying doas configuration"
cp $CONFIGD_DIR/doas.conf /etc/doas.conf
chown root:root /etc/doas.conf
chmod -rw /etc/doas.conf


pri "Cleaning up"
rm -rf $USER_HOME/.cargo
find /var/cache/pacman/pkg/ -iname "*.part" -delete
paru --noconfirm -Scc > /dev/null 2>&1

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
#END_COMMENT

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
chsh -s /bin/bash root > /dev/null 2>&1

pri "Enabling mkinitpckio"
mv /90-mkinitcpio-install.hook /usr/share/libalpm/hooks/90-mkinitcpio-install.hook
#sed -i '1d' /bin/mkinitcpio

pri "Copying mkinitpcio configuration"
cp $CONFIGD_DIR/mkinitcpio.conf /etc/mkinitcpio.conf
chown root:root /etc/mkinitcpio.conf

pri "Generating mkinitcpio"
mkinitcpio -p $KERNEL

pri "Copying grub configuration"
cp $CONFIGD_DIR/grub /etc/default/grub
chown root:root /etc/default/grub

CRYPT_UUID=$(blkid $CRYPT_PART -s UUID -o value)
ESCAPED_CRYPT_UUID=$(printf '%s\n' "$CRYPT_UUID" | sed -e 's/[\/&]/\\&/g')
sed -i "s/CRYPT_UUID/$ESCAPED_CRYPT_UUID/g" /etc/default/grub

ESCAPED_CRYPT_NAME=$(printf '%s\n' "$CRYPT_NAME" | sed -e 's/[\/&]/\\&/g')
sed -i "s/CRYPT_NAME/$ESCAPED_CRYPT_NAME/g" /etc/default/grub

ESCAPED_LVM_GROUP_NAME=$(printf '%s\n' "$LVM_GROUP_NAME" | sed -e 's/[\/&]/\\&/g')
sed -i "s/LVM_GROUP_NAME/$ESCAPED_LVM_GROUP_NAME/g" /etc/default/grub
#ESCAPED_LVM_DIR=$(printf '%s\n' "$LVM_DIR" | sed -e 's/[\/&]/\\&/g')
#sed -i "s/LVM_DIR/$ESCAPED_LVM_DIR/g" /etc/default/grub

pri "Installing grub to $EFI_DIR_ALONE"
grub-install --target=x86_64-efi --efi-directory=$EFI_DIR_ALONE --bootloader-id=$BOOTLOADER_ID

pri "Generating grub config"
grub-mkconfig -o /boot/grub/grub.cfg

confirm "" "ignore"

