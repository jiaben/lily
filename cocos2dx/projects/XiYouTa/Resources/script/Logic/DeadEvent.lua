require "Base.extern"
require "Logic.EventBase"
require "Object.Hero"

DeadEvent = class("DeadEvent",EventBase)

function DeadEvent:ctor(Hero)
	Hero:setAttackEvent(self)
	self.Hero = Hero
end

function DeadEvent:callback()
--	TODO:
--	here do sth.
	EventManager.getInstance():callEvent()
end

function DeadEvent:call()
    self.Hero:dead()
end

