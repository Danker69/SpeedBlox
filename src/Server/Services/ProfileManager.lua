-- Profile Manager
-- whibri
-- July 20, 2021



local ProfileManager = {Client = {}}

local Players: Players = game:GetService("Players")
local Profiles = {}

function ProfileManager:Start()
	--[[
	local profileTemplate = {
		Coins = 0;

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
			Animations = {};
			Trails = {};
			Tools = {};
		};
	}

	local ProfileService = self.Modules.ProfileService

    local GameProfileStore = ProfileService.GetProfileStore(
		"UserData_Temporary", -- Was "UserData"
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
				self.Modules.DataHandler:TAB(Profiles[player].Data)
				--Profiles[player].Data.CurrentTag = "Tester"
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
end

-- External Access
function ProfileManager:GetProfile(player)
	local profile = Profiles[player]

	return profile.Data

	--[[if profile then
		return profile.Data
	else
		warn("Profile wasn't found, re-running.")
		repeat
			wait(.1)
		until profile ~= nil
		print("Profile found after repeating.")
		return profile.Data
	end
	]]
end

-- Client Access
--[[
function ProfileManager.Client:c_GetProfile(user)
	return self.Server:GetProfile(user)
end]]
-- End External Access

function ProfileManager:Init()
	
end


return ProfileManager