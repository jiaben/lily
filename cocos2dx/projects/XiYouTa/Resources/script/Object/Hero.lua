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
        self.ccSprite:setFlipX(true)
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
    self.armature:getAnimation():play("run01")
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
