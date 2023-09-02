local addonName, addon = ...





local JobList = addon.JobList

local function isItemInBag(itemId)
    for bag = BACKPACK_CONTAINER, NUM_TOTAL_EQUIPPED_BAG_SLOTS do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            if select(10, C_Container.GetContainerItemInfo(bag, slot)) == itemId then
                return true
            end
        end
    end
    return false
end

local function getDropData()
    local dropData = {}
    dropData.UpdateStatus = function (self)
        assert(false, "this function should be overriden")
    end

    dropData.IsComplete = function (self)
        assert(false, "this function should be overriden")
    end
    return dropData
end

local function MountDropData(dropId, spellId)

    local mountDropData = getDropData()

    mountDropData.dropId = dropId
    mountDropData.spellId = spellId

    mountDropData.UpdateStatus = function (self)
        local mountId =  C_MountJournal.GetMountFromSpell(self.spellId)
        local isCollected = select(11, C_MountJournal.GetMountInfoByID(mountId))
        self.currentStatus = isCollected or isItemInBag(self.dropId)
    end

    mountDropData.IsComplete = function (self)
        return self.currentStatus
    end


    return mountDropData
end


local function getReasonBuilder()

    local reasonBuilder = {}
    reasonBuilder.Build = function (self)

        return function ()
            return {
                ["Drop"] = self.mount
            }
        end
    end

    reasonBuilder.MountDrop = function (self, mountData)
        self.mount = self.mount or {}
        tinsert(self.mount, mountData)
        return self
    end



    return reasonBuilder
end

local function CreateRareSpawnData(name, questId, Reason)
    return {
        name = name,
        questId = questId,
        Reason = Reason,
        IsActive = function (self)
            do return true end
            return C_QuestLog.IsQuestFlaggedCompleted(self.questId) == false
        end,
        ToDoListRowText = function (self)
            return "("..tostring(#self.Reason().Drop)..") ".. self.name
        end,
        IsComplete = function (self)
            for _, value in ipairs(self.Reason().Drop) do
                value:UpdateStatus()
                
                if value:IsComplete() == false then
                    return false
                end
            end
            return true
        end

    }
end

JobList:AddJob(CreateRareSpawnData("Karokta", 75334,
getReasonBuilder()
:MountDrop(MountDropData(205203, 408647))
:Build()
))




JobList:AddJob(CreateRareSpawnData("Invoq", 75336))
JobList:AddJob(CreateRareSpawnData("Brullo the Strong", 75326))
JobList:AddJob(CreateRareSpawnData("kob'rok", 75267))



JobList:AddJob({
    name = "Karokta",
    questId = 75334,
    IsActive = function (self)
        return C_QuestLog.IsQuestFlaggedCompleted(self.questId) == false
    end,
    Reason = function ()
        return {
            Drop = {
            205203,
            205147
            
            }
        }
    end,
    ToDoListRowText = function (self)
        return "("..tostring(#self.Reason().Drop)..") ".. self.name
    end
})
