-- Event Handler
-- whibri
-- July 19, 2021
-- Handles server-side events

local RS = game:GetService("ReplicatedStorage")

local EventHandler = {Client = {}}

function EventHandler.Client:TeleportViaInteger(player: Player, tpIndex: number)
    self.Server.Modules.TeleportWithinPlace:teleportPlayerViaInteger(player, tpIndex)
end

function EventHandler.Client:getShopTrails()
    local data = {}

    for _, trail: Trail in pairs(RS.Assets.Shop.Trails:GetChildren()) do
        data[trail.Name] = trail:GetAttribute("Name")
    end

    return data
end

function EventHandler:setTrail(player: Player, trailId: string, dequip: string?): boolean | string
    local profile = self.Services.DataManager:Get(player)

    if trailId == "" then print("trailId = ''") return "reset" end

    if dequip == "dequip" then
        print("dequipping...")
        self.Services.DataManager:Get(player).Inventory.CurrentTrail = ""

        if player.Character.Head:FindFirstChildOfClass("Trail") then -- trail exists, remove current
            player.Character.Head:FindFirstChildOfClass("Trail"):Destroy()
            player.Character.Head["Attachment0-Trail"]:Destroy()
            player.Character.HumanoidRootPart["Attachment1-Trail"]:Destroy()
        end
        return "dequip"
    end

    local Trails: Folder = RS.Assets.Shop.Trails

    local function isOwned(): boolean
        local profile: table = self.Services.DataManager:Get(player)

        return table.find(profile.Inventory.Trails, trailId) and true or nil
    end

    local function createTrail()
        local sameExists: boolean = false

        if (player.Character.Head:FindFirstChildOfClass("Trail")) then -- trail exists, remove current, add new
            if player.Character.Head:FindFirstChildOfClass("Trail").Name ~= trailId then
                player.Character.Head:FindFirstChildOfClass("Trail"):Destroy()
                player.Character.Head["Attachment0-Trail"]:Destroy()
                player.Character.HumanoidRootPart["Attachment1-Trail"]:Destroy()
            else
                sameExists = true
            end
        end

        if not sameExists then
            local trailC: Trail = Trails[trailId]:Clone()

            trailC.Parent = player.Character.Head
            local Attach0: Attachment = Instance.new("Attachment", player.Character.Head)
            Attach0.Name = "Attachment0-Trail"
    
            local Attach1: Attachment = Instance.new("Attachment", player.Character.HumanoidRootPart)
            Attach1.Name = "Attachment1-Trail"
    
            trailC.Attachment0 = Attach0
            trailC.Attachment1 = Attach1
        end
    end

    local function purchase(): boolean
        local price: number = Trails[trailId]:GetAttribute("Price")

        if profile.Coins >= price then

            profile.Coins -= price

            profile.Inventory.CurrentTrail = trailId
            table.insert(profile.Inventory.Trails, trailId)

            createTrail()
            return true
        else
            return false
        end
    end

    if isOwned() then
        profile.Inventory.CurrentTrail = trailId
        createTrail()
        return true
    else
        return purchase()
    end

    -- Testing:
    -- createTrail()
end

function EventHandler.Client:setTrail(player: Player, trailId: string, dequip: string?): boolean
    return self.Server:setTrail(player, trailId, dequip)
end

function EventHandler.Client:setCurrentAnim(player: Player, animName: string)
    if animName == "" then return end
    self.Server.Services.DataManager:Get(player).Inventory.CurrentRunAnimation = animName
end

function EventHandler.Client:PurchaseShopItem(player: Player, _type: string, name: string): boolean
    if _type == "anim" then
        local prices: Folder = game:GetService("ServerStorage"):WaitForChild("AnimationPrices")
        local coins = self.Server.Services.DataManager:Get(player).Coins

        for _, priceValue: NumberValue in pairs(prices:GetChildren()) do
            if coins >= priceValue.Value then
                coins -= priceValue.Value

                self.Server.Services.DataManager:Get(player).Inventory.CurrentRunAnimation = name
                table.insert(self.Server.Services.DataManager:Get(player).Inventory.Animations, name)
                return true
            else
                -- player doesn't have enough coins
                print(player.Name .. " doesn't have enough coins!")
            end
        end
    end
end

function EventHandler:Start()

end


function EventHandler:Init()
	self:RegisterClientEvent("SetStageChanges")
end


return EventHandler