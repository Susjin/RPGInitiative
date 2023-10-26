----------------------------------------------------------------------------------------------
--- RPGInitiative
--- author: peteR_pg
--- Steam profile: https://steamcommunity.com/id/peter_pg/
--- GitHub Repository: https://github.com/Susjin/RPGInitiative

--- Main file with all functions related to PLACEHOLDER
--- @class RPGInitiativeGame
local RPGInitiativeGame = {}
----------------------------------------------------------------------------------------------
--Setting up locals
local pairs = pairs

local options = {
    "roll",
    "calculate",
    "pass",
    "endFight",
    "addPlayer",
    "removePlayer",
    "addNPC",
    "removeNPC",
    "back",
    "wrong"
}

function RPGInitiativeGame.printListTable(listTable, tableName)
    io.stdout:write(string.format("%s: {\n", tableName))
    for i , id in pairs(listTable) do
        io.stdout:write(string.format("\t'%s': %s,\n", tostring(i), tostring(id)))
    end
    io.stdout:write(string.format("}\n\n"))
end

function RPGInitiativeGame.printCharacterTable(charTable, tableName)
    io.stdout:write(string.format("%s: {\n", tableName))
    for i , char in pairs(charTable) do
        io.stdout:write(string.format("\t'%d': {\n", i))
        for j, data in pairs(char) do
            io.stdout:write(string.format("\t\t'%s': %s,\n", j, data))
        end
        io.stdout:write(string.format("\t}\n"))
    end
    io.stdout:write(string.format("}\n\n"))
end

---Prints the play turn table with current character turn
---@param playerTable Character[]
---@param NPCTable Character[]
---@param list1 ListAPI
---@param list2 ListAPI
function RPGInitiativeGame.printOrder(playerTable, NPCTable, list1, list2)
    --Checking current list to peek
    local currentID = RPGInitiativeGame.getCurrentTurn(list1, list2)

    --Getting all players list
    local total = {}
    for _, data in pairs(playerTable) do table.insert(total, {id = data.id, name = data.name, class = data.class, roll = data.roll or 0, type = " Player"}) end
    for _, data in pairs(NPCTable) do table.insert(total, {id = data.id, name = data.name, class = data.class, roll = data.roll or 0, type = " NPC   "}) end

    --Printing
    os.execute("cls")
    io.stdout:write(string.format("\n----------- Turn order -----------\n\n"))
    for _, char in pairs(total) do
        if char.id == currentID then
            io.stdout:write(string.format(">>> %s", char.name))
            for _=1, 20-string.len(char.name) do io.stdout:write(" ") end
        else
            io.stdout:write(string.format("    %s", char.name))
            for _=1, 20-string.len(char.name) do io.stdout:write(" ") end
        end
        io.stdout:write(string.format(" %s | Roll: %02d | Class: %s\n", char.type, char.roll, char.class))
    end
    io.stdout:write(string.format("\n"))
end

---Creates the Menu for the game started
---@return string Option selected
function RPGInitiativeGame.doMenu()
    --Printing menu
    io.stdout:write(string.format("\n----------- Game Started! -----------\n\n"))
    io.stdout:write(string.format("1. Roll Initiative\n2. Calculate order\n3. Pass turn\n"))
    io.stdout:write(string.format("4. Finish encounter\n5. Add player\n6. Remove Player\n"))
    io.stdout:write(string.format("7. Add NPC\n8. Remove NPC\n9. Go back"))
    io.stdout:write(string.format("\nPlease select your option: "))

    --Reading selection
    local option = io.stdin:read("*n")
    if option > 9 or option < 1 then option = 10 end
    return options[option]
end

---Sets the roll for each character on all tables
---@param playerTable Character[]
---@param NPCTable Character[]
function RPGInitiativeGame.rollInitiative(playerTable, NPCTable)
    --Setting roll for players
    if #playerTable > 0 then
        for _, player in pairs(playerTable) do
            if player.roll == nil then
                io.stdout:write(string.format("Set roll value for Player %s: ", player.name))
                player.roll = io.read("*n")
            end
        end
    end
    --Setting rolls for NPCs
    if #NPCTable > 0 then
        for _, npc in pairs(NPCTable) do
            if npc.roll == nil then
                io.stdout:write(string.format("Set roll value for NPC %s: ", npc.name))
                npc.roll = io.read("*n")
            end
        end
    end
