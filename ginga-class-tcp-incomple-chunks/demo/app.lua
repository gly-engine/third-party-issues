local canvas = canvas
local event = event 
local delta = 100
local width, height = 1280, 720
local problem = ''
local fsm = {
    'conecting',
    'request',
    'response',
    'closed connection by server'
}
local state = 0
local chunks = 0
local total_size = 0

local function handler(evt)
    if evt.class ~= 'tcp' then return end
    if evt.type == 'connect' then
        state = 2
        event.post({
            class      = 'tcp',
            type       = 'data',
            connection = evt.connection,
            value      = 'GET /cli.lua HTTP/1.1\r\nHost: get.gamely.com.br\r\nConnection: close\r\n\r\n',
        })
    end
    if evt.type == 'data' then
        state = 3
        chunks = chunks + 1
        total_size = total_size + (evt.value and #evt.value or 0)
    end
    if evt.type == 'disconect' then state = 4 end
    if evt.type == 'disconnect' then state = 5 end
    if evt.error then
        state = 6
        problem = problem..tostring(evt.error)
    end
end

local function tick()
    -- step
    if state == 0 then
        state = 1
        width, height = canvas:attrSize()
        event.post({
            class = 'tcp',
            type = 'connect',
            host = 'get.gamely.com.br',
            port = 80
        })
    end

    -- draw
    canvas:attrColor('black')
    canvas:clear()
    canvas:attrColor('white')
    canvas:attrFont('Tiresias', 24)
    local w1 = width/8
    local w2 = w1*7
    local t1 = tostring(fsm[state] or state)
    local t2 = tostring(chunks)
    local t3 = tostring(total_size)
    local t4 = tostring(problem)
    local s1 = canvas:measureText(t1)
    local s2 = canvas:measureText(t2)
    local s3 = canvas:measureText(t3)
    local s4 = canvas:measureText(t4)
    canvas:drawText(w1, 8, 'state:')
    canvas:drawText(w1, 40, 'chunks:')
    canvas:drawText(w1, 72, 'size:')
    canvas:drawText(w1, 104, 'error:')
    canvas:drawText(w2 - s1, 8, t1)
    canvas:drawText(w2 - s2, 40, t2)
    canvas:drawText(w2 - s3, 72, t3)
    canvas:drawText(w2 - s4, 104, t4)
    canvas:flush()
    event.timer(delta, tick)
end

event.register(handler)
event.timer(delta, tick)
