local checkcon = false

CreateThread(function()
    while not checkcon do
        if MySQL.ready then
            print("The database is ready")
            checkcon = true
        else
            print("Waiting for a database connection...")
        end
        Citizen.Wait(5000)
    end
end)

function wipebroni()
    local sqlStatements = {
        "UPDATE `users` SET inventory = REGEXP_REPLACE(inventory, '\"pistol_ammo\":%d+,?', '')",
        "UPDATE `users` SET inventory = REGEXP_REPLACE(inventory, '\"pistol\":%d+,?', '')",
        "UPDATE `users` SET inventory = REGEXP_REPLACE(inventory, '\"vintagepistol\":%d+,?', '')",
        "UPDATE `users` SET inventory = REPLACE(inventory, ',}', '}')",
        "DELETE FROM `addon_inventory_items` WHERE `name` IN ('pistol_ammo', 'pistol', 'vintagepistol')"
    }
    
    for i, statement in ipairs(sqlStatements) do
        MySQL.Async.execute(statement, {})
    end
end

RegisterCommand("wipebroni", function(source, args, rawCommand)
    if checkcon then
        wipebroni()
    else
         print("the database is not ready...")
    end
end, false)
