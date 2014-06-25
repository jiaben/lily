Hero = class()

function Hero:ctor(heroType)
    self._heroMeta = HeroBase:getData(heroType)
    self._sprite = CCSprite:create(self._heroMeta["filename"])
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
    performWithDelay(self._sprite, callback delay)
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

function Hero
