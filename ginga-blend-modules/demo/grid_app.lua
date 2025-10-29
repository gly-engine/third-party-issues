local canvas = canvas

local horizontal_images = {}
local vertical_images = {}
for col = 1, 9 do
    horizontal_images[col] = canvas.new("assets/out_compressed_" .. col .. ".png")
    vertical_images[col]  = canvas.new("assets/out1_compressed_" .. col .. ".png")
end

local function draw_grids(size, width, height)
    local cols = 9
    local rows = math.floor(height / size)
    local number = 1
    for l = 0, rows - 1 do
        local y = l * size
        for col = 0, cols - 1 do
            local x = col * size
            local count = col + 1
            local col_img = col + 1
            if x + size > width or y + size > height then break end

            local alpha = math.max(255 - (count - 1) * 25.5, 25)
            alpha = math.floor(alpha)

            canvas:attrColor(0, 255, 0, 255)
            canvas:drawRect("fill", x, y, size, size)
            if count == 1 then
            elseif count == 2 then
                canvas:attrColor(255, 0, 0, 128)
                canvas:drawRect("fill", x, y, size, size/2)
                canvas:attrColor(0, 0, 255, 128)
                canvas:drawRect("fill", x, y + size/2, size, size/2)
            elseif count == 3 then
                canvas:attrColor(255, 0, 0, 128)
                canvas:drawRect("fill", x, y, size/2, size)
                canvas:attrColor(0, 0, 255, 128)
                canvas:drawRect("fill", x + size/2, y, size/2, size)
            elseif count == 4 then
                canvas:attrColor(255, 0, 0, 128)
                canvas:drawRect("fill", x, y, size, size/2)
                canvas:attrColor(0, 0, 255, 128)
                canvas:drawRect("fill", x, y + size/2, size, size/2)
                canvas:attrColor(255, 0, 0, 128)
                canvas:drawRect("fill", x, y, size/2, size)
                canvas:attrColor(0, 0, 255, 128)
                canvas:drawRect("fill", x + size/2, y, size/2, size)
            elseif count == 5 then
                canvas:compose(x, y, horizontal_images[col_img])
            elseif count == 6 then
                canvas:compose(x, y, vertical_images[col_img])
            elseif count == 7 then
                canvas:compose(x, y, horizontal_images[col_img])
                canvas:compose(x, y, vertical_images[col_img])
            elseif count == 8 then
                canvas:compose(x, y, horizontal_images[col_img])
                canvas:attrColor(255, 0, 0, 128)
                canvas:drawRect("fill", x, y, size/2, size)
                canvas:attrColor(0, 0, 255, 128)
                canvas:drawRect("fill", x + size/2, y, size/2, size)
            elseif count == 9 then
                canvas:attrColor(255, 0, 0, 128)
                canvas:drawRect("fill", x, y, size, size/2)
                canvas:attrColor(0, 0, 255, 128)
                canvas:drawRect("fill", x, y + size/2, size, size/2)
                canvas:compose(x, y, vertical_images[col_img])
            end

            -- borda amarela
            canvas:attrColor(255, 255, 0, 255)
            canvas:drawRect("frame", x, y, size, size)

            -- número centralizado
            local num = tostring(number)
            canvas:attrColor(255, 255, 255, 255)
            local tw, th = canvas:measureText(num)
            local tx = x + (size - tw) / 2
            local ty = y + (size - th) / 2
            canvas:drawText(tx, ty, num)

            count = count + 1
            number = number + 1
        end
    end
    canvas:flush()
end

draw_grids(80, 1280, 720)