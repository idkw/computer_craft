function clearTerm()
    term.setBackgroundColor(colors.black)
    term.clear()
    term.setTextColor(colors.white)
    term.setCursorPos(1, 1)
end

function pressAnyKey()
    utils.printC("&7Appuyer sur une touche pour continuer")
    os.pullEvent("key")
end

local colorTable = {
    ["0"] = colors.black,
    ["1"] = colors.blue,
    ["2"] = colors.green,
    ["3"] = colors.cyan,
    ["4"] = colors.red,
    ["5"] = colors.purple,
    ["6"] = colors.orange,
    ["7"] = colors.lightGray,
    ["8"] = colors.gray,
    ["9"] = colors.lightBlue,
    ["a"] = colors.lime,
    ["b"] = colors.lightBlue,
    ["c"] = colors.red,
    ["d"] = colors.magenta,
    ["e"] = colors.yellow,
    ["f"] = colors.white
}

function writeC(...)

    local s = "&f"
    for k, v in ipairs(arg) do
        s = s .. v
    end
    s = s .. "&f"

    local fields = {}
    local lastcolor, lastpos = "f", 0
    for pos, clr in s:gmatch "()&(%x)" do
        table.insert(fields, { s:sub(lastpos + 2, pos - 1), lastcolor })
        lastcolor, lastpos = clr, pos
    end

    for i = 2, #fields do
        color = colorTable[fields[i][2]]
        term.setTextColor(color)
        io.write(fields[i][1])
    end
end

function printC(...)
    writeC(...)
    io.write("\n")
end