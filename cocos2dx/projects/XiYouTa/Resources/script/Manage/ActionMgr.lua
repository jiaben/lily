require "Base.init"
ActionMgr = class("ActionMgr")
ActionData = class("ActionData")

function ActionData:ctor(target, action)
	self.target = target
	self.action = action
end

function ActionMgr:ctor()
	self.isSequenceAction = false
	self.tbl_sequenceAction = {}
	self.tbl_immidiatAction = {}
end

function ActionMgr:addActionSequence(target, action)
	local act = ActionData.new(target, action)
	table.insert(self.tbl_sequenceAction, act)
end

function ActionMgr:excuteActionImmidietly(target, action)
	target:runAction(action)
end

function ActionMgr:executeActionSequence()
	if not self.isSequenceAction then
		return
	end
	if table.maxn(self.tbl_sequenceAction) == 0 then
		return
	end
	self.isSequenceAction = true
	local act = self.tbl_sequenceAction[1]
	table.remove(self.tbl_sequenceAction,1)
	local callback = function()
		self.isSequenceAction = false
		g_ActionMgr:sequenceActionCallback()
	end
	local callfunc = CCCallFunc:create(callback)
	local seq = CCSequence:createWithTwoActions(act.action, callfunc)
	act.target:runAction(seq)	
end

function ActionMgr:sequenceActionCallback()
	self:_callNextAction()
end

function ActionMgr:_callNextAction()
	self:executeActionSequence()
end

g_ActionMgr = g_ActionMgr or ActionMgr.new()

local node = CCNode:create()
local callback = function()
if not g_ActionMgr.isSequenceAction then
	g_ActionMgr:executeActionSequence()
end
schedule(node, callback, 0.01)
