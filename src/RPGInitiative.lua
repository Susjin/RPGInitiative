----------------------------------------------------------------------------------------------
--- RPGInitiative
--- author: peteR_pg
--- Steam profile: https://steamcommunity.com/id/peter_pg/
--- GitHub Repository: https://github.com/Susjin/RPGInitiative

--- Main file with all functions related to PLACEHOLDER
--- @class RPGInitiative
--- @field diceType string
--- @field playerCharacters table[]
--- @field npcCharacters table[]
--- @field orderList table
local RPGInitiative = {}
----------------------------------------------------------------------------------------------
--Setting up locals
local Menu = require "RPGInitiativeMenu"
local Lists = require "ListUtils"

local pairs = pairs

function RPGInitiative:MenuActions()
    local option

    repeat
        option = Menu.createMenu()
        if option == "start" then

        elseif option == "saveAll" then

        elseif option == "loadAll" then

        elseif option == "quit" then
            os.exit()
        end
    until option == "quit"
end

function RPGInitiative:new(diceType, playerCharacters, npcCharacters)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.diceType = diceType
    o.playerCharacters = playerCharacters or {}
    o.npcCharacters = npcCharacters or {}
    o.orderList = {}
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