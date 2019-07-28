function __init(current_dir)
    os.loadAPI(current_dir .. "/utils.lua")
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