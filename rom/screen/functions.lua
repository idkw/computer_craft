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
    shell = config.shell
    monitorHeight = config.monitor.height
    monitorfilePath =  config.monitor.contentFile
    p = wrapMonitor(config)

    utils.printC("Ouverture de l'éditeur de texte")
    utils.printC("Enregistrer &a:&f CTRL > SAVE > ENTREE")
    utils.printC("Quitter     &a:&f CTRL > QUIT > ENTREE")
    utils.pressAnyKey()
    utils.clearTerm()

    shell.run("edit " .. monitorfilePath)

    p.clear()
    p.setTextScale(config.monitor.scale)

    file = fs.open(monitorfilePath, "r")
    line_idx = 1
    line = 0
    repeat
        line = file.readLine()
        if line ~= nil then
            p.setCursorPos(1,line_idx)
            utils.writeMonitorC(p, line)
        end
        line_idx = line_idx + 1
    until line == nil
    file.close()

    utils.printC("&aLe fichier est maintenant affiché sur le moniteur")

end