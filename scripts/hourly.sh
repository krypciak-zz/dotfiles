#!/bin/sh

sh ~/.config/dotfiles/scripts/ttyper.sh

if [ "$(pgrep "League")" == "" ]; then 
    zenity --question --text "break time\n select 'no' to go to sleep"
    SLEEP=$?
    if [ $SLEEP -eq 1 ]; then
        export $(dbus-launch)
        /usr/bin/awesome-client 'suspend()'
    fi
fi
     
