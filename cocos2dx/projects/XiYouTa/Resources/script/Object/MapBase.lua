MapBase = class("MapBase")

MapBase.tblHeroMetaData = {}
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

function MapBase:ctor()
end

function MapBase:setData(name,tbl)
    if MapBase.tblHeroMetaData[name] then
        error(string.format("Metadata of Hero type %s has been already inited", name))
    end
    MapBase.tblHeroMetaData[name] = tbl
end

function MapBase:getData(name)
    return MapBase.tblHeroMetaData[name]
end
