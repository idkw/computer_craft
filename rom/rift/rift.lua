-- pastebin YGgNJiUu

os.loadAPI("/scripts/update/update.lua")
update.setShell(shell)

os.loadAPI("/scripts/neuralUtil/neuralUtil.lua")
local neural = peripheral.find("neuralInterface")
neuralUtil.setNeural(neural)
neuralUtil.ensureHasModule("plethora:sensor")
neuralUtil.ensureHasModule("plethora:introspection")
neuralUtil.ensureHasModule("plethora:chat")

local function scanForRifts()
    while true do
        print("Scanning Rift")
        os.sleep(2)
        pigs = neuralUtil.getNearbyEntitiesWithName("Pig")
        print("Found " .. pigs.count .. " pigs")
    end
end

print("Starting rift !")
parallel.waitForAny(
        update.waitForUpdateFunc("rift"),
        scanForRifts
)