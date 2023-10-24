----------------------------------------------------------------------------------------------
--- RPGInitiative
--- author: peteR_pg
--- Steam profile: https://steamcommunity.com/id/peter_pg/
--- GitHub Repository: https://github.com/Susjin/RPGInitiative

--- Main file with all functions related to PLACEHOLDER
--- @class ListUtils
--- @field first number
--- @field last number
--- @field current boolean
local ListUtils = {}
----------------------------------------------------------------------------------------------

function ListUtils:pushLeft(value)
    local first = self.first - 1
    self.first = first
    self[first] = value
end

function ListUtils:pushRight(value)
    local last = self.last + 1
    self.last = last
    self[last] = value
end

function ListUtils:popLeft()
    local first = self.first
    if first > self.last then error("list is empty") end
    local value = self[first]
    self[first] = nil        -- to allow garbage collection
    self.first = first + 1
    return value
end

function ListUtils:popRight()
    local last = self.last
    if self.first > last then error("list is empty") end
    local value = self[last]
    self[last] = nil         -- to allow garbage collection
    self.last = last - 1
    return value
end

function ListUtils:peekLeft()
    return self[self.first]
end

function ListUtils:peekRight()
    return self[self.last]
end

function ListUtils:wipe()
    self = ListUtils:new()
end

function ListUtils:length()
    return (self.last - self.first) + 1
end

function ListUtils:empty()
    return self:length() == 0
end

function ListUtils:new ()
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.first = 0
    o.last = -1
    o.current = false
    return o
end


------------------ Returning file for 'require' ------------------
return ListUtils