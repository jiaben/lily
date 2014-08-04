require "Object.HeroBase"
Hero = class("Hero",Object)

function Hero:ctor(heroType)
--    self._heroMeta = HeroBase:getData(heroType)
--    self._sprite = CCSprite:create(self._heroMeta["filename"])
    self.heroType = heroType
    print(self.heroType)
    if not g_HeroBase:isExistHero(heroType) then
        error(heroType)
        return
    end
    self:createArmature()
    self.ccSprite = CCSprite:create()
    self.ccSprite:addChild(self.armature)
    self.ccSprite:setScale(0.4)
    self.alive = true

	local progressSprite = CCSprite:create("res/ui/blue.png",CCRectMake(0,0,200,20))
--	progressSprite:setColor(ccc3(0,100,0))
	self.progress = CCProgressTimer:create(progressSprite)
	self.progress:setType(kCCProgressTimerTypeBar)
	self.progress:setMidpoint(ccp(0,1))
	self.progress:setBarChangeRate(ccp(1,0))
--	progressSprite:setAnchorPoint(ccp(0,0))

	self.progressBg = CCSprite:create("res/ui/word_cell.png",CCRectMake(0,0,200,20))
	self.progressBg:addChild(self.progress)
	local szProgressBg = self.progressBg:getContentSize()
	self.progress:setPosition(ccp(szProgressBg.width/2, szProgressBg.height/2))

	self.progress:setPercentage(100)

	local szHero = self.ccSprite:getContentSize()
	self.ccSprite:addChild(self.progressBg)
	self.progressBg:setPosition(ccp(0,300))
	self.label_name = CCLabelTTF:create("", "Arial", 40)
	self.label_name:setString(heroType)
	self.label_name:setPosition(ccp(100,50))
	self.progressBg:addChild(self.label_name)
	self.isHero = true
end

function Hero:getSprite()
    return self.ccSprite
end

function Hero:setScale(f)
	self.armature:setScale(f)
end

function Hero:remove()
	self.ccSprite:removeFromParent()
end

function Hero:getArmature()
    return self.armature
end

function Hero:createArmature()
    local name = "zhujv_"..self.heroType
    self.armature = CCArmature:create(name)
end

function Hero:setName(name)
	self.name = name
	self.label_name:setString(name)
	if self.isEnemy then
		self.label_name:setColor(ccc3(255,0,0))
	else
		self.label_name:setColor(ccc3(0,255,0))
	end
end

function Hero:setPosition(p)
	
    self.ccSprite:setPosition(p)
end

function Hero:setDirection(d)
    if d == -1 then
        local scale = self.ccSprite:getScale()
--        self.armature:getAnimation():setFlipX(true)
        self.armature:setScaleX(-1)
    end
end

function Hero:_loadResource()
end

function Hero:setMP(num)
	self.MaxMP = num
	self.MP = num
end

function Hero:walk(road)
    self:playAnimation("walk")
    local function callback()
        self:stand()
    end
    local dis = road:getDistance()
    local delay = dis / self.heroMetaData["speed"]
    performWithDelay(self._sprite, callback, delay)
end

function Hero:run()
    local loop1 = math.ceil(math.random()*20)

    local n = math.floor(math.random()*2)+1
    self.armature:getAnimation():play(string.format("run%02d",n))
end

function Hero:hurt()
	self.MP = self.MP - 20
	if self.MP < 0 then
		self:die()
		return
	end
	self.progress:setPercentage(self.MP/self.MaxMP*100)
	local function callback_move(armature,movementType,movementID)
		if movementType == ccs.MovementEventType.COMPLETE then
			armature:getAnimation():setMovementEventCallFunc()
			self.armature:getAnimation():play("stand")
		end
	end
	self.armature:getAnimation():setMovementEventCallFunc(callback_move)
	self.armature:getAnimation():play("suffer",-1,-1,0)
end

function Hero:die()
    self.alive = false
	local function callback_move(armature,movementType,movementID)
		if movementType == ccs.MovementEventType.COMPLETE then
			armature:getAnimation():setMovementEventCallFunc()
			self:onDieCallBack()
		end
	end
	self.armature:getAnimation():setMovementEventCallFunc(callback_move)
	self.armature:getAnimation():play("die",-1,-1,0)
    self:onDie()
end

function Hero:onDie()
    AI.getInstance():removeHero(self)
end

function Hero:onDieCallBack()
	self.ccSprite:stopAllActions()
    self.ccSprite:setVisible(false)
    local event = DeadEvent.new(self)
    EventManager.getInstance():pushEvent(event)
--    self.attackEvent:callback()
end

function Hero:dead()
    AI.getInstance():removeDeadObject(self)
	self.ccSprite:removeFromParentAndCleanup(true)
    self.attackEvent:callback()
end

function Hero:stand()
	self.armature:getAnimation():play("stand")
end

function Hero:setAttackEvent(e)
	self.attackEvent = e
end

function Hero:attack()
    if self.alive == false or self.isOccup then
        print(" hero dead")
        self.attackEvent:callback()
        return
    end
	
	local n = math.floor(math.random()*2)+1
	self.armature:getAnimation():play(string.format("attack%02d",n),-1,-1,0)

	local i = 0
	local function callback_frame(armature,movementType,movementID)
		self.armature:getAnimation():setFrameEventCallFunc()
		local enemy = AI.getInstance():getEnemy()
		local tower =  AI.getInstance():getCurrentTower()
		if enemy then
			enemy:hurt()
		elseif tower:isAlive() then
			tower:hurt()
		else
			self.armature:getAnimation():play("stand")
			return
		end
        local event = AttackEvent.new(self)
		EventManager.getInstance():pushEvent(event)
		self.attackEvent:callback()
	end

	self.armature:getAnimation():setFrameEventCallFunc(callback_frame)
end

function Hero:doSkill(skillname)
    self:playAnimation(skillname)
end

function Hero:win()
	self.armature:getAnimation():play("shengli")
end
