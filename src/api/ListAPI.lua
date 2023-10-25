----------------------------------------------------------------------------------------------
--- RPGInitiative
--- author: peteR_pg
--- Steam profile: https://steamcommunity.com/id/peter_pg/
--- GitHub Repository: https://github.com/Susjin/RPGInitiative

--- Main file with all functions related to PLACEHOLDER
--- @class ListAPI
--- @field first number
--- @field last number
--- @field current boolean
local ListAPI = {}
----------------------------------------------------------------------------------------------

---Push a given value to the start on the list
---@param value any Value to be inserted
function ListAPI:pushLeft(value)
    local first = self.first - 1
    self.first = first
    self[first] = value
end

---Push a given value to the end of the list
---@param value any Value to be inserted
function ListAPI:pushRight(value)
    local last = self.last + 1
    self.last = last
    self[last] = value
end

---Removes the value on the start of the list
---@return any Value removed
function ListAPI:popLeft()
    local first = self.first
    if first > self.last then error("list is empty") end
    local value = self[first]
    self[first] = nil        -- to allow garbage collection
    self.first = first + 1
    return value
end

---Removes the value on the end of the list
---@return any Value removed
function ListAPI:popRight()
    local last = self.last
    if self.first > last then error("list is empty") end
    local value = self[last]
    self[last] = nil         -- to allow garbage collection
    self.last = last - 1
    return value
end

---Gets the value on the start of the list without removing it.
---@return any Value got
function ListAPI:peekLeft()
    return self[self.first]
end

---Gets the value on the end of the list without removing it.
---@return any Value got
function ListAPI:peekRight()
    return self[self.last]
end

---Clears the whole list
function ListAPI:wipe()
    self = ListAPI:new()
end

---Gets the current length of the list
---@return number Current length
function ListAPI:length()
    return (self.last - self.first) + 1
end

---Checks if the list is empty
---@return boolean True if empty, false if not
function ListAPI:empty()
    return self:length() == 0
end

---Creates a new list
---@return ListAPI
function ListAPI:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.first = 0
    o.last = -1
    o.current = false
    return o
end


------------------ Returning file for 'require' ------------------
return ListAPI