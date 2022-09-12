#!/bin/bash
function install_social() {
    echo 'noto-fonts-emoji tutanota-desktop-bin webapp-manager discord betterdiscordctl'
}

function configure_social() {
    betterdiscordctl install &>/dev/null
}
