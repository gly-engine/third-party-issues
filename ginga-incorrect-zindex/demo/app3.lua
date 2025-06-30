local canvas = canvas

local App = {
    title   = "Canvas Always‑On",
    author  = "João Vicente",
    version = "1.0.0"
}

local W, H = canvas:attrSize()
local rectW, rectH = 100, H
local rectX = (W - rectW) / 2
local rectY = (H - rectH) / 2

canvas:attrColor(0xDD, 0xC1, 0xFF, 0xFF)
canvas:drawRect("fill", rectX, rectY, rectW, rectH)

canvas:flush()

return App