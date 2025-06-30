local canvas = canvas

local App = {
    title   = "Canvas Always‑On",
    author  = "João Vicente",
    version = "1.0.0"
}

local W, H = canvas:attrSize()
local rectW, rectH = W, 100
local rectX = (W - rectW) / 2
local rectY = (H - rectH) / 2

canvas:attrColor(0xFF, 0xA3, 0xFF, 0xFF)
canvas:drawRect("fill", rectX, rectY, rectW, rectH)

canvas:flush()

return App