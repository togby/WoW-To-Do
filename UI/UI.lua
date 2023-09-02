local addonName, addon = ...

addon.UIWindows = {}

function addon:SetupFrames()
	for _, Window in pairs(addon.UIWindows) do
		if Window.SetupWindow then
			Window:SetupWindow()
		end
	end
	addon:UpdateFrameColours()
end

function addon:UpdateFrameColours()
    for _, Window in pairs(addon.UIWindows) do
		if Window.UpdateFrameColours then
			Window:UpdateFrameColours()
		end
	end
end

function addon:ShowWindow(WindowName)
    addon.UIWindows[WindowName]:Show()
end

function addon:HideWindow(WindowName)
    addon.UIWindows[WindowName]:Hide()
end

function addon:isWindowHidden(WindowName)
    addon.UIWindows[WindowName]:isWindowHidden()
end

function addon:ToggleWindow(WindowName)
    if(addon.UIWindows[WindowName]:isWindowHidden(WindowName)) then
        addon:ShowWindow(WindowName)
    else
        addon:HideWindow(WindowName)
    end
end