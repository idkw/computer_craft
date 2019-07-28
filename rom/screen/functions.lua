function __init(current_dir)
    os.loadAPI(current_dir .. "/utils.lua")
    os.loadAPI(current_dir .. "/music.lua")
    music.__init(current_dir)
end

function shutdown()
    utils.writeC("&8Arrêt en cours")
    for i=1,3 do
        os.sleep(0.5)
        utils.writeC("&8.")
    end
    os.sleep(0.5)
    os.shutdown()
end

local function wrapMonitor(config)
    return peripheral.wrap(config.monitor.id)
end

local function wrapSpeaker(config)
    return peripheral.wrap(config.speaker.id)
end

function clearMonitor(config)
    p = wrapMonitor(config)
    p.clear()
    utils.printC("&aMoniteur effacé")
end

function writeMonitor(config)
    -- edit monitor content file
    local filePath = config.monitor.contentFile
    config.shell.run("edit " .. filePath)
    local lines = utils.readLines(filePath)

    -- display content on monitor
    local p = wrapMonitor(config)
    p.clear()
    p.setTextScale(config.monitor.scale)
    utils.writeMonitorLinesC(p, lines)

    utils.clearTerm()
    utils.printC("&aLe fichier est maintenant affiché sur le moniteur")
end

function playSounds(config)
    local path = ""
    local keys = music.getSoundsKeys(path)

    while keys == nil or #keys > 0 do
        utils.clearTerm()
        utils.printC("&aChoisis un son :")
        if path ~= "" then
            utils.printC("&aSelection actuelle : &7"..path)
        end
        for k,v in pairs(keys) do
            utils.printC(k.."&a : &f"..v)
        end

        local selectedPath
        while selectedPath == nil do
            local userInput = read()
            local selectedPathTentative = keys[tonumber(userInput)]
            if selectedPathTentative ~= nil then
                selectedPath = selectedPathTentative
            end
        end

        if path == "" then
            path = selectedPath
        else
            path = path .. "." .. selectedPath
        end

        keys = music.getSoundsKeys(path)
    end

    local sound_name = path

    p = wrapSpeaker(config)
    utils.printC("&aLecture du son &f : ".. path)
    p.playSound(sound_name)
end