#!/bin/bash
function install_awesome() {
    wget --quiet https://tools.suckless.org/dmenu/scripts/dmenu_run_with_command_history/dmenu_run_history -O /bin/dmenu_run_history
    chmod +x /bin/dmenu_run_history
    echo 'alacritty awesome breeze breeze-gtk breeze-icons dmenu feh lxappearance qt5-base qt6-base unclutter-xfixes-git xbindkeys xdg-ninja-git xdg-desktop-portal xdotool xkeyboard-config xorg-server xorg-xinit xorg-xprop xorg-xrandr xorg-xrefresh zenity copyq world/xorg-xmodmap redshift scrot topgrade xdg-utils gtk2 gtk3 qt5ct'
}
