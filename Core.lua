local addonName, addon = ...

WoWToDoDB = WoWToDoDB or {}
local profile

local AceConfig = LibStub('AceConfigDialog-3.0')

addon.ACE3 = LibStub("AceAddon-3.0"):NewAddon("WowToDo", "AceConsole-3.0")

function addon.ACE3:OnInitialize()

   local profiledefaults = { profile = {

	}}

	addon:EmitEvent("onProfileSetup", profiledefaults.profile)

	addon:SetupOptionList(profiledefaults.profile)
	
	addon:EmitEvent("onOptionListSetup", addon.configOptions.args)

	LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, addon.configOptions, {'WTD', addonName})
	addon.db = LibStub("AceDB-3.0"):New("WoWToDoDB", profiledefaults)

	addon.BlizzardOptionFrame = AceConfig:AddToBlizOptions(addonName, addonName)
	addon.configOptions.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(addon.db)
	profile = addon.db.profile
	addon.db.RegisterCallback(addon, "OnprofileChanged", "OnProfileChanged")
	addon.db.RegisterCallback(addon, "OnprofileCopied", "OnProfileChanged")
	addon.db.RegisterCallback(addon, "OnprofileReset", "OnProfileChanged")
	addon:OnProfileChanged()

	addon:SetupFrames()

end

function addon.ACE3:OnEnable()
end

function addon.ACE3:OnDisable()
   
end

function addon:OnProfileChanged()
	profile = addon.db.profile

	addon:EmitEvent("OnProfileChange", profile)
end