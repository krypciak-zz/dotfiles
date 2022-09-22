#!/bin/sh
if [ "$(pgrep "League")" == "" ]; then 
    zenity --info --text="ttyper time!" && alacritty --class 'ttyper','ttyper' -e ttyper
fi
