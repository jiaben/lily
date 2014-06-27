TowerBase = class()

TowerBase.tblHeroMetaData = {}
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

function TowerBase:ctor()
end

function TowerBase:setData(name,tbl)
    if TowerBase.tblHeroMetaData[name] then
        error(string.format("Metadata of Hero type %s has been already inited", name))
    end
    TowerBase.tblHeroMetaData[name] = tbl
end

function TowerBase:getData(name)
    return TowerBase.tblHeroMetaData[name]
end
