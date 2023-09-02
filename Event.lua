
local addonName, addon = ...


--event system is from https://github.com/slime73/Lua-Event/blob/master/event.lua

local functionCallBacks = {}

function addon:EmitEvent(Name, ...)
	functionCallBacks:Emit(Name, ...)
end

function addon:RegisterCallback(Name, callbackFunc)
	assert(type(callbackFunc) =="function", "arg2 has to be a function")
	functionCallBacks:add(Name, callbackFunc)
end

functionCallBacks.eventlist = {}

function functionCallBacks:add(Name, callbackFunc)
	functionCallBacks.eventlist[Name] = functionCallBacks.eventlist[Name] or {}
	functionCallBacks.eventlist[Name][callbackFunc] = true
end

function functionCallBacks:Emit(Name, ...)
	local eventlist = functionCallBacks.eventlist[Name] or {}
	for callbackFunction, _ in pairs(eventlist) do
		callbackFunction(unpack({...}))
	end
end