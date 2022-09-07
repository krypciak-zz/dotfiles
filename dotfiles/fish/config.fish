if status is-interactive
    set fish_greeting
    alias ls='lsd'
    alias l='lsd -l'
    alias la='lsd -a'
    alias lla='lsd -la'
    alias lt='lsd --tree'

    alias reboot='loginctl reboot'
    alias poweroff='loginctl shutdown'

    source /usr/share/autojump/autojump.fish   
end
