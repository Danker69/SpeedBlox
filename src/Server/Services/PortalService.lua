-- Portal Service
-- whibri
-- June 27, 2021



local PortalService = {Client = {}}

function PortalService:TeleportWithin()
    local RS = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local PortalFolder = workspace.Portals
    local TPLocations = workspace.TeleportLocations

    local RESET_SECONDS = 5
    local isTouched = false

    for _, structure in pairs(PortalFolder:GetChildren()) do
        local portal
        
        if structure:FindFirstChild("Portal") then
            portal = structure:FindFirstChild("Portal")
        end
        
        -- Teleport player.
        portal.Touched:Connect(function(hit)
            if hit.Parent:IsA("Model") and hit.Parent:FindFirstChild("Humanoid") then
                if not isTouched then
                    isTouched = true
                    
                    local player = Players:GetPlayerFromCharacter(hit.Parent)
    
                    for _, location in pairs(TPLocations:GetChildren()) do
                        if portal.Parent:GetAttribute("Stage") + 1 == location:GetAttribute("Stage") then
                            player.Character.HumanoidRootPart.CFrame = location.CFrame
                            player.Values.PortalIndex.Value = location:GetAttribute("Stage")
                        end
                    end

                    self.Services.EventHandler:FireClient("SetStageChanges", player, player.Values.PortalIndex.Value)
                    self.Services.DataManager:Get(player).Coins += math.floor(50 * portal.Parent:GetAttribute("Stage"))
                    
                    task.wait(RESET_SECONDS)
			        isTouched = false
                end
            end
        end)
    end
end

function PortalService:Start()
    self:TeleportWithin()
end


function PortalService:Init()
    
end


return PortalService