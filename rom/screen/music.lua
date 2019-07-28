local sound_names = nil
local dir = nil

local VALUE_MARKER = "__PATH__"

local function readSounds()
    local names = {}
    local lines = utils.readLines(dir.."music.txt")
    for i=1,#lines do
        local sound_name = lines[i]
        local cat = names

        local split = utils.splitString(sound_name, ".")
        local path = ""

        for k,v in pairs(split) do
            path = path..v
            if cat[v] == nil then
                cat[v] = {}
            end
            cat[v][VALUE_MARKER] = path
            cat = cat[v]
        end
    end
    return names
end

function __init(current_dir)
    dir = current_dir
    os.loadAPI(dir.."utils.lua")
    sound_names = readSounds()
end

function getSoundsKeys(path)
    local split = utils.splitString(path, ".")

    local sound = sound_names
    for k,v in pairs(split) do
        sound = sound[v]
    end

    local keys = {}

    local idx = 1
    for k,v in pairs(sound) do
        if k ~= VALUE_MARKER then
            keys[idx] = k
            idx = idx + 1
        end
    end

    return keys
end