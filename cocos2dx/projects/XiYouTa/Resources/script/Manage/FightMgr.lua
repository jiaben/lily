require "Base.init"
require "Base.extern"
require "Object.Hero"
require "Object.Soldier"

FightMgr = class("FightMgr")

function FightMgr:ctor()
	self.tblFights = {}
    self.rage_value = 0
end

function FightMgr:resetData()
    self.rage_value = 0
end

function FightMgr:timeOut()
	return false
end

function FightMgr:loop()
	while (not self:timeOut()) and table.maxn(self.tblFights) > 0 do
		local fighter = self.tblFights[1]
		table.remove(self.tblFights,1)
		fight:attack()
	end
end

function FightMgr:getRage()
    return self.rage_value
end

function FightMgr:addRage(value)
    self.rage_value = self.rage_value + value
end


g_FightMgr = g_FightMgr or FightMgr.new()