end

---Calculate the order of play turns
---@param playerTable Character[]
---@param NPCTable Character[]
---@param list1 ListAPI
---@param list2 ListAPI
function RPGInitiativeGame.calculateOrder(playerTable, NPCTable, list1, list2)
    --Merging characters tables
    local total = {}
    for _, data in pairs(playerTable) do table.insert(total, {id = data.id, name = data.name, roll = data.roll}) end
    for _, data in pairs(NPCTable) do table.insert(total, {id = data.id, name = data.name, roll = data.roll}) end

    --Wiping old lists
    local currentID = 0
    if not (list1:empty() and list2:empty()) then
        local found = false
        currentID = RPGInitiativeGame.getCurrentTurn(list1, list2)
        for _, data in pairs(total) do
            if data.id == currentID then
                found = true
                break
            end
        end
        if not found then
            RPGInitiativeGame.passTurn(list1, list2)
            currentID = RPGInitiativeGame.getCurrentTurn(list1, list2)
        end
    end
    list1:wipe()
    list2:wipe()

    --Calculating each character turn
    while #total > 0 do
        local minor = 99
        local minorPos = 0
        for i, char in pairs(total) do
            if char.roll < minor then
                minor = char.roll
                minorPos = i
            --If the roll is the same, ask who is first
            elseif char.roll == minor then
                io.stdout:write(string.format("Characters %s and %s have the same roll, who is first?\n", char.name, total[minorPos].name))
                io.stdout:write(string.format("1. %s | 2. %s - ", char.name, total[minorPos].name))
                local select
                repeat
                    select = io.stdin:read("*n")
                    if select == 2 then minor = char.roll; minorPos = i end
                until (select == 1) or (select == 2)
            end
        end
        list1:pushRight(total[minorPos].id)
        table.remove(total, minorPos)
    end
    --Setting the starting list
    list1.current = true

    if currentID > 0 then
        while (RPGInitiativeGame.getCurrentTurn(list1, list2) ~= currentID) do
            RPGInitiativeGame.passTurn(list1, list2)
        end
    end
end

---Pass the play turn to the next character
---@param list1 ListAPI
---@param list2 ListAPI
function RPGInitiativeGame.passTurn(list1, list2)
    --Checking what is the currently list
    if list1.current == true then
        list2:pushRight(list1:popRight())
        --Switching currently list if empty
        if list1:empty() then list1.current = false; list2.current = true; end
    elseif list2.current == true then
        list1:pushLeft(list2:popLeft())
        --Switching currently list if empty
        if list2:empty() then list2.current = false; list1.current = true; end
    end
end

---Clear all character rolls from the tables and wipes all lists
---@param playerTable Character[]
---@param NPCTable Character[]
---@param list1 ListAPI
---@param list2 ListAPI
function RPGInitiativeGame.finishFight(playerTable, NPCTable, list1, list2)
    if #playerTable > 0 then
        for _, player in pairs(playerTable) do
            player.roll = nil
        end
    end
    if #NPCTable > 0 then
        for _, npc in pairs(NPCTable) do
            npc.roll = nil
        end
    end
    list1:wipe()
    list2:wipe()
    return list1, list2
end

---Adds a Player to the Player characters table
---@param playerTable Character[]
---@param totalIDs number
function RPGInitiativeGame.addPlayer(playerTable, totalIDs)
    os.execute("cls")
    local player = {}

    --Program is eating one read for some random reason
    io.stdin:read()

    io.stdout:write(string.format("\n----------- Insert player information | Insert 'cancel' to end operation -----------\n"))
    io.stdout:write(string.format("Name: "))
    player.name = io.stdin:read()
    io.stdout:write(string.format("Class: "))
    player.class = io.stdin:read()
    if (player.name == 'cancel') or (player.class == 'cancel') then return false end
    io.stdout:write(string.format("Player ID will be %d. Press any key to continue...", totalIDs+1)); io.stdin:read(); player.id = totalIDs+1

    table.insert(playerTable, player)
    return true
