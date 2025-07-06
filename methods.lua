local json = require("json")


local TaskUtils = {}


function TaskUtils.loadJSON(fileName)
    local file = assert(io.open(fileName, "r"))
    local content = file:read("*a")
    file:close()
    return json.decode(content)
end

function TaskUtils.saveJSON(fileName, data)
    local file = assert(io.open(fileName, "w"))
    file:write(json.encode(data))
    file:close()
end


function TaskUtils.showMenu()
    local answer = tonumber(io.read("*l"))
    while (answer < 1 or answer > 4) and answer ~= 99 do
        print("Digite uma resposta valida.")
        answer = tonumber(io.read("*l"))
    end
    return answer
end


function TaskUtils.newTask()
    print("Escreva as informações do compromisso que deseja criar ou digite -1 se o compromisso não contê-las.")
    print("Digite o titulo do compromisso:")
    local title = io.read("*l")
    print("Digite a descriçao do compromisso:")
    local description = io.read("*l")
    print("Digite a data do compromisso:")
    local date = nil
    repeat
        print("Digite a data no formato DD/MM/AAAA:")
        date = io.read()
    until date:match("^%d%d/%d%d/%d%d%d%d$")
    return {_title = title, _description = description, _date = date}
end


function TaskUtils.verifyTask(task)
    if task._title == "-1" then task._title = "Sem titulo" end
    if task._description == "-1" then task._description = "Sem descriçao" end
    if task._date == "-1" then task._date = "Sem data" end
    return task
end


function TaskUtils.encodeDate(date)
    local day, month, year = date:match("(%d%d)/(%d%d)/(%d%d%d%d)")
    return tonumber(year..month..day)
end

function TaskUtils.decodeDate(number)
    local str = tostring(number)
    local year = str:sub(1, 4)
    local month = str:sub(5, 6)
    local day = str:sub(7, 8)
    return string.format("%s/%s/%s", day, month, year)
end


function TaskUtils.orderTasks(task_list)
    table.sort(task_list, function(a, b) return a._date < b._date end)
end


function TaskUtils.verifyCondition(condition)
    return function(inp, exp)
        if condition(inp,exp) then return true
        else return false end
    end
end


function TaskUtils.editData(list, ID)
    print("O que deseja editar? (titulo | descricao | data | cancelar)")
    local answer = io.read("*l")
    while answer ~= "titulo" and answer ~= "descricao" and answer ~= "data" and answer ~= "cancelar" do
        print("Responda apenas com as opçoes dadas (titulo | descriçao | data | cancelar)")
        answer = io.read("*l")
    end

    local condition = TaskUtils.verifyCondition(function(inp, exp) return string.lower(inp) == exp end)

    local value = nil
    if condition(answer, "titulo") then
        print("Digite o novo titulo:")
        value = io.read("*l")
        list[ID]._title = value
    elseif condition(answer, "descricao") then
        print("Digite anvoa descriçao:")
        value = io.read("*l")
        list[ID]._description = value
    elseif condition(answer, "data") then
        print("Digite a nova data.")
        repeat
            print("Utilize o formato DD/MM/AAAA:")
            value = io.read()
        until value:match("^%d%d/%d%d/%d%d%d%d$")
        list[ID]._date = TaskUtils.encodeDate(value)
    end
end


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

-- MAIN.LUA OPTIONS METHODS

function TaskUtils.createTask(task_list)
    local task = TaskUtils.verifyTask(TaskUtils.newTask())
    task._date = TaskUtils.encodeDate(task._date)
    table.insert(task_list, task)
    print()
    print("Compromisso criado com sucesso!")
    print()
    TaskUtils.saveJSON("db.json", task_list)
end


function TaskUtils.viewTasks(task_list, id_Option)
    if id_Option == nil then id_Option = false end
    if #task_list > 0 then
        if id_Option == true then
            for i, task in ipairs(task_list) do
                print("Id: "..i)
                print(task._title)
                print(task._description)
                print(TaskUtils.decodeDate(task._date))
                print()
            end
        else
            for i, task in ipairs(task_list) do
                print(task._title)
                print(task._description)
                print(TaskUtils.decodeDate(task._date))
                print()
            end
        end
    else
        print("Nenhum compromisso cadastrado na sua listagem.")
    end
end


function TaskUtils.editTask(task_list)
    TaskUtils.viewTasks(task_list, true)
    local taskID = nil
    repeat
        print("Selecione o ID da task deseja editar.")
        taskID = tonumber(io.read("*l"))
    until
        taskID > 0 and taskID <= #task_list
    TaskUtils.viewTasks({task_list[taskID]})
    TaskUtils.editData(task_list, taskID)
end


function TaskUtils.cancelTask(task_list)
    TaskUtils.viewTasks(task_list, true)
    print("Digite o ID do compromisso que deseja cancelar (ou digite 'A' para cancelar todos)")
    local answer = io.read("*l")
    if string.lower(answer) == "a" then
        for i=#task_list, 0, -1 do
            table.remove(task_list, i)
        end
    else
        table.remove(task_list, answer)
    end
end


return TaskUtils