SkillBase = class("SkillBase")

SkillBase.tblHeroMetaData = {}
--[[
 name:
 needenery:
 effect:
 hurt:

 --]]

function SkillBase:ctor()
end

function SkillBase:setData(name,tbl)
    if SkillBase.tblHeroMetaData[name] then
        error(string.format("Metadata of Hero type %s has been already inited", name))
    end
    SkillBase.tblHeroMetaData[name] = tbl
end

function SkillBase:getData(name)
    return SkillBase.tblHeroMetaData[name]
end
