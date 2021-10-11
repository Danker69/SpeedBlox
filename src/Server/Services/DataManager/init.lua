-- Data Manager
-- whibri
-- August 12, 2021



local DataManager = {Client = {}}

local ProfileManager = require(script:WaitForChild("ProfileManager"))

function DataManager:Start()
    --ProfileManager = require(script:WaitForChild("ProfileManager"))
end


function DataManager:Init()
	
end

-- // External Access \\ --
-- Server Access:
function DataManager:Get(player)
    local profile = ProfileManager:Get(player)

    if profile then
        return profile.Data
    end
end

-- Client Access:
function DataManager.Client:Get(player)
    return self.Server:Get(player)
end

return DataManager