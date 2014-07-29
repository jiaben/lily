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
		if self.alertLoop > 5 then
			self.ccSprite:setColor(ccc3(255,255,255))
			self.ccSprite:stopAction(self.alert_action)
		elseif self.alertLoop % 2 == 1 then
			self.ccSprite:setColor(ccc3(255,0,0))
		else
			self.ccSprite:setColor(ccc3(255,255,255))
		end
	end
	self.alert_action = schedule(self.ccSprite, callback, 0.5)
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
	print("tower", self.MP)
	return self.MP > 0
end

function Tower:hurt()
	self.MP = self.MP - 20
end

function Tower:createSoldier()
	local x,y = self.ccSprite:getPosition()
	print(x,y)
	local parent = self.ccSprite:getParent()
	local loop = 1
	local function callback()
		for i = 1,4 do
			local bp = Hero.new("baopi")
			bp.isEnemy = true
			bp:stand()
			parent:addChild(bp:getSprite(),2)
			bp:setPosition(ccp(x-100*(loop+math.random()),100+440*math.random()))
			bp:setDirection(0)
			bp.ccSprite:setColor(ccc3(255,0,0))
			table.insert(AI.getInstance().tbl_Enemy, bp)
		end
		loop = loop + 1
	end
	callback()
	
	self.createSoldier_action = schedule(self.ccSprite, callback, 30)
end

function Tower:clear()
end