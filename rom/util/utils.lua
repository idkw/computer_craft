-- pastebin Tu9yLJFG

function ensurePeripheral(name)
    local modem = peripheral.find(name)
    if modem == nil then
        error("Peripheral [" .. name .. "] not found !", 1)
    end
    return modem
end
