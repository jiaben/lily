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

function EnemySoldier:calculate()
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
end

function EnemySoldier:onDie()
    AI.getInstance():removeEnemy(self)
end

function EnemySoldier:onRelease()
    AI.getInstance():removeEnemySoldier(self)
end
