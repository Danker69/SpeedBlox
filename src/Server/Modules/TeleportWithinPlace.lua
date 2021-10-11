-- Teleport Within Place
-- whibri
-- June 27, 2021

local TeleportWithinPlace = {}

local Players = game:GetService("Players")
local TPLocations = workspace.TeleportLocations

function TeleportWithinPlace:teleportPlayerViaInteger(player: Player, int: number)
    local function getLocation(n)
        for _, locationPart in pairs(TPLocations:GetChildren()) do
            if locationPart:GetAttribute("Stage") == n then
                return locationPart
            end
        end
    end

    self.Services.EventHandler:FireClient("SetStageChanges", player, int)
    player.Character.HumanoidRootPart.CFrame = getLocation(int).CFrame
    player.Values.PortalIndex.Value = int
end

return TeleportWithinPlace