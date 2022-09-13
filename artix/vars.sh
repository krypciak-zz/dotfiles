#!/bin/sh

INSTALL_DIR="/mnt"
# Disk managment
DISK="/dev/vda"
EFI_PART="${DISK}1"
EFI_SIZE='200M'
CRYPT_PART="${DISK}2"

EFI_DIR_ALONE='/boot'
EFI_DIR=${INSTALL_DIR}${EFI_DIR_ALONE}

# LUKS
CRYPT_NAME='lvmcrypt'
CRYPT_DIR="/dev/mapper/$CRYPT_NAME"
KEY_SIZE=512
ITER_TIME=5000
HASH='sha512'
LUKSFORMAT_ARUGMNETS="--key-size $KEY_SIZE --hash $HASH --iter-time $ITER_TIME"

# LVM
LVM_PASSWORD=123
SWAP_SIZE='16G'
ROOT_SIZE='50G'
LVM_NAME='artixlvm'
LVM_GROUP_NAME='Artix'

LVM_DIR="/dev/$LVM_GROUP_NAME"

# File systems
EFI_FORMAT_COMMAND="mkfs.fat -n EFI $EFI_PART"
ROOT_FORMAT_COMMAND="mkfs.btrfs -f -L root $LVM_DIR/root"
HOME_FORMAT_COMMAND="mkfs.btrfs -f -L home $LVM_DIR/home"
#ROOT_FORMAT_COMMAND="mkfs.ext4 -L root $LVM_DIR/root"
#HOME_FORMAT_COMMAND="mkfs.ext4 -L home $LVM_DIR/home"


# Packages
LIB32=1
PACMAN_ARGUMENTS='--noconfirm --needed'
PARU_ARGUMENTS='--noremovemake --skipreview --noupgrademenu'

KERNEL='linux-zen'
# drivers basic audio bluetooth browsers coding fstools 
# gaming media security social virt android awesome
PACKAGE_GROUPS=(
    #'drivers'
    'basic'
    'audio'
    'media'
    'browsers'
    'coding'
    'fstools'
    'gaming'
    'security'
    'social'
    'virt'
    'awesome'
)

# If ALL_DRIVERS is set to 1, GPU and CPU options are ignored
ALL_DRIVERS=0
# Options: [ 'amd', 'ati', 'intel', 'nvidia' ]
# The nvidia driver is the open source one
GPU='amd'
# Options: [ 'amd', 'intel' ]
CPU='amd'


# Installer
YOLO=1
AUTO_REBOOT=1
PAUSE_AFTER_DONE=0



# User configuration
USER1="krypek"
USER_HOME="/home/$USER1"

USER_PASSWORD=123
ROOT_PASSWORD=123

REGION="Europe"
CITY="Warsaw"
HOSTNAME="krypekartix"
LANG="en_US.UTF-8"

INSTALL_DOTFILES=1
INSTALL_PRIVATE_DOTFILES=1

BOOTLOADER_ID='Artix'




LGREEN='\033[1;32m'
GREEN='\033[0;32m'
LBLUE='\033[1;34m'
RED='\033[0;31m'
NC='\033[0m' 

function pri() {
    echo -e "$GREEN ||| $LGREEN$1$NC"
}


function confirm() {
    echo -en "$LBLUE |||$LGREEN $1 $LBLUE(Y/n/shell)? >> $NC"
    if [ $YOLO -eq 1 ] && [ "$2" != "ignore" ]; then echo "y"; return 0; fi 
    read choice
    case "$choice" in 
    y|Y|"" ) return 0;;
    n|N ) echo -e "$RED Exiting..."; exit;;
    shell ) pri "Entering shell..."; bash; pri "Exiting shell..."; confirm "$1" "ignore"; return 0;;
    * ) confirm "$1" "ignore"; return 0;;
    esac
}

