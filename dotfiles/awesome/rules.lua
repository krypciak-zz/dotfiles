awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            callback = awful.client.setslave,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap +
                awful.placement.no_offscreen,
            size_hints_honor = false
        }
    }, 
    -- Always on top
    {
	rule_any = { class = { "leagueclientux.exe" } },
	properties = { ontop = true} 
    },

    -- Maximized clients
    {
        rule_any = {name = {"Minecraft*"}},
        properties = {maximized = true}
    }, 
    -- Fullscreen clients
    {
        rule_any = {
            class = {"league of legends.exe"},
        },
        properties = { fullscreen = true}
    }, 
    -- Floating clients
    {
        rule_any = {
            class = {
		    "leagueclient.exe", "leagueclientux.exe",
		    "riotclientux.exe"
	    },
	    name = {
		    "Picture in picture"
	    },
        },
        properties = {floating = true, size_hints_honor = true}
    }, 
    -- Fixed size clients
    {
        rule_any = {
            class = {
		    "leagueclient.exe", "leagueclientux.exe",
		    "riotclientux.exe"
	    },
        },
        properties = {is_fixed = true}
    }, 
    -- Titlebars enabled clients
    {
        rule_any = {
            class = {
		    "leagueclient.exe", "leagueclientux.exe",
     		    "riotclientux.exe"
	    },
        },
        properties = {titlebars_enabled = true}
    }, 
    -- League of legends
    {
        rule_any = {
            class = {
                "leagueclient.exe", "leagueclientux.exe",
                "league of legends.exe", "riotclientux.exe"
            },
        },
        callback = function(client)
	    -- Functions from tags.lua
	    -- Make sure tag mc exists, if not create it
	    client:move_to_tag(get_tag(all_tags["lol"]))
        end,

        properties = {tag = "lol"}
    },

    -- Minecraft
    {rule_any = {name = {"Minecraft*"}, class = {"MultiMC"}}, 
    callback = function(client)
	    client:move_to_tag(get_tag(all_tags["mc"]))
    end,
    properties = {tag = "mc"}},
    
    -- Music player
    {rule_any = {class = { music_player, "kmix"}}, 
     callback = function(client)
        client:move_to_tag(get_tag(all_tags["music"]))
    end,
    properties = {tag = "music"}},

    -- Steam games
    {rule_any = {class = { "Steam" }}, 
    callback = function(client)
	    client:move_to_tag(get_tag(all_tags["lutris"]))
    end,
    properties = {tag = "lutris", minimalized = false}},

    -- BTD6
    { rule = { name = "BloonsTD6" },
    callback = function(client)
	    client:move_to_tag(get_tag(all_tags["btd6"]))
    end,
    properties = {tag = "btd6"}},

    -- Discord
    { rule_any = { class = { "discord", "WebApp-discord7290" } },
    callback = function(client)
	    client:move_to_tag(get_tag(all_tags["discord"]))
    end,
    properties = {tag = "discord"}},

    -- Freetube and LBRY
    { rule_any = { class = { "FreeTube", "LBRY" } },
    callback = function(client)
	    client:move_to_tag(get_tag(all_tags["media"]))
    end,
    properties = {tag = "media"}},

    -- Chromium
    { rule_any = { class = { "chromium", "Chromium" } },
    callback = function(client)
	    local tag = get_tag(all_tags["chromium"])
	    client:move_to_tag(tag)
	    --tag:view_only()
    end,
    properties = {tag = "chromium", maximized=false}},
    
    -- Icecat
    { rule_any = { class = { "icecat" } },
    callback = function(client)
	    local tag = get_tag(all_tags["icecat"])
	    client:move_to_tag(tag)
	    --tag:view_only()
    end,
    properties = {tag = "icecat", maximized=false}},

    -- Tutanota
    { rule_any = { class = { "tutanota-desktop" } },
    callback = function(client)
	    client:move_to_tag(get_tag(all_tags["mail"]))
    end,
    properties = {tag = "mail", maximized=false}},

    -- Dialect
    { rule_any = { class = { "dialect" } },
    callback = function(client)
	    client:move_to_tag(get_tag(all_tags["dialect"]))
    end,
    properties = {tag = "dialect", maximized=false}},
}

