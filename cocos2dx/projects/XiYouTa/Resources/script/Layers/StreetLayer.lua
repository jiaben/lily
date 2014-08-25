require "Object.Hero"
require "Object.Soldier"
require "Object.EnemySoldier"
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
    self.tbl_EnemySoldier = {}
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
    self:initBG()
    self:addCharactor()
	self:addTower()
    self:initSoldier()
	AI.new()
	AI.getInstance():start()
end

function StreetLayer:initBG()
    for i=1, 5 do
        local bg = CCSprite:create("res/StreetScene/bbg_burning_land.jpg")
        bg:setPosition(ccp((i-0.5)*960,320))
        self.bgLayer:addChild(bg,1)
    end
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

function StreetLayer:HeroDonotMove(hero)
	hero:getSprite():retain()
	hero:getSprite():removeFromParentAndCleanup(false)
	self.bgLayer:addChild(hero:getSprite())
	hero:getSprite():release()
	local x,y = AI.getInstance():getCurrentTower():getPosition()
	hero:setScale(0.5)
	hero.isOccup = true
	hero:getSprite():setPosition(ccp(x, y-200))
end

function StreetLayer:HeroRun(f, pos)
	self.bgLayer:runAction(CCMoveBy:create(f,pos))
end

function StreetLayer:addCharactor()
    local wy = Hero.new("wuya_zhandou")
	wy:setMP(200)
	self.layer:addChild(wy:getSprite(),2)
	wy:setPosition(ccp(400,400))
	wy:setDirection(-1)
	wy:setName("乌鸦")
	table.insert(self.tbl_Hero, wy)

    --[[
    local jp = Hero.new("jiaopi")
	jp:setMP(200)
    self.layer:addChild(jp:getSprite(),2)
    jp:setPosition(ccp(150,200))
    jp:setDirection(-1)
	jp:setName("蕉皮")
	table.insert(self.tbl_Hero, jp)
    ]]
    
    
    local dt = Hero.new("datian")
	dt:setMP(200)
    self.layer:addChild(dt:getSprite(),2)
    dt:setPosition(ccp(230,400))
	dt:setDirection(-1)
	dt:setName("大天")
	table.insert(self.tbl_Hero,dt)

    local hn = Hero.new("chenhaonan")
	hn:setMP(200)
    self.layer:addChild(hn:getSprite(),2)
    hn:setPosition(ccp(320,200))
    hn:setDirection(-1)
	hn:setName("陈浩南")
	table.insert(self.tbl_Hero, hn)
end

function StreetLayer:initSoldier()
    local node = CCNode:create()
    local function callback()
        if #AI.getInstance().tbl_Soldier ~= 0 then
            return
        end
        print("create soldier count = 5")
        local soldier_tbl = {"snk"}
        for i = 1,5 do
            local index = math.ceil(math.random()*#(soldier_tbl))
            local soldier_type = soldier_tbl[index]
			local bp = Soldier.new(soldier_type)
			bp:setMP(30)
			bp.isEnemy = self.isEnemy
			bp:stand()
			self.layer:addChild(bp:getSprite(),2)
			bp:setPosition(ccp(100,i*100))
            bp:setScale(2.5)
			bp:setDirection(1)
			bp.ccSprite:setColor(ccc3(255,0,0))
			local name = string.format("士兵%03d", i)
			bp:setName(name)
            table.insert(AI.getInstance().tbl_Soldier, bp)
		end
        for i,v in pairs(AI.getInstance().tbl_Soldier) do
            local event = AttackEvent.new(v)
            EventManager.getInstance():pushEvent(event)
        end
    end
    schedule(self.layer, callback, 15)
end
