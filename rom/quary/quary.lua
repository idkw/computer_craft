path = "/rom/quary/"
os.loadAPI(path.."/lib/test.lua")
os.loadAPI(path.."/lib/utils.lua")
os.loadAPI(path.."/lib/move.lua")
os.loadAPI(path.."/config.lua")
os.loadAPI(path.."/config.lua")
test.coucou()
utils.refuel()

c = config.get()
print(c.lava_tank_loc.x)
print(c.lava_tank_loc.y)
print(c.lava_tank_loc.z)

--turtle.forward(10)
--turtle.turnLeft()
--turtle.forward(10)
--turtle.turnLeft()
--turtle.forward(10)
--turtle.turnLeft()
--turtle.forward(10)
--turtle.turnLeft()

move.forward(10)