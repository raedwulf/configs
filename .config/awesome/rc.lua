---- {{{ Require lua libraries
-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- Scratch
require("scratch")
-- Rodentbane: Rapid cursor control using the keyboard
require("rodentbane")
-- Vicious library
require("vicious")
helpers = require("vicious.helpers")
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init(os.getenv("HOME").."/.config/awesome/themes/arch/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvtc"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
browser = os.getenv("HOME").."/bin/lk"
mail = terminal .. " -e " .. "mutt"

-- Test whether we're on a laptop
laptop = false
f = io.open(os.getenv("HOME").."/.laptop")
if f ~= nil then
    laptop = true
    io.close(f)
end
-- }}}

---- {{{ Settings

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu.new({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                        { "open terminal", terminal },
                                        { "open browser", browser }
                                      }
                            })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock(" %a %b %d, %H:%M:%S", 1)

-- Keyboard map indicator and changer
kbdcfg = {}
kbdcfg.cmd = "setxkbmap "
kbdcfg.layout = { "gb", "us", "gb dvorak" }
kbdcfg.current = 1  -- gb is our default layout
kbdcfg.widget = wibox.widget.textbox()
kbdcfg.widget:set_text(" " .. kbdcfg.layout[kbdcfg.current] .. " ")
kbdcfg.switch = function ()
    kbdcfg.current = (kbdcfg.current + 1) % #(kbdcfg.layout) + 1
    local t = kbdcfg.layout[kbdcfg.current]
    kbdcfg.widget:set_text(" " .. t .. " ")
    os.execute( kbdcfg.cmd .. t )
end

-- Mouse bindings
kbdcfg.widget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () kbdcfg.switch() end)
))

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

