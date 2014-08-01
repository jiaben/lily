Tower = class("Tower")

function Tower:ctor(file)
	self.ccSprite = CCSprite:create(file)
	self.soldierLoop = 0
	self.alertLoop = 0
	self.soldier = {}
	self.MP = 3000
end

function Tower:alert()
	local function callback()
		self.alertLoop = self.alertLoop + 1
		if self.alertLoop % 2 == 1 then
			self.ccSprite:setColor(ccc3(255,0,0))
		else
			self.ccSprite:setColor(ccc3(255,255,255))
		end
	end
	self.alert_action = schedule(self.ccSprite, callback, 0.5)
end

function Tower:win()
	if self.alert_action then
		self.ccSprite:stopAction(self.alert_action)
		self.alert_action = nil
	end
	
	if self.createSoldier_action then
		self.ccSprite:stopAction(self.createSoldier_action)
		self.createSoldier_action = nil
	end
	self.ccSprite:setColor(ccc3(0,0,255))
end

function Tower:getSprite()
	return self.ccSprite
end

function Tower:getPosition()
	return self.ccSprite:getPosition()
end

function Tower:setPosition(p)
	self.ccSprite:setPosition(p)
end

function Tower:isAlive()
	return self.MP > 0
end

function Tower:hurt()
	self.MP = self.MP - 40
	if self.MP <= 0 then
		if self.alert_action then
			self.ccSprite:stopAction(self.alert_action)
			self.alert_action = nil
		end
		self.ccSprite:stopAction(self.createSoldier_action)
		self.ccSprite:setColor(ccc3(0,255,0))
		return
	end
	if not self.alert_action then
		self:alert()
	end
end

function Tower:createSoldier()
	local x,y = self.ccSprite:getPosition()
	print(x,y)
	local parent = self.ccSprite:getParent()
	local loop = 1
	local function callback()
		for i = 1,4 do
			local bp = Soldier.new("baopi")
			bp:setMP(80)
			bp.isEnemy = true
			bp:stand()
			parent:addChild(bp:getSprite(),2)
			bp:setPosition(ccp(x-100*(loop+math.random()),100+440*math.random()))
			bp:setDirection(0)
			bp.ccSprite:setColor(ccc3(255,0,0))
			table.insert(AI.getInstance().tbl_Enemy, bp)
            table.insert(AI.getInstance().tbl_Soldier, bp)
		end
		loop = loop + 1
		self.ccSprite:setColor(ccc3(255,255,255))
		if self.alert_action then
			self.ccSprite:stopAction(self.alert_action)
			self.alert_action = nil
		end
	end
	callback()
	
	self.createSoldier_action = schedule(self.ccSprite, callback, 30)
end

function Tower:clear()
end