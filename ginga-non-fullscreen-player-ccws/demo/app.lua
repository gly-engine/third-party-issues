local function script()
    local uri = 'http://localhost:44642/dtv/mediaplayers/1'
    local headers = {['User-Agent'] = 'Ginga (WebOS;SmartTv/Linux)'}
    local rnd = tostring({}):gsub('0x', ''):match('^table: (%w+)$')
    local play = '"https://dash.akamaized.net/dash264/TestCasesIOP33/adapatationSetSwitching/5/manifest.mpd?'..rnd..'"'
    local body = '{"action":"start","url":'..play..',"pos":{"x":0,"y":0,"w":1280,"h":720}}'
    event.post({
        class = 'http',
        type = 'request',
        method = 'post',
        uri = uri,
        body = body,
        headers = headers
    })
end

event.timer(200, script)
