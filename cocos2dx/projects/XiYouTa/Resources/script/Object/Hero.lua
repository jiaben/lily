require "Object.HeroBase"
Hero = class(Object)

function Hero:ctor(heroType)
--    self._heroMeta = HeroBase:getData(heroType)
--    self._sprite = CCSprite:create(self._heroMeta["filename"])
    self.heroType = heroType
    print(self.heroType)
    if not g_HeroBase:isExistHero(heroType) then
        error(heroType)
        return
    end
    self:createArmature()
    self.ccSprite = CCSprite:create()
    self.ccSprite:addChild(self.armature)
    self.ccSprite:setScale(0.4)
end

function Hero:getSprite()
    return self.ccSprite
end

function Hero:getArmature()
    return self.armature
end

function Hero:createArmature()
    local name = "zhujv_"..self.heroType
    self.armature = CCArmature:create(name)
end

function Hero:setPosition(p)
    self.ccSprite:setPosition(p)
end

function Hero:setDirection(d)
    if d then
        local scale = self.ccSprite:getScale()
--        self.armature:getAnimation():setFlipX(true)
        self.ccSprite:setScaleX(-1*scale)
    end
end

function Hero:_loadResource()
end

function Hero:playAnimation(aniName, isInfinit)
    local ani
    if isInfinit then
        self.sprite:runAction(CCRepeatForever:create(ani))
    else
        self.sprite:runAction(CCRepeatOnce:create(ani))
    end
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

    local n = math.floor(math.random()*2)+1
    self.armature:getAnimation():play(string.format("run%02d",n),-1,-1,loop1)
    
    local t1 = 0
    
    local function callback(armature,movementType,movementID)
        local id = movementID
        if movementType == ccs.MovementEventType.LOOP_COMPLETE then
            if id == "run01" or id == "run02" then
                t1 = t1 + 1
                if t1 >= loop1 then
                    local n = math.floor(math.random()*2)+1
                    local loop2 = math.ceil(math.random()*20)
                    armature:getAnimation():play(string.format("attack%02d",n),-1,-1,loop2)
                end
            elseif id == "attack02" or id == "attack01" then
                armature:stopAllActions()
                armature:getAnimation():play("die",-1,-1,1)
            elseif id == "die" then
            --    armature:getAnimation():stop()
                armature:getAnimation():play("stand")
                armature:getAnimation():setMovementEventCallFunc()
            end
        end
    end
    self.armature:getAnimation():setMovementEventCallFunc(callback)
end

function Hero:stand()
    self:playAnimation("stand", true)
end

function Hero:attack()
    self:playAnimation("attack")
end

function Hero:doSkill(skillname)
    self:playAnimation(skillname)
end
