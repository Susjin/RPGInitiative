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
local StringUtils = require "api.StringUtils"
local pairs = pairs


local options = {
    "start",
    "loadAll",
    "saveAll",
    "quit",
    "wrong"
}

---Creates the main menu for the program
---@return string Option selected
function RPGInitiativeMenu.createMenu()
    os.execute("cls")
    io.write(string.format("\n----------- Welcome to RPGInitiative! -----------\n\n"))
    io.write(string.format("1. Start game\n2. Load from file\n"))
    io.write(string.format("3. Save to file\n4. Quit"))
    io.write(string.format("\nPlease select your option: "))

    local option = io.stdin:read("*n")
    if option > 4 or option < 1 then option = 5 end
    return options[option]
end

---Saves all characters to a file
---@param playerTable Character[] Table with all players
---@param NPCTable Character[] Table with all NPCs
function RPGInitiativeMenu.saveAll(playerTable, NPCTable)
    --Program is eating one read for some random reason
    io.stdin:read()

    --Getting the filename from the user
    local file, filename
    repeat
        os.execute("cls")
        io.stdout:write(string.format("\n----------- Please specify the filename to save | Insert 'cancel' to end operation -----------\n\n"))
        io.stdout:write(string.format("Filename: ")); filename = io.stdin:read()
        if filename == 'cancel' then return end
        file = io.open(filename, "w")
    until file ~= nil

    io.stdout:write(string.format("\nSaving to file '%s'...", filename))
    sleep(1)
    file:write("playerData{")
    for _, player in pairs(playerTable) do
        file:write(string.format("|id:%d,name:%s,class:%s,", player.id, player.name, player.class))
    end
    file:write(string.format("}\n"))

    file:write("NPCData{")
    for _, npc in pairs(NPCTable) do
        file:write(string.format("|id:%d,name:%s,class:%s,", npc.id, npc.name, npc.class))
    end
    file:write("}")
    file:flush()
    file:close()

    io.stdout:write(string.format("\nSuccessfully saved to file '%s'!", filename))
    sleep(0.5)
end

---Loads all characters from the saved file
---@return Character[], Character[], number PlayerTable, NPCTable and the TotalIDS respectively
function RPGInitiativeMenu.loadAll()
    --Program is eating one read for some random reason
    io.stdin:read()

    --Getting the filename from the user
    local file, filename
    repeat
        os.execute("cls")
        io.stdout:write(string.format("\n----------- Please specify the filename to load | Insert 'cancel' to end operation -----------\n\n"))
        io.stdout:write(string.format("Filename: ")); filename = io.stdin:read()
        if filename == 'cancel' then return end
        file = io.open(filename, "r")
    until file ~= nil

    io.stdout:write(string.format("\nLoading from file '%s'...", filename))
    sleep(1)
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

    io.stdout:write(string.format("\nSuccessfully loaded from file '%s'!", filename))
    sleep(1)
    return players, npcs, totalIDs
end

------------------ Returning file for 'require' ------------------
return RPGInitiativeMenu