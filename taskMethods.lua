local userMethods = require("userMethods")


local TaskUtils = {}


local function contains(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

-- Creates a menu that returns the decisions of users on what to do next.
function TaskUtils.showMenu()
    local possibleAnswers = {"1", "2", "3", "4", "99"}
    local answer = io.read("*l")
    while not contains(possibleAnswers, answer) do
        print("Digite uma resposta valida.")
        answer = io.read("*l")
    end
    return answer
end


-- Verification of date consistency considering leap years, returning true if the date is valid or false if it is not.
function TaskUtils.valiDATE(date)
    local monthRelation = {
        31, -- january
        28, -- february
        31, -- march
        30, -- april
        31, -- may
        30, -- june
        31, -- july
        31, -- august
        30, -- september
        31, -- october
        30, -- november
        31 -- december
    }
    if type(date) ~= "string" then date = tostring(date) end
    if date == "-1" then return true end
    local leapYear = tonumber(date:sub(1, 4))%4 == 0
    local month = tonumber(date:sub(5, 6))
    local day = tonumber(date:sub(7, 8))

    local exceptionFebruary = leapYear and day == 29 and monthRelation[month] == 2

    if month < 1 or month > 12 then return false end
    if day > monthRelation[month] and not exceptionFebruary then return false end
    return true
end


-- Creation of a new task based on user's input.
function TaskUtils.newTask()
    print("Escreva as informações do compromisso que deseja criar ou apenas pressione Enter se o compromisso não contê-las.")
    print("Digite o titulo do compromisso:")
    local title = io.read("*l")
    print("Digite a descriçao do compromisso:")
    local description = io.read("*l")
    print("Digite a data do compromisso.")
    local date = nil
    repeat
        print("A data deve estar no formato DD/MM/AAAA:")
        date = io.read()
    until date:match("^%d%d/%d%d/%d%d%d%d$") and TaskUtils.valiDATE(TaskUtils.encodeDate(date)) or date == "-1"
    return {_title = title, _description = description, _date = date}
end


-- Substitutes every -1 with the message "Sem [...]".
function TaskUtils.verifyTask(task)
    if task._title == "" then task._title = "Sem titulo" end
    if task._description == "" then task._description = "Sem descriçao" end
    if task._date == "" then task._date = "Sem data" end
    return task
end


-- Returns a date in the form YYYYMMDD. If it has no date, the output is defined to 99999999
function TaskUtils.encodeDate(date)
    if date == "Sem data" then return 99999999 end
    local day, month, year = date:match("(%d%d)/(%d%d)/(%d%d%d%d)")
    return tonumber(year..month..day)
end

-- Returns a date in the form DD/MM/YYYY. If no date is defined, the output will be "Sem data"
function TaskUtils.decodeDate(number)
    if number == 99999999 then return "Sem data" end
    local str = tostring(number)
    local year = str:sub(1, 4)
    local month = str:sub(5, 6)
    local day = str:sub(7, 8)
    return string.format("%s/%s/%s", day, month, year)
end


-- Orders every task in chronological order.
function TaskUtils.orderTasks(task_list)
    table.sort(task_list, function(a, b) return a._date < b._date end)
end


-- Allows the creation of any two variable function. It was used to compare an input and an expected result (not needed at all, just testing my closure manipulation skills).
function TaskUtils.verifyCondition(condition)
    return function(inp, exp)
        if condition(inp,exp) then return true
        else return false end
    end
end


-- Edits the title, description or date of any specified task.
function TaskUtils.editData(task, ID)
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
        task[ID]._title = value
    elseif condition(answer, "descricao") then
        print("Digite anvoa descriçao:")
        value = io.read("*l")
        task[ID]._description = value
    elseif condition(answer, "data") then
        print("Digite a nova data.")
        repeat
            print("Utilize o formato DD/MM/AAAA:")
            value = io.read("*l")
        until value:match("%d%d/%d%d/%d%d%d%d") and TaskUtils.valiDATE(TaskUtils.encodeDate(value)) or value == "-1"
        task[ID]._date = TaskUtils.encodeDate(value)
    end
end


-- MAIN.LUA METHODS

function TaskUtils.createTask(task_list)
    local task = TaskUtils.verifyTask(TaskUtils.newTask())
    task._date = TaskUtils.encodeDate(task._date)
    table.insert(task_list, task)
    print()
    print("Compromisso criado com sucesso!")
    print()
end


function TaskUtils.viewTasks(task_list, id_Option)
    id_Option = id_Option or false
    if #task_list == 0 then
        print("Nenhum compromisso cadastrado na sua listagem.")
        print()
        return false
    end

    for i, task in ipairs(task_list) do
        if id_Option == true then print("Id: "..i) end
        print(task._title)
        print(task._description)
        print(TaskUtils.decodeDate(task._date))
        print()
    end
    return true
end


function TaskUtils.editTask(task_list)
    if not TaskUtils.viewTasks(task_list, true) then return end
    local taskID = nil
    repeat
        print("Selecione o ID da task deseja editar.")
        taskID = tonumber(io.read("*l"))
    until taskID > 0 and taskID <= #task_list
    TaskUtils.viewTasks({task_list[taskID]})
    TaskUtils.editData(task_list, taskID)
end


function TaskUtils.cancelTask(task_list)
    local qtd = TaskUtils.viewTasks(task_list, true) or true
    if qtd then
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
end


return TaskUtils