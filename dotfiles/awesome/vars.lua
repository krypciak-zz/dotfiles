userdir	     = "/home/krypek"
awesomedir   = userdir.."/.config/awesome"
themefile    = awesomedir.."/theme.lua"

terminal     = "alacritty"
terminal_cmd = terminal.." -e "
editor       = "nvim"
music_player = "strawberry"

altkey       = "Mod1"
superkey     = "Mod4"
ctrlkey	     = "Control"
shiftkey     = "Shift"
capskey      = "Mod3"

default_layout_index = 2

awful.layout.layouts = {
    		awful.layout.suit.floating,
    		awful.layout.suit.tile,
		awful.layout.suit.tile.left,
    		awful.layout.suit.tile.bottom,
    		awful.layout.suit.tile.top,
    		--awful.layout.suit.fair,
    		--awful.layout.suit.fair.horizontal,
    		--lain.layout.cascade,
    		--lain.layout.cascade.tile,
    		--lain.layout.centerwork,
    		--lain.layout.centerwork.horizontal,
    		--lain.layout.termfair,
    		--lain.layout.termfair.center
}
normal_tag_count = 3

no_border_when_1client = true

default_useless_gap = 6

default_screen_brightness = 1
screen_brightness_inc = 0.05
screens = {"DisplayPort-0"}

awful.util.terminal = terminal