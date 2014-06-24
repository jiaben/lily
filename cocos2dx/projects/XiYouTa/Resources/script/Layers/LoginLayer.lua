
function createLoginLayer()
	local scene = CCScene:create()
	local uiLayer = TouchGroup:create()
	local uiWidget = GUIReader:shareReader():widgetFromJsonFile("res/ui/ghm_beginLayer_ui/BeginLayerUI_1.ExportJson")
	uiLayer:addWidget(uiWidget)
	scene:addChild(uiLayer)
	CCDirector:sharedDirector():runWithScene(scene)
end