-- 9hHpr9Zm

os.loadAPI("/scripts/update/update.lua")
update.setShell(shell)

input = nil
output = nil
cfg = {
    conversions = {
        ["techreborn:ingot"] = {
            item_in = {
                name = "techreborn:ingot",
                damage = 18,
                count = 1
            },
            item_out = {
                name = "extraplanets:tier8_items",
                damage = 5,
                count = 1
            }
        }
    }
}

function setup()
    input = peripheral.wrap("top")
    output = peripheral.wrap("bottom")

    if (input == nil
            or input.getMetadata().name ~= "minecraft:chest"
            or output == nil
            or output.getMetadata().name ~= "minecraft:chest") then
        error("Needs a chest on top as input and a chest at the bottom as output !")
    end

    local path = "/scripts/convertitems/settings.cfg"
    if fs.exists(path) then
        local f = fs.open(path, "r")
        cfg = textutils.unserialize(f.readAll())
        f.close()
    else
        local f = fs.open(path, "w")
        f.write(textutils.serialize(cfg))
        f.flush()
        f.close()
    end
end

function convertItems()
    setup()

    while true do
        local conv = cfg.conversions
        local input_items = input.list()
        --print(textutils.serialize(input_items))
        local cmd_outs = {}
        for slot, item in pairs(input_items) do
            local recipe = conv[item.name]
            print(textutils.serialize(item))
            if recipe ~= nil then
                local item_in = recipe.item_in
                local item_out = recipe.item_out
                if item_in.name == item.name and item_in.damage == item.damage then
                    local recipe_batches = item.count / item_in.count
                    local remaining = item.count - (item_in.count * recipe_batches)
                    local out_count = item_out.count * recipe_batches

                    local cmd_in = "replaceitem block ~ ~1 ~ slot.container.".. slot-1 .. " minecraft:air "
                    exec(cmd_in)

                    local cmd_out = "replaceitem block ~ ~-1 ~ slot.container.0 ".. item_out.name.. " ".. out_count.. " ".. item_out.damage
                    exec(cmd_out)

                    foo = {}
                    table.insert(foo, "bar")
                    table.insert(foo, "baz")
                end
            end
        end
        os.sleep(2)
    end
end

parallel.waitForAny(
        update.waitForUpdateFunc("convertitem"),
        convertItems
)