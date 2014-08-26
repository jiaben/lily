require "Object.HeroBase"
Hero = class("Hero",Object)

function Hero:ctor(heroType)
--    self._heroMeta = HeroBase:getData(heroType)
--    self._sprite = CCSprite:create(self._heroMeta["filename"])
    self.heroType = heroType
    if not self:isExistType(heroType) then
        error(heroType)
        return
    end
    self:createArmature()
    self.ccSprite = CCSprite:create()
    self.ccSprite:addChild(self.armature)
    self.ccSprite:setScale(0.4)
    self.alive = true
    self.action_node = CCNode:create()
    self.ccSprite:addChild(self.action_node)

	local progressSprite = CCSprite:create("res/ui/blue.png",CCRectMake(0,0,200,20))
--	progressSprite:setColor(ccc3(0,100,0))
	self.progress = CCProgressTimer:create(progressSprite)
	self.progress:setType(kCCProgressTimerTypeBar)
	self.progress:setMidpoint(ccp(0,1))
	self.progress:setBarChangeRate(ccp(1,0))
--	progressSprite:setAnchorPoint(ccp(0,0))

	self.progressBg = CCSprite:create("res/ui/word_cell.png",CCRectMake(0,0,200,20))
	self.progressBg:addChild(self.progress)
	local szProgressBg = self.progressBg:getContentSize()
	self.progress:setPosition(ccp(szProgressBg.width/2, szProgressBg.height/2))

	self.progress:setPercentage(100)

	local szHero = self.ccSprite:getContentSize()
	self.ccSprite:addChild(self.progressBg)
	self.progressBg:setPosition(ccp(0,300))
	self.label_name = CCLabelTTF:create("", "Arial", 40)
	self.label_name:setString(heroType)
	self.label_name:setPosition(ccp(100,50))
	self.progressBg:addChild(self.label_name)
	self.isHero = true
    self.attacking = false
    self:initpro()
end

function Hero:initpro()
    self.multi_attack = 1.0
    self.attack_speed = 1.0
    self.fight_begintime = 0
    self.skill_time = 0
    self.skill_hurt = 0
    self.skill_rage = 0
end

function Hero:setAttackSpeed(value)
    self.attack_speed = value
end

function Hero:setMultiAttack(value)
    self.multi_attack = value
end

function Hero:setSkillTime(time)
    self.skill_time = time
end

function Hero:setSkillHurt(value)
    self.skill_hurt = value
end

function Hero:setSkillRage(value)
    self.skill_rage = value
end

function Hero:isExistType(Type)
    if not g_HeroBase:isExistHero(Type) then
        return false
    end
    return true
end


function Hero:getSprite()
    return self.ccSprite
end

function Hero:setScale(f)
	self.armature:setScale(f)
end

function Hero:remove()
	self.ccSprite:removeFromParent()
end

function Hero:getArmature()
    return self.armature
end

function Hero:createArmature()
    local name = self.heroType
    self.armature = CCArmature:create(name)
    self.armature:setScaleX(2.5)
    self.armature:setScaleY(2.5)
end

function Hero:setName(name)
	self.name = name
	self.label_name:setString(name)
	if self.isEnemy then
		self.label_name:setColor(ccc3(255,0,0))
	else
		self.label_name:setColor(ccc3(0,255,0))
	end
end

function Hero:getPosition()
	return self.ccSprite:getPosition()
end

function Hero:setPosition(p)
	
    self.ccSprite:setPosition(p)
end

function Hero:setDirection(ff)
    if ff == -1 then
        local scale = self.ccSprite:getScale()
        self.armature:setScaleX(-2.5)
    end
end

function Hero:_loadResource()
end

function Hero:setMP(num)
	self.MaxMP = num
	self.MP = num
end

function Hero:walk(road)
    self:playAnimation("walk")
    local function callback()
        self:stand()
    end
    local dis = road:getDistance()
    local delay = dis / self.heroMetaData["speed"]
    performWithDelay(self._sprite, callback, delay)
end

function Hero:run()
    local loop1 = math.ceil(math.random()*20)

    --local n = math.floor(math.random()*2)+1
    local n = 1
    self.armature:getAnimation():play(string.format("run%02d",n))
end

function Hero:hurt(value)
	self.MP = self.MP - value
	if self.MP < 0 then
		self:die()
		return
	end
	self.progress:setPercentage(self.MP/self.MaxMP*100)
    if self.attacking == true then
        return
    end
	local function callback_move(armature,movementType,movementID)
		if movementType == ccs.MovementEventType.COMPLETE then
			armature:getAnimation():setMovementEventCallFunc()
			self.armature:getAnimation():play("stand")
		end
	end
	self.armature:getAnimation():setMovementEventCallFunc(callback_move)
	self.armature:getAnimation():play("suffer",-1,-1,0)
end

function Hero:die()
    self.alive = false
	local function callback_move(armature,movementType,movementID)
		if movementType == ccs.MovementEventType.COMPLETE then
			armature:getAnimation():setMovementEventCallFunc()
			self:onDieCallBack()
		end
	end
	self.armature:getAnimation():setMovementEventCallFunc(callback_move)
	self.armature:getAnimation():play("die",-1,-1,0)
    self:onDie()
