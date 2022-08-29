DISK="/dev/vda"
EFI_PART="${DISK}1"
# In MB
EFI_SIZE=40

CRYPT_PART="${DISK}2"
CRYPT_NAME='lvmcrypt'
CRYPT_DIR="/dev/mapper/$CRYPT_NAME"
LVM_NAME='artixlvm'
LVM_DIR="/dev/$LVM_NAME"
LVM_GROUP_NAME='Artix'

SWAP_SIZE='1G'
ROOT_SIZE='14G'

export INSTALL_DIR="/mnt/artix"
EFI_DIR=$INSTALL_DIR/efi


export USER1="krypek"
export REGION="Europe"
export CITY="Warsaw"
export HOSTNAME="krypekartix"
export LANG="en_US.UTF-8"

export USER_HOME="/home/$USER1"
export DOTFILES_DIR="$USER_HOME/.config/dotfiles"
export INSTALL_DIR="$DOTFILES_DIR/artix"
export CONFIGF_DIR="$DOTFILES_DIR/config-files"

LGREEN='\033[1;32m'
GREEN='\033[0;32m'
LBLUE='\033[1;34m'
RED='\033[0;31m'
NC='\033[0m' 

function pri() {
    echo -e "$GREEN ||| $LGREEN$1$NC"
}


function retry() {
    echo -en "$LBLUE |||$LGREEN $1 $LBLUE(y/n)? >> $NC"
    read choice
    case "$choice" in 
    y|Y ) return;;
    n|N ) echo -e "$RED Exiting..."; exit;;
    * ) retry $1; return;;
    esac
}

cryptsetup close $CRYPT_DIR > /dev/null
umount $EFI_PART > /dev/null
umount $CRYPT_DIR > /dev/null
umount -R $INSTALL_DIR > /dev/null
mkdir -p $INSTALL_DIR

retry "Start partitioning the disk? $RED(DATA WARNING)"

(
echo g # set partitioning scheme to GPT
echo n # Create EFI partition
echo p # primary partition
echo 1 # partition number 1
echo   # default - start at beginning of disk 
echo +${EFI_SIZE}M # your size
echo n # Create LVM partition
echo p # primary partition
echo 2 # partion number 2
echo " "  # default, start immediately after preceding partition
echo " " # default, extend partition to end of disk
echo p # print the in-memory partition table
echo w # write the partition table
echo q # and we're done
) | fdisk $DISK
retry

# Create encryptred container on LVM_PART
while true; do
    pri "Setting up luks on $CRYPT_PART $RED(DATA WARNING)"
    cryptsetup luksFormat --key-size 512 --hash sha512 --iter-time 5000 $CRYPT_PART
    if [ $? -eq 0 ]; then
        break
    fi
    retry "Do you wanna retry?" 
done
        

while true; do
    pri "Opening $CRYPT_PART as $CRYPT_NAME"
    cryptsetup open $CRYPT_PART $CRYPT_NAME 
    if [ $? -eq 0 ]; then
        break
    fi
    retry "Do you wanna retry?" 
done


# Setup LVM
retry "Setup LVM?"
pri "Setting up LVM"

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
mkfs.btrfs -L root $LVM_DIR/root
pri "HOME"
mkfs.btrfs -L home $LVM_DIR/home
pri "EFI"
mkfs.fat -n EFI -F 32 $EFI_PART

pri "Mounting volumes"
pri "Mounting ROOT to $INSTALL_DIR/"
mount $LVM_DIR/root $INSTALL_DIR/

pri "Mounting HOME to $INSTALL_DIR/home/$USER1/"
mkdir -p $INSTALL_DIR/home/$USER1
mount $LVM_DIR/root $INSTALL_DIR/home/$USER1/

pri "Mounting $EFI_PART to $EFI_DIR"
mkdir -p $EFI_DIR
mount $EFI_PART $EFI_DIR


retry

