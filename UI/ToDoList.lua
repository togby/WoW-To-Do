local addonName, addon = ...

addon.UIWindows.InGameOverview.ToDoList = {}
local window = addon.UIWindows.InGameOverview.ToDoList


local factory = addon.FrameFactory

local rowHeight = 30

function window:Setup(parentFrame)
    local posY = 0
    for key, value in ipairs(addon.JobList.All) do
        if value:IsActive() then
            local toDoListRowFrame = CreateFrame("Frame", nil, parentFrame, "BackdropTemplate")
            toDoListRowFrame:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", 5, posY)
            toDoListRowFrame:SetWidth(parentFrame:GetWidth()-10)
            toDoListRowFrame:SetHeight(rowHeight)
            
            factory:CreateToDoListRow(value, toDoListRowFrame)
            posY = posY - rowHeight
        end
    end
end