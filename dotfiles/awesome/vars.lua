userdir	     = os.getenv('HOME')
awesomedir   = userdir.."/.config/awesome"
themefile    = awesomedir.."/theme.lua"

terminal     = "alacritty"
terminal_cmd = terminal.." -e "
editor       = "nvim"
music_player = "alacritty --class cmus --title cmus -e cmus"
music_player_class = "cmus"

altkey       = "Mod1"
superkey     = "Mod4"
ctrlkey	     = "Control"
shiftkey     = "Shift"
capskey      = "Mod3"

wallpaper_dir = awesomedir .. '/theme/wallpapers/'
wallpapers   = { 
    { 'oneshot/factory.png', 'oneshot/main.png', 'oneshot/library.png', 'oneshot/asteroid.png' }, 
    { 'autumn.png' }, 
    { '#000000', '#303030' } 
}
lock_wallpaper = wallpapers[2][2]

wallpaper_group = 2
wallpaper_index = 1

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

--screens = {"DisplayPort-0"}

screenshots_folder = userdir .. '/Pictures/Screenshots/'
screenshots_date_format = '%x_%X'
screenshot_editor = 'kolourpaint'


lock_command = 'alock -b image:file=' .. wallpaper_dir .. lock_wallpaper .. ' -i none'

awful.util.terminal = terminal