end

function Hero:onDie()
    AI.getInstance():removeHero(self)
end

function Hero:onDieCallBack()
	self.ccSprite:stopAllActions()
    self.ccSprite:setVisible(false)
    local event = DeadEvent.new(self)
    EventManager.getInstance():pushEvent(event)
--  self.attackEvent:callback()
end

function Hero:dead()
    AI.getInstance():removeDeadObject(self)
	self.ccSprite:removeFromParentAndCleanup(true)
    --self.attackEvent:callback()
end

function Hero:stand()
	self.armature:getAnimation():play("stand")
end

function Hero:setAttackEvent(e)
	self.attackEvent = e
end

function Hero:attack()
    if self.alive == false or self.isOccup then
        print(" obj dead")
        --self.attackEvent:callback()
        return
    end
	if self.fight_begintime == 0 then
        self.fight_begintime = os.time()
    end
	local n = math.floor(math.random()*2)+1
    n = 1
    local function callback_move(armature,movementType,movementID)
		if movementType == ccs.MovementEventType.COMPLETE then
			armature:getAnimation():setMovementEventCallFunc()
			self.armature:getAnimation():play("stand")
            self.attacking = false
            self:nextAttack()
		end
	end
    self.armature:getAnimation():setMovementEventCallFunc(callback_move)
	self.armature:getAnimation():play(string.format("attack%02d",n),-1,-1,0)
    self.attacking = true
    local fightTime = os.time() - self.fight_begintime
    if self.skill_time ~= 0 and fightTime >= self.skill_time then
        self:doSkillAttack()
        self.fight_begintime = os.time()
    else
        self:doNormalAttack()
    end
end

function Hero:doSkillAttack()
    --print("hero:do skill attack")
	local function callback_frame(armature,movementType,movementID)
		self.armature:getAnimation():setFrameEventCallFunc()
		local enemy = AI.getInstance():getEnemy()
		local tower =  AI.getInstance():getCurrentTower()
        local tx,ty
		if enemy then
			enemy:hurt(self.skill_hurt*self.multi_attack)
            tx,ty = enemy:getPosition()
		elseif tower:isAlive() then
			tower:hurt(self.skill_hurt*self.multi_attack)
            tx,ty = tower:getPosition()
		else
			self.armature:getAnimation():play("stand")
			return
		end
        g_FightMgr:addRage(self.skill_rage)
        --CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("res/skill_eff/eff_tile_TH_atk2/sheet.plist")
        --利用帧缓存创建精灵
        --local sp = CCSprite:createWithSpriteFrameName("s1.png")
        local sp = CCSprite:create("res/skill_eff/eff_tile_TH_atk2/sheet_PList.Dir/s1.png")
        local x,y = self.ccSprite:getPosition()
        sp:setPosition(ccp(x,y))
        self.ccSprite:getParent():addChild(sp)
    
        local animFrames = CCArray:createWithCapacity(4)
        for i=1, 4 do
            local str = string.format("res/skill_eff/eff_tile_TH_atk2/sheet_PList.Dir/s%d.png", i)
            local frame = CCSpriteFrame:create(str,CCRectMake(0, 0, 272, 129))
            animFrames:addObject(frame)
        end
        local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.3)
        --animation:setLoops(-1)
        sp:runAction(CCAnimate:create(animation))

        local function skilleff_callback()
            print("skill eff end")
            sp:removeFromParentAndCleanup(true)
        end
        local callfunc = CCCallFunc:create(skilleff_callback)
        local sequence = CCSequence:createWithTwoActions(CCMoveTo:create(1.0,ccp(tx,ty)), callfunc)
        sp:runAction(sequence)
    end

	self.armature:getAnimation():setFrameEventCallFunc(callback_frame)
end

function Hero:doNormalAttack()
    local function callback_frame(armature,movementType,movementID)
		self.armature:getAnimation():setFrameEventCallFunc()
        self:calculate()
	end
	self.armature:getAnimation():setFrameEventCallFunc(callback_frame)
end

function Hero:calculate()
    local enemy = AI.getInstance():getEnemy()
    local tower =  AI.getInstance():getCurrentTower()
    if enemy then
        enemy:hurt(20*self.multi_attack)
    elseif tower:isAlive() then
        tower:hurt(20*self.multi_attack)
    else
        self.armature:getAnimation():play("stand")
        return
    end
    g_FightMgr:addRage(10)
end

function Hero:nextAttack()
    local function attack_func()
        local event = AttackEvent.new(self)
        EventManager.getInstance():pushEvent(event)
        --self.attackEvent:callback()
        self.delay = nil
    end
    self.delay = performWithDelay(self.action_node, attack_func, self.attack_speed)
end

function Hero:doSkill(skillname)
    self:playAnimation(skillname)
end

function Hero:win()
	self.armature:getAnimation():play("shengli")
end
