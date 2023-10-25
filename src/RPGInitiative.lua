----------------------------------------------------------------------------------------------
--- RPGInitiative
--- author: peteR_pg
--- Steam profile: https://steamcommunity.com/id/peter_pg/
--- GitHub Repository: https://github.com/Susjin/RPGInitiative

--- Main file with all functions related to PLACEHOLDER
--- @class RPGInitiative
--- @field playerCharacters Character[]
--- @field npcCharacters Character[]
--- @field list1 ListAPI
--- @field list2 ListAPI
--- @field totalIDs number
local RPGInitiative = {}
----------------------------------------------------------------------------------------------
--Setting up classes
--- @class Character The base character class
--- @field id number ID of the character
--- @field name string Name of the character
--- @field class string Class of the character
--- @field roll number Roll value of the character

--Setting up locals
local Menu = require "RPGInitiativeMenu"
local Game = require "RPGInitiativeGame"
local ListAPI = require "api.ListAPI"

local clock = os.clock

---Sleeps the program
---@param n number Seconds to sleep
local function sleep(n)
    local t0 = clock()
    local t
    while clock() - t0 <= n do t=1 end
end


function RPGInitiative:menuActions()
    local option
    repeat
        option = Menu.createMenu()
        if option == "start" then
            self:inGameActions()
        elseif option == "saveAll" then
            Menu.saveAll(self.playerCharacters, self.npcCharacters)
            io.stdout:write(string.format("\nFully saved all characters!"))
            sleep(1)
        elseif option == "loadAll" then
            self.playerCharacters, self.npcCharacters, self.totalIDs = Menu.loadAll()
            io.stdout:write(string.format("\nFully loaded all characters!"))
            sleep(1)
        elseif option == "wrong" then
            io.stdout:write(string.format("\nWrong option!"))
            sleep(1)
        end
    until option == "quit"
    os.exit()
end

function RPGInitiative:inGameActions()
    local option
    repeat
        Game.printOrder(self.playerCharacters, self.npcCharacters, self.list1, self.list2)
        option = Game.doMenu()
        if option == "roll" then
            Game.rollInitiative(self.playerCharacters, self.npcCharacters)
            io.stdout:write(string.format("\nCharacter rolls added!"))
            sleep(1)
        elseif option == "calculate" then
            Game.calculateOrder(self.playerCharacters, self.npcCharacters, self.list1)
            io.stdout:write(string.format("\nPlay Turn order calculated!"))
            sleep(1)
        elseif option == "pass" then
            Game.passTurn(self.list1, self.list2)
            io.stdout:write(string.format("\nPlay Turn passed!"))
        elseif option == "addPlayer" then
            Game.addPlayer(self.playerCharacters, self.totalIDs)
            io.stdout:write(string.format("\nPlayer added!"))
            sleep(1)
        elseif option == "removePlayer" then
            Game.removePlayer(self.playerCharacters)
            io.stdout:write(string.format("\nPlayer removed!"))
            sleep(1)
        elseif option == "addNPC" then
            Game.addNPC(self.npcCharacters, self.totalIDs)
            io.stdout:write(string.format("\nNPC added!"))
            sleep(1)
        elseif option == "removeNPC" then
            Game.removeNPC(self.npcCharacters)
            io.stdout:write(string.format("\nNPC removed!"))
            sleep(1)
        elseif option == "reset" then
            self.list1, self.list2 = Game.resetRolls(self.playerCharacters, self.npcCharacters, self.list1, self.list2)
            io.stdout:write(string.format("\nRolls cleared!"))
            sleep(1)
        elseif option == "wrong" then
            io.stdout:write(string.format("\nWrong option!"))
            sleep(1)
        end
    until option == "back"
end

function RPGInitiative:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.playerCharacters = {}
    o.npcCharacters = {}
    o.list1 = ListAPI:new()
    o.list2 = ListAPI:new()

    return o
end



io.stdout:setvbuf('no')
local game = RPGInitiative:new()
game:menuActions()










--[[Menu.saveAll({{name = "Jake Holt", class = "Shooter"}, {name = "Mando Christmas", class = "Thief"}, {name = "Jihen Crown", class = "Medic"}}, {{name = "Naga", class = "Boss"}})
print("writted")
local tbl1, tbl2 = Menu.loadAll()

for i, player in pairs(tbl1) do
    print(string.format("ID: %d\nName: %s\nClass: %s\n\n", i, player.name, player.class))
end

for i, npc in pairs(tbl2) do
    print(string.format("ID: %d\nName: %s\nClass: %s\n\n", i, npc.name, npc.class))
end]]

--io.stdout:setvbuf('no')
--RPGInitiative:MenuActions()

------------------ Returning file for 'require' ------------------
--return RPGInitiative