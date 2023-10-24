----------------------------------------------------------------------------------------------
--- RPGInitiative
--- author: peteR_pg
--- Steam profile: https://steamcommunity.com/id/peter_pg/
--- GitHub Repository: https://github.com/Susjin/RPGInitiative

--- Main file with all functions related to PLACEHOLDER
--- @class RPGInitiativeMenu
local RPGInitiativeMenu = {}
----------------------------------------------------------------------------------------------
--Setting up locals
local StringUtils = require "StringUtils"
local pairs = pairs


local options = {
    "start",
    "loadAll",
    "saveAll",
    "quit",
    "wrong"
}

function RPGInitiativeMenu.saveAll(playersTable, npcsTable)
    local file = io.open("text.txt", "w")
    file:write("playerData{")
    for _, player in pairs(playersTable) do
        file:write(string.format("|id:%d,name:%s,class:%s,", player.id, player.name, player.class))
    end
    file:write(string.format("}\n"))

    file:write("NPCData{")
    for _, npc in pairs(npcsTable) do
        file:write(string.format("|id:%d,name:%s,class:%s,", npc.id, npc.name, npc.class))
    end
    file:write("}")
    file:flush()
    file:close()
end

function RPGInitiativeMenu.loadAll()
    local file = io.open("text.txt", "r")
    local str = file:read("*all")
    local players = {}
    local npcs = {}
    local totalIDs = 0

    local playerPos1 = string.find(str, "playerData{"); local playerPos2 = string.find(str, "}", playerPos1)
    local playerData = string.sub(str, playerPos1, playerPos2)
    str = string.sub(str, playerPos2+1, -1)
    playerData = StringUtils.split(playerData, "|")
    for _, data in pairs(playerData) do
        if not string.find(data, "playerData{") then
            local pos1, pos2
            pos1 = string.find(data, "id:"); pos2 = string.find(data, ",", pos1)
            local _ = tonumber(string.sub(data, pos1+3, pos2-1))
            pos1 = string.find(data, "name:"); pos2 = string.find(data, ",", pos1)
            local name = string.sub(data, pos1+5, pos2-1)
            pos1 = string.find(data, "class:"); pos2 = string.find(data, ",", pos1)
            local class = string.sub(data, pos1+6, pos2-1)
            table.insert(players, {id = totalIDs + 1, name = name, class = class})
            totalIDs = totalIDs + 1
        end
    end

    local npcsPos1 = string.find(str, "NPCData{"); local npcsPos2 = string.find(str, "}")
    local npcsData = string.sub(str, npcsPos1, npcsPos2)
    str = string.sub(str, playerPos1, playerPos2)
    npcsData = StringUtils.split(npcsData, "|")
    for _, data in pairs(npcsData) do
        if not string.find(data, "NPCData{") then
            local pos1, pos2
            pos1 = string.find(data, "id:"); pos2 = string.find(data, ",", pos1)
            local _ = tonumber(string.sub(data, pos1+3, pos2-1))
            pos1 = string.find(data, "name:"); pos2 = string.find(data, ",", pos1)
            local name = string.sub(data, pos1+5, pos2-1)
            pos1 = string.find(data, "class:"); pos2 = string.find(data, ",", pos1)
            local class = string.sub(data, pos1+6, pos2-1)
            table.insert(npcs, {id = totalIDs + 1, name = name, class = class})
            totalIDs = totalIDs + 1
        end
    end

    file:close()
    return players, npcs, totalIDs
end

function RPGInitiativeMenu.createMenu()
    os.execute("cls")
    io.write(string.format("\n\nWelcome to RPGInitiative!\n\n"))
    io.write(string.format("1. Start game\n2. Load from file\n"))
    io.write(string.format("3. Save to file\n4. Quit"))
    io.write(string.format("\nPlease select your option: "))

    local option = io.stdin:read("*n")
    if option > 4 or option < 1 then option = 5 end
    return options[option]
end

------------------ Returning file for 'require' ------------------
return RPGInitiativeMenu