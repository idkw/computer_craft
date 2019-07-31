-- Config
local flyKey = keys.a

--
local neural = peripheral.find("neuralInterface")

if not neural then
    error("Must have a neural interface", 0)
end

if not neural.hasModule("plethora:sensor") then
    error("Must have a sensor", 0)
end

if not neural.hasModule("plethora:introspection") then
    error("Must have an introspection module", 0)
end

if not neural.hasModule("plethora:kinetic", 0) then
    error("Must have a kinetic agument", 0)
end

local meta = {}

local function fly()
    while true do
        local event, key = os.pullEvent("key")
        if key == flyKey then
            meta = neural.getMetaOwner()
            neural.launch(meta.yaw, meta.pitch, 3)
        end
    end
end


parallel.waitForAny(fly)