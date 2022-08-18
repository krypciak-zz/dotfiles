-- Function to retrieve console output
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

function split_by_line_ending(str)
   local t = {}
   local function helper(line)
      table.insert(t, line)
      return ""
   end
   helper((str:gsub("(.-)\r?\n", helper)))
   return t
end

function list_contains(list, key) 
    for i = 1, #list do
        if list[i] == key then return true end
    end
    return false
end

function run_if_not_running_pgrep(name, func)
    if type(name) == "string" then 
        if not func then
            func = function() 
                awful.spawn(name)
            end
        end
        name = { name }
    end
    local running = 0
    for _, grep in ipairs(name) do
        local cmd
        if string.sub(grep, 0, 1) == "@" then
            grep = string.sub(grep, 2, string.len(grep))
            cmd = "pgrep --full \"" .. grep .. "\""
        else
            cmd = "pgrep " .. grep
        end
        local output = os.capture(cmd)
	    if output ~= "" then
            running = 1 
	    end
    end
    if running == 0 then
        func()
    end
end