-- {{{ Vicious widgets

-- Gmail widget
gmaildata=''
gmailscroll = 0
gmailwidth = 16
gmailwidget = wibox.widget.textbox()
gmailcount = 0
gmailsubject = "N/A"
vicious.register(gmailwidget, vicious.widgets.gmail,
    function(widget, args)
        gmailcount = args["{count}"]
        if not gmailcount then
            gmailsubject = string.rep(" ", gmailwidth).."N/A"..
                           string.rep(" ", gmailwidth)
        else
            gmailsubject = string.rep(" ", gmailwidth)..
                           args["{subject}"]..
                           string.rep(" ", gmailwidth)
        end
        local subscroll = helpers.escape(string.sub(gmailsubject, gmailscroll + 1, gmailscroll + gmailwidth))
        return '<span color="white">GMAIL </span><span color="gray">['..
               string.format("%03d", gmailcount)..'] </span>'..
               '<span color="white">: </span><span color="yellow" font="Dejavu Sans Mono">'..
               string.format("%"..gmailwidth.."s", subscroll)..'</span>'
    end, 10)
gmailscrolltimer = timer({ timeout = 1 })
gmailscrolltimer:connect_signal("timeout", 
    function() 
        local subscroll = helpers.escape(string.sub(gmailsubject, gmailscroll + 1, gmailscroll + gmailwidth))
        gmailscroll = (gmailscroll + 1) % (string.len(gmailsubject) - gmailwidth)
        gmailwidget:set_markup('<span color="white">GMAIL </span><span color="gray">['..
               string.format("%03d", gmailcount)..'] </span>'..
               '<span color="white">: </span><span color="yellow" font="Dejavu Sans Mono">'..
               string.format("%"..gmailwidth.."s", subscroll)..'</span>')
    end)
gmailscrolltimer:start()
-- CPU widget
cpuwidget = awful.widget.graph()
cpuwidget:set_width(20)
cpuwidget:set_background_color("#494B4F")
cpuwidget:set_color("#FF5656")
--cpuwidget:set_gradient_colors({ "#FF5656", "#88A175", "#AECF96" })

cpudata=''
vicious.register(cpuwidget, vicious.widgets.cpu, 
    function(widget, args)
        local names = { "Average:" }
        for i = 2,#args do
            table.insert(names, "Core "..(i-2)..":")
        end
        cpudata = '<span weight="bold" font="Dejavu Sans Mono" underline="single">'..
                  'CPU Usage</span>\n'
        for i = 1,#args do
            cpudata = cpudata..
                      '<span weight="bold" font="Dejavu Sans Mono">'..
                      string.format("%-8s", names[i])..'</span>'..
                      '<span color="green" font="Dejavu Sans Mono">'..
                      string.format("%5d", args[i])..
                      ' %</span>\n'
        end
        cpudata = cpudata:sub(1,-2)
        return args[1]
    end, 1)

cputooltip = awful.tooltip({ objects = { cpuwidget },
    timer_function = function()
        return cpudata
    end })
    
-- MEM widget
memwidget = awful.widget.progressbar()
memwidget:set_width(4)
memwidget:set_vertical(true)
memwidget:set_background_color("#494B4F")
memwidget:set_color("#AECF96")
--memwidget:set_gradient_colors({ "#AECF96", "#88A175", "#FF5656" })

memdata = ''
vicious.register(memwidget, vicious.widgets.mem, 
    function(widget, args)
        local names = { "Used %:", "In Use:", "Total:", "Free:" }
        local units = { " % ", " MB", " MB", " MB" }
        memdata = '<span weight="bold" font="Dejavu Sans Mono" underline="single">'..
                  'RAM Usage</span>\n'
        for i = 1,4 do
            memdata = memdata..
                      '<span weight="bold" font="Dejavu Sans Mono">'..
                      string.format("%-7s", names[i])..'</span>'..
                      '<span color="green" font="Dejavu Sans Mono">'..
                      string.format("%8s", args[i]..units[i])..'</span>\n'
        end
        memdata = memdata:sub(1,-2)
        return args[1]
    end, 13)
vicious.cache(vicious.widgets.mem)

memtooltip = awful.tooltip({ objects = { memwidget },
    timer_function = function()
        return memdata
    end })

-- Thermal widget
thrmwidget = awful.widget.progressbar()
thrmwidget:set_width(4)
thrmwidget:set_vertical(true)
thrmwidget:set_background_color("#494B4F")
thrmwidget:set_border_color(nil)
thrmwidget:set_color("#AECF96")
--thrmwidget:set_gradient_colors({ "#AECF96", "#88A175", "#FF5656" })
vicious.register(thrmwidget, vicious.widgets.thermal, 
    function(widget, args)
        thrmdata = args[1]
        return args[1]
    end
, 5, {"thermal_zone0", "sys"})

thrmtooltip = awful.tooltip({ objects = { thrmwidget },
    timer_function = function()
        return '<span weight="bold" font="Dejavu Sans Mono">Temperature: </span>'..
               '<span color="green" font="Dejavu Sans Mono">'..thrmdata.." C</span>"
    end })
    
-- Battery widget
if laptop then
    batwidget = awful.widget.progressbar()
    batwidget:set_width(4)
    batwidget:set_vertical(true)
    batwidget:set_background_color("#494B4F")
    batwidget:set_border_color(nil)
    batwidget:set_color("#AECF96")
    --batwidget:set_gradient_colors({ "#AECF96", "#88A175", "#FF5656" })
    vicious.register(batwidget, vicious.widgets.bat, "$2", 61, "BAT0")
    vicious.cache(vicious.widgets.bat)

    batdata = ''
    batsymwidget = wibox.widget.textbox()
    vicious.register(batsymwidget, vicious.widgets.bat, 
        function (widget, args)
            local state = args[1]
            local charge = args[2]
            if state ~= "⌁" and charge < 10 then
                naughty.notify({ text = "Battery low, only ".. charge .. "% left!" })
            end
            batdata = '<span weight="bold" font="Dejavu Sans Mono">Charge: </span>'..
                      '<span color="green" font="Dejavu Sans Mono">'..charge.." %</span>"
            local colour = "#"..string.format("%02X", (1 - charge/100) * 255)..
                string.format("%02X", (charge / 100) * 255).."00"
            return '<span color="'..colour..'">'..args[1]..'</span>'
        end, 61, "BAT0")

    battooltip = awful.tooltip({ objects = { batwidget, batsymwidget },
        timer_function = function()
            return batdata
        end })

    wifiwidget = awful.widget.progressbar()
    wifiwidget:set_width(4)
    wifiwidget:set_vertical(true)
    wifiwidget:set_background_color("#494B4F")
    wifiwidget:set_border_color(nil)
    wifiwidget:set_color("#AECF96")
    vicious.register(wifiwidget, vicious.widgets.wifi, "${link}", 60, "wlan0")
    vicious.cache(vicious.widgets.wifi)

    wifidata = ''
    wifisymwidget = wibox.widget.textbox()
    vicious.register(wifisymwidget, vicious.widgets.wifi, 
        function (widget, args)
            local names = {
                ["{ssid}"] = "SSID:", 
                ["{mode}"] = "Mode:", 
                --["{chan}"] = "Channel:",
                ["{rate}"] = "Rate:", 
                --["{link}"] = "Link:",
                ["{linp}"] = "Quality:",
                --["{sign}"] = "Signal:"
            }
            wifidata = '<span weight="bold" font="Dejavu Sans Mono" underline="single">'..
                       'Wifi Status</span>\n'
            args["{rate}"] = args["{rate}"].." Mbps"
            args["{linp}"] = args["{linp}"].." %"
            --args["{sign}"] = args["{sign}"].." dB"
            for i,v in pairs(names) do
                wifidata = wifidata..
                           '<span weight="bold" font="Dejavu Sans Mono">'..
                           string.format("%-9s", v)..' </span>'..
                           '<span color="green" font="Dejavu Sans Mono">'..
                           string.format("%8s", args[i]).."</span>\n"
            end
            wifidata = wifidata:sub(1,-2)
            if args["{linp}"] == "0 %" then
                colour = 'red'
            else
                colour = 'green'
            end
            return '<span color="'..colour..'" font="Dejavu Sans Mono">◉</span>'
        end, 60, "wlan0")

    wifitooltip = awful.tooltip({ objects = { wifiwidget, wifisymwidget },
        timer_function = function()
            return wifidata
        end })

    wifisymwidget:set_markup('<span color="red" font="Dejavu Sans Mono">◉</span>')

end

-- Volume widget
volwidget = awful.widget.progressbar()
volwidget:set_width(4)
volwidget:set_vertical(true)
volwidget:set_background_color("#494B4F")
volwidget:set_border_color(nil)
volwidget:set_color("#AECF96")
--volwidget:set_gradient_colors({ "#AECF96", "#88A175", "#FF5656" })
vicious.register(volwidget, vicious.widgets.volume, "$1", 0, "Master")
vicious.cache(vicious.widgets.volume)

voldata = ''
volsymwidget = wibox.widget.textbox()
vicious.register(volsymwidget, vicious.widgets.volume,
    function (widget, args)
        local volume = 0
        local colour = "red"
        if args[1] ~= nil then
            volume = args[1]
        end
        if args[2] == "♫" then
            colour = "green"
        end
        voldata = '<span weight="bold" font="Dejavu Sans Mono">Volume: </span>'..
                  '<span color="green" font="Dejavu Sans Mono">'..volume.." %</span>"
        return '<span color="'..colour..'"> ☊</span>'
    end, 0, "Master")

voltooltip = awful.tooltip({ objects = { volwidget, volsymwidget },
    timer_function = function()
        return voldata
    end })
-- }}}

