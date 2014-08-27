CardEffect = class("CardEffect")

CardEffect.tblCardMetaData = {}
--[[
 name:
 needenery:
 effect:
 hurt:

 --]]

function CardEffect:ctor(name,cost,effect)
    self.name = name
    self.cost = cost
    self.effect = effect
end

function CardEffect:doEffect()
    print("do effect .....")
    if g_FightMgr:getRage() < self.cost then
        return false
    end
    g_FightMgr:addRage(0-self.cost)
    StreetLayer.getInstance():updateRage()
    if self.effect == "eff_add_attack" then
        self:addHeroAttack()
    elseif self.effect == "eff_aoe_hurt" then
        self:aoeHurt()
    elseif self.effect == "eff_add_soldier" then
        self:addSoldier()
    end
    return true
end

function CardEffect:addHeroAttack()
    for i,v in pairs(AI.getInstance().tbl_Hero) do
		v:addMultiAttack(0.5)
        local buff = CCSprite:create("res/skill_eff/eff_tile_TH_atk2/sheet_PList.Dir/light_buff_1.png")
        buff:setPosition(ccp(0,400))
        v:getSprite():addChild(buff)
	end
end

function CardEffect:aoeHurt()
    for i,v in pairs(AI.getInstance().tbl_EnemySoldier) do
        v:hurt(300)
        local sp = CCSprite:create("res/skill_eff/eff_impact_Zeus_ult/sheet_PList.Dir/s_1.png")
        --local x,y = v.getSprite().ccSprite:getPosition()
        sp:setPosition(ccp(0,0))
        v:getSprite():addChild(sp)
    
        local animFrames = CCArray:createWithCapacity(4)
        for i=1, 6 do
            local str = string.format("res/skill_eff/eff_impact_Zeus_ult/sheet_PList.Dir/s_%d.png", i)
            local frame = CCSpriteFrame:create(str,CCRectMake(0, 0, 118, 482))
            animFrames:addObject(frame)
        end
        local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.1)
        local function skilleff_callback()
            print("skill eff end")
            sp:removeFromParentAndCleanup(true)
        end
        local callfunc = CCCallFunc:create(skilleff_callback)
        local sequence = CCSequence:createWithTwoActions(CCAnimate:create(animation), callfunc)
        sp:runAction(sequence)
    end
end

function CardEffect:addSoldier()
    StreetLayer.getInstance():createSoldier()
end

