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

function RPGInitiativeGame.doMenu()
    print(string.format("Game Started!\n\n"))
    print(string.format("1. Roll Initiative\n2. Calculate order\n3. Skip turn\n"))
    print(string.format("4. Add player\n5. Remove Player\n6. Add NPC\n7. Remove NPC\n"))
    print(string.format("8. Reset rolls. 9. Go back"))
    print(string.format("\nPlease select your option: "))

    local option = io.read("*n")
    if option > 7 or option < 1 then option = 8 end
    return options[option]
end

function RPGInitiativeGame.rollInitiative(playerTable, NPCTable)
    if #playerTable > 0 then
        for _, player in pairs(playerTable) do
            io.write(string.format("Set roll value for player %s: ", player.name))
            player.roll = io.read("*n")
        end
    end
    if #NPCTable > 0 then
        for _, npc in pairs(NPCTable) do
            io.write(string.format("Set roll value for NPC %s: ", npc.name))
            npc.roll = io.read("*n")
        end
    end
end


------------------ Returning file for 'require' ------------------
return RPGInitiativeGame