ARTIXD_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DOTFILES_DIR=$ARTIXD_DIR/..
CONFIGD_DIR=$DOTFILES_DIR/config-files

source "$ARTIXD_DIR/vars.sh"

cp -rv $CONFIGD_DIR/root/etc/fstab /etc/fstab

pri "Configuring fstab"
ROOT_UUID=$(blkid $LVM_DIR/root -s UUID -o value)
ESCAPED_ROOT_UUID=$(printf '%s\n' "$ROOT_UUID" | sed -e 's/[\/&]/\\&/g')
sed -i "s/ROOT_UUID/$ESCAPED_ROOT_UUID/g" /etc/fstab

SWAP_UUID=$(blkid $LVM_DIR/swap -s UUID -o value)
ESCAPED_SWAP_UUID=$(printf '%s\n' "$SWAP_UUID" | sed -e 's/[\/&]/\\&/g')
sed -i "s/SWAP_UUID/$ESCAPED_SWAP_UUID/g" /etc/fstab

HOME_UUID=$(blkid $LVM_DIR/home -s UUID -o value)
ESCAPED_HOME_UUID=$(printf '%s\n' "$HOME_UUID" | sed -e 's/[\/&]/\\&/g')
sed -i "s/HOME_UUID/$ESCAPED_HOME_UUID/g" /etc/fstab

BOOT_UUID=$(blkid $BOOT_PART -s UUID -o value)
ESCAPED_BOOT_UUID=$(printf '%s\n' "$BOOT_UUID" | sed -e 's/[\/&]/\\&/g')
sed -i "s/BOOT_UUID/$ESCAPED_BOOT_UUID/g" /etc/fstab


ESCAPED_LVM_GROUP_NAME=$(printf '%s\n' "$LVM_GROUP_NAME" | sed -e 's/[\/&]/\\&/g')
sed -i "s/LVM_GROUP_NAME/$ESCAPED_LVM_GROUP_NAME/g" /etc/fstab


ESCAPED_ROOT_FSTAB_ARGS=$(printf '%s\n' "$ROOT_FSTAB_ARGS" | sed -e 's/[\/&]/\\&/g')
sed -i "s/ROOT_FSTAB_ARGS/$ESCAPED_ROOT_FSTAB_ARGS/g" /etc/fstab

ESCAPED_HOME_FSTAB_ARGS=$(printf '%s\n' "$HOME_FSTAB_ARGS" | sed -e 's/[\/&]/\\&/g')
sed -i "s/HOME_FSTAB_ARGS/$ESCAPED_HOME_FSTAB_ARGS/g" /etc/fstab

ESCAPED_BOOT_FSTAB_ARGS=$(printf '%s\n' "$BOOT_FSTAB_ARGS" | sed -e 's/[\/&]/\\&/g')
sed -i "s/BOOT_FSTAB_ARGS/$ESCAPED_BOOT_FSTAB_ARGS/g" /etc/fstab

ESCAPED_FAKE_USER_HOME=$(printf '%s\n' "$FAKE_USER_HOME" | sed -e 's/[\/&]/\\&/g')
sed -i "s/FAKE_USER_HOME/$ESCAPED_FAKE_USER_HOME/g" /etc/fstab

pri "Enabling mkinitpckio"
mv /90-mkinitcpio-install.hook /usr/share/libalpm/hooks/90-mkinitcpio-install.hook
#sed -i '1d' /bin/mkinitcpio
