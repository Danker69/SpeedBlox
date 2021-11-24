local Players = game:GetService("Players")
-- On Player Event Manager
-- whibri
-- July 19, 2021



local OnPlayerEventManager = {Client = {}}

function OnPlayerEventManager:CreatePortalIndex(player: Player)
    -- start datastore GET
    local ProfilePortalIndex
    -- end datastore GET

    -- NumberValue that holds the value of the player's current stage.
    local PortalIndex: NumberValue = Instance.new("NumberValue")
    PortalIndex.Name = "PortalIndex"
    PortalIndex.Value = ProfilePortalIndex or 1
    PortalIndex.Parent = player.Values
end

function OnPlayerEventManager:PlayerDied(player: Player, valuesFolder: Folder)
    local thread = coroutine.create(function()
        task.wait(10)
        local RunService = game:GetService("RunService")

        player.CharacterAdded:Connect(function(character)
            character.HumanoidRootPart:GetPropertyChangedSignal("CFrame"):Connect(function()
                --print(player, " has teleported here:", character.HumanoidRootPart.Position)
            end)

            player.CharacterAppearanceLoaded:Wait()
            RunService.Stepped:Wait()

            local profile = self.Services.DataManager:Get(player)
            local trailId = profile.Inventory.CurrentTrail

            self.Services.EventHandler:setTrail(player, trailId)

            self.Modules.TeleportWithinPlace:teleportPlayerViaInteger(player, valuesFolder.PortalIndex.Value)
            player.Character.Humanoid.WalkSpeed = _G.DEFAULT_BOOSTED_WALKSPEED
        end)
        --print("LOADED")
	end)

    coroutine.resume(thread)
end

function OnPlayerEventManager:SetTags(player: Player)
    if not table.find(self.Services.DataManager:Get(player).Tags, "Tester") then
        if player.UserId == 458071717 or 231482825 or 62786105 or 1970849469 then
            table.insert(self.Services.DataManager:Get(player).Tags, "Tester")
        end
    end
    
    if not table.find(self.Services.DataManager:Get(player).Tags, "Alpha") then
        if self.Services.DataManager:Get(player).Alpha then
            table.insert(self.Services.DataManager:Get(player).Tags, "Alpha")
        end
    end
end

function OnPlayerEventManager:SetTrail(player: Player)
    local trail = self.Services.DataManager:Get(player).Inventory.CurrentTrail
    
    if trail ~= "" and trail ~= "def" then
        self.Services.EventHandler:setTrail(player, trail)
    end
end

function OnPlayerEventManager:AddCoins_Rep(player: Player, coins: number)
    coroutine.wrap(function()
        while true do
            self.Services.DataManager:Get(player).Coins += coins
            task.wait(10)
        end
    end)()
end

function OnPlayerEventManager:HandleAnims()
    local function g(animName: string): string
        if animName == "def" then
            return "http://www.roblox.com/asset/?id=180426354"
        elseif animName == "idle" then
            return "http://www.roblox.com/asset/?id=180435571"
        end

        for _, anim: Animation in pairs(game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Shop"):WaitForChild("Animations"):GetChildren()) do
            if anim:GetAttribute("Name") == animName then
                print(anim)
                return anim.AnimationId
            end
        end
    end

    print("handle anims")

    local function onCharacterAdded(char: Model)
        local hum: Humanoid = char:WaitForChild("Humanoid")

        for _, playingTracks in pairs(hum:GetPlayingAnimationTracks()) do
            playingTracks:Stop()
        end

        local animScript: LocalScript = char:WaitForChild("Animate")

        animScript.Disabled = true
        animScript.run.RunAnim.AnimationId = g(self.Services.DataManager:Get(game:GetService("Players"):GetPlayerFromCharacter(char)).Inventory.CurrentRunAnimation)
        animScript.Disabled = false
    end

    return function(player: Player)
        player.CharacterAppearanceLoaded:Connect(onCharacterAdded)
    end
end

-- Main Thing --
function OnPlayerEventManager:Start()
    local Players: Players = game:GetService("Players")

    Players.PlayerAdded:Connect(function(player: Player)

        -- Folder that holds most if not all player-values.
        local ValuesFolder: Folder = Instance.new("Folder")
        ValuesFolder.Name = "Values"
        ValuesFolder.Parent = player

        -- Call needed methods
        self:CreatePortalIndex(player)
        self:PlayerDied(player, ValuesFolder)
        self:SetTags(player)
        self:AddCoins_Rep(player, 1)
        self:SetTrail(player)
        
        -- Leaderstats
        local leaderstats = Instance.new("Folder")
        leaderstats.Name = "leaderstats"
        leaderstats.Parent = player

        local coins = Instance.new("NumberValue")
        coins.Name = "Coins"
        coins.Value = self.Services.DataManager:Get(player)
        coins.Parent = leaderstats

        coroutine.wrap(function()
            while true do
                coins.Value = self.Services.DataManager:Get(player).Coins
                task.wait(5)
            end
        end)()
    end)

    Players.PlayerRemoving:Connect(function(player: Player)
        
    end)
end


function OnPlayerEventManager:Init()
	
end


return OnPlayerEventManager