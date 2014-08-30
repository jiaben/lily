require "Object.Hero"
require "Object.Soldier"
require "Object.EnemySoldier"
require "Logic.AI"
require "Object.Tower"
require "Manage.FightMgr"
require "Skill.CardEffect"
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
    self:initHeroButton()
	self:addTower()
    self:initSoldier()
	AI.new()
	AI.getInstance():start()
    local function update(dt)
        AI.getInstance():update(dt)
    end
    self.uiLayer:scheduleUpdateWithPriorityLua(update,0)
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
    local wy = Hero.new("Panda")
    wy:setEntityID(1)
	wy:setMP(200)
    wy:setSkillTime(30)
    wy:setSkillHurt(50)
    wy:setSkillRage(50)
    wy:setAttackSpeed(2.0)
	self.layer:addChild(wy:getSprite(),2)
	wy:setPosition(ccp(230,340))
	wy:setDirection(1)
	wy:setName("熊猫")
	table.insert(self.tbl_Hero, wy)

    --[[
    local jp = Hero.new("snk")
	jp:setMP(200)
    self.layer:addChild(jp:getSprite(),2)
    jp:setPosition(ccp(150,200))
    jp:setDirection(1)
	jp:setName("哪吒")
	table.insert(self.tbl_Hero, jp)
    ]]
    
    
    local dt = Hero.new("honghaier")
    dt:setEntityID(2)
	dt:setMP(200)
    dt:setSkillTime(15)
    dt:setSkillHurt(20)
    dt:setSkillRage(20)
    wy:setAttackSpeed(2.0)
    self.layer:addChild(dt:getSprite(),2)
    dt:setPosition(ccp(400,340))
	dt:setDirection(-1)
    dt.armature:setScaleX(-1)
    dt.armature:setScaleY(1)
	dt:setName("红孩儿")
	table.insert(self.tbl_Hero,dt)

    local hn = Hero.new("xiaozuanfeng")
    hn:setEntityID(3)
	hn:setMP(200)
    hn:setSkillTime(60)
    hn:setSkillHurt(100)
    hn:setSkillRage(120)
    wy:setAttackSpeed(2.0)
    self.layer:addChild(hn:getSprite(),2)
    hn:setPosition(ccp(320,150))
    hn:setDirection(-1)
	hn:setName("小钻风")
	table.insert(self.tbl_Hero, hn)
end

function StreetLayer:initHeroButton()
    --self.uiFightLayer = GUIReader:shareReader():widgetFromJsonFile("res/ui/FightLayer_1/FightLayer_1.ExportJson")
    self.uiFightLayer = NodeReader:getInstance():createNode("res/ui/FightLayer_1/FightLayer_1.ExportJson");
    self.layer:addChild(self.uiFightLayer,1)
    self.tbl_hpbar = {}
    
    local children = self.uiFightLayer:getChildren()
    print("children count" , children:count())
    --for i=0,children:count()-1,1  do
        --local object = children:objectAtIndex(i)
        --local obj2  = tolua.cast(object, "CCNode")
        self.tbl_cardbtn = {}
        self.card_action = {}
        for j=1,3 do
            local widgt = tolua.cast(self.uiFightLayer,"Widget")
            local btn = UIHelper:seekWidgetByTag(widgt,120+j)
            --print(tolua.type(btn))
            local card_button = tolua.cast(btn,"Button")
            print(tolua.type(card_button))
            local function touchEvent(sender,eventType)
                if eventType == ccs.TouchEventType.began then
                elseif eventType == ccs.TouchEventType.moved then
                elseif eventType == ccs.TouchEventType.ended then
                    --print("card btn clk :::",j)
                    local rage = g_FightMgr:getRage()
                    local eff
                    if j == 1 and rage > 200 then
                        eff = CardEffect.new("card_a",200,"eff_add_attack")
                    elseif j == 2  and rage > 100 then
                        eff = CardEffect.new("card_b",100,"eff_aoe_hurt")
                    elseif j == 3  and rage > 50 then
                        eff = CardEffect.new("card_c",50,"eff_add_soldier")
                    end
                    if eff then
                        local ret = eff:doEffect()
                        if ret == true then
                            for n = 1, 3 do
                                if self.card_action[n] then
                                    self.tbl_cardbtn[n]:stopAllActions()
                                    self.tbl_cardbtn[n]:setPosition(ccp(self.card_action[n][2],self.card_action[n][3]))
                                    --self.card_action[n] = nil
                                end
                            end
                            self.card_action = {}
                        end
                    end
                elseif eventType == ccs.TouchEventType.canceled then
                end
            end
            card_button:addTouchEventListener(touchEvent)
            self.tbl_cardbtn[j] = card_button
            --self.tbl_cardbtn[j]:setEnabled(false)
        end
        self.tbl_hpbar={}
        for j=1,3 do
            local widgt = tolua.cast(self.uiFightLayer,"Widget")
            local bar = UIHelper:seekWidgetByTag(widgt,110+j)
            local hp_bar = tolua.cast(bar,"LoadingBar")
            --hp_bar:setDirection(1)
            self.tbl_hpbar[j]=hp_bar
        end

        local widgt = tolua.cast(self.uiFightLayer,"Widget")
        self.rage_Label = UIHelper:seekWidgetByTag(widgt,10)
        print("rage_Label",tolua.type(self.rage_Label))
        self.rage_Label = tolua.cast(self.rage_Label,"LabelAtlas")
        print("rage_Label",tolua.type(self.rage_Label))
        self.rage_Label:setStringValue("0")
        
        local widgt = tolua.cast(self.uiFightLayer,"Widget")
        local back_btn = UIHelper:seekWidgetByTag(widgt,138)
        self.back_button = tolua.cast(back_btn,"Button")
        local function touchEvent(sender,eventType)
            if eventType == ccs.TouchEventType.began then
            elseif eventType == ccs.TouchEventType.moved then
            elseif eventType == ccs.TouchEventType.ended then
                CCDirector:sharedDirector():replaceScene(MainLayer:scene())
            end
        end
        self.back_button:addTouchEventListener(touchEvent)
        self.back_button:setVisible(false)
    --end
