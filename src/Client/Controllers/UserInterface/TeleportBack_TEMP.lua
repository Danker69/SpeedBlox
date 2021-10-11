-- Teleport BackTEMP
-- Username
-- July 7, 2021



local TeleportBack_TEMP = {}

function TeleportBack_TEMP:TPBack()
    -- Teleports player back to defined area --
    local Button: TextButton = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("TP_DeleteLater"):WaitForChild("TextButton")
    local EventHandler = self.Services.EventHandler

    Button.MouseButton1Click:Connect(function()
        local index = 1
        EventHandler:TeleportViaInteger(index)
    end)
end

function TeleportBack_TEMP:Start()
    self:TPBack()
end

function TeleportBack_TEMP:Init()
    
end

return TeleportBack_TEMP