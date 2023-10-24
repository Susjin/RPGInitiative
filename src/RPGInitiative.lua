----------------------------------------------------------------------------------------------
--- RPGInitiative
--- author: peteR_pg
--- Steam profile: https://steamcommunity.com/id/peter_pg/
--- GitHub Repository: https://github.com/Susjin/RPGInitiative

--- Main file with all functions related to PLACEHOLDER
--- @class RPGInitiative
--- @field playerCharacters Character[]
--- @field npcCharacters Character[]
--- @field list1 ListUtils
--- @field list2 ListUtils
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
local Lists = require "ListUtils"

local pairs = pairs



function RPGInitiative:menuActions()
    local option
    repeat
        option = Menu.createMenu()
        if option == "start" then

        elseif option == "saveAll" then

        elseif option == "loadAll" then

        elseif option == "back" then

        end
    until option == "quit"
    os.exit()
end

function RPGInitiative:inGameActions()
    local option
    repeat
        option = Game.doMenu()
        if option == "roll" then

        elseif option == "calculate" then

        elseif option == "addPlayer" then

        elseif option == "removePlayer" then

        elseif option == "addNPC" then

        elseif option == "removeNPC" then

        elseif option == "wrong" then

        end
    until option == "back"
end

function RPGInitiative:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.playerCharacters = {}
    o.npcCharacters = {}
    o.list1 = Lists:new()
    o.list2 = Lists:new()

    return o
end

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