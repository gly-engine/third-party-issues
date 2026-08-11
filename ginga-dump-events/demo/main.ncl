<?xml version='1.0' encoding='utf-8'?>
<ncl id="ginga-app">
  <head>
    <regionBase><region id='luaRegion' width='100%' height='100%'/></regionBase>
    <descriptorBase><descriptor id='luaDesc' region='luaRegion' focusIndex='0'/></descriptorBase>
    <connectorBase>
      <causalConnector id="onBeginSet">
        <connectorParam name="var"/>
        <simpleCondition role="onBegin"/>
        <simpleAction role="set" value="$var"/>
      </causalConnector>
     </connectorBase>
  </head>
  <body>
    <port id='init' component='lua'/>
    <media id='lua' descriptor='luaDesc' src='app.lua'/>
    <media type="application/x-ginga-settings" id="settings">
      <property name="service.currentKeyMaster" value="application"/>
    </media>
    <link xconnector="onBeginSet">
      <bind role="onBegin" component="lua"/>
      <bind role="set" component="settings" interface="service.currentKeyMaster">
        <bindParam name="var" value="lua"/>
      </bind>
    </link>
  </body>
</ncl>