end

function StreetLayer:updateHeroHP(entityId, hp, Maxhp)
    if self.tbl_hpbar[entityId] then
        self.tbl_hpbar[entityId]:setPercent(hp/Maxhp*100)
    end
end

function StreetLayer:updateRage()
    local rage = g_FightMgr:getRage()
    self.rage_Label:setStringValue(rage)
    if rage >= 200 and self.card_action[1] == nil then
        --self.tbl_cardbtn[1]:setEnabled(true)
        self.card_action[1] = {self.tbl_cardbtn[1]:runAction(CCJumpBy:create(5.0,ccp(0,0),20,15)),self.tbl_cardbtn[1]:getPosition()}
    end
    if rage >= 100 and self.card_action[2] == nil then
        self.card_action[2] = {self.tbl_cardbtn[2]:runAction(CCJumpBy:create(5.0,ccp(0,0),20,15)),self.tbl_cardbtn[2]:getPosition()}
        --self.tbl_cardbtn[2]:setEnabled(true)
    end
    if rage >= 50  and self.card_action[3] == nil then
        --self.tbl_cardbtn[3]:setEnabled(true)
        self.card_action[3] = {self.tbl_cardbtn[3]:runAction(CCJumpBy:create(5.0,ccp(0,0),20,15)),self.tbl_cardbtn[3]:getPosition()}
    end
end

function StreetLayer:initSoldier()
    local node = CCNode:create()
    local function callback()
        if #AI.getInstance().tbl_Soldier ~= 0 then
            return
        end
        if #(AI.getInstance().tbl_Hero) == 0 then
            return
        end
        print("create soldier count = 5")
        self:createSoldier()
    end
    schedule(self.layer, callback, 15)
end

function StreetLayer:createSoldier()
    if AI.getInstance():getState() ~= AI.state.attack then
        return
    end
    local soldier_tbl = {"snk"}
    for i = 1,5 do
        local index = math.ceil(math.random()*#(soldier_tbl))
        local soldier_type = soldier_tbl[index]
        local bp = Soldier.new(soldier_type)
        bp:setMP(30)
        bp.isEnemy = self.isEnemy
        bp:stand()
        self.layer:addChild(bp:getSprite(),2)
        bp:setPosition(ccp(100,520-i*90))
        bp:setScale(2.5)
        bp:setDirection(1)
        bp.ccSprite:setColor(ccc3(255,0,0))
        local name = string.format("士兵%03d", i)
        bp:setName(name)
        table.insert(AI.getInstance().tbl_Soldier, bp)
        local event = AttackEvent.new(bp)
        EventManager.getInstance():pushEvent(event)
    end
end


function StreetLayer:FightLose()
    self.back_button:setVisible(true)
end

