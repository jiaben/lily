require "Object.Hero"
StreetLayer = class()

function StreetLayer:scene()
    local street = StreetLayer:new()
    local scene = CCScene:create()
    street:init()
    scene:addChild(street.layer)
    return scene
end

function StreetLayer:ctor(name)
    self._name = name
end

function StreetLayer:init()
    self.layer = CCLayer:create()
    self.uiLayer = GUIReader:shareReader():widgetFromJsonFile("res/ui/ghm_streetLayer_ui_1/ghm_streetLayer_ui_1.ExportJson")
    self.layer:addChild(self.uiLayer,1)
    self:addCharactor()
end

function StreetLayer:addCharactor()
    local bp = Hero.new("baopi")
    self.layer:addChild(bp:getSprite(),2)
    bp:setPosition(ccp(100,400))
    bp:run()
 
    local jp = Hero.new("jiaopi")
    self.layer:addChild(jp:getSprite(),2)
    jp:setPosition(ccp(300,200))
    jp:setDirection(-1)
    jp:run()

    local dt = Hero.new("datian")
    self.layer:addChild(dt:getSprite(),2)
    dt:setPosition(ccp(470,400))
    dt:run()

    local hn = Hero.new("chenhaonan")
    self.layer:addChild(hn:getSprite(),2)
    hn:setPosition(ccp(650,200))
    hn:setDirection(-1)
    hn:run()

    local wy = Hero.new("wuya_zhandou")
    self.layer:addChild(wy:getSprite(),2)
    wy:setPosition(ccp(800,400))
    wy:run()

end