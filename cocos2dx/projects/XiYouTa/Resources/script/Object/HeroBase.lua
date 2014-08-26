HeroBase = class("HeroBase")

HeroBase.tblHeroMetaData = {}
--[[
 name:
 filename:
 speed:
 animation:
    walk
    stand
    die
    skills:
        [{},{}]
 --]]

g_tblZhujv = {"Panda","snk","xiaozuanfeng"}
function HeroBase:ctor()
    self.hero = {}
    for i, v in pairs(g_tblZhujv) do
        local path = string.format("res/animation/%s/%s.ExportJson", v, v)
        CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(path)
        self.hero[v] = true
    end
end

function HeroBase:isExistHero(name)
    return self.hero[name]
end

function HeroBase:setData(name,tbl)
    if HeroBase.tblHeroMetaData[name] then
        error(string.format("Metadata of Hero type %s has been already inited", name))
    end
    HeroBase.tblHeroMetaData[name] = tbl
end

function HeroBase:getData(name)
    return HeroBase.tblHeroMetaData[name]
end

g_HeroBase = g_HeroBase or HeroBase.new()