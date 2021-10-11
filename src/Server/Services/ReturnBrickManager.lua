-- Return Brick Manager
-- whibri
-- July 19, 2021



local ReturnBrickManager = {Client = {}}


function ReturnBrickManager:Start()
    local Players = game:GetService("Players")
	local StageFolder = workspace.Stages

    for _, Stage: Instance in pairs(StageFolder:GetChildren()) do
        for __, ReturnPart: Part in pairs(Stage:GetChildren()) do

            if ReturnPart.Name == "ReturnToStage" then
                ReturnPart.Touched:Connect(function(hit)
                    if hit.Parent:IsA("Model") and hit.Parent:FindFirstChild("Humanoid") then
                        local player = Players:GetPlayerFromCharacter(hit.Parent)

                        self.Modules.TeleportWithinPlace:teleportPlayerViaInteger(player, player.Values.PortalIndex.Value)
                    end
                end)
            end
        end
    end
end


function ReturnBrickManager:Init()
	
end


return ReturnBrickManager