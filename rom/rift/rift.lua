-- pastebin YGgNJiUu

os.loadAPI("/scripts/update/update.lua")
update.setShell(shell)

os.loadAPI("/scripts/neuralUtil/neuralUtil.lua")
local neural = peripheral.find("neuralInterface")
neuralUtil.setNeural(neural)
neuralUtil.ensureHasModule("plethora:sensor")
neuralUtil.ensureHasModule("plethora:introspection")
neuralUtil.ensureHasModule("plethora:chat")
neuralUtil.ensureHasModule("plethora:kinetic")

local currentRifts = {}
local config

local function scanForRifts()
    while true do
        os.sleep(2)
        local riftDection = neuralUtil.getNearbyEntitiesWithName("FluxRift")
        local count = riftDection.count
        local rifts = riftDection.entities

        local toAdd = {}

        -- Detecting new unseen rifts
        for k, v in pairs(rifts) do
            if currentRifts[k] == nil then
                toAdd[k] = v
            end
        end

        local toRemove = {}

        -- Detecting dead rifts
        for k, v in pairs(currentRifts) do
            if rifts[k] == nil then
                toRemove[k] = v
            end
        end

        for k, v in pairs(toAdd) do
            local x = math.floor(config.x + v.x)
            local y = math.floor(config.y + v.y)
            local z = math.floor(config.z + v.z)
            neural.say("[RiftDetector] Un RIFT a spawn en x[" .. x .. "] y[" .. y .. "] z[" .. z .. "]")
            currentRifts[k] = v
        end

        for k, v in pairs(toRemove) do
            local x = math.floor(config.x + v.x)
            local y = math.floor(config.y + v.y)
            local z = math.floor(config.z + v.z)
            neural.say("[RiftDetector] Le RIFT en x[" .. x .. "] y[" .. y .. "] z[" .. z .. "] est MORT !")
            currentRifts[k] = nil
        end
    end
end

print("Starting rift !")

local cfgPath = "/scripts/rift/rift.cfg"
if fs.exists(cfgPath) then
    f = fs.open(cfgPath, "r")
    config = textutils.unserialize(f.readAll())
    f.close()
else
    f = fs.open(cfgPath, "w")
    config = {
        x = 0,
        y = 0,
        z = 0
    }
    f.write(config)
    f.close()
end

neural.disableAI()

parallel.waitForAny(
        update.waitForUpdateFunc("rift"),
        scanForRifts
)