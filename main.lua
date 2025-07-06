_G.TaskUtils = require("methods")
local task_list = TaskUtils.loadJSON("db.json")

print("Bem-vindo ao sistema de tarefas.")
while true do
    print([[O que deseja fazer?
1 - Criar novo compromisso.
2 - Mostrar compromisso existentes.
3 - Editar compromisso.
4 - Cancelar compromisso.
99 - Sair.]])

    local answer = TaskUtils.showMenu()

    if answer == 1 then
        TaskUtils.createTask(task_list)
        TaskUtils.orderTasks(task_list)

    elseif answer == 2 then
        TaskUtils.viewTasks(task_list, true)

    elseif answer == 3 then
        TaskUtils.editTask(task_list)
        TaskUtils.orderTasks(task_list)

    elseif answer == 4 then
        TaskUtils.cancelTask(task_list)

    elseif answer == 99 then
        TaskUtils.saveJSON("db.json", task_list)
        break
    end
end