end

---Removes a Player from the Player characters table
---@param playerTable Character[]
---@param NPCTable Character[]
---@param list1 ListAPI
---@param list2 ListAPI
function RPGInitiativeGame.removePlayer(playerTable, NPCTable, list1, list2)
    local id; local foundPos = 0

    --Repeat until player name is found, avoid errors when inserting wrong name
    repeat
        os.execute("cls")
        io.stdout:write(string.format("\n----------- Current players list -----------\n"))
        for _, player in pairs(playerTable) do
            io.stdout:write(string.format("%d. %s\n", player.id, player.name))
        end
        io.stdout:write(string.format("\n----------- Insert player's ID for removal | Insert '0' to end operation -----------\n"))
        io.stdout:write(string.format("ID: ")); id = tonumber(io.stdin:read())
        if id == 0 then break end
        for i, player in pairs(playerTable) do
            if player.id == id then foundPos = i; break; end
        end
    until foundPos > 0
    if id == 0 then return false end

    io.stdout:write(string.format("Player %s will be removed. Press any key to continue...", playerTable[foundPos].name)); io.stdin:read()
    table.remove(playerTable, foundPos)
    if not (list1:empty() and list2:empty()) then RPGInitiativeGame.calculateOrder(playerTable, NPCTable, list1, list2) end
    return true
end

---Adds a NPC to the NPC characters table
---@param NPCTable Character[]
---@param totalIDs number
function RPGInitiativeGame.addNPC(NPCTable, totalIDs)
    os.execute("cls")
    local npc = {}

    --Program is eating one read for some random reason
    io.stdin:read()

    io.stdout:write(string.format("\n----------- Insert NPC information | Insert 'cancel' to end operation -----------\n"))
    io.stdout:write(string.format("Name: ")); npc.name = io.stdin:read()
    io.stdout:write(string.format("Class: ")); npc.class = io.stdin:read()
    if (npc.name == 'cancel') or (npc.class == 'cancel') then return false end
    io.stdout:write(string.format("NPC ID will be %d. Press any key to continue...", totalIDs+1)); io.stdin:read(); npc.id = totalIDs+1

    table.insert(NPCTable, npc)
    return true
end

---Removes a NPC from the NPC characters table
---@param playerTable Character[]
---@param NPCTable Character[]
---@param list1 ListAPI
---@param list2 ListAPI
function RPGInitiativeGame.removeNPC(playerTable, NPCTable, list1, list2)
    local id; local foundPos = 0

    --Repeat until npc name is found, avoid errors when inserting wrong name
    repeat
        os.execute("cls")
        io.stdout:write(string.format("\n----------- Current NPCs list -----------\n"))
        for _, npc in pairs(NPCTable) do
            io.stdout:write(string.format("%d. %s\n", npc.id, npc.name))
        end

        io.stdout:write(string.format("\n----------- Insert NPC's ID for removal | Insert '0' to end operation -----------\n"))
        io.stdout:write(string.format("ID: ")); id = tonumber(io.stdin:read())
        if id == '0' then return false end
        for i, npc in pairs(NPCTable) do
            if npc.id == id then foundPos = i; break; end
        end
    until foundPos > 0

    io.stdout:write(string.format("NPC %s will be removed. Press any key to continue...", NPCTable[foundPos].name)); io.stdin:read()
    table.remove(NPCTable, foundPos)
    if not (list1:empty() and list2:empty()) then RPGInitiativeGame.calculateOrder(playerTable, NPCTable, list1, list2) end
    return true
end

function RPGInitiativeGame.getCurrentTurn(list1, list2)
    local currentID
    if list1.current == true then currentID = list1:peekRight()
    elseif list2.current == true then currentID = list2:peekLeft() end
    if list1:empty() and list2:empty() then currentID = 0 end
    return currentID
end

------------------ Returning file for 'require' ------------------
return RPGInitiativeGame