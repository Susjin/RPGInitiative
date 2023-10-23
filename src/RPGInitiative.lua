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

local pairs = pairs

function RPGInitiative:MenuActions()
    ::start::
    local option = Menu.createMenu()

    if option == "start" then

    elseif option == "savePlayers" then

    elseif option == "loadPlayers" then

    elseif option == "saveAll" then

    elseif option == "loadAll" then

    elseif option == "quit" then
        os.exit()
    elseif option == "wrong" then
        goto start
    end
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

------------------ Returning file for 'require' ------------------
return RPGInitiative