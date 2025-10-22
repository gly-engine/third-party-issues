local canvas = canvas
local event = event 
local delta = 100
local ccws_finished, ccws_status, ccws_error, ccws_body, ccws_post = '', '', '', '', ''
local base_url = 'http://localhost:44642/dtv/mediaplayers/1'
local video_url = 'https://yt-dash-mse-test.commondatastorage.googleapis.com/media/car-20120827-manifest.mpd'
local action_play = '{"url":"%s","action":"%s","pos":{"x":%d,"y":%d,"w":%d,"h":%d}}'
local action_stop = '{"action":"unload"}'
local headers = {['User-Agent'] = 'Ginga (GlyOS;SmartTv/Linux)'}
local actions = {'prepare','start','pause','resume','stop','unload'}
local menu = 1
local debounce = 300
local lasttime = -9999
local lastevt = 'evt'
local now = 0

local function dump(tbl)
    local result = {}
    for k, v in pairs(tbl) do
        table.insert(result, k .. "=" .. tostring(v))
    end
    return table.concat(result, ", ")
end

local function do_something()
    ccws_finished, ccws_status, ccws_error, ccws_body = '', '', '', ''
    if menu == 6 then
        local r1, r2 = event.post({
            class = 'http',
            type = 'request',
            method = 'post',
            uri = base_url,
            headers = headers,
            body = action_stop
        })
        ccws_post = tostring(r1)..' '..tostring(r2)
    else
        local body = string.format(action_play, video_url, actions[menu], 0, 0, 1280, 720)
        local r1, r2 = event.post({
            class = 'http',
            type = 'request',
            method = 'post',
            uri = base_url,
            headers = headers,
            body = body
        })
        ccws_post = tostring(r1)..' '..tostring(r2)
    end
end

local function handler(evt)
    lastevt = dump(evt)
    if evt.class == 'key' and evt.type == 'press' then
        if menu > 1 and evt.key == 'CURSOR_UP' then
            menu = menu - 1
        elseif menu < 6 and evt.key == 'CURSOR_DOWN' then
            menu = menu + 1
        elseif evt.key == 'CURSOR_RIGHT' and (now - lasttime) > debounce then
            print('clicado')
            lasttime = now
            do_something()
        end
    end
    if evt.class == 'http' then
        if evt.body ~= nil then ccws_body = ccws_body..tostring(evt.body):gsub('\r', ''):gsub('\n', '') end
        if evt.finished ~= nil then ccws_finished = tostring(evt.finished) end
        if evt.error ~= nil then ccws_error = tostring(evt.error) end
        if evt.code ~= nil then ccws_status = tostring(evt.code) end
    end
end

local function tick()
    now = event.uptime()
    canvas:attrColor(0x33, 0x33, 0x33, 0x70)
    canvas:clear()
    canvas:attrFont('Tiresias', 20)
    canvas:attrColor('red')
    canvas:drawText(6, 8 + ((menu-1) * 24), '>')
    canvas:attrColor('white')
    for i = 1, #actions do
        canvas:drawText(20, 8 + ((i-1) * 24), actions[i])
    end
    canvas:drawText(6, 312, 'ccws finished: '..ccws_finished)
    canvas:drawText(6, 344, 'ccws status: '..ccws_status)
    canvas:drawText(6, 376, 'ccws post: '..ccws_post)
    canvas:drawText(6, 408, 'ccws error: '..ccws_error)
    canvas:drawText(6, 440, 'ccws body: '..ccws_body:sub(1, 100))
    canvas:drawText(6, 472, 'ccws body: '..ccws_body:sub(101, 200))
    canvas:drawText(6, 504, 'ccws body: '..ccws_body:sub(201, 300))
    canvas:drawText(6, 536, 'ccws body: '..ccws_body:sub(301, 400))
    canvas:drawText(6, 640, 'evt: '..lastevt)
    if (now - lasttime) < (debounce*3) then
        canvas:drawRect('fill', 320, 180, 640, 64)
        canvas:attrColor('black')
        canvas:drawRect('frame', 320, 180, 640, 64)
        canvas:drawText(460, 188, 'C O M A N D O   E N V I A DO !')
    end
    canvas:flush()
    event.timer(delta, tick)
end

event.register(handler)
event.timer(delta, tick)
