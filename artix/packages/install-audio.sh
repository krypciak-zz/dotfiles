#!/bin/bash
function install_audio() {
    echo 'alsa-firmware alsa-lib alsa-plugins alsa-utils alsa-utils-openrc apulse cmus-git playerctl'
}
function configure_audio() {
    pip install cmus-notify
    rc-update add alsasound default
}
# world/webrtc-audio-processing media-player-info pulseaudio world/pipewire-jack 
