-- Main Menu
-- whibri
-- August 2, 2021



local MainMenu = {}

function MainMenu:Start()
	local Gui: ScreenGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MainMenuGui")
	local Background = Gui:WaitForChild("Background")
	local ButtonHolder = Background:WaitForChild("ButtonHolder")
	local PlayButton = ButtonHolder:WaitForChild("PlayButton")
	local SettingsButton = ButtonHolder:WaitForChild("SettingsButton")
	local SettingsExit = Gui:WaitForChild("SettingsFrame"):WaitForChild("ExitButton")
	local CreditsButton = ButtonHolder:WaitForChild("CreditsButton")
	local CreditsExit = Gui:WaitForChild("CreditsFrame"):WaitForChild("ExitButton")
	local SettingsTagSelection = SettingsExit.Parent:WaitForChild("SettingsHolder"):WaitForChild("ChatTagSetting"):WaitForChild("TagSelection")
	local SettingsTagDropdown = SettingsExit.Parent:WaitForChild("TagDropdown")
	local SettingsMusicToggle = SettingsExit.Parent:WaitForChild("SettingsHolder"):WaitForChild("MusicToggle"):WaitForChild("Toggle")
	
	local CreditsHandler = require(script:WaitForChild("CreditsHandler"))

	local Detached: Frame = Gui.Parent:WaitForChild("Detached")
	local MainMenuToggle: TextButton = Detached:WaitForChild("MainMenuToggle"):WaitForChild("Toggle")

	local Blur = Instance.new("BlurEffect")
	Blur.Name = "MainMenuBlur"
	Blur.Size = 24
	Blur.Enabled = true
	Blur.Parent = game:GetService("Lighting")

	local profile: {}

	CreditsHandler.AddCredit(1, 493677451, "Lead Developer") -- Danker
	CreditsHandler.AddCredit(2, 2242612589, "Map Builder") -- Angel
	CreditsHandler.AddCredit(2, 458071717, "Tester") -- BadCat
	CreditsHandler.AddCredit(3, 231482825, "Tester") -- Alex
	CreditsHandler.AddCredit(4, 62786105, "Tester") -- Sen

	local function tempFunc(bool: boolean)
		Background.Visible = bool
		game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, bool)
	end

	-- Detached:
	MainMenuToggle.MouseButton1Click:Connect(function()
		MainMenuToggle.Visible = false
		Gui.Enabled = true
		Blur.Enabled = true
	end)

	-- Main:
	PlayButton.MouseButton1Click:Connect(function()
		Gui.Enabled = false
		Blur.Enabled = false
		MainMenuToggle.Visible = true
	end)

	SettingsButton.MouseButton1Click:Connect(function()
		SettingsExit.Parent.Visible = true
		profile = self.Services.DataManager:Get(game:GetService("Players").LocalPlayer.UserId)
		tempFunc(false)
	end)

	SettingsExit.MouseButton1Click:Connect(function()
		SettingsExit.Parent.Visible = false
		SettingsTagDropdown.Visible = false
		tempFunc(true)
	end)

	CreditsButton.MouseButton1Click:Connect(function()
		CreditsExit.Parent.Visible = true
		tempFunc(false)
	end)

	CreditsExit.MouseButton1Click:Connect(function()
		CreditsExit.Parent.Visible = false
		tempFunc(true)
	end)

	SettingsTagSelection.MouseButton1Click:Connect(function()
		SettingsTagDropdown.Visible = not SettingsTagDropdown.Visible
	end)

	SettingsMusicToggle.MouseButton1Click:Connect(function()
		local status = self.Controllers.MusicController:GetStatus()

		if status then
			self.Controllers.MusicController:Stop()
			SettingsMusicToggle.Text = "Off"
			SettingsMusicToggle.BackgroundColor3 = Color3.fromRGB(255, 87, 87)
		else
			self.Controllers.MusicController:Play()
			SettingsMusicToggle.Text = "On"
			SettingsMusicToggle.BackgroundColor3 = Color3.fromRGB(85, 255, 127)
		end
	end)

	-- Add tags to dropdown --
	profile = self.Services.DataManager:Get(game:GetService("Players").LocalPlayer.UserId)

	SettingsTagSelection.Text = profile.CurrentTag ~= "" and profile.CurrentTag or "None"
	
	for _, tag in pairs(profile.Tags) do
		print(tag)
		local Assets = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("MainMenuGui"):WaitForChild("Assets")
		local TagSelectionClone = Assets:WaitForChild("TagSelection"):Clone()
			
		TagSelectionClone.Button.Text = tag
			
		local toggle = Assets.Parent
		:WaitForChild("SettingsFrame")
		:WaitForChild("SettingsHolder")
		:WaitForChild("ChatTagSetting")
		:WaitForChild("TagSelection")

		TagSelectionClone.Name = "oogabooga"
		TagSelectionClone.Visible = true
		TagSelectionClone.Parent = SettingsTagDropdown

		TagSelectionClone.Button.MouseButton1Click:Connect(function()
			self.Services.ChatTags:ChangeTag(tag)
			toggle.Text = tag
		end)
	end
end

function MainMenu:Init()
    
end

return MainMenu