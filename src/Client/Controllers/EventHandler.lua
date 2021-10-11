-- Event Handler
-- whibri
-- July 20, 2021



local EventHandler = {}

function EventHandler:OnStageChange(stageIndex)
    local RS = game:GetService("ReplicatedStorage")

    self.Shared.StageOptimizer.RemoveAllStagesAndAdd(stageIndex)

    for _, Stage: Instance in pairs(RS.Assets.Stages:GetChildren()) do
        if Stage:GetAttribute("Stage") == stageIndex then
            local ToDoModule = require(Stage.ToDo)
            ToDoModule:Run()
        end
    end
end

function EventHandler:Start()
	local ServerEventHandler = self.Services.EventHandler

    ServerEventHandler.SetStageChanges:Connect(function(stageIndex: number)
        self:OnStageChange(stageIndex)
    end)
end


function EventHandler:Init()
	
end


return EventHandler