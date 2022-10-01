#!/bin/sh

sh ~/.config/dotfiles/scripts/ttyper.sh

if [ "$(pgrep "League")" == "" ]; then 
    zenity --question --text "break time\n select 'no' to go to sleep"
    if [ $? -eq 1 ]; then
        awesome-client "suspend()"
    fi
fi
     
