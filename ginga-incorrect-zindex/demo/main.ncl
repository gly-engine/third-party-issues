<?xml version='1.0' encoding='utf-8'?>
<ncl>
  <head>
    <regionBase>
      <region id='luaRegion' width="1280" height="720" zIndex='2'/>
      <region id='luaRegion1' width="1280" height="720" zIndex="3"/>
      <region id="regionTv" left="200" top="200" width="768" height="432" zIndex="1"/>
      <region id='luaRegion2' width="1280" height="720" zIndex="4"/>
    </regionBase>
    <descriptorBase>
      <descriptor id='luaDesc' region='luaRegion'/>
      <descriptor id='luaDesc1' region='luaRegion1'/>
      <descriptor id='luaDesc2' region='luaRegion2'/>
      <descriptor id='descriptorTv' region='regionTv'/>
    </descriptorBase>
  </head>
  <body>
    <port id='init' component='lua'/>
    <port id='init1' component='lua1'/>
    <port id='init2' component='lua2'/>
    <port id="portTv" component="tv"/>
    <media id="tv" src="sbtvd-ts://video" descriptor="descriptorTv"></media>
    <media id='lua' descriptor='luaDesc' src='app1.lua'/>
    <media id='lua2' descriptor='luaDesc2' src='app2.lua'/>
    <media id='lua1' descriptor='luaDesc1' src='app3.lua'/>
  </body>
</ncl>
