--[[
Users = {}
Users.__index = Users

function Users:new()
    local instance = setmetatable({}, Users)
    return instance
end

function Users:add(user)
    table.insert(Users, user)
end

function Users:auth(username, psswd)
    for v in ipairs(Users) do
        if v._name == username and v._psswd == psswd then
            return true
        end
    end
    return false
end
]]