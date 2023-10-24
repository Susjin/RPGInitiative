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
    "addPlayer",
    "removePlayer",
    "addNPC",
    "removeNPC",
    "back",
    "wrong"
}

---printOrder
---@param playerTable table
---@param NPCTable table
---@param list1 ListUtils
---@param list2 ListUtils
function RPGInitiativeGame.printOrder(playerTable, NPCTable, list1, list2)
    --Checking current list to peek
    local currentID
    if list1.current == true then currentID = list1:peekRight() end
    if list2.current == true then currentID = list2:peekLeft() end
    if list1:empty() and list2:empty() then currentID = 0 end

    --Getting all players list
    local total = {}
    for _, data in pairs(playerTable) do table.insert(total, {id = data.id, name = data.name, class = data.class}) end
    for _, data in pairs(NPCTable) do table.insert(total, {id = data.id, name = data.name, class = data.class}) end

    --Printing
    os.execute("cls")
    io.write(string.format("----------- Turn order -----------\n\n"))
    for _, char in pairs(total) do
        if char.id == currentID then io.write(string.format(">>> %s --Class: %s\n"))
         else io.write(string.format("    %s --Class: %s\n"))
        end
    end
    io.write(string.format("\n"))
end

function RPGInitiativeGame.doMenu()
    io.write(string.format("\n\nGame Started!\n\n"))
    io.write(string.format("1. Roll Initiative\n2. Calculate order\n3. Pass turn\n"))
    io.write(string.format("4. Add player\n5. Remove Player\n6. Add NPC\n7. Remove NPC\n"))
    io.write(string.format("8. Reset rolls. 9. Go back"))
    io.write(string.format("\nPlease select your option: "))

    local option = io.read("*n")
    if option > 7 or option < 1 then option = 8 end
    return options[option]
end

function RPGInitiativeGame.rollInitiative(playerTable, NPCTable)
    if #playerTable > 0 then
        for _, player in pairs(playerTable) do
            if player.roll == nil then
                io.write(string.format("Set roll value for player %s: ", player.name))
                player.roll = io.read("*n")
            end
        end
    end
    if #NPCTable > 0 then
        for _, npc in pairs(NPCTable) do
            if npc.roll == nil then
                io.write(string.format("Set roll value for NPC %s: ", npc.name))
                npc.roll = io.read("*n")
            end
        end
    end
end

---calculateOrder
---@param playerTable table
---@param NPCTable table
---@param list1 ListUtils
function RPGInitiativeGame.calculateOrder(playerTable, NPCTable, list1)
    list1:wipe()
    local total = {}
    for _, data in pairs(playerTable) do table.insert(total, {id = data.id, roll = data.roll}) end
    for _, data in pairs(NPCTable) do table.insert(total, {id = data.id, roll = data.roll}) end

    while #total > 0 do
        local minor = 30
        local minorPos = 0
        for i=1, #total do
            if total[i].roll < minor then minor = total[i].roll; minorPos = i end
        end
        list1:pushRight(total[minorPos].id)
        table.remove(total, minorPos)
    end
    list1.current = true
end

---passTurn
---@param list1 ListUtils
---@param list2 ListUtils
function RPGInitiativeGame.passTurn(list1, list2)
    if list1.current == true then
        list2:pushRight(list1:popRight())
        if list1:length() < 1 then list1.current = false; list2.current = true; end
    end
    if list2.current == true then
        list1:pushLeft(list2:popLeft())
        if list2:length() < 1 then list2.current = false; list1.current = true; end
    end
end

function RPGInitiativeGame.addPlayer(playerTable, totalIDs)
    os.execute("cls")
    local player = {}

    io.write(string.format("\n\n----------- Insert player information -----------\n\n"))
    io.write(string.format("Name: ")); player.name = io.stdin:read()
    io.write(string.format("Class: ")); player.class = io.stdin:read()
    io.write(string.format("Player ID will be %d. Press any key to continue...", totalIDs+1)); io.stdin:read(); player.id = totalIDs+1

    table.insert(playerTable, player)
end

function RPGInitiativeGame.removePlayer(playerTable)
    os.execute("cls")
    local name, foundPos = 0

    repeat
        io.write(string.format("\n\n----------- Insert player's name for removal -----------\n\n"))
        io.write(string.format("Name: ")); name = io.stdin:read()
        for i, player in pairs(playerTable) do
            if player.name == name then foundPos = i; break; end
        end
    until foundPos > 0
    io.write(string.format("Player %s will be removed. Press any key to continue...", name)); io.stdin:read()

    table.remove(playerTable, foundPos)
end

function RPGInitiativeGame.addNPC(NPCTable, totalIDs)
    os.execute("cls")
    local npc = {}

    io.write(string.format("\n\n----------- Insert NPC information -----------\n\n"))
    io.write(string.format("Name: ")); npc.name = io.stdin:read()
    io.write(string.format("Class: ")); npc.class = io.stdin:read()
    io.write(string.format("NPC ID will be %d. Press any key to continue...", totalIDs+1)); io.stdin:read(); npc.id = totalIDs+1

    table.insert(NPCTable, npc)
end

function RPGInitiativeGame.removeNPC(NPCTable)
    os.execute("cls")
    local name, foundPos = 0

    repeat
        io.write(string.format("\n\n----------- Insert NPC's name for removal -----------\n\n"))
        io.write(string.format("Name: ")); name = io.stdin:read()
        for i, npc in pairs(NPCTable) do
            if npc.name == name then foundPos = i; break; end
        end
    until foundPos > 0
    io.write(string.format("NPC %s will be removed. Press any key to continue...", name)); io.stdin:read()

    table.remove(NPCTable, foundPos)
end

function RPGInitiativeGame.resetRolls(playerTable, NPCTable)
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
end

------------------ Returning file for 'require' ------------------
return RPGInitiativeGame