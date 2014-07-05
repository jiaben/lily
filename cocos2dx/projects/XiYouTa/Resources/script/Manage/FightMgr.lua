require "Base.init"
require "Base.extern"
require "Object.Hero"
require "Object.Soldier"
require "Object.Street"
require "Layers.StreetLayer"

FightMgr = class()

function FightMgr:ctor()
	self.tblFights = {}
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
