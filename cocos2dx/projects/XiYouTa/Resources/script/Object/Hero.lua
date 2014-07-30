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
	self.MP = 120
end

function Hero:getSprite()
    return self.ccSprite
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

function Hero:setPosition(p)
    self.ccSprite:setPosition(p)
end

function Hero:setDirection(d)
    if d == -1 then
        local scale = self.ccSprite:getScale()
--        self.armature:getAnimation():setFlipX(true)
        self.ccSprite:setScaleX(-1*scale)
    end
end

function Hero:_loadResource()
end

function Hero:setMP(num)
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
		if self.isEnemy then
			AI.getInstance():removeEnemy(self)
		end
		self:die()
		return
	end
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
	local function callback_move(armature,movementType,movementID)
		if movementType == ccs.MovementEventType.COMPLETE then
			armature:getAnimation():setMovementEventCallFunc()
			self:release()
		end
	end
	self.armature:getAnimation():setMovementEventCallFunc(callback_move)
	self.armature:getAnimation():play("die",-1,-1,0)
end

function Hero:release()
	self.ccSprite:stopAllActions()
	self.ccSprite:removeFromParentAndCleanup(true)
end

function Hero:stand()
	self.armature:getAnimation():play("stand")
end

function Hero:setAttackEvent(e)
	self.attackEvent = e
end

function Hero:attack()

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
