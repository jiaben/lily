require "Object.SoldierBase"
require "Object.Hero"
Soldier = class("Soldier",Hero)

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

function Soldier:onDie()
    AI.getInstance():removeEnemy(self)
    AI.getInstance():removeSoldier(self)
end
