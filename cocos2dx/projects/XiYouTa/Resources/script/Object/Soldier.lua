require "Object.SoldierBase"
require "Object.Hero"
Soldier = class("Soldier",Hero)

function Soldier:ctor(heroType)
	Hero.ctor(self, heroType)
	self.isHero = false
end

function Soldier:isExistType(Type)
    if not g_SoldierBase:isExistSoldier(Type) then
        return false
    end
    return true
end

function Soldier:createArmature()
    local name = self.heroType
    self.armature = CCArmature:create(name)
end

function Soldier:setDirection(ff)
    if ff == -1 then
--        error("in soldier set direction")
        local scale = self.ccSprite:getScale()
        self.armature:setScaleX(-2.5)
        self.armature:setScaleY(2.5)
    end
end

function Soldier:attack()
    if self.alive == false then
        print("alive == false soldier")
        self.attackEvent:callback()
        return
    end
	local n = math.floor(math.random()*2)+1
	--self.armature:getAnimation():play(string.format("attack%02d",n),-1,-1,0)
    self.armature:getAnimation():play(string.format("attack%02d",1),-1,-1,0)

	local i = 0
	local function callback_frame(armature,movementType,movementID)
        self.armature:getAnimation():setFrameEventCallFunc()
        local tower =  AI.getInstance():getCurrentTower()
		if tower then
			tower:hurt(50)
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

function Soldier:onDie()
    AI.getInstance():removeSoldier(self)
    local tower =  AI.getInstance():getCurrentTower()
    if tower and #AI.getInstance().tbl_Soldier == 0 then
        tower:stopAlertAction()
    end
end
