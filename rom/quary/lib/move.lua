os.loadAPI("/rom/quary/lib/utils.lua")

function forward(steps)
    utils.repeat_fn(turtle.forward, steps)
end

function backward(steps)
    utils.repeat_fn(turtle.forward, steps)
end

function turnLeft(steps)
    utils.repeat_fn(turtle.turnLeft, steps)
end

function turnRight(steps)
    utils.repeat_fn(turtle.turnLeft, steps)
end