#!/bin/bash
function install_social() {
    echo 'noto-fonts-cjk ttf-symbola noto-fonts-emoji webapp-manager discord betterdiscordctl'
}

function configure_social() {
    betterdiscordctl install &>/dev/null
}
