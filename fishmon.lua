addon.name = "fishmon";
addon.author = "Floaty";
addon.version = "1.1.0";
addon.desc = 'Updated fishmon for tracking gil/hr';
addon.link = 'https:ashitaxi.com/';

require("common");
local chat = require('chat');
----------------------------------------------------------------------------------------------------
-- Default config
-- A file will be generated at settings/settings.json in the addon folder
-- Edit the settings file or add new fish in here with the format ['fishid'] = gilvalue
----------------------------------------------------------------------------------------------------
local default_config = {
    prices = {},
    show_gui = true,
    show_debug = true,
}

-- below is vendor prices/AH pricing
default_config.prices = {
    ["5455"] = 700, --Ahtapot
    ["5454"] = 600, --Mercanbaligi
    ["4290"] = 458 --AH price per
}

local fishmon_config = default_config
local fish_caught = 0
local started = false
local start_time = os.time(os.date("!*t")) -- Start time is temporarily set on load
local profit = 0
local profit_per_hour = 0
local fishing = {}
fishing.messages = {
    ["Something caught the hook!!!1"] = string.format("\31\130=========================>>> \31\6Big Fish"),
    ["Something caught the hook!1"] = string.format("\31\130=========================>>> \31\36Small Fish"),
    ["You feel something pulling at your line."] = string.format("\31\130=========================>>> \31\05Item"),
    ["Something clamps onto your line ferociously!"] = string.format(
        "\31\130=========================>>> \31\39Monster"
    ),
}
-- Load config

ashita.register_event("load", function()
    if not ashita.file.file_exists(addon.path .. "/settings/settings.json") then
        ashita.settings.save(addon.path .. "/settings/settings.json", fishmon_config)
    end

    fishmon_config = ashita.settings.load_merged(addon.path .. "/settings/settings.json", fishmon_config)
end)
----------------------------------------------------------------------------------------------------
-- Parse packets for fish and result data
----------------------------------------------------------------------------------------------------
ashita.register_event("incoming_packet", function(id, size, data)
    profit_per_hour = profit / (((os.time(os.date("!*t")) - start_time) / 60) / 60)
    if id == 277 then -- Packet 277 has info on stamina, damage, and time
        if fishmon_config.show_debug == true then
            stamina = struct.unpack("H", data, 0x04 + 1)
            dmg = struct.unpack("H", data, 0x0C + 1)
            time = struct.unpack("H", data, 0x10 + 1)
            print(
                "\31\16"
                    .. tostring(math.floor((stamina / dmg) + 0.5))
                    .. " Arrows | "
                    .. tostring(time)
                    .. " Seconds | "
                    .. tostring(stamina)
                    .. " Health | "
                    .. tostring(dmg)
                    .. " Damage"
            )
        end
    end
    if id == 39 then -- Packet 39 contains the actual fish ID. It is only sent after the fish is caught
        local player = GetPlayerEntity()
        target = struct.unpack("H", data, 5)
        if player.ServerId == target then
            id = tostring(struct.unpack("H", data, 17))
            for key, v in pairs(fishmon_config.prices) do
                if string.contains(id, key) then
                    if (started == false) and (fish_caught == 0) then
                        start_time = os.time(os.date("!*t"))
                        started = true
                    end
                    fish_caught = fish_caught + 1
                    profit = profit + v
                end
            end
        end
    end
    return false
end)
----------------------------------------------------------------------------------------------------
-- Replace default message
----------------------------------------------------------------------------------------------------
ashita.register_event("incoming_text", function(mode, chat)
    for key, v in pairs(fishing.messages) do
        if string.contains(chat, key) then
            return v
        end
    end
    return false
end)
----------------------------------------------------------------------------------------------------
-- Render GUI
----------------------------------------------------------------------------------------------------
ashita.register_event("render", function()
    if fish_caught == 0 then -- Don't show the GUI if the user isn't fishing yet.
        return
    end
    if fishmon_config.show_gui == false then
        return
    end
    imgui.SetNextWindowSize(200, 100, ImGuiSetCond_Always)
    if imgui.Begin("fishmon") == false then
        imgui.End()
        return
    end
    imgui.Text("Fish Caught:")
    imgui.SameLine()
    imgui.Text(fish_caught)
    imgui.Separator()
    imgui.Text("Total gil:")
    imgui.SameLine()
    imgui.Text(string.gsub(profit, "^(-?%d+)(%d%d%d)", "%1,%2"))
    imgui.Separator()
    imgui.Text("Gil/hr:")
    imgui.SameLine()
    imgui.Text(string.gsub(math.floor(profit_per_hour), "^(-?%d+)(%d%d%d)", "%1,%2"))
    imgui.Separator()
    imgui.End()
end)
