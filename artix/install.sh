DISK="/dev/sdX"
EFI_PART="${DISK}1"
# In MB
EFI_SIZE=40
LVM_PART="${DISK}2"

export INSTALL_DIR="/mnt/artix"
EFI_DIR=$INSTALL_DIR/efi

LVM_NAME='artixlvm'

export USER1="krypek"
export REGION="Europe"
export CITY="Warsaw"
export HOSTNAME="krypekartix"
export LANG="en_US.UTF-8"

export USER_HOME="/home/$USER1"
export DOTFILES_DIR="$USER_HOME/.config/dotfiles"
export INSTALL_DIR="$DOTFILES_DIR/artix"
export CONFIGF_DIR="$DOTFILES_DIR/config-files"

LGREEN='\033[1;32m'l
GREEN='\033[0;32m'l
RED='\033[0;31m'
NC='\033[0m' 

function confirm() {
    read -p "Continue (y/n)?" choice
    case "$choice" in 
    y|Y ) echo "yes";;
    n|N ) exit;;
    * ) confirm; return;;
    esac
}

echo -e "$RED Start partitioning the disk? $RED(DATA WARNING)$NC"
confirm
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk ${TGTDEV}
  g # set partitioning scheme to GPT
  o # clear the in memory partition table
  n # Create EFI partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk 
  +${EFI_SIZE}M # your size
  n # Create LVM partition
  p # primary partition
  2 # partion number 2
    # default, start immediately after preceding partition
    # default, extend partition to end of disk
  p # print the in-memory partition table
  w # write the partition table
  q # and we're done
EOF
confirm

# Create encryptred container on LVM_PART
echo -e "$LGREEN Setting up luks on $LVM_PART $RED(DATA WARNING)$NC"
cryptsetup luksFormat --key-size 512 --hash sha512 --iter-time 5000 $LVM_PART

echo -e "$LGREEN Opening $LVM_PART as $LVM_NAME $NC"
cryptsetup open $LVM_PART $LVM_NAME

confirm

# Format EFI_PART
echo -e"$LGREEN Formatting $EFI_PART as FAT32 $RED(DATA WARNING)$NC"
mkfs.fat -n efi -F 32 $EFI_PART

# Mount EFI_PART
echo -e "$GREEN Mounting $EFI_PART to $EFI_DIR $NC"
mkdir -p $EFI_DIR
mount $EFI_PART $EFI_DIR

confirm


