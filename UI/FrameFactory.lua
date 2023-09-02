local addonName, addon = ...

addon.FrameFactory = {}
local factory = addon.FrameFactory


local teleportButtonPool = CreateFramePool("Button", nil, "SecureActionButtonTemplate")


function factory:CreateToDoListRow(toDoData, parent)

    toDoData.button = teleportButtonPool:Acquire()
    local button = toDoData.button
    button:Show()
    button:SetParent(parent)
    button.texture = button:CreateTexture()
    button.texture:SetAllPoints(button)

	button:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, 0)
    button.texture:SetTexture(select(3, GetSpellInfo(393764)))
	local size = 30

    button:SetWidth(size)
    button:SetHeight(size)
    button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
	button:RegisterForClicks("LeftButtonUp", "LeftButtonDown")

	button.Text = factory:CreateFontString(parent, toDoData:ToDoListRowText(), 30, -5, parent:GetWidth(), 20)
	button.Text:SetJustifyH("LEFT")
	if toDoData:IsComplete() then
		button.Text:SetTextColor(0, 1, 0 ,1)
	end
    return button
end

function factory:CreateFontString(parent, text, posX, posY, width, height)
	local fontString = parent:CreateFontString(nil, "ARTWORK","GameFontNormalSmall")
	
	fontString:SetWidth(width)
	fontString:SetHeight(height)
	fontString:SetFont(fontString:GetFont(), height * 0.8,"OUTLINE")
	fontString:SetPoint("TOPLEFT", parent, "TOPLEFT", posX, posY)
	fontString:SetText(text)

	return fontString
end