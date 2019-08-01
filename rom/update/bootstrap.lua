-- pastebin 5VEeNudJ

local config = {
    update = {
        path = "/scripts/update/update.lua",
        url = "iMV3C2Ch"
    }
}

local updateScriptPath = config.update.path
if fs.exists(updateScriptPath) then
    fs.delete(updateScriptPath)
end

print("Downloading update script")
shell.run("pastebin", "get", config.update.url, updateScriptPath)
os.loadAPI(updateScriptPath)
update.setShell(shell)


local function displayScripts(s)
    print("Select a script to install :")
    for k, v in pairs(s) do
        print(k .. " : " .. v)
    end
end

local scripts = update.getScriptsNames()
displayScripts(scripts)

local selection
while selection == nil do
    local input = tonumber(read())
    if input == nil or scripts[input] == nil then
        print("Invalid selection !")
        displayScripts(scripts)
    else
        selection = input
    end
end

local script = scripts[selection]
print("Installing script [".. script .."] ...")
update.forceUpdateScript(script, true)
update.setStartupScript(script)