require "Object.SoldierBase"
Soldier = class("Soldier",Object)

function Soldier:ctor(soldierType)
--    self._soldierMeta = SoldierBase:getData(soldierType)
--    self._sprite = CCSprite:create(self._soldierMeta["filename"])
    self.soldierType = soldierType
    print(self.soldierType)
    if not g_SoldierBase:isExistSoldier(soldierType) then
        error(soldierType)
        return
    end
    self:createArmature()
    self.ccSprite = CCSprite:create()
    self.ccSprite:addChild(self.armature)
    self.ccSprite:setScale(0.4)
	self.MP = 80
    self.alive = true
end

function Soldier:getSprite()
    return self.ccSprite
end

function Soldier:remove()
	self.ccSprite:removeFromParent()
end

function Soldier:getArmature()
    return self.armature
end

function Soldier:createArmature()
    local name = "zhujv_"..self.soldierType
    self.armature = CCArmature:create(name)
end

function Soldier:setPosition(p)
    self.ccSprite:setPosition(p)
end

function Soldier:setDirection(d)
    if d == -1 then
        local scale = self.ccSprite:getScale()
--        self.armature:getAnimation():setFlipX(true)
        self.ccSprite:setScaleX(-1*scale)
    end
end

function Soldier:_loadResource()
end

function Soldier:setMP(num)
	self.MP = num
end

function Soldier:walk(road)
    self:playAnimation("walk")
    local function callback()
        self:stand()
    end
    local dis = road:getDistance()
    local delay = dis / self.heroMetaData["speed"]
    performWithDelay(self._sprite, callback, delay)
end

function Soldier:run()
    local loop1 = math.ceil(math.random()*20)

    local n = math.floor(math.random()*2)+1
    self.armature:getAnimation():play(string.format("run%02d",n))
end

function Soldier:hurt()
	self.MP = self.MP - 20
	if self.MP < 0 then
		if self.isEnemy then
			AI.getInstance():removeEnemy(self)
            AI.getInstance():removeSoldier(self)
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

function Soldier:die()
    self.alive = false
	local function callback_move(armature,movementType,movementID)
		if movementType == ccs.MovementEventType.COMPLETE then
			armature:getAnimation():setMovementEventCallFunc()
			self:onDie()
		end
	end
	self.armature:getAnimation():setMovementEventCallFunc(callback_move)
	self.armature:getAnimation():play("die",-1,-1,0)
end

function Soldier:onDie()
	self.ccSprite:stopAllActions()
    self.ccSprite:setVisible(false)
    local event = DeadEvent.new(self)
    EventManager.getInstance():pushEvent(event)
--    self.attackEvent:callback()
end

function Soldier:dead()
    AI.getInstance():removeDeadObject(self)
    self.ccSprite:removeFromParentAndCleanup(true)
    self.attackEvent:callback()
end

function Soldier:stand()
	self.armature:getAnimation():play("stand")
end

function Soldier:setAttackEvent(e)
	self.attackEvent = e
end

function Soldier:attack()
    if self.alive == false then
        print("alive == false soldier")
        self.attackEvent:callback()
        return
    end
	local n = math.floor(math.random()*2)+1
	self.armature:getAnimation():play(string.format("attack%02d",n),-1,-1,0)

	local i = 0
	local function callback_frame(armature,movementType,movementID)
		self.armature:getAnimation():setFrameEventCallFunc()
		local enemy = AI.getInstance():getHero()
		if enemy then
			enemy:hurt()
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

function Soldier:doSkill(skillname)
    self:playAnimation(skillname)
end

function Soldier:win()
	self.armature:getAnimation():play("shengli")
end
