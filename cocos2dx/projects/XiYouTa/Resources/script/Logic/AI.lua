require "Base.extern"
AI=class()

AI.state = {}
AI.state["normal"] 		= 0
AI.state["stand"] 		= 1
AI.state["run"]			= 2
AI.state["encounter"]	= 3
AI.state["attack"]		= 4
AI.state["hurt"]		= 5
AI.state["lose"]		= 6
AI.state["win"]			= 7


AI.camp = {}
AI.camp["player"] 		= 1
AI.camp["enemy"] 		= 2
AI.camp["npc"] 			= 3

function AI:ctor()
    self.tbl_Hero   	= StreetLayer.getInstance().tbl_Hero
    self.tbl_Tower  	= StreetLayer.getInstance().tbl_Tower
	self.tbl_Enemy		= StreetLayer.getInstance().tbl_Enemy
	self.tbl_Soldier	= StreetLayer.getInstance().tbl_Soldier
    self.state 			= AI.state.normal
    AI.instance 		= self
end

function AI.getInstance()
    return AI.instance
end


function AI:addHero(hero)
end

function AI:addTower(tower)
end

local function ai_callback()
    local self = AI:getInstance()
    if self.state == AI.state.normal then
		self.state = AI.state.stand
		self:_move()
	elseif self.state == AI.state.stand then
    elseif self.state == AI.state.run then
        if not self:_encounter() then
            return
        end
        self.state = AI.state.encounter
    elseif self.state == AI.state.encounter then
		self:_attack()
        self.state = AI.state.attack
    elseif self.state == AI.state.attack then
		self:_update()
    elseif self.state == AI.state.lose then
        self:stop()
    elseif self.state == AI.state.win then
        self:stop()
    else
        error("IN AI: undefined AI status")
    end
end

function AI:start()
    self.action_node = CCNode:create()
	StreetLayer.getInstance().layer:addChild(self.action_node,0)
    self.action = schedule(self.action_node, ai_callback, 1/30)
end

function AI:pause()
    self.action_node:pauseSchedulerAndActions()
end

function AI:resume()
    self.action_node:resumeSchedulerAndActions()
end

function AI:stop()
    self.action_node:stopAction(self.action)
end

function AI:_move()
	for i,v in pairs(self.tbl_Hero) do
		v:stand()
	end

	local function callback()
		for i,v in pairs(self.tbl_Hero) do
			v:run()
		end
		self.state = AI.state.run
	end
	performWithDelay(self.action_node, callback, 2.0)
end

function AI:_attack()

	self.curTower:alert()
	self.curTower:createSoldier()
	for i,v in pairs(self.tbl_Hero) do
		v:attack()
	end
end

function AI:_update()
--[[
	if table.maxn(self.tbl_Hero) == 0 then
        self.state = AI.state.lose
	elseif self.curTower:getMP() == 0 then
		table.remove(self.tbl_Tower,1)
		if table.maxn(self.tbl_Tower) == 0 then
			self.state = AI.state.win
		else
			self.state = AI.state.run
		end
	else
	
	end
--]]
end

function AI:_encounter()
	self.curTower = self.tbl_Tower[1]
	local pTower = self.curTower:getSprite():convertToWorldSpace(ccp(0,0))
	
	self.firstHero = self.tbl_Hero[1]
	local pHero = self.firstHero.ccSprite:convertToWorldSpace(ccp(0,0))
	
	print(pTower.x, pTower.y, pHero.x, pHero.y)
	StreetLayer.getInstance().bgLayer:runAction(CCMoveBy:create(1/30,ccp(-5,0)))
	
	return math.abs(pTower.x-pHero.x) < 200
end

function AI:_lose()
end

function AI:_KO()
end

function AI:clear()
    
end