-- Separator widgets
separator = wibox.widget.textbox()
--separator:set_markup('<span color="white" weight="heavy"> · </span>')
separator:set_text(' · ')
spacer = wibox.widget.textbox()
spacer:set_text(' ')

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(gmailwidget)
    right_layout:add(separator)
    right_layout:add(cpuwidget)
    right_layout:add(spacer)
    right_layout:add(memwidget)
    right_layout:add(spacer)
    right_layout:add(thrmwidget)
    right_layout:add(spacer)
    if laptop then
        right_layout:add(batwidget)
        right_layout:add(spacer)
        right_layout:add(batsymwidget)
        right_layout:add(spacer)
    end
    right_layout:add(volwidget)
    right_layout:add(volsymwidget)
    right_layout:add(separator)
    if laptop then
        right_layout:add(wifiwidget)
        right_layout:add(spacer)
        right_layout:add(wifisymwidget)
        right_layout:add(separator)
    end
    right_layout:add(kbdcfg.widget)
    right_layout:add(separator)
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "#38",      awful.tag.viewprev       ), -- a
    awful.key({ modkey,           }, "#39",      awful.tag.viewnext       ), -- s
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "#52", -- z
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "#53", -- x
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "#27", function () mymainmenu:show({keygrabber=true})        end), -- r

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "#52", function () awful.client.swap.byidx(  1) end), -- z
    awful.key({ modkey, "Shift"   }, "#53", function () awful.client.swap.byidx( -1) end), -- x
    awful.key({ modkey, "Control" }, "#52", function () awful.screen.focus_relative( 1)       end), -- z
    awful.key({ modkey, "Control" }, "#53", function () awful.screen.focus_relative(-1)       end), -- x
    awful.key({ modkey,           }, "#30", awful.client.urgent.jumpto), -- u
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "#24", function () awful.util.spawn(terminal) end), -- q
    awful.key({ modkey,           }, "#45", function () awful.util.spawn(terminal.." -e "..os.getenv("HOME").."/bin/irc") end), -- k
    awful.key({ modkey,           }, "#56", function () awful.util.spawn(browser) end), -- b
    awful.key({ modkey,           }, "#43", function () awful.util.spawn(mail) end), -- h
    awful.key({ modkey, "Control" }, "#27", awesome.restart), -- r
    awful.key({ modkey, "Shift"   }, "#24", awesome.quit), -- q

    -- Music
    awful.key({ modkey,           }, "#57", function () awful.util.spawn("cmus-remote -u") end), -- n

    -- Mixer
    awful.key({ "",               }, "#121", function () awful.util.spawn("toggle-mute") end),
    awful.key({ "",               }, "#122", function () awful.util.spawn("pavol up") end),
    awful.key({ "",               }, "#123", function () awful.util.spawn("pavol down") end),

    -- Tag adjustment
    awful.key({ modkey,           }, "#55",     function () awful.tag.incmwfact( 0.05)    end), -- v
    awful.key({ modkey,           }, "#54",     function () awful.tag.incmwfact(-0.05)    end), -- c
    awful.key({ modkey, "Shift"   }, "#54",     function () awful.tag.incnmaster( 1)      end), -- c
    awful.key({ modkey, "Shift"   }, "#55",     function () awful.tag.incnmaster(-1)      end), -- v
    awful.key({ modkey, "Control" }, "#54",     function () awful.tag.incncol( 1)         end), -- c
    awful.key({ modkey, "Control" }, "#55",     function () awful.tag.incncol(-1)         end), -- v
    awful.key({ modkey,           }, "space",   function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space",   function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    awful.key({ modkey,           }, "#25",     function () mypromptbox[mouse.screen]:run() end), -- w

    awful.key({ modkey,           }, "#260", -- e
        function ()
            awful.prompt.run({ prompt = "Run Lua code: " },
            mypromptbox[mouse.screen].widget,
            awful.util.eval, nil,
            awful.util.getdir("cache") .. "/history_eval")
        end),
        
    awful.key({ modkey,           }, "#26", -- e
        function ()
            scratch.drop(terminal)
        end),

    -- Rodentbane 
    awful.key({ modkey,           }, "#27",     rodentbane.start),
    awful.key({ modkey, "Alt"     }, "#27",     rodentbane.start),
    
    -- Scratchpad
    awful.key({ modkey, "Shift"   }, "#40",     scratch.pad.toggle)
)

