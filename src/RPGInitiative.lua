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
            Game.calculateOrder(self.playerCharacters, self.npcCharacters, self.list1, self.list2)
            io.stdout:write(string.format("\nPlay Turn order calculated!"))
            sleep(1)
        elseif option == "pass" then
            Game.passTurn(self.list1, self.list2)
            io.stdout:write(string.format("\nPlay Turn passed!"))
        elseif option == "endFight" then
            self.list1, self.list2 = Game.finishFight(self.playerCharacters, self.npcCharacters, self.list1, self.list2)
            io.stdout:write(string.format("\nThe fight is finished!"))
            sleep(1)
        elseif option == "addPlayer" then
            if Game.addPlayer(self.playerCharacters, self.totalIDs) then
                self.totalIDs = self.totalIDs + 1
            else
            io.stdout:write(string.format("\nCanceled!"))
            sleep(1)
            end
        elseif option == "removePlayer" then
            if not Game.removePlayer(self.playerCharacters, self.npcCharacters, self.list1, self.list2) then
                io.stdout:write(string.format("\nCanceled!"))
                sleep(1)
            end
        elseif option == "addNPC" then
            if Game.addNPC(self.npcCharacters, self.totalIDs) then
                self.totalIDs = self.totalIDs + 1
            else
            io.stdout:write(string.format("\nCanceled!"))
            sleep(1)
            end
        elseif option == "removeNPC" then
            if not Game.removeNPC(self.playerCharacters, self.npcCharacters, self.list1, self.list2) then
                io.stdout:write(string.format("\nCanceled!"))
                sleep(1)
            end
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
    o.totalIDs = 0
    o.list1 = ListAPI:new()
    o.list2 = ListAPI:new()

    return o
end



io.stdout:setvbuf('no')
io.stdin:setvbuf('no')
local game = RPGInitiative:new()
game:menuActions()




--TODO: List of names when removing
--TODO: Current roll of each character
--TODO: Type of character before class
--TODO:






------------------ Returning file for 'require' ------------------
--return RPGInitiative