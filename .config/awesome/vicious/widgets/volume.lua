---------------------------------------------------
-- Licensed under the GNU General Public License v2
--  * (c) 2010, Eastwood, TCMR. <tcmreastwood@gmail.com>
---------------------------------------------------

-- {{{ Grab environment
local tonumber = tonumber
local io = { popen = io.popen }
local setmetatable = setmetatable
local string = { match = string.match, find = string.find }
-- }}}


-- Volume: provides volume levels and state of requested pulseaudio mixers
module("vicious.widgets.volume")


-- {{{ Volume widget type
local function worker(format, warg)
    if not warg then return end

    local insink = false
    local f = io.popen("pacmd list-sinks")
    local volu = "0"
    local mute = "-"
    local mixer_state = {
        ["no"]  = "♫", -- "",
        ["yes"] = "♩"  -- "M"
    }
    for line in f:lines() do
        if string.find(line, "index:") ~= nil then
            local index = string.match(line, "index: ([%d]+)")
            if tonumber(index) == warg then
                insink = true
            elseif tonumber(index) == nil then
                insink = false
            end
        end
        if insink then
            if string.find(line, "volume: 0:") ~= nil then
                volu = string.match(line, "volume: 0:  ([%d]+)")
            end
            if string.find(line, "muted:") ~= nil then
                mute = mixer_state[string.match(line, "muted: ([%a]+)")]
            end
        end
    end
    f:close()

    return {tonumber(volu), mute}
end
-- }}}

setmetatable(_M, { __call = function(_, ...) return worker(...) end })
