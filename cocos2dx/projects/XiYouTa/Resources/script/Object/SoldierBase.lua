SoldierBase = class()

SoldierBase.tblHeroMetaData = {}
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

function SoldierBase:ctor()
end

function SoldierBase:setData(name,tbl)
    if SoldierBase.tblHeroMetaData[name] then
        error(string.format("Metadata of Hero type %s has been already inited", name))
    end
    SoldierBase.tblHeroMetaData[name] = tbl
end

function SoldierBase:getData(name)
    return SoldierBase.tblHeroMetaData[name]
end
