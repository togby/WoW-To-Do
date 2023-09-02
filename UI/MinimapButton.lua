local addonName, addon = ...

local MinimapButton = CreateFrame('Button', nil, Minimap)

local iconPath = "Interface/Icons/spell_arcane_teleportironforge"

local LibDataBroker = LibStub and LibStub:GetLibrary("LibDataBroker-1.1", true)

function MinimapButton:Load()
	self:SetWidth(31); self:SetHeight(31)
	self:SetFrameLevel(8)
	self:SetFrameStrata("MEDIUM")
	self:RegisterForClicks('AnyUp')
	self:RegisterForDrag('LeftButton')
	self:SetHighlightTexture('Interface/Minimap/UI-Minimap-ZoomButton-Highlight')

	local overlay = self:CreateTexture(nil, 'OVERLAY')
	overlay:SetWidth(53); overlay:SetHeight(53)
	overlay:SetTexture('Interface/Minimap/MiniMap-TrackingBorder')
	overlay:SetPoint('TOPLEFT')

	local icon = self:CreateTexture(nil, 'BACKGROUND')
	icon:SetWidth(20); icon:SetHeight(20)
	icon:SetTexture(iconPath)
	icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
	icon:SetPoint('TOPLEFT', 7, -5)
	self.icon = icon
	self:SetScript('OnDragStart', self.OnDragStart)
	self:SetScript('OnDragStop', self.OnDragStop)
	self:SetScript('OnMouseDown', self.OnMouseDown)
	self:SetScript('OnMouseUp', self.OnMouseUp)
	self:SetScript('OnEnter', self.OnEnter)
	self:SetScript('OnLeave', self.OnLeave)
	self:SetScript('OnClick', self.OnClick)
	self:Show()
	-- For Titan panel etc
	if LibDataBroker then
		LibDataBroker:NewDataObject(addonName, {
			type = "launcher",
			text = addonName,
			icon = iconPath,
			OnTooltipShow = function(tooltip)
				MinimapButton:OnTooltipShow(tooltip)
			end,
			OnClick = MinimapButton.OnClick,
		})
	end
end



function MinimapButton:OnClick(button)
	if button == 'LeftButton' then
		addon:ToggleWindow("TeleportWindowFrame")
	elseif button == 'RightButton' then
		addon:ToggleWindow("SettingsWindow")
	end
end




function MinimapButton:OnEnter()
	if not self.dragging then
		GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
		MinimapButton:OnTooltipShow(GameTooltip)
		GameTooltip:Show()
	end
end

function MinimapButton:OnTooltipShow(tooltip)
	tooltip:AddLine("Left-Click to toggle the teleport window")
	tooltip:AddLine("Right-click to open the settings menu")
end

function MinimapButton:OnLeave()
	GameTooltip:Hide()
end

function MinimapButton:OnMouseDown()
	self.icon:SetTexCoord(0, 1, 0, 1)
end

function MinimapButton:OnMouseUp()
	self.icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
end

function MinimapButton:OnDragStart()
	self.dragging = true
	self:LockHighlight()
	self.icon:SetTexCoord(0, 1, 0, 1)
	self:SetScript('OnUpdate', self.OnUpdate)
	GameTooltip:Hide()
end

function MinimapButton:OnDragStop()
	self.dragging = nil
	self:SetScript('OnUpdate', nil)
	self.icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
	self:UnlockHighlight()
end


function MinimapButton:OnUpdate()
	local mx, my = Minimap:GetCenter()
	local px, py = GetCursorPosition()
	local scale = Minimap:GetEffectiveScale()
	px, py = px / scale, py / scale
	addon.profile.MiniMapAngle = math.deg(math.atan2(py - my, px - mx)) % 360
	self:UpdatePosition()
end


function MinimapButton:UpdatePosition()
	local angle = math.rad(addon.profile.MiniMapAngle)
	local cos = math.cos(angle)
	local sin = math.sin(angle)
	local minimapShape = GetMinimapShape and GetMinimapShape() or 'ROUND'

	local round = false
	if minimapShape == 'ROUND' then
		round = true
	elseif minimapShape == 'SQUARE' then
		round = false
	elseif minimapShape == 'CORNER-TOPRIGHT' then
		round = not(cos < 0 or sin < 0)
	elseif minimapShape == 'CORNER-TOPLEFT' then
		round = not(cos > 0 or sin < 0)
	elseif minimapShape == 'CORNER-BOTTOMRIGHT' then
		round = not(cos < 0 or sin > 0)
	elseif minimapShape == 'CORNER-BOTTOMLEFT' then
		round = not(cos > 0 or sin > 0)
	elseif minimapShape == 'SIDE-LEFT' then
		round = cos <= 0
	elseif minimapShape == 'SIDE-RIGHT' then
		round = cos >= 0
	elseif minimapShape == 'SIDE-TOP' then
		round = sin <= 0
	elseif minimapShape == 'SIDE-BOTTOM' then
		round = sin >= 0
	elseif minimapShape == 'TRICORNER-TOPRIGHT' then
		round = not(cos < 0 and sin > 0)
	elseif minimapShape == 'TRICORNER-TOPLEFT' then
		round = not(cos > 0 and sin > 0)
	elseif minimapShape == 'TRICORNER-BOTTOMRIGHT' then
		round = not(cos < 0 and sin < 0)
	elseif minimapShape == 'TRICORNER-BOTTOMLEFT' then
		round = not(cos > 0 and sin < 0)
	end

	local x, y
	if round then
		x = cos*80
		y = sin*80
	else
		x = math.max(-82, math.min(110*cos, 84))
		y = math.max(-86, math.min(110*sin, 82))
	end

	self:SetPoint('CENTER', x, y)
end

MinimapButton:Load()
