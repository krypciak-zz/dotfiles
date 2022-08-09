-- Set screeb brightness
set_screens_brightness(default_screen_brightness)

-- Set the keyboard layout to pl
os.execute("setxkbmap pl")
 

local function xmodmap(cmd)
	os.execute("xmodmap -e \""..cmd.."\"")
end
--awful.spawn("setxkbmap -option caps:menu")
-- Remap Caps Lock to Mod5
xmodmap("clear mod4")
xmodmap("add mod4 = Super_L Super_L Super_L Hyper_L")
xmodmap("clear lock")
xmodmap("keycode 66 = Super_R Super_R Super_R Super_R")
xmodmap("add mod3 = Super_R")

-- Hide the mouse after 3 seconds of inactivity
awful.spawn("unclutter --timeout 3 --jitter 5 --ignore-scrolling --start-hidden")

-- Clipbooard manager
awful.spawn("copyq")

-- Spawn music_player in tag music
awful.spawn("kmix")

awful.spawn(music_player)

os.execute("killall redshift")
awful.spawn("redshift")

