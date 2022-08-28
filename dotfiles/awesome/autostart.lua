-- Spawn music_player in tag music
awful.spawn("kmix")

awful.spawn(music_player)

-- Start redshift if not running
local redshift_running = os.capture("pgrep redshift")
if redshift_running == "" then
	awful.spawn("redshift")
else

end

-- Hide the mouse after 3 seconds of inactivity
os.execute("killall unclutter")
awful.spawn("unclutter --timeout 2 --jitter 20 --ignore-scrolling --start-hidden")

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


-- Clipbooard manager
awful.spawn("copyq")

-- Bluetooth
awful.spawn("bluetoothctl connect DC:2C:26:30:B8:9B")

-- Shutter (screenshot tool)
run_if_not_running_pgrep({"shutter"}, function() awful.spawn("shutter --min_at_startup") end)

run_if_not_running_pgrep("keepassxc")

run_if_not_running_pgrep("tutanota-desktop")

-- Launch after_init.lua after waiting a bit
awful.spawn.easy_async_with_shell("sleep 0.1", 
    function(_,_,_,_) require("after_init") end
)

-- Launch after_5sec.lua after waiting 5 seconds
awful.spawn.easy_async_with_shell("sleep 5", 
    function(_,_,_,_) require("after_5sec") end
)
