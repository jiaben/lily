SoldierBase = class("SoldierBase")

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

g_tblSoldier = {"Panda","snk"}

function SoldierBase:ctor()
    self.soldier = {}
    for i, v in pairs(g_tblSoldier) do
        local path = string.format("res/animation/%s/%s.ExportJson", v, v)
        CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(path)
        self.soldier[v] = true
    end
end

function SoldierBase:isExistSoldier(name)
    return self.soldier[name]
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

g_SoldierBase = g_SoldierBase or SoldierBase.new()
