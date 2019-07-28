os.loadAPI("/rom/screen/functions.lua")
os.loadAPI("/rom/screen/utils.lua")

local function getConfig()
    return {
        monitor = {
            id = "monitor_0",
            height = 5,
            scale = 2,
            contentFile = "/disk/screen/monitor.txt"
        },
        monitorId = "monitor_0",
        monitorHeight = 5,
        monitorScale = 2,
        speakerId = "speaker_0",
        shell = shell
    }
end

local function getFunctions()
    return{
        [0] = {
            desc = "Eteindre l'ordinateur",
            fn = functions.shutdown
        },
        [1] = {
            desc = "Effacer le moniteur",
            fn = functions.clearMonitor
        },
        [2] = {
            desc = "Ecrire sur le moniteur",
            fn = functions.writeMonitor
        }
    }
end


local function printFunctions(functions)
    for k, v in pairs(functions) do
        utils.printC("&f", k, "&a : &f", v["desc"])
    end
end

local function selectFunction(functions)
    utils.printC("&aVeuillez choisir une action et appuyer sur ENTREE:")
    printFunctions(functions)
    local userInput = read()
    local index = tonumber(userInput)
    if index == nil then
        return nil
    end
    return functions[index]
end

local function main()
    functions = getFunctions()
    while(true) do
        utils.clearTerm()
        selected_function = selectFunction(functions)

        if(selected_function ~= nil) then
            utils.clearTerm()
            selected_function.fn(getConfig())
        else
            utils.printC("&4Cette action n'existe pas.")
        end

        utils.pressAnyKey()
    end
end

-- Begin script

main()