-- Profile Manager
-- whibri
-- August 12, 2021



local ProfileManager = {}

local Players: Players = game:GetService("Players")
local Profiles = {}

local profileTemplate = {
	Coins = 0;

	Developer = false;
	Tester = false;
	Alpha = false;
	Beta = false;

	Tags = {};
	CurrentTag = "";

	Settings = {};
	Information = {};
	Moderation = {};
	Purchases = {};
	RedeemedCodes = {};

	Inventory = {
		CurrentRunAnimation = "def";
		CurrentTrail = "";

		Animations = {
			-- anim = "test" -> animName
		};
		Trails = {};
		Tools = {};
	};
}

local devs = {
	493677451;
	2242612589;
}

local ProfileService = require(script.Parent.Parent.Parent:WaitForChild("Modules"):WaitForChild("ProfileService"))

local GameProfileStore = ProfileService.GetProfileStore(
	"UserData_Temporary_V4", -- Was "UserData"
	profileTemplate
)

local function PlayerAdded(player: Player)
	local profile = GameProfileStore:LoadProfileAsync(
		"UserId_" .. player.UserId,
		"ForceLoad"
	)
	if profile ~= nil then
		profile:Reconcile() -- Fill in missing variables from ProfileTemplate (optional)
		profile:ListenToRelease(function()
			Profiles[player] = nil
			-- The profile could've been loaded on another Roblox server:
			player:Kick()
		end)
		if player:IsDescendantOf(Players) == true then
			Profiles[player] = profile
			-- A profile has been successfully loaded:
			profile.Data.Alpha = true

			for _, id in pairs(devs) do
				if player.UserId == id then
					profile.Data.Developer = true
				end
			end
		else
			-- Player left before the profile loaded:
			profile:Release()
		end
	else
		-- The profile couldn't be loaded possibly due to other
		--   Roblox servers trying to load this profile at the same time:
		player:Kick()
	end
end

-- In case Players have joined the server earlier than this script ran:
for _, player in ipairs(Players:GetPlayers()) do
	coroutine.wrap(PlayerAdded)(player)
end

Players.PlayerAdded:Connect(PlayerAdded)

Players.PlayerRemoving:Connect(function(player)
	local profile = Profiles[player]
	if profile ~= nil then
		profile:Release()
	end
end)

function ProfileManager:Get(player)
    local profile = Profiles[player]
    
    if profile then
        return profile
	else
		warn("Profile could not be loaded. - " .. (player.Name or "Player doesn't exist."), "retrying...")
		local maxCount = 100
		local time = .3

		for i = 1, maxCount do
			local profile = Profiles[player]
			if profile then
				print("Profile found after retrying.", "Attempt ".. i)
				return profile
			else
				wait(time)		
			end

			if i == maxCount then
				warn("Failed to get profile after trying " .. maxCount .. " times.")
			end
		end
    end
end

return ProfileManager