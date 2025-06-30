local canvas = canvas

local App = {
  title   = "Canvas Always‑On",
  author  = "João Vicente",
  version = "1.0.0"
}

local W, H = canvas:attrSize()
local rect_width, rect_height = W, 100
local rect_x = 0
local rect_y = (H / 2) + 60

canvas:attrColor(0xFF, 0xFF, 0xFF, 0xFF)
canvas:drawRect("fill", rect_x, rect_y, rect_width, rect_height)

canvas:flush()

return App