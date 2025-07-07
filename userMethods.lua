local json = require("json")


-- "Users" methods refer to the list of users.
Users = {}
Users.__index = Users


-- Creates a new table that will contain every user.
function Users:new(initial_data)
    local instance = setmetatable(initial_data or {}, Users)
    return instance
end


-- Adds a new user to the table.
function Users:add(user)
    table.insert(self, user)
end


-- Verifies wheter the user exists or not.
function Users:auth(username, psswd)
    for i, u in ipairs(self) do
        if u._name == username and u._psswd == psswd then
            return u, true
        end
    end
    return nil, false
end


-- Loading and saving the db.json file that stores data about every user.
function Users.loadJSON(fileName)
    local file = assert(io.open(fileName, "r"))
    local content = file:read("*a")
    file:close()
    return json.decode(content)
end

function Users.saveJSON(fileName, data)
    local file = assert(io.open(fileName, "w"))
    file:write(json.encode(data))
    file:close()
end


-- "User" methods refer to a single user's methods.
User = {}
User.__index = User


-- Creates a new user.
function User:new(username, psswd)
    local instance = setmetatable({}, User)
    instance._name = username
    instance._psswd = psswd
    instance._task_list = {}
    return instance
end


-- MAIN.LUA METHODS

function Users:createAccount()
    print("Digite um nome de usuario:")
    local name = io.read("*l")
    print("Digite a senha:")
    local psswd = io.read("*l")
    repeat
        print("Digite a mesma senha novamente:")
        local psswd_rep = io.read("*l")
    until psswd == psswd_rep
    return User:new(name, psswd)
end


function Users:login()
    local user, found = nil, true
    repeat
        if not found then
            print("Usuario ou senha incorretos, tente novamente.")
        end
        print("Digite seu nome de usuario:")
        local username = io.read("*l")
        print("Digite sua senha:")
        local psswd = io.read("*l")
        user, found = self:auth(username, psswd)
        until found

    return user
end


return Users, User