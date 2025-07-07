_G.TaskUtils = require("taskMethods")
_G.userMethods = require("userMethods")

local usersTable = Users:new(userMethods.loadJSON("db.json"))

while true do
    local exit = false
    print([[Bem-vindo ao sistema de compromissos!
1 - Criar nova conta.
2 - Entrar em uma conta.
3 - Sair.]])
    local account_option
    repeat
        print("Digite o que deseja fazer:")
        account_option = io.read("*l")
    until account_option == "1" or account_option == "2" or account_option == "3"

    local user
    if account_option == "1" then
        usersTable:add(usersTable:createAccount())
    elseif account_option == "2" then
        user = usersTable:login()
    else
        exit = true
    end

    while not exit and user ~= nil do
        userMethods.saveJSON("db.json", usersTable)
        print("Bem vindo de volta, "..user._name.."!")
        print([[O que deseja fazer?
    1 - Criar novo compromisso.
    2 - Mostrar compromisso existentes.
    3 - Editar compromisso.
    4 - Cancelar compromisso.
    99 - Sair.]])

        local answer = TaskUtils.showMenu()

        if answer == 1 then
            TaskUtils.createTask(user._task_list)
            TaskUtils.orderTasks(user._task_list)

        elseif answer == 2 then
            TaskUtils.viewTasks(user._task_list, true)

        elseif answer == 3 then
            TaskUtils.editTask(user._task_list)
            TaskUtils.orderTasks(user._task_list)

        elseif answer == 4 then
            TaskUtils.cancelTask(user._task_list)

        elseif answer == 99 then
            userMethods.saveJSON("db.json", usersTable)
            break
        end
    end
    if exit then break end
end
print("PROGRAMA FINALIZADO.")