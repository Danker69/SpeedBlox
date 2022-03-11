-- Credits Handler
-- whibri
-- August 2, 2021



local CreditsHandler = {}

function CreditsHandler.AddCredit(layoutOrder: number, userId: number, title: string, array: {}?)
	local Players = game:GetService("Players")
	local player = Players.LocalPlayer
	
	local Assets = player.PlayerGui:WaitForChild("MainMenuGui"):WaitForChild("Assets")
	local CreditsFrameClone = Assets:WaitForChild("CreditsFrame"):Clone()
	CreditsFrameClone.Credit.Text = Players:GetNameFromUserIdAsync(userId) .. " - " ..title
	
	local content, isReady = Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
	CreditsFrameClone.UserProfilePic.Image = content
	
	CreditsFrameClone.UserProfilePic.ImageTransparency = 1
	CreditsFrameClone.UserProfilePic.BackgroundTransparency = 1

	CreditsFrameClone.Credit.TextTransparency = 1

	CreditsFrameClone.LayoutOrder = layoutOrder
	CreditsFrameClone.Visible = true
	
	CreditsFrameClone.Parent = player.PlayerGui:WaitForChild("MainMenuGui"):WaitForChild("CreditsFrame"):WaitForChild("CreditsHolder")

	table.insert(array, CreditsFrameClone)
end

return CreditsHandler