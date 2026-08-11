local canvas = canvas
local event = event
local pairs = pairs
local table = table
local tostring = tostring
local w, h = canvas:attrSize ()
local console =  {}
local count = 0

local function dump(tbl)
    local result = {}
    for k, v in pairs(tbl) do
        table.insert(result, k .. "=" .. tostring(v))
    end
    return table.concat(result, ", ")
end

local function event_loop(evt)
    count = count + 1
    table.insert(console, {text=dump(evt), item=count})
    if #console > (h/17) then
        table.remove(console, 1)
    end
end

local function fixed_loop()
    canvas:attrColor (0, 0, 0, 0)
    canvas:clear()
    canvas:attrColor('white')
    canvas:attrFont('sans', 12)
    for i=1, #console do
        local x, y = canvas:measureText(console[i].item)
        canvas:drawText(w - x - 8, 16 * i, console[i].item)
        canvas:drawText(8, 16 * i, console[i].text)
    end
    canvas:flush()
    event.timer(1, fixed_loop)
end

event.register(event_loop)
event.timer(1, fixed_loop)