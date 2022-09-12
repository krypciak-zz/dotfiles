#!/bin/bash
function install_audio() {
    echo 'pulseaudio cmus-git playerctl'
}
function configure_audio() {
    pip install cmus-notify
}
# world/webrtc-audio-processing media-player-info pulseaudio world/pipewire-jack 
