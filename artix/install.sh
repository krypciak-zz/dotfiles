#!/bin/sh

ARTIXD_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "$ARTIXD_DIR/vars.sh"
export OUTPUT_REDIRECT

function unmount() {
    sync
    swapoff -a > /dev/null 2>&1
    umount -q $EFI_PART > /dev/null 2>&1
    umount -Rq $INSTALL_DIR > /dev/null 2>&1
    swapoff $LVM_DIR/swap > /dev/null 2>&1
    lvchange -an $LVM_GROUP_NAME > /dev/null 2>&1
    cryptsetup close $CRYPT_DIR > /dev/null 2>&1
    umount -q $CRYPT_DIR > /dev/null 2>&1
    sync
}

confirm "Start partitioning the disk? $RED(DATA WARNING)"
pri "Unmouting"

unmount 
vgremove -f $LVM_GROUP_NAME > /dev/null 2>&1
unmount
mkdir -p $INSTALL_DIR
echo bul
(
echo g # set partitioning scheme to GPT
echo n # Create EFI partition
echo p # primary partition
echo 1 # partition number 1
echo   # default - start at beginning of disk 
echo +${EFI_SIZE} # your size
echo t # set partition type
echo 1 # to EFI system
echo n # Create LVM partition
echo p # primary partition
echo 2 # partion number 2
echo " "  # default, start immediately after preceding partition
echo " " # default, extend partition to end of disk
echo t # set partition type
echo 2
echo 43 # to LV
echo p # print the in-memory partition table
echo w # write changes
echo q # quit
) | fdisk $DISK

# Create encryptred container on LVM_PART

if [ "$LVM_PASSWORD" != "" ]; then 
    pri "Setting up luks on $CRYPT_PART $RED(DATA WARNING)"
    pri "${NC}Automaticly filling password..."
    echo $LVM_PASSWORD | cryptsetup luksFormat $LUKSFORMAT_ARGUMENTS $CRYPT_PART
    if [ $? -ne 0 ]; then
        pri "${RED}ERROR. Exiting..."
    fi
    pri "Opening $CRYPT_PART as $CRYPT_NAME"
    pri "${NC}Automaticly filling password..."
    echo $LVM_PASSWORD | cryptsetup open $CRYPT_PART $CRYPT_NAME
else
    while true; do
        pri "Setting up luks on $CRYPT_PART $RED(DATA WARNING)"
        
        cryptsetup luksFormat $LUKSFORMAT_ARGUMENTS $CRYPT_PART
        if [ $? -eq 0 ]; then
            break
        fi
        confirm "Do you wanna retry?"  "ignore"
    done    
    
    while true; do
        pri "Opening $CRYPT_PART as $CRYPT_NAME"
        cryptsetup open $CRYPT_PART $CRYPT_NAME 
        if [ $? -eq 0 ]; then
            break
        fi
        confirm "Do you wanna retry?" "ignore"
    done
fi

# Setup LVM
confirm "Set up LVM?" 

pri "Creating LVM group $LVM_GROUP_NAME"
pvcreate $CRYPT_DIR
vgcreate $LVM_GROUP_NAME $CRYPT_DIR

pri "Creating volumes"
pri "Creating SWAP"
lvcreate -C y -L $SWAP_SIZE $LVM_GROUP_NAME -n swap
pri "Creating ROOT of size $ROOT_SIZE"
lvcreate -C y -L $ROOT_SIZE $LVM_GROUP_NAME -n root
pri "Creating HOME of size 100%FREE"
lvcreate -C y -l 100%FREE $LVM_GROUP_NAME -n home

pri "Formatting volumes"
pri "SWAP"
mkswap -L swap $LVM_DIR/swap
pri "ROOT"
$ROOT_FORMAT_COMMAND > /dev/null 2>&1
pri "HOME"
$HOME_FORMAT_COMMAND > /dev/null 2>&1
pri "EFI"
$EFI_FORMAT_COMMAND 

pri "Mounting ${LBLUE}$LVM_DIR/root ${LGREEN}to ${LBLUE}$INSTALL_DIR/"
mount $LVM_DIR/root $INSTALL_DIR/

pri "Mounting ${LBLUE}$LVM_DIR/home${LGREEN} to ${LBLUE}$INSTALL_DIR/home/$USER1/"
mkdir -p $INSTALL_DIR/home/$USER1
mount $LVM_DIR/home $INSTALL_DIR/home/$USER1/

pri "Mounting ${LBLUE}${EFI_PART}${LGREEN} to ${LBLUE}$EFI_DIR"
mkdir -p $EFI_DIR
mount $EFI_PART $EFI_DIR

confirm "" "ignore"

pri "Turning swap on"
swapon $LVM_DIR/swap

# Prepare to chroot
confirm "Basestrap basic packages?"
export LANG
basestrap -C $ARTIXD_DIR/../config-files/pacman.conf.install $INSTALL_DIR base openrc elogind-openrc artix-keyring artix-mirrorlist autoconf automake bison fakeroot flex gcc groff libtool m4 make patch pkgconf texinfo which 

pri "Generating fstab"
fstabgen -U $INSTALL_DIR >> $INSTALL_DIR/etc/fstab


DOTFILES_DIR=$INSTALL_DIR$USER_HOME/home/.config/dotfiles
pri "Copying the repo to $NEW_ARTIXD_DIR"
mkdir -p $DOTFILES_DIR/..
cp -rf $ARTIXD_DIR/../ $DOTFILES_DIR/

pri "Chrooting..."
artix-chroot $INSTALL_DIR sh $USER_HOME/home/.config/dotfiles/artix/after-chroot.sh

if [ $AUTO_REBOOT -eq 0 ]; then
    confirm "Reboot?" "ignore"
fi
unmount
reboot

