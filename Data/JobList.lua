local addonName, addon = ...

addon.JobList = {}
local JobList = addon.JobList

JobList.All = {}
JobList.Tracked = {}
--jobList.


local log = addon.Log

function JobList:AddJob(data)

    data.Reason = data.Reason or function () return {Drop ={}} end
    data.IsActive = data.IsActive or function () return false end
    data.IsComplete = data.IsComplete or function () return true end
    data.IsTracked = data.IsTracked or function () return false end
    data.ToDoListRowText = data.ToDoListRowText or function (self) return self.name end

    tinsert(JobList.All, data)
end


