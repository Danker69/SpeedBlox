-- Main Menu
-- whibri
-- August 2, 2021



local MainMenu = {}

function MainMenu:Start()
	local TS = game:GetService("TweenService")

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
	local credits = {}

	local ButtonHolderSequence = {
		"PlayButton",
		"SettingsButton",
		"CreditsButton",
	}

	CreditsHandler.AddCredit(1, 493677451, "Lead Developer", credits) -- Danker
	CreditsHandler.AddCredit(2, 2242612589, "Map Builder", credits) -- Angel
	CreditsHandler.AddCredit(2, 458071717, "Tester", credits) -- BadCat
	CreditsHandler.AddCredit(3, 231482825, "Tester", credits) -- Alex
	CreditsHandler.AddCredit(4, 62786105, "Tester", credits) -- Sen

	local function tempFunc(bool: boolean)
		Background.Visible = bool
		game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, bool)
	end

	-- Detached:
	MainMenuToggle.MouseButton1Click:Connect(function()
		Background.Transparency = .5
		Background.TitleLogo.Image.ImageTransparency = 0
		Background.Andromeda.TextTransparency = 0

		MainMenuToggle.Visible = false
		Gui.Enabled = true
		Blur.Enabled = true

		local t = TS:Create(Background, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = UDim2.fromScale(0, 0)})
		t:Play()
		t.Completed:Wait()
	end)

	-- Main:
	PlayButton.MouseButton1Click:Connect(function()
		Blur.Enabled = false

		-- !! actual shit code below !! --
		-- we do a little redefining :troll:
		TS:Create(Background, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { Transparency = 1 }):Play()
		TS:Create(Background.TitleLogo.Image, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { ImageTransparency = 1 }):Play()
		local t = TS:Create(Background.Andromeda, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { TextTransparency = 1 })
		t:Play()
		t.Completed:Wait()
		local t = TS:Create(Background, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Position = UDim2.fromScale(0, 1)})
		t:Play()
		t.Completed:Wait()

		MainMenuToggle.Visible = true
		Gui.Enabled = false
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

		for _, credit: GuiBase in ipairs(credits) do
			local ti = TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

			credit.UserProfilePic.ImageTransparency = 1
			credit.UserProfilePic.BackgroundTransparency = 1
		
			credit.Credit.TextTransparency = 1

			for __, element in ipairs(credit:GetDescendants()) do
				local tp
				if element:IsA("TextLabel") then
					tp = { TextTransparency = 0 }
				end
				if element:IsA("ImageLabel") then
					tp = { ImageTransparency = 0, BackgroundTransparency = 0 }
				end

				if not tp then continue end
				TS:Create(element, ti, tp):Play()
			end
			local t = TS:Create(credit, ti, { BackgroundTransparency = 0 })
			t:Play()
			t.Completed:Wait()
		end
	end)

	CreditsExit.MouseButton1Click:Connect(function()
		CreditsExit.Parent.Visible = false
		tempFunc(true)

		for _, credit in ipairs(credits) do
			credit.UserProfilePic.ImageTransparency = 1
			credit.UserProfilePic.BackgroundTransparency = 1
		
			credit.Credit.TextTransparency = 1
		end
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