-- Credits Handler
-- whibri
-- August 2, 2021



local CreditsHandler = {}

function CreditsHandler.AddCredit(layoutOrder: integer, userId: number, title: string)
	local Players = game:GetService("Players")
	local player = Players.LocalPlayer
	
	local Assets = player.PlayerGui:WaitForChild("MainMenuGui"):WaitForChild("Assets")
	local CreditsFrameClone = Assets:WaitForChild("CreditsFrame"):Clone()
	CreditsFrameClone.Credit.Text = Players:GetNameFromUserIdAsync(userId) .. " - " ..title
	
	local content, isReady = Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
	CreditsFrameClone.UserProfilePic.Image = content
	
	CreditsFrameClone.LayoutOrder = layoutOrder
	CreditsFrameClone.Visible = true
	
	CreditsFrameClone.Parent = player.PlayerGui:WaitForChild("MainMenuGui"):WaitForChild("CreditsFrame"):WaitForChild("CreditsHolder")
end

return CreditsHandler