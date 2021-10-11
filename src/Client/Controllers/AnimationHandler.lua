-- Animation Handler
-- whibri
-- September 3, 2021



local AnimationHandler = {}

local RS = game:GetService("ReplicatedStorage")

local player: Player = game:GetService("Players").LocalPlayer
local char: Model = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

local onRunning: RBXScriptSignal

function AnimationHandler:SetAnimation(animName: string)
	local animator: Animator = humanoid.Animator

	if animName ~= "idle" then
		local anims = RS:WaitForChild("Assets"):WaitForChild("Shop"):WaitForChild("Animations"):GetChildren()
		
	elseif animName == "def" then
		
	elseif animName == "idle" then

	end 
end

function AnimationHandler:Run() --[[
	humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function()
		if humanoid.MoveDirection.Magnitude > Vector3.new(0, 0, 0).Magnitude then
			self:SetAnimation(self.Services.DataManager:Get().Inventory.CurrentRunAnimation)
		else
			self:SetAnimation("idle")
		end
	end)

	onRunning = humanoid.Running:Connect(function(speed)
		if speed > 0 then
			self:SetAnimation(self.Services.DataManager:Get().Inventory.CurrentRunAnimation)
		else
			self:SetAnimation("idle")
		end
	end)]]
end

function AnimationHandler:Start()
	
end

function AnimationHandler:Init()
	local animator = Instance.new("Animator")
	animator.Name = "Animator"
	animator.Parent = humanoid
end

return AnimationHandler