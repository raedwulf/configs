-----------------------------------------------------------------------
-- luakit configuration file, more information at http://luakit.org/ --
-----------------------------------------------------------------------

-- Load library of useful functions for luakit
require "lousy"

-- Small util functions to print output (info prints only when luakit.verbose is true)
function warn(...) io.stderr:write(string.format(...) .. "\n") end
function info(...) if luakit.verbose then io.stderr:write(string.format(...) .. "\n") end end

-- Load users global config
-- ("$XDG_CONFIG_HOME/luakit/globals.lua" or "/etc/xdg/luakit/globals.lua")
require "globals"

-- Load users theme
-- ("$XDG_CONFIG_HOME/luakit/theme.lua" or "/etc/xdg/luakit/theme.lua")
lousy.theme.init(lousy.util.find_config("theme.lua"))
theme = assert(lousy.theme.get(), "failed to load theme")

-- Load users window class
-- ("$XDG_CONFIG_HOME/luakit/window.lua" or "/etc/xdg/luakit/window.lua")
require "window"

-- Load users webview class
-- ("$XDG_CONFIG_HOME/luakit/webview.lua" or "/etc/xdg/luakit/webview.lua")
require "webview"

-- Load users mode configuration
-- ("$XDG_CONFIG_HOME/luakit/modes.lua" or "/etc/xdg/luakit/modes.lua")
require "modes"

-- Load users keybindings
-- ("$XDG_CONFIG_HOME/luakit/binds.lua" or "/etc/xdg/luakit/binds.lua")
require "binds"

----------------------------------
-- Optional user script loading --
----------------------------------

-- Add vimperator-like link hinting & following
require "follow"

-- Add uzbl-like form filling
require "formfiller"

-- Add proxy support & manager
require "proxy"

-- Add quickmarks support & manager
require "quickmarks"

-- Add session saving/loading support
require "session"

-- Add command to list closed tabs & bind to open closed tabs
require "undoclose"

-- Add greasemonkey-like javascript userscript support
require "userscripts"

-- Add bookmarks support
require "bookmarks"

-- Add download support
require "downloads"
require "downloads_chrome"

-- Add command completion
require "completion"

-- Add command history
require "cmdhist"

-- Add search mode & binds
require "search"

-- Add ordering of new tabs
require "taborder"

-- Save web history
require "history"

require "follow_selected"
require "go_input"
require "go_next_prev"
require "go_up"
require "session"
require "quickmarks"
require "proxy"
require "dbus"

-----------------------------
-- End user script loading --
-----------------------------

-- Restore last saved session
local w = (session and session.restore())
if w then
    for i, uri in ipairs(uris) do
        w:new_tab(uri, i == 1)
    end
else
    w = window.new(uris)
end

-- register my dbus callback
require "dumper"
function dump(...)
  print(DataDumper(...), "\n---")
end

dbus.handlers:add_signal("open_url", function (handler, dbus_msg)
        for i,uri in ipairs(dbus_msg.args) do
            w:new_tab(uri)
        end
    end)
dbus.handlers:add_signal("active", function (handler, dbus_msg)
        return true
    end)

-- vim: et:sw=4:ts=8:sts=4:tw=80