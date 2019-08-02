-- pastebin viDEcBes

local neural

function setNeural(aNeuralInterface)
    neural = aNeuralInterface
end

function ensureHasNeural()
    if not neural then
        error("Must have a neural interface", 0)
    end
end

function ensureHasModule(moduleName)
    ensureHasNeural()

    if not neural.hasModule(moduleName) then
        error("Must have a module ["..moduleName.."]", 0)
    end
end

function getNearbyEntitiesWithName(name)
    local entities = {}
    local count = 0
    for k, v in pairs(neural.sense()) do
        if v.name == name then
            count = count + 1
            entities[v.id] = v
        end
    end
    return {
        name = name,
        count = count,
        entities = entities
    }
end