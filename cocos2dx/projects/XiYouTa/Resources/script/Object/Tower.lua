Tower = class("Tower")

function Tower:ctor(file)
	self.ccSprite = CCSprite:create()
	self.ccTowerSprite = CCSprite:create(file)
	local menuItem = CCMenuItemSprite:create(self.ccTowerSprite, self.ccTowerSprite)
	local function menuCallback(sender)
		self.isEnemy = false
		AI.getInstance():randGetHero()
		AI.getInstance():continueBattle()
	end
	menuItem:registerScriptTapHandler(menuCallback)

	self.towerMenu = CCMenu:create()
	self.towerMenu:addChild(menuItem)
	self.towerMenu:setEnabled(false)
	self.towerMenu:setPosition(ccp(0,0))

	self.ccSprite:addChild(self.towerMenu)

	self.soldierLoop = 0
	self.alertLoop = 0
	self.soldier = {}
	self.Max_MP = 1000
	self.MP = 1000
	self.soldierIndex = 1
	self.isEnemy = true

	local progressSprite = CCSprite:create("res/ui/blue.png",CCRectMake(0,0,300,20))
	--	progressSprite:setColor(ccc3(0,100,0))
	self.progress = CCProgressTimer:create(progressSprite)
	self.progress:setType(kCCProgressTimerTypeBar)
	self.progress:setMidpoint(ccp(0,1))
	self.progress:setBarChangeRate(ccp(1,0))
	--	progressSprite:setAnchorPoint(ccp(0,0))

	self.progressBg = CCSprite:create("res/ui/word_cell.png",CCRectMake(0,0,300,20))
	self.progressBg:addChild(self.progress)
	local szProgressBg = self.progressBg:getContentSize()
	self.progress:setPosition(ccp(szProgressBg.width/2, szProgressBg.height/2))

	self.progress:setPercentage(100)
	self.ccSprite:addChild(self.progressBg,10)
	
	local szTower = self.ccTowerSprite:getContentSize()
	self.progressBg:setPosition(ccp(0,szTower.height/2-100))
	self.label_name = CCLabelTTF:create("塔", "Arial", 40)
	self.label_name:setColor(ccc3(255,0,0))
	self.label_name:setPosition(ccp(0,szTower.height/2-50))
	self.ccSprite:addChild(self.label_name)
	self.progressBg:setScaleY(0.4)
	self.progressBg:setScaleX(0.6)
end

function Tower:setClickEnabed(b)
	self.towerMenu:setEnabled(b)
end

function Tower:alert()
	local function callback()
		self.alertLoop = self.alertLoop + 1
		if self.alertLoop % 2 == 1 then
			self.ccTowerSprite:setColor(ccc3(255,0,0))
		else
			self.ccTowerSprite:setColor(ccc3(255,255,255))
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
	self.ccTowerSprite:setColor(ccc3(0,0,255))
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
		self.progress:setPercentage(100)
		self.ccSprite:stopAction(self.createSoldier_action)
		self.ccTowerSprite:setColor(ccc3(255,255,255))
		self.label_name:setColor(ccc3(0,255,0))
		return
	end
	self.progress:setPercentage(self.MP/self.Max_MP*100)
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
			bp.isEnemy = self.isEnemy
			bp:stand()
			parent:addChild(bp:getSprite(),2)
			bp:setPosition(ccp(x-200*(loop+math.random()),100+440*math.random()))
			bp:setDirection(0)
			bp.ccSprite:setColor(ccc3(255,0,0))
			local name = string.format("士兵%03d", self.soldierIndex)
			self.soldierIndex = self.soldierIndex + 1
			bp:setName(name)
			table.insert(AI.getInstance().tbl_Enemy, bp)
            table.insert(AI.getInstance().tbl_Soldier, bp)
		end
		loop = loop + 1
		self.ccTowerSprite:setColor(ccc3(255,255,255))
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