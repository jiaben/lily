require "Object.Hero"
require "Object.Soldier"
require "Logic.AI"
require "Object.Tower"
StreetLayer = class("StreetLayer")

function StreetLayer:scene()
    local street = StreetLayer:new()
    local scene = CCScene:create()
    street:init()
    scene:addChild(street.layer)
    return scene
end

function StreetLayer:ctor(name)
    self._name 		 = name
	self.tbl_Hero	 = {}
	self.tbl_Tower   = {}
	self.tbl_Enemy	 = {}
	self.tbl_Soldier = {}
	StreetLayer._instance = self
end

function StreetLayer.getInstance()
    return StreetLayer._instance
end

function StreetLayer:init()
    self.layer = CCLayer:create()
	self.bgLayer = CCLayer:create()
    self.uiLayer = GUIReader:shareReader():widgetFromJsonFile("res/ui/ghm_streetLayer_ui_1/ghm_streetLayer_ui_1.ExportJson")
    self.bgLayer:addChild(self.uiLayer,1)
	self.layer:addChild(self.bgLayer)
    self:addCharactor()
	self:addTower()
	AI.new()
	AI.getInstance():start()
end

function StreetLayer:addTower()
	local tower1 = Tower.new("res/StreetScene/Jiaotang.png")
	tower1:setPosition(ccp(1500,400))
	self.bgLayer:addChild(tower1:getSprite(), 2)
	table.insert(self.tbl_Tower, tower1)
	
	local tower2 = Tower.new("res/StreetScene/Huisuo.png")
	tower2:setPosition(ccp(2500,400))
	self.bgLayer:addChild(tower2:getSprite(), 2)
	table.insert(self.tbl_Tower, tower2)
	
	local tower3 = Tower.new("res/StreetScene/Cantin.png")
	tower3:setPosition(ccp(4000,400))
	self.bgLayer:addChild(tower3:getSprite(), 2)
	table.insert(self.tbl_Tower, tower3)

end

function StreetLayer:addCharactor()
	local wy = Hero.new("wuya_zhandou")
	wy:setMP(200)
	self.layer:addChild(wy:getSprite(),2)
	wy:setPosition(ccp(400,400))
	wy:setDirection(-1)
	wy:setName("乌鸦")
	table.insert(self.tbl_Hero, wy)

    local jp = Hero.new("jiaopi")
	jp:setMP(240)
    self.layer:addChild(jp:getSprite(),2)
    jp:setPosition(ccp(150,200))
    jp:setDirection(-1)
	jp:setName("蕉皮")
	table.insert(self.tbl_Hero, jp)

    local dt = Hero.new("datian")
	dt:setMP(120)
    self.layer:addChild(dt:getSprite(),2)
    dt:setPosition(ccp(230,400))
	dt:setDirection(-1)
	dt:setName("大天")
	table.insert(self.tbl_Hero,dt)

    local hn = Hero.new("chenhaonan")
	hn:setMP(480)
    self.layer:addChild(hn:getSprite(),2)
    hn:setPosition(ccp(320,200))
    hn:setDirection(-1)
	hn:setName("陈浩南")
	table.insert(self.tbl_Hero, hn)
end
