require "Object.SoldierBase"
Soldier = class("Soldier",Hero)

function Soldier:onDie()
    AI.getInstance():removeEnemy(self)
    AI.getInstance():removeSoldier(self)
end

