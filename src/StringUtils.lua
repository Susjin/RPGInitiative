----------------------------------------------------------------------------------------------
--- RPGInitiative
--- author: peteR_pg
--- Steam profile: https://steamcommunity.com/id/peter_pg/
--- GitHub Repository: https://github.com/Susjin/RPGInitiative

--- Main file with all functions related to PLACEHOLDER
--- @class StringUtils
local StringUtils = {}
----------------------------------------------------------------------------------------------

-- startWith java style !
StringUtils.stringStarts = function(String,Start)
    return string.sub(String, 1, string.len(Start)) == Start;
end

StringUtils.stringEnds = function(String, End)
    return String:sub(-End:len()) == End;
end

StringUtils.trim = function(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- split java style
StringUtils.split = function(pString, pPattern)
    local Table = {};
    local fpat = "(.-)" .. pPattern;
    local last_end = 1;
    local s, e, cap = pString:find(fpat, 1);
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(Table,cap);
        end
        last_end = e+1;
        s, e, cap = pString:find(fpat, last_end);
    end
    if last_end <= #pString then
        cap = pString:sub(last_end);
        table.insert(Table, cap);
    end
    return Table
end




------------------ Returning file for 'require' ------------------
return StringUtils