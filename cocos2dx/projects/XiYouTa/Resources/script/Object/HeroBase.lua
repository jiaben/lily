HeroBase = class()

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

function HeroBase:ctor()
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