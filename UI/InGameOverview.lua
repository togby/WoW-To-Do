local addonName, addon = ...

local profile
addon:RegisterCallback("OnProfileChange", function(newProfile)
	profile = newProfile
end)


addon.UIWindows.InGameOverview = {}
local window = addon.UIWindows.InGameOverview


local mainFrame

local size = 50



function window:SetupWindow()
	local factory = addon.FrameFactory
	-- main frame
	mainFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    window:LoadFramePosition()
    --mainFrame:Hide()


	factory:CreateFontString(mainFrame, "Wow To Do List", 0,0, 300,50)

    mainFrame:SetMouseClickEnabled()
	mainFrame:SetMouseMotionEnabled()
	mainFrame:SetFrameStrata("MEDIUM")
	mainFrame:SetMovable(true)
	mainFrame:SetToplevel(true)
	
	mainFrame:SetWidth(300)
	mainFrame:SetHeight(500)

	-- button size
	local backdropSize = size/2
	local backdropInsets = backdropSize/4
    mainFrame:SetBackdrop( {
		bgFile = "Interface\\Buttons\\WHITE8X8",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = backdropSize, edgeSize = backdropSize,
		insets = { left = backdropInsets, right = backdropInsets, top = backdropInsets, bottom = backdropInsets}
	})
    local BorderColor = {r = 0.1,g = 0.1,b = 0.1, a = 0.25}
    local BackgroundColor = {r = 0,g = 0,b = 0.1, a = 0.3}
	mainFrame:SetBackdropColor(BackgroundColor.r, BackgroundColor.g, BackgroundColor.b, BackgroundColor.a)
	mainFrame:SetBackdropBorderColor(BorderColor.r, BorderColor.g, BorderColor.b, BorderColor.a)

    mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)


    mainFrame:SetScript("OnMouseDown",function(self, button)
		if ( button == "LeftButton" ) then
			self:StartMoving()
		end
	end)
	mainFrame:SetScript("OnMouseUp",function(self, button)
		if ( button == "LeftButton" ) then
			self:StopMovingOrSizing()
			window:SaveFramePosition()
		end
	end)
	mainFrame:SetScript("OnHide",function(self) self:StopMovingOrSizing() end)
	mainFrame:SetClampedToScreen(true)

	local toDoListFrame = CreateFrame("Frame", nil, mainFrame, "BackdropTemplate")
	toDoListFrame:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 5, -50)
	toDoListFrame:SetWidth(mainFrame:GetWidth()-10)
	toDoListFrame:SetHeight(mainFrame:GetHeight()-100)

	window.ToDoList:Setup(toDoListFrame)

end

function window:SaveFramePosition()
	profile.mainFramePosX = mainFrame:GetLeft()
	profile.mainFramePosY = mainFrame:GetTop()
end

function window:LoadFramePosition()
	mainFrame:ClearAllPoints()
	if (addon.db.profile.mainFramePosX or 0 ~= 0) or (profile.mainFramePosY or 0 ~= 0) then
		mainFrame:SetPoint("TOPLEFT", UIParent,"BOTTOMLEFT", profile.mainFramePosX, profile.mainFramePosY)
	else
		mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	end
end

function window:Show()
	if (InCombatLockdown()) then
		return
	end
	ShowUIPanel(mainFrame)
end

function window:Hide()
	if (InCombatLockdown()) then
		return
	end
	HideUIPanel(mainFrame)
end

function window:isWindowHidden()
	return mainFrame:IsShown() == false
end