-- Marketplace Service
-- Username
-- December 10, 2021



local MarketplaceService = {Client = {}}

local MS = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

function MarketplaceService:Start()
	Players.PlayerAdded:Connect(function(plr: Player)
        if MS:UserOwnsGamePassAsync(plr.UserId, 20462009) then
            if not table.find(self.Services.DataManager:Get(plr).Tags, "VIP") then
                table.insert(self.Services.DataManager:Get(plr).Tags, "VIP")
            end
            if not table.find(self.Services.DataManager:Get(plr).Inventory.Trails, "VIP") then
                table.insert(self.Services.DataManager:Get(plr).Inventory.Trails, "VIP")
            end
        end
    end)

    coroutine.wrap(function()
        for _, plr: Player in pairs(Players:GetPlayers()) do
            if MS:UserOwnsGamePassAsync(plr.UserId, 20462009) then
                if not table.find(self.Services.DataManager:Get(plr).Tags, "VIP") then
                    table.insert(self.Services.DataManager:Get(plr).Tags, "VIP")
                end
                if not table.find(self.Services.DataManager:Get(plr).Trails, "VIP") then
                    table.insert(self.Services.DataManager:Get(plr).Trails, "VIP")
                end
            end
        end
    end)()
end


function MarketplaceService:Init()
	
end


return MarketplaceService