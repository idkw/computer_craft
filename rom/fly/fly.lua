-- Config
local flyKey = keys.f

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

local canvasCache

local function saveDocs(object)
    docs = textutils.serialize(object.getDocs())

    f = fs.open("docs", "a")
    f.write("\n--------------------------\n")
    f.write(textutils.serialize(object.getDocs()))
    f.close()

    print("Saved docs")
end

local function fly()
    while true do
        local event, key = os.pullEvent("key")
        if key == flyKey then
            meta = neural.getMetaOwner()
            neural.launch(meta.yaw, meta.pitch, 3)
        end
    end
end

local function getNearbyEntitiesWithName(name)
    local entities = {}
    local count = 0
    for k, v in pairs(neural.sense()) do
        if v.name == name then
            count = count + 1
            entities[k] = v
        end
    end
    return {
        name = name,
        count = count,
        entities = entities
    }
end

local function getCanvas()
    if canvasCache == nil then

        local c = neural.canvas()
        c.clear()

        local group = c.addGroup({ 0, 30 })

        local item = group.addItem({ 0, 0 }, "minecraft:skull", 4)
        item.setScale(3)

        local text = group.addText({ 18, 18 }, "")
        text.setColor(255, 0, 0)
        text.setScale(2)

        canvasCache = {
            c = c,
            group = group,
            text = text,
            item = item
        }
    end
    return canvasCache
end

local function destroyCanvas()
    if canvasCache ~= nil then
        canvasCache.c.clear()
        canvasCache = nil
    end
end

local function updateCanvas(data)
    local count = data.creepers.count
    if count > 0 then
        local canvas = getCanvas()
        canvas.text.setText(tostring(count))
    else
        destroyCanvas()
    end
end

local function scanCreepers()
    while true do
        os.sleep(0.5)
        creepers = getNearbyEntitiesWithName("Creeper")
        meta = neural.getMetaOwner()
        updateCanvas({
            creepers = creepers
        })
    end
end

parallel.waitForAny(fly, scanCreepers)