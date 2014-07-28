require "Base.extern"

EventBase = class("EventBase")
EventManager = class("EventManager")

function EventManager:ctor()
	self.tblEvent = {}
end


function EventManager.getInstance()
	if not EventManager._instance then
		EventManager._instance = EventManager.new()
	end
	
	return EventManager._instance
end

function EventManager:pushEvent(event)
	table.insert(self.tblEvent, event)
end

function EventManager:popEvent()
	local e = self.tblEvent[1]
	table.remove(self.tblEvent, 1)
	return e
end

function EventManager:callEvent()
	local e = self:popEvent()
	if e then
		e:call()
	end
end

function EventManager:clear()
	self.tblEvent = {}
	EventManager._instance = nil
end


function EventBase:ctor()
end

function EventBase:call()
end

function EventBase:release()
end
