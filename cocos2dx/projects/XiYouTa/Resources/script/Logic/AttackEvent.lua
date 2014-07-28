require "Base.extern"
require "Logic.EventBase"
require "Object.Hero"

AttackEvent = class("AttackEvent",EventBase)

function AttackEvent:ctor(Hero)
	Hero:setAttackEvent(self)
	self.Hero = Hero
end

function AttackEvent:callback()
--	TODO:
--	here do sth.
	EventManager.getInstance():callEvent()
end

function AttackEvent:call()
	self.Hero:attack()
end

