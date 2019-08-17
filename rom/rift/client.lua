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
neuralUtil.ensureHasModule("plethora:kinetic")

os.loadAPI("/scripts/utils/utils.lua")
utils.ensurePeripheral("modem")

local currentRifts = {}
local currentPosition = nil

local function updatePosition()
    local x,y,z = gps.locate(0.1)
    if x == nil then
        currentPosition = nil
    else
        currentPosition = {
            x = x,
            y = y,
            z = z
        }
    end
end

local function scanForRifts()
    while true do
        os.sleep(2)
        local riftDection = neuralUtil.getNearbyEntitiesWithName("FluxRift")
        local count = riftDection.count
        local rifts = riftDection.entities

        -- Detecting new unseen rifts
        local toAdd = {}
        local toAddCount = 0
        for k, v in pairs(rifts) do
            if currentRifts[k] == nil then
                toAdd[k] = v
                toAddCount = toAddCount + 1
            end
        end

        -- Detecting dead rifts
        local toRemove = {}
        local toRemoveCount = 0
        for k, v in pairs(currentRifts) do
            if rifts[k] == nil then
                toRemove[k] = v
                toRemoveCount = toRemoveCount + 1
            end
        end

        if toAddCount > 0 or toRemoveCount > 0 then
            updatePosition()
        end

        -- Announcing new rifts
        for k, v in pairs(toAdd) do
            if currentPosition == nil then
                neural.say("[RiftDetector] Un RIFT a spawn (Pas de couverture GPS)")
            else
                local x = math.floor(currentPosition.x + v.x)
                local y = math.floor(currentPosition.y + v.y)
                local z = math.floor(currentPosition.z + v.z)
                neural.say("[RiftDetector] Un RIFT a spawn en x[" .. x .. "] y[" .. y .. "] z[" .. z .. "]")
            end
            currentRifts[k] = v
        end

        -- Annoucing dead rifts
        for k, v in pairs(toRemove) do
            if currentPosition == nil then
                neural.say("[RiftDetector] Un RIFT est MORT (pas de couverture GPS) !")
            else
                local x = math.floor(currentPosition.x + v.x)
                local y = math.floor(currentPosition.y + v.y)
                local z = math.floor(currentPosition.z + v.z)
                neural.say("[RiftDetector] Le RIFT en x[" .. x .. "] y[" .. y .. "] z[" .. z .. "] est MORT !")
            end
            currentRifts[k] = nil
        end
    end
end

print("Starting rift !")

if neural.disableAI ~= nil then
    neural.disableAI()
end

parallel.waitForAny(
        update.waitForUpdateFunc("rift"),
        scanForRifts
)