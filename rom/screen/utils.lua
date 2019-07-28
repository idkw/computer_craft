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


local function splitInColors(...)
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

    return fields
end

-- Write on console in color
function writeC(...)
    local fields = splitInColors(...)

    for i = 2, #fields do
        term.setTextColor(colorTable[fields[i][2]])
        io.write(fields[i][1])
    end
end

-- Write on console in color then add a line break
function printC(...)
    writeC(...)
    io.write("\n")
end

-- Write on a monitor in color
function writeMonitorC(monitor, ...)
    local fields = splitInColors(...)

    for i = 2, #fields do
        monitor.setTextColour(colorTable[fields[i][2]])
        monitor.write(fields[i][1])
    end
end

-- Write multiple lines on a monitor with color
function writeMonitorLinesC(monitor, lines)
    monitor.setCursorPos(1,1)
    local disp_length, disp_height = monitor.getSize()
    local scale = monitor.getTextScale()
    disp_length = disp_length / scale

    local line_idx = 1
    for i=1,#lines do
        line = lines[i]
        local char_idx = 1
        local line_length = #line
        -- Break to new line if displayed line is full
        repeat
            local next_char_idx = math.min(char_idx + disp_length, line_length)
            local line_part = line:sub(char_idx, next_char_idx)
            monitor.setCursorPos(char_idx % disp_length, line_idx)
            char_idx = next_char_idx
            line_idx = line_idx + 1
            writeMonitorC(monitor, line_part)
        until char_idx >= line_length
    end
end

-- Read file content into an array of lines
function readLines(filePath)
    local lines = {}
    local file = fs.open(filePath, "r")
    local line_idx = 1
    repeat
        line = file.readLine()
        if line ~= nil then
            lines[line_idx] = line
            line_idx = line_idx + 1
        end
    until line == nil
    file.close()
    return lines
end