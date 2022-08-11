-- {{{ Required libraries

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

gears         = require("gears")
awful         = require("awful")
                require("awful.autofocus")
wibox         = require("wibox")
beautiful     = require("beautiful")
naughty       = require("naughty")
lain          = require("lain")

-- }}}



-- Error handling

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify {
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    }
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true
        naughty.notify {
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        }
        in_error = false
    end)
end


---
-- Function to retrieve console output
-- 
function os.capture(cmd)
    local handle = assert(io.popen(cmd, "r"))
    local output = assert(handle:read("*a"))
    handle:close()
    return output
end


function noti(title, text) 
    	naughty.notify {
        		preset = naughty.config.presets.low,
        		title = title,
       			text = text}
end

-- vars
require("vars")

-- Init theme
beautiful.init(themefile)

-- Signals
require("signals")

-- Key bindings
require("keybindings")

-- Setup tags
local tags = require("tags")

-- Activate the keys
root.keys(globalkeys)

-- Rules
require("rules")

-- Autostart
require("autostart")
