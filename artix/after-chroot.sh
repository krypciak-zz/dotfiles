#!/bin/sh


# Time
ln -sf /usr/share/zoneinfo/$REGION/$CITY /etc/localtime
hwclock --systohc

# Locale
cp $CONFIGF_DIR/locale.gen /etc/locale.gen
locale-gen
echo "LANG=\"$LANG\"" > /etc/locale.conf
export LC_COLLATE="C"

# Hostname
echo "$HOSTNAME" > /etc/hostname
echo "hostname=\'$HOSTNAME\'" >> /etc/conf.d/hostname

# Hosts
cp $CONFIGF_DIR/hosts /etc/hosts
chown root:root /etc/hosts

# Copy pacman configuration
cp $CONFIGF_DIR/pacman.conf /etc/pacman.conf
chown root:root /etc/pacman.conf
cp -r $CONFIGF_DIR/pacman.d /etc/
chown -R root:root /etc/pacman.d
pacman-key --populate archlinux

# Install base
sh $INSTALL_DIR/install-base.sh

# Add user
useradd -m -s /bin/zsh $USER1
chown $USER1:$USER1 $USER_HOME/
chown -R $USER1:$USER1 $DOTFILES_DIR

# Create temporary doas.conf
echo "permit nopass root" > /etc/doas.conf
echo "permit nopass $USER1" >> /etc/doas.conf

sed -i 's/#PACMAN_AUTH=()/PACMAN_AUTH=(doas)/' /etc/makepkg.conf

# Install paru
if [ -d /tmp/paru ]; then rm -rf /tmp/paru; fi

#mkdir -p $USER_HOME/.cargo
#chown -R $USER1:$USER1 $USER_HOME/.cargo

git clone https://aur.archlinux.org/paru-bin.git /tmp/paru
chown -R $USER1:$USER1 /tmp/paru
chmod +wrx /tmp/paru
cd /tmp/paru
doas -u $USER1 makepkg -si --noconfirm --needed

# Set paru auth method to doas
sed -i 's/#\[bin\]/\[bin\]/g' /etc/paru.conf
sed -i 's/#Sudo = doas/Sudo = doas/g' /etc/paru.conf

# Install packages
doas -u $USER1 sh $INSTALL_DIR/install-packages.sh

# Install gpu drivers
doas -u $USER1 sh $INSTALL_DIR/install-gpudrivers.sh

# Install oh-my-zsh for both users
# root
mkdir -p /root/.local/share/
if [ -d /root/.local/share/oh-my-zsh ]; then rm -rf /root/.local/share/oh-my-zsh; fi
git clone https://github.com/ohmyzsh/ohmyzsh.git /root/.local/share/oh-my-zsh

# user
mkdir -p $USER_HOME/.local/share/
if [ -d $USER_HOME/.local/share/oh-my-zsh ]; then rm -rf $USER_HOME/.local/share/oh-my-zsh; fi

cp -r /root/.local/share/oh-my-zsh $USER_HOME/.local/share/
chown -R $USER1:$USER1 $USER_HOME/.local/share/oh-my-zsh

# Add user groups
usermod -aG tty,ftp,games,network,scanner,libvirt,users,video,audio,wheel $USER1

# Enable services
rc-update add NetworkManager default
rc-update add device-mapper boot
rc-update add lvm boot
rc-update add dmcrypt boot
rc-update add dbus default
rc-update add elogind boot

# libvirtd
rc-update add libvirtd default
cp $CONFIGF_DIR/libvirtd.conf /etc/libvirt/libvirtd.conf
chown root:root /etc/libvirt/libvirtd.conf

cp $CONFIGF_DIR/qemu.conf /etc/libvirt/qemu.conf
sed -i "s/USER/${USER1}/g" /etc/libvirt/qemu.conf
chown root:root /etc/libvirt/qemu.conf

# Autologin
cp $CONFIGF_DIR/agetty-autologin* /etc/init.d/
sed -i "s/USER/${USER1}/g" /etc/init.d/agetty-autologin*
#sed -i "s/USER/${USER1}/g" /etc/init.d/agetty-autologin.tty1
chown root:root /etc/init.d/agetty-autologin*

rc-update del agetty.tty1 default
rc-update add agetty-autologin.tty1 default

mkdir -p /etc/zsh
cp $CONFIGF_DIR/zprofile /etc/zsh/
chown root:root /etc/zsh/zprofile

# Install dotfiles
sh $DOTFILES_DIR/install-dotfiles.sh
sh $DOTFILES_DIR/install-dotfiles-root.sh

# Copy doas.conf config
cp $CONFIGF_DIR/doas.conf /etc/doas.conf
chown root:root /etc/doas.conf
chmod -rw /etc/doas.conf

# Cleanup
rm -rf $USER_HOME/.cargo


# Set passwords for user
echo "Password for $USER1:"
n=0
until [ "$n" -ge 5 ]
do
   passwd $USER1 && break
   n=$((n+1)) 
   sleep 15
done
chown -R $USER1:$USER1 $USER_HOME

# Set password for root
echo "Password for root:"
n=0
until [ "$n" -ge 5 ]
do
   passwd root && break
   n=$((n+1)) 
   sleep 15
done

chsh -s /bin/zsh root
mkdir -p /root/.config/zsh


echo configre grub now