-- Stage Optimizer
-- whibri
-- June 28, 2021
-- Try setting the parent of the object to nil rather than destroying it


local RS = game:GetService("ReplicatedStorage")

local _table = {}
local portalTable = {}

for _, stage: Instance in pairs(workspace.Stages:GetChildren()) do
    table.insert(_table, stage:GetAttribute("Stage"), stage)
end

for _, portal: Instance in pairs(workspace.Portals:GetChildren()) do
    table.insert(portalTable, portal:GetAttribute("Stage"), portal)
end

local StageOptimizer = {}

function StageOptimizer.Default()

    --[[
    for i, stage in pairs(_table) do
        if i ~= 1 then
            stage.Parent = nil
        end
    end

    for i, portal in pairs(portalTable) do
        if i ~= 1 then
            portal.Parent = nil
        end
    end]]
end

function StageOptimizer.RemoveAllStagesAndAdd(stageIndex: number)
    -- Removes all stages except the one passed in the arguments.
    --[[
    _table[stageIndex].Parent = workspace.Stages
    portalTable[stageIndex].Parent = workspace.Portals

    for i, stageModel: Instance in pairs(_table) do
        if i ~= stageIndex then
            stageModel.Parent = nil
        end
    end

    for i, portalModel: Instance in pairs(portalTable) do
        if i ~= stageIndex then
            portalModel.Parent = nil
        end
    end]]
end

function StageOptimizer.NextStage(newStageIndex: number)
    -- Adds the next stage and deletes the last.
    _table[newStageIndex].Parent = workspace.Stages
    portalTable[newStageIndex].Parent = workspace.Portals

    if newStageIndex > 1 then
        _table[newStageIndex - 1].Parent = nil
        portalTable[newStageIndex - 1].Parent = nil
    end
end

function StageOptimizer.Switch(toAddIndex: number, toRemoveIndex: number)
    -- Remove and add a specific stage.
    _table[toAddIndex].Parent = workspace.Stages
    _table[toRemoveIndex].Parent = nil

    portalTable[toAddIndex].Parent = workspace.Portals
    portalTable[toRemoveIndex].Parent = nil
end

function StageOptimizer.AddStage(stageIndex: number)
    -- Adds a stage
    _table[stageIndex].Parent = workspace.Stages
    portalTable[stageIndex].Parent = workspace.Portals
end

function StageOptimizer.RemoveStage(stageIndex: number)
    -- Removes a stage
    _table[stageIndex].Parent = nil
    portalTable[stageIndex].Parent = nil
end

return StageOptimizer