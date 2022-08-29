#!/bin/sh

DOTFILES_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "$DOTFILES_DIR/vars.sh"

function unmount() {
    lvchange -an $LVM_GROUP_NAME > /dev/null 2>&1
    cryptsetup close $CRYPT_DIR > /dev/null 2>&1
    umount -q $EFI_PART > /dev/null 2>&1
    umount -q $CRYPT_DIR > /dev/null 2>&1
    umount -Rq $INSTALL_DIR > /dev/null 2>&1
}

confirm "Start partitioning the disk? $RED(DATA WARNING)"
pri "Unmouting"

unmount
vgremove -f $LVM_GROUP_NAME > /dev/null 2>&1
mkdir -p $INSTALL_DIR

(
echo g # set partitioning scheme to GPT
echo n # Create EFI partition
echo p # primary partition
echo 1 # partition number 1
echo   # default - start at beginning of disk 
echo +${EFI_SIZE} # your size
echo n # Create LVM partition
echo p # primary partition
echo 2 # partion number 2
echo " "  # default, start immediately after preceding partition
echo " " # default, extend partition to end of disk
echo p # print the in-memory partition table
echo w # write the partition table
echo q # and we're done
) | fdisk $DISK
confirm

# Create encryptred container on LVM_PART
while true; do
    pri "Setting up luks on $CRYPT_PART $RED(DATA WARNING)"
    cryptsetup luksFormat --key-size 512 --hash sha512 --iter-time 5000 $CRYPT_PART
    if [ $? -eq 0 ]; then
        break
    fi
    confirm "Do you wanna retry?" 
done
        

while true; do
    pri "Opening $CRYPT_PART as $CRYPT_NAME"
    cryptsetup open $CRYPT_PART $CRYPT_NAME 
    if [ $? -eq 0 ]; then
        break
    fi
    confirm "Do you wanna retry?" 
done


# Setup LVM
confirm "Set up LVM?"

pri "Creating LVM group $LVM_GROUP_NAME"
pvcreate $CRYPT_DIR
vgcreate $LVM_GROUP_NAME $CRYPT_DIR

pri "Creating volumes"
pri "Creating SWAP"
lvcreate -L $SWAP_SIZE $LVM_GROUP_NAME -n swap
pri "Creating ROOT of size $ROOT_SIZE"
lvcreate -L $ROOT_SIZE $LVM_GROUP_NAME -n root
pri "Creating HOME of size 100%FREE"
lvcreate -l 100%FREE $LVM_GROUP_NAME -n home

pri "Formatting volumes"
pri "SWAP"
mkswap $LVM_DIR/swap
pri "ROOT"
mkfs.btrfs -f -L root $LVM_DIR/root > /dev/null 2>&1
pri "HOME"
mkfs.btrfs -f -L home $LVM_DIR/home > /dev/null 2>&1
pri "EFI"
mkfs.fat -n EFI -F 32 $EFI_PART

pri "Mounting volumes"
pri "$INSTALL_DIR"
pri "Mounting $LVM_DIR/root to $INSTALL_DIR/"
mount $LVM_DIR/root $INSTALL_DIR/

pri "Mounting $LVM_DIR/home to $INSTALL_DIR/home/$USER1/"
mkdir -p $INSTALL_DIR/home/$USER1
mount $LVM_DIR/home $INSTALL_DIR/home/$USER1/

pri "Mounting $EFI_PART to $EFI_DIR"
mkdir -p $EFI_DIR
mount $EFI_PART $EFI_DIR

pri "Turning swap on"
swapon $LVM_DIR/swap

# Prepare to chroot
confirm "Install base packages?"
sh $DOTFILES_DIR/artix/install-base.sh

pri "Generating fstab"
fstabgen -U $INSTALL_DIR >> $INSTALL_DIR/etc/fstab


NEW_DOTFILES_DIR=$INSTALL_DIR$USERHOME/.config/dotfiles
pri "Copying the repo to $NEW_DOTFILES_DIR"
mkdir -p $NEW_DOTFILES_DIR/../
copy -rf $DOTFILES_DIR $NEW_DOTFILES_DIR/../

pri "Chrooting..."
artix-chroot $INSTALL_DIR $NEW_DOTFILES_DIR/artix/after-chroot.sh

confirm "Reboot?"
unmount
reboot

