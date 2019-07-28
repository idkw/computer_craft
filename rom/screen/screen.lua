current_dir = "/" .. shell.getRunningProgram():gsub("\/screen\.lua","/")
os.loadAPI(current_dir .. "/functions.lua")
os.loadAPI(current_dir .. "/utils.lua")
functions.__init(current_dir)

local function getConfig()
    filePath = "/disk/screen/config.cfg"

    local config = nil

    -- Read config from file if it exists
    if fs.exists(filePath) then
        local file = fs.open(filePath,"r")
        local cfg = file.readAll()
        file.close()
        config = textutils.unserialize(cfg)
    else
        -- Save default config to file and return it
        local defaultConfig = {
            monitor = {
                id = "monitor_0",
                height = 5,
                scale = 2,
                contentFile = "/disk/screen/monitor.txt"
            },
            monitorHeight = 5,
            monitorScale = 2,
            speaker = {
                id = "speaker_0",
            }
        }

        local file = fs.open(filePath,"w")
        file.write(textutils.serialize(defaultConfig))
        file.flush()
        file.close()
        config = defaultConfig
    end

    config["shell"] = shell

    return config
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
    term.clearLine()
    local userInput = read()
    local index = tonumber(userInput)
    if index == nil then
        return nil
    end
    return functions[index]
end

local function main()
    functions = getFunctions()
    config = getConfig()
    while(true) do
        utils.clearTerm()
        selected_function = selectFunction(functions)

        if(selected_function ~= nil) then
            utils.clearTerm()
            selected_function.fn(config)
        else
            utils.printC("&4Cette action n'existe pas.")
        end

        utils.pressAnyKey()
    end
end

-- Begin script
main()