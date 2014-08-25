require "Object.SoldierBase"
require "Object.Hero"
EnemySoldier = class("EnemySoldier",Hero)

function EnemySoldier:ctor(heroType)
	Hero.ctor(self, heroType)
	self.isHero = false
end

function EnemySoldier:isExistType(Type)
    if not g_SoldierBase:isExistSoldier(Type) then
        return false
    end
    return true
end

function EnemySoldier:createArmature()
    local name = "zhujv_"..self.heroType
    self.armature = CCArmature:create(name)
end

function EnemySoldier:setDirection(ff)
    if ff == -1 then
--        error("in soldier set direction")
        local scale = self.ccSprite:getScale()
        --self.armature:setScaleX(-0.4)
        --self.armature:setScaleY(0.4)
    end
end

function EnemySoldier:attack()
    if self.alive == false then
        print("alive == false enemy soldier")
        self.attackEvent:callback()
        return
    end
	local n = math.floor(math.random()*2)+1
	--self.armature:getAnimation():play(string.format("attack%02d",n),-1,-1,0)
    self.armature:getAnimation():play(string.format("attack%02d",1),-1,-1,0)

	local i = 0
	local function callback_frame(armature,movementType,movementID)
        self.armature:getAnimation():setFrameEventCallFunc()
        local soldier = AI.getInstance():getSoldier()
		local hero = AI.getInstance():getHero()
		if soldier then
			soldier:hurt(20)
        elseif hero then
            hero:hurt(10)
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

function EnemySoldier:onDie()
    AI.getInstance():removeEnemy(self)
    AI.getInstance():removeEnemySoldier(self)
end
