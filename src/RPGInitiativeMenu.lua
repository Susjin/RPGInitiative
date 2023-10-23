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
    "loadPlayers",
    "savePlayers",
    "loadAll",
    "saveAll",
    "quit",
    "wrong"
}

function RPGInitiativeMenu.savePlayers(playersTable)
    local file = io.open("text.txt", "w")
    file:write(string.format("playerData{"))
    for i, player in pairs(playersTable) do
        file:write(string.format("|id:%d,name:%s,class:%s", i, player.name, player.class))
    end
    file:write(string.format("}"))
    file:close()
end

function RPGInitiativeMenu.loadPlayers()
    local file = io.open("text.txt", "r")
    local str = file:read("*all")
    local players = {}

    local playerPos1 = string.find(str, "playerData{"); local playerPos2 = string.find(str, "}")
    local playerData = string.sub(str, playerPos1, playerPos2)
    str = string.sub(str, playerPos2+1, -1)
    playerData = StringUtils.split(playerData, "|")

    for _, data in pairs(playerData) do
        local pos1, pos2
        pos1, pos2 = string.find(data, "id:%d+,")
        local id = tonumber(string.sub(data, pos1+3, pos2))
        pos1, pos2 = string.find(data, "name:%l+,")
        local name = string.sub(data, pos1+5, pos2)
        pos1, pos2 = string.find(data, "class:%l+,")
        local class = string.sub(data, pos1+6, pos2)
        players[id] = {name = name, class = class}
    end

    file:close()
    return players
end

function RPGInitiativeMenu.saveAll(playersTable, npcsTable)
    local file = io.open("text.txt", "w")
    file:write(string.format("playerData:{"))
    for i, player in pairs(playersTable) do
        file:write(string.format("|id:%d,name:%s,class:%s", i, player.name, player.class))
    end
    file:write(string.format("}"))

    file:write(string.format("NPCData{"))
    for i, npc in pairs(npcsTable) do
        file:write(string.format("|id:%d,name:%s,class:%s", i, npc.name, npc.class))
    end
    file:write(string.format("}"))
    file:close()
end

function RPGInitiativeMenu.loadAll()
    local file = io.open("text.txt", "r")
    local str = file:read("*all")
    local players = {}
    local npcs = {}

    local playerPos1 = string.find(str, "playerData{"); local playerPos2 = string.find(str, "}")
    local playerData = string.sub(str, playerPos1, playerPos2)
    str = string.sub(str, playerPos2+1, -1)
    playerData = StringUtils.split(playerData, "|")
    for _, data in pairs(playerData) do
        local pos1, pos2
        pos1, pos2 = string.find(data, "id:%d+,")
        local id = tonumber(string.sub(data, pos1+3, pos2))
        pos1, pos2 = string.find(data, "name:%l+,")
        local name = string.sub(data, pos1+5, pos2)
        pos1, pos2 = string.find(data, "class:%l+,")
        local class = string.sub(data, pos1+6, pos2)
        players[id] = {name = name, class = class}
    end

    local npcsPos1 = string.find(str, "NPCData{"); local npcsPos2 = string.find(str, "}")
    local npcsData = string.sub(str, npcsPos1, npcsPos2)
    str = string.sub(str, playerPos1, playerPos2)
    npcsData = StringUtils.split(npcsData, "|")
    for _, data in pairs(npcsData) do
        local pos1, pos2
        pos1, pos2 = string.find(data, "id:%d+,")
        local id = tonumber(string.sub(data, pos1+3, pos2))
        pos1, pos2 = string.find(data, "name:%l+,")
        local name = string.sub(data, pos1+5, pos2)
        pos1, pos2 = string.find(data, "class:%l+,")
        local class = string.sub(data, pos1+6, pos2)
        npcs[id] = {name = name, class = class}
    end

    file:close()
    return players, npcs
end

function RPGInitiativeMenu.createMenu()
    print(string.format("Welcome to RPGInitiative!\n\n"))
    print(string.format("1. Start game\n2. Load players from file\n3. Save players to file"))
    print(string.format("4. Load players and NPCs from file\n5. Save players and NPCs to file\n6. Quit"))
    print(string.format("\nPlease select your option: "))

    local option = io.read("n")
    if option > 6 or option < 1 then option = 7 end
    return options[option]
end

------------------ Returning file for 'require' ------------------
return RPGInitiativeMenu