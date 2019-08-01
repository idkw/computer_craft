-- Script for automatizing the update of scripts
-- pastebin iMV3C2Ch

-- config

local config = {
    cfgPath = "/scripts/update/",
    cfgFile = "versions.cfg",
    url = "jsgH9zSA", -- versions url
    shell = nil
}

-- internal functions

local function buildScriptDirPath(scriptName)
    return "/scripts/" .. scriptName .. "/"
end

local function buildVersionedScriptName(scriptName, version)
    return scriptName .. "_" .. version .. ".lua"
end

local function buildVersionedScriptPath(scriptName, version)
    return buildScriptDirPath(scriptName) .. buildVersionedScriptName(scriptName, version)
end

local function buildScriptName(scriptName)
    return scriptName .. ".lua"
end

local function buildEntrypointScriptPath(scriptName)
    return buildScriptDirPath(scriptName) .. buildScriptName(scriptName)
end

local function getCfgFilePath()
    return config.cfgPath .. config.cfgFile
end

local function downloadPastebin(url, toPath)
    config.shell.run("pastebin", "get", url, toPath)
end

local function removeIfExists(path)
    if fs.exists(path) then
        fs.delete(path)
    end
end

local function getVersionsCfg()
    local cfgFilePath = getCfgFilePath()
    if fs.exists(cfgFilePath) then
        fs.delete(cfgFilePath)
    end
    downloadPastebin(config.url, cfgFilePath)

    local cfg = {}
    if fs.exists(cfgFilePath) then
        f = fs.open(cfgFilePath, "r")
        local content = f.readAll()
        f.close()
        cfg = textutils.unserialize(content)
    end
    return cfg
end

local function doUpdateScript(name, cfg, force)
    local entrypointPath = buildEntrypointScriptPath(name)
    local versionedPath = buildVersionedScriptPath(name, cfg.version)
    local dirPath = buildScriptDirPath(name)

    if fs.exists(versionedPath) and not force then
        print("Script [" .. name .. "] version [" .. cfg.version .. "] is already installed. Nothing to update")
        return false
    end

    removeIfExists(entrypointPath)
    downloadPastebin(cfg.url, entrypointPath)

    -- Remove old versions
    for k, v in pairs(fs.list(dirPath)) do
        if string.match(v, name .. "_[0-9]+\.[0-9]+\.[0-9]+\.lua") then
            fs.delete(dirPath .. v)
        end
    end

    if cfg.dependencies ~= nil then
        print("Updating dependencies")
        for k,v in pairs(cfg.dependencies) do
            forceUpdateScript(k, force)
        end
    end

    f = fs.open(versionedPath, "w")
    f.write(textutils.serialize({
        name = name,
        cfg = cfg
    }))
    f.close()

    print("Updated script [" .. name .. "] to version [" .. cfg.version .. "]")
    return true
end



-- API

function setShell(aShell)
    config.shell = aShell
end

function updateAllScripts()
    local cfg = getVersionsCfg()
    for k, v in pairs(cfg) do
        doUpdateScript(k, v, false)
    end
end

function forceUpdateScript(name, force)
    local cfg = getVersionsCfg()
    if cfg[name] == nil then
        error("Script " .. name .. " does not exist")
    end
    return doUpdateScript(name, cfg[name], force)
end

function updateScript(name)
    return forceUpdateScript(name, false)
end

function updateScriptAndReboot(name)
    if updateScript(name) then
        print("Rebooting")
        os.sleep(2)
        os.reboot()
    end
end

function setStartupScript(name)
    local path = "/startup.lua"
    removeIfExists(path)
    f = fs.open(path, "w")
    f.write("os.loadAPI(\"" .. config.cfgPath .. "update.lua\")\n")
    f.write("update.setShell(shell)\n")
    f.write("update.updateScript(\"update\")\n")
    f.write("shell.run(\"" .. buildEntrypointScriptPath(name) .. "\")\n")
    f.close()
    print("Startup script set to [" .. name .. "]")
end

function getScriptsNames()
    local cfg = getVersionsCfg()
    local names = {}
    local index = 1
    for k, v in pairs(cfg) do
        if k ~= "update" then
            names[index] = k
            index = index + 1
        end
    end
    return names
end

function waitForUpdate(name, sleep_delay)
    if sleep_delay == nil then
        sleep_delay = 300
    end
    print("Waiting for updates for script [" .. name .. "] with a fixed delay of [" .. sleep_delay .. "] seconds")
    while true do
        os.sleep(sleep_delay)

        -- Trying to update update script itself first
        if updateScript("update") then
            local s = config.shell
            os.loadAPI("/scripts/update/update.lua")
            update.setShell(s)
            setShell(s)
        end

        if update == nil then
            -- updates are run from the current update script
            updateScriptAndReboot(name)
        else
            -- updates are delegated to a new updated update script
            update.updateScriptAndReboot(name)
        end

    end
end

function waitForUpdateFunc(name, sleep_delay)
    return function()
        waitForUpdate(name, sleep_delay)
    end
end