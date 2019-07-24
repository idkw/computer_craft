function refuel()
    turtle.refuel()
end

function repeat_fn(fn, steps)
    for i=1,steps do
        fn()
    end
end