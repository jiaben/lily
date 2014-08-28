require "Layers.StreetLayer"

MainLayer = class("MainLayer")

function MainLayer:scene()
    local main = MainLayer:new()
    local scene = CCScene:create()
    main:init()
    scene:addChild(main.layer)
    return scene
end

function MainLayer:ctor()
end

function MainLayer:init()
    self.layer = CCLayer:create()
    self.uiLayer = TouchGroup:create()
    self.layer:addChild(self.uiLayer)
    local uiMainLayer = NodeReader:getInstance():createNode("res/ui/MainLayer_1/MainLayer_1.ExportJson");
    self.uiLayer:addChild(uiMainLayer,1)

    local children = uiMainLayer:getChildren()
    local widgt = tolua.cast(uiMainLayer,"Widget")
    local btn = UIHelper:seekWidgetByTag(widgt,300)
    local tollgate_button = tolua.cast(btn,"Button")
    local function touchEvent(sender,eventType)
        if eventType == ccs.TouchEventType.began then
        elseif eventType == ccs.TouchEventType.moved then
        elseif eventType == ccs.TouchEventType.ended then
            CCDirector:sharedDirector():replaceScene(StreetLayer:scene())
        elseif eventType == ccs.TouchEventType.canceled then
        end
    end
    tollgate_button:addTouchEventListener(touchEvent)
end

