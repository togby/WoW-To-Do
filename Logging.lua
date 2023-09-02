local addonName, addon = ...


local charectorCapInTheChat = 250
function addon.Log:Print(Message)
    if type(Message) ~= "string" then
        print(Message)
        return
    end
    --split the Message if it's longer then the chat cap
    local str = ""
    for _,s in pairs({strsplit(" ", Message)}) do
        if #str + #s >= charectorCapInTheChat then
            print(addon.shortName.."::"..str)
            str = ""
        end
        str = str .. " " .. s
    end
    print(addon.shortName.."::"..str)
end

function addon.Log:Error(Message)
	UIErrorsFrame:AddMessage(addon.shortName .. "::" .. Message, 0, 1.0, 1.0, 1.0, 1);
	self:Print(Message)
end

function addon.Log:Info(Message)
    addon.Log:Print(Message)
end

function addon.Log:Debug(Message)
    if not addon.db.profile.Debug then
        return
    end
    addon.Log:Print(Message)
end

function addon.Log:Dev(Message)
    if not addon.db.profile.Development then
        return
    end
    addon.Log:Print(Message)
end

