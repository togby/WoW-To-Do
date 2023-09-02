local addonName, addon = ...


addon.UIWindows.SettingsWindow = {}
local window = addon.UIWindows.SettingsWindow

local size = 200

local mainFrame


function window:SetupWindow()
    local frame, button, fs -- temps used below
	-- main frame
	mainFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    mainFrame:EnableMouse(true)
	mainFrame:SetFrameStrata("MEDIUM")
	mainFrame:SetMovable(true)
	mainFrame:SetToplevel(true)
	mainFrame:RegisterEvent("ADDON_LOADED")
	mainFrame:SetScript("OnEvent", function(self, event, ...)
		if (event == "ADDON_LOADED") and select(1,...) == addonName then
			addon.profile = HaveGroupWillTravelDB
			window:LoadFramePosition()
		end
	end)
	-- Size of background
	local sizeOfBackground = size*1.5
	mainFrame:SetWidth(sizeOfBackground)
	mainFrame:SetHeight(sizeOfBackground)

	-- button size
	local backdropSize = size/2
	local backdropInsets = backdropSize/4
    mainFrame:SetBackdrop( {
		bgFile = "Interface\\Buttons\\WHITE8X8",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = backdropSize, edgeSize = backdropSize,
		insets = { left = backdropInsets, right = backdropInsets, top = backdropInsets, bottom = backdropInsets}
	})
    local BorderColor = {r = 0,g = 0,b = 0, a = 0.15}
    local BackgroundColor = {r = 0.1,g = 0,b = 0, a = 1}
	mainFrame:SetBackdropColor(BackgroundColor.r, BackgroundColor.g, BackgroundColor.b, BackgroundColor.a)
	mainFrame:SetBackdropBorderColor(BorderColor.r, BorderColor.g, BorderColor.b, BorderColor.a)

    mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)


    mainFrame:SetScript("OnMouseDown",function(self, Button)
		if ( Button == "LeftButton" ) then
			self:StartMoving()
		end
	end)
	mainFrame:SetScript("OnMouseUp",function(self, Button)
		if ( Button == "LeftButton" ) then
			self:StopMovingOrSizing()
			window:SaveFramePosition()
		end
	end)
	mainFrame:SetScript("OnHide",function(self) self:StopMovingOrSizing() end)
	mainFrame:SetClampedToScreen(true)
	button = CreateFrame("Button", nil, mainFrame, "UIPanelCloseButton")

    button:SetWidth(40)
    button:SetHeight(40)
	button:SetPoint("TOPRIGHT", mainFrame, "TOPRIGHT", -10, -10)
	button:SetScript("OnMouseDown",function()
		window:Hide()
	end)
	window:Hide()
end

function window:SaveFramePosition()
	addon.profile.SettingsFramePosX = mainFrame:GetLeft()
	addon.profile.SettingsFramePosY = mainFrame:GetTop()
end

function window:LoadFramePosition()
	mainFrame:ClearAllPoints()
	if (addon.profile.SettingsFramePosX or 0 ~= 0) or (addon.profile.SettingsFramePosY or 0 ~= 0) then
		mainFrame:SetPoint("TOPLEFT", UIParent,"BOTTOMLEFT", addon.profile.SettingsFramePosX, addon.profile.SettingsFramePosY)
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