require "Object.SoldierBase"
require "Object.Hero"
Soldier = class("Soldier",Hero)

function Soldier:ctor(heroType)
	Hero.ctor(self, heroType)
	self.isHero = false
end

function Soldier:createArmature()
    local name = self.heroType
    self.armature = CCArmature:create(name)
end

function Soldier:setDirection(ff)
    if ff == -1 then
--        error("in soldier set direction")
        local scale = self.ccSprite:getScale()
        --self.armature:setScaleX(-2.5)
        --self.armature:setScaleY(2.5)
    end
end

function Soldier:calculate()
    local tower =  AI.getInstance():getCurrentTower()
    if tower then
        tower:hurt(50)
    else
        self.armature:getAnimation():play("stand")
        return
    end
    g_FightMgr:addRage(2)
end

function Soldier:onDie()
    g_FightMgr:addRage(5)
    AI.getInstance():removeSoldier(self)
    local tower =  AI.getInstance():getCurrentTower()
    if tower and #AI.getInstance().tbl_Soldier == 0 then
        tower:stopAlertAction()
    end
end
