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

function EventHandler.Client:setTrail(player: Player, trailId: string) print "event fired"
    local Trails: Folder = RS.Assets.Shop.Trails

    local function createTrail()
        if not player.Character.Head:FindFirstChildOfClass("Trail") then -- trail doesn't exist, create new one
            local trailC: Trail = Trails[trailId]:Clone()

            trailC.Parent = player.Character.Head
            local Attach0 = Instance.new("Attachment", player.Character.Head)
            Attach0.Name = "Attachment0"

            local Attach1 = Instance.new("Attachment", player.Character.HumanoidRootPart)
            Attach1.Name = "Attachment1"

            trailC.Attachment0 = Attach0
            trailC.Attachment1 = Attach1
        else -- trail exists, remove current, add new

        end
    end

    createTrail()

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