-- Client awful tagging: this is useful to tag some clients and then do stuff like move to tag on them
clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "#42",      function (c) -- g
            if c.titlebar == nil then
                awful.titlebar.add(c, { modkey = modkey } ) 
            else
                awful.titlebar.remove(c)
            end
        end),
    awful.key({ modkey,           }, "#41",      function (c) c.fullscreen = not c.fullscreen  end), -- f
    awful.key({ modkey,           }, "#49",      function (c) c:kill()                         end), -- `
    awful.key({ modkey,           }, "#40",      function (c) scratch.pad.set(c)               end), -- d
    awful.key({ modkey,           }, "#51",      function (c) c:swap(awful.client.getmaster()) end), -- \
    awful.key({ modkey,           }, "#32",      awful.client.movetoscreen                        ), -- o
    awful.key({ modkey, "Shift"   }, "#27",      function (c) c:redraw()                       end), -- r
    awful.key({ modkey }, "#28", awful.client.floating.toggle), -- t
    awful.key({ modkey }, "#58", -- m
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end),
    awful.key({ modkey }, "Scroll_Lock", kbdcfg.switch),
    awful.key({        }, "Print",                function (c) 
        awful.util.spawn("scrot '%Y-%m-%d_%H.%M.%S_$wx$h_scrot.png' -e 'mv $f ~/pictures/screenshots/'")
    end),
    awful.key({ modkey }, "F12",                  function (c) 
        awful.util.spawn("scrot '%Y-%m-%d_%H.%M.%S_$wx$h_scrot.png' -e 'mv $f ~/pictures/screenshots/'") 
    end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "F" .. i,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          for k, c in pairs(awful.client.getmarked()) do
                              awful.client.movetotag(tags[screen][i], c)
                          end
                      end
                   end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "Evince" },
      properties = { floating = false } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "Gimp" },
      properties = { floating = true } },
    { rule = { class = "Skype" },
      properties = { floating = true } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    -- Don't honour hint sizes so it fills screen nicely
    c.size_hints_honor = false
end)
 
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Listen to remote code over tempfile
remotefile = timer { timeout = 1 }
remotefile:connect_signal("timeout", function()
    local file = io.open('/tmp/awesome-remote')
    local exe = {}

    if file then
        -- Read all code
        for line in file:lines() do
            table.insert(exe, line)
        end

        -- Close and delete file
        file:close()
        os.remove('/tmp/awesome-remote')

        -- Execute code
        for i, code in ipairs(exe) do
            loadstring(code)()
        end
    end
end)

remotefile:start()
-- }}}

-- vim: set filetype=lua fdm=marker tabstop=4 shiftwidth=4 expandtab smarttab autoindent smartindent nu:
