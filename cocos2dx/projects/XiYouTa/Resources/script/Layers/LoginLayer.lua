require "Layers.StreetLayer"

function createLoginLayer()
	local scene = CCScene:create()
	local uiLayer = TouchGroup:create()
	local uiWidget = GUIReader:shareReader():widgetFromJsonFile("res/ui/ghm_beginLayer_ui/BeginLayerUI_1.ExportJson")
	uiLayer:addWidget(uiWidget)
    local btn = uiWidget:getChildByName("Enter")
    
    local function touchEvent(sender,eventType)
        if eventType == ccs.TouchEventType.began then
        elseif eventType == ccs.TouchEventType.moved then
        elseif eventType == ccs.TouchEventType.ended then
            CCDirector:sharedDirector():replaceScene(StreetLayer:scene())
        elseif eventType == ccs.TouchEventType.canceled then
        end
    end
    
    btn:addTouchEventListener(touchEvent)
	scene:addChild(uiLayer)
	CCDirector:sharedDirector():runWithScene(scene)
end

