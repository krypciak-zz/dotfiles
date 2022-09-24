-- https://libreddit.kavin.rocks/r/awesomewm/comments/h07f5y/does_awesome_support_window_swallowing/
-- Thanks u/niknah and u/nfjlanlsad

function is_terminal(c)
    return (c.class and c.class:match("Alacritty")) and true or false
end

function copy_size(c, parent_client)
    if not c or not parent_client then
        return
    end
    if not c.valid or not parent_client.valid then
        return
    end
    c.x=parent_client.x;
    c.y=parent_client.y;
    c.width=parent_client.width;
    c.height=parent_client.height;
end
function check_resize_client(c)
    if(c.child_resize) then
        copy_size(c.child_resize, c)
    end
end

client.connect_signal("property::size", check_resize_client)
client.connect_signal("property::position", check_resize_client)


--[[function get_client_index(client)
    noti("searching for", tostring(client.name), 0)
    noti("client 1", serialize_table(client.screen.get_clients()[1].name), 0)
    noti("client 2", serialize_table(client.screen.get_clients()[2].name), 0)
    noti("client 3", serialize_table(client.screen.get_clients()[3].name), 0)
    noti("client 4", serialize_table(client.screen.get_clients()[4].name), 0)
    for i, c in ipairs(client.screen.get_clients()) do
        if c == client then 
            return i 
        end
    end
    return -1
end--]]

client.connect_signal("manage", function(c) 
    if is_terminal(c) then return end

    local parent_client=awful.client.focus.history.get(c.screen, 1)
    if c.pid then
    awful.spawn.easy_async('bash '..awesomedir..'/window_swallow/helper.sh gppid '..c.pid, function(gppid)
        awful.spawn.easy_async('bash '..awesomedir..'/window_swallow/helper.sh ppid '..c.pid, function(ppid)
            if parent_client and (gppid:find('^' .. parent_client.pid) or ppid:find('^' .. parent_client.pid))and is_terminal(parent_client) then

                --local parent_index = get_client_index(parent_client)
                --noti("wow", tostring(parent_index), 0)

                parent_client.child_resize = c
                

                parent_client.force_minimalize = true
                parent_client.minimized = true

                c:connect_signal("unmanage", function() 
                    parent_client.minimized = false 
                    parent_client.force_minimalize = false
                end)

                --awful.client.swap.byidx(2, c)
                copy_size(c, parent_client)
            end
        end)
    end)
    end
end)
