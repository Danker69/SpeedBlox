-- Shop
-- whibri
-- September 2, 2021
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player: Player = game:GetService("Players").LocalPlayer

local Gui = player.PlayerGui:WaitForChild("Shop")
local Menu = Gui:WaitForChild("Background"):WaitForChild("Holder"):WaitForChild("Menu")
local Toggle = Gui:WaitForChild("Toggle")
local ExitButton = Gui:WaitForChild("Background"):WaitForChild("Holder"):WaitForChild("TopBar"):WaitForChild("ExitButton")
-- Selection Frames:
local AnimationsSelection = Menu:WaitForChild("AnimationsSelection")
local TrailsSelection = Menu:WaitForChild("TrailsSelection")
local CoinsSelection = Menu:WaitForChild("CoinsSelection")
-- Selection Buttons:
local TB = Menu:WaitForChild("TopBar")
local AnimationsSelector = TB:WaitForChild("AnimationsSelector")
local TrailsSelector = TB:WaitForChild("TrailsSelector")
local CoinsSelector = TB:WaitForChild("CoinsSelector")

-- Main:

local Shop = {}

function Shop:Start()
    local function CreateNotification(Title: string, Text: string, Icon: string?)
        local SetCore = game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = Title;
            Text = Text;
            Icon = Icon or "";
            Duration = 5;
        })
    end

    local function createElement(trail: string, trailId: string)
        local profile = self.Services.DataManager:Get()

        local clone = Gui.Assets.ShopElement:Clone()
        clone.Title.Text = trail
        clone:SetAttribute("id", trailId)

        if table.find(profile.Inventory.Trails, trailId) then
            clone.Use.Text = "Equip"
        end

        if profile.Inventory.CurrentTrail == trailId then
            clone.Use.Text = "Dequip"
        end

        clone.Use.MouseButton1Click:Connect(function()
            local result = self.Services.EventHandler:setTrail(trailId, clone.Use.Text:lower())

            if result == true then
                for _, btn in pairs(TrailsSelection:GetChildren()) do
                    if btn:IsA("UIGridLayout") then continue end

                    if btn.Use.Text == "Dequip" then
                        btn.Use.Text = "Equip"
                    end
                end
                clone.Use.Text = "Dequip"

            elseif result == "dequip" then
                clone.Use.Text = "Equip"

            elseif result == false then
                CreateNotification("Purchase Error", "Not enough coins!")
            end
        end)

        clone.Visible = true
        clone.Parent = TrailsSelection
    end

    -- Animations:
    --[[
    local Animations: {} = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Shop"):WaitForChild("Animations"):GetChildren()
    local Assets = Gui:WaitForChild("Assets")

    for _, anim: Animation in pairs(Animations) do
        if anim:GetAttribute("Active") == true then
            local profile = self.Services.DataManager:Get()

            local clone = Assets:WaitForChild("ShopElement"):Clone()
            clone.Name = anim:GetAttribute("Name")
            clone.Title.Text = anim:GetAttribute("Name")
            clone:SetAttribute("n", anim:GetAttribute("Name"))

            if table.find(profile.Inventory.Animations, anim:GetAttribute("Name")) and anim:GetAttribute("Name") ~= profile.Inventory.CurrentRunAnimation then
                clone.Use.Text = "Equip"
            end

            if table.find(profile.Inventory.Animations, profile.Inventory.CurrentRunAnimation) then
                clone.Use.Text = "Unequip"
            end

            if not table.find(profile.Inventory.Animations, anim:GetAttribute("Name")) then
                clone.Use.Text = "Purchase"
            end
            
            -- use anim
            clone.Use.MouseButton1Click:Connect(function()
                local profile = self.Services.DataManager:Get()
                if table.find(profile.Inventory.Animations, anim:GetAttribute("Name")) and anim:GetAttribute("Name") ~= profile.Inventory.CurrentRunAnimation then
                    self.Services.EventHandler:setCurrentAnim(anim:GetAttribute("Name"))

                    for _, v in pairs(clone.Parent:GetChildren()) do
                        if v:FindFirstChild("Use") then
                            local btn = v.Use
                            if btn.Text ~= "Purchase" then
                                btn.Text = "Equip"
                            end
                        end
                    end

                    clone.Use.Text = "Unequip"
                end
    
                if table.find(profile.Inventory.Animations, profile.Inventory.CurrentRunAnimation) then -- Unequip
                    self.Services.EventHandler:setCurrentAnim("def")

                    clone.Use.Text = "Equip"
                end
    
                if not table.find(profile.Inventory.Animations, anim:GetAttribute("Name")) then -- Purchase
                    if self.Services.EventHandler:PurchaseShopItem("anim", anim:GetAttribute("Name")) then
                        for _, v in pairs(clone.Parent:GetChildren()) do
                            if v:FindFirstChild("Use") then
                                local btn = v.Use
                                if btn.Text ~= "Purchase" then
                                    btn.Text = "Equip"
                                end
                            end
                        end

                        clone.Use.Text = "Unequip"
                    else
                        -- player doesn't have enough coins
                        CreateNotification("Store", "You do not have enough coins!")
                    end
                end
            end)
            clone.Visible = true
            clone.Parent = AnimationsSelection
        end
    end]]

    -- Trails:
    local ShopTrailData: table = self.Services.EventHandler:getShopTrails()
    for trailId: string, trailName: string in pairs(ShopTrailData) do
        createElement(trailName, trailId)
    end


    Toggle.MouseButton1Click:Connect(function()
        Gui:WaitForChild("Background").Visible = true
        Toggle.Visible = false
    end)

    ExitButton.MouseButton1Click:Connect(function()
        Gui:WaitForChild("Background").Visible = false
        Toggle.Visible = true
    end)

    for _, selection: Instance in pairs({AnimationsSelection, TrailsSelection, CoinsSelection}) do
        for _, selector: Instance in pairs({AnimationsSelector, TrailsSelector, CoinsSelector}) do
            if selector:GetAttribute("Type") == selection:GetAttribute("Type") then
                selector:WaitForChild("Select").MouseButton1Click:Connect(function()
                    selection.Visible = true
                    for _, _selection in pairs({AnimationsSelection, TrailsSelection, CoinsSelection}) do
                        if selection ~= _selection then
                            _selection.Visible = false
                        end
                    end
                end)
            end
        end
    end
end

function Shop:Init()
    
end

return Shop