-- Chat Tags
-- whibri
-- August 1, 2021



local ChatTags = {Client = {}}

local tags = {
    ["VIP"] = {TagText = "VIP", TagColor = Color3.fromRGB(255, 98, 98)};
    ["Beta"] = {TagText = "Beta", TagColor = Color3.fromRGB(246, 255, 116)};
    ["Alpha"] = {TagText = "Alpha", TagColor = Color3.fromRGB(255, 98, 247)};
    ["Tester"] = {TagText = "Tester", TagColor = Color3.fromRGB(169, 255, 98)};
    ["Moderator"] = {TagText = "Moderator", TagColor = Color3.fromRGB(98, 224, 255)};
    ["Developer"] = {TagText = "Developer", TagColor = Color3.fromRGB(255, 169, 98)};

    -- Testing / Debugging --
    ["Error"] = {TagText = "ERROR", TagColor = Color3.fromRGB(255, 0, 0)};
}

function ChatTags.Client:ChangeTag(player: Player, tag: string)
    self.Server.Services.DataManager:Get(player).CurrentTag = tag

    local SSS = game:GetService("ServerScriptService")
    local ChatService = require(SSS:WaitForChild("ChatServiceRunner").ChatService)

    local speaker = ChatService:GetSpeaker(player.Name)
    speaker:SetExtraData("Tags", {tags[tag]})
end

function ChatTags:Start()
	local SSS = game:GetService("ServerScriptService")
    local ChatService = require(SSS:WaitForChild("ChatServiceRunner").ChatService)

    local function speakerAdded(speakerName)
        local speaker = ChatService:GetSpeaker(speakerName)
        local player = speaker:GetPlayer()
    
        -- Safe, as if statement fails if first condition is falsy
        if player and tags[self.Services.DataManager:Get(player).CurrentTag] then
            -- Wrap tag in table, as Tags expects a table value worth of tags
            if self.Services.DataManager:Get(player).CurrentTag ~= "" then
                local tag = tags[self.Services.DataManager:Get(player).CurrentTag] or tags["Error"]

                speaker:SetExtraData("Tags", {tag})
            end
        end
    end

    ChatService.SpeakerAdded:Connect(speakerAdded)
    for _, speaker in ipairs(ChatService:GetSpeakerList()) do
        speakerAdded(speaker)
    end
end


function ChatTags:Init()
	
end


return ChatTags