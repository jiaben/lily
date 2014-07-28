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

function Hero:playAnimation(aniName, isInfinit)
    local ani
    if isInfinit then
        self.sprite:runAction(CCRepeatForever:create(ani))
    else
        self.sprite:runAction(CCRepeatOnce:create(ani))
    end
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
	self.armature:getAnimation():play("suffer",-1,-1,0)
--	self.MP = self.MP - 20
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
		local enemy = AI.getInstance():getEnemy()
		enemy:hurt()
		self.attackEvent:callback()
	end

	local function callback_move()
		if movementType == ccs.MovementEventType.LOOP_COMPLETE then
			armature:getAnimation():play("stand")
			armature:getAnimation():setMovementEventCallFunc()
			armature:getAnimation():setMovementEventCallFunc()
		end
	end
	self.armature:getAnimation():setFrameEventCallFunc(callback_frame)
	self.armature:getAnimation():setMovementEventCallFunc(callback_move)
end

function Hero:doSkill(skillname)
    self:playAnimation(skillname)
end
