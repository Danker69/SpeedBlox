-- Music Controller
-- whibri
-- November 27, 2021



local MusicController = {}

local Soundtrack = {
    "rbxassetid://1846823031"; -- Mellow Dub
    "rbxassetid://1840577916"; -- Probe Logic 60
    "rbxassetid://1837849285"; -- Night Vision
    "rbxassetid://1840403089"; -- The Urban Environment(b)
}

local Status: boolean

local played: {[number]: string} = {}

local Player: Player = game:GetService("Players").LocalPlayer

local Music: Folder = Instance.new("Folder")
Music.Name = "Music"
Music.Parent = Player

local Audio: Sound = Instance.new("Sound")
Audio.Name = "Audio"
Audio.Volume = .15
Audio.Parent = Music

function MusicController:Play()
    Audio.SoundId = Soundtrack[math.random(1, #Soundtrack)]
    if not Audio.IsLoaded then
        Audio.Loaded:Wait()
    end
    Audio:Play()

    Audio.Ended:Connect(function()
        table.insert(played, Audio.SoundId)

        if #played == #Soundtrack then
            table.clear(played)
        end

        -- test
        local new: string
        while true do
            new = Soundtrack[math.random(1, #Soundtrack)]
            if not table.find(played, new) then
                break
            end
            task.wait(.1)
        end
        -- end test

        Audio.SoundId = new
        if not Audio.IsLoaded then
            Audio.Loaded:Wait()
        end
        Audio:Play()
    end)
    Status = true
end

function MusicController:GetStatus()
    return Status
end

function MusicController:Stop()
    Audio:Stop()
    table.clear(played)
    Status = false
end

function MusicController:Start()
    self:Play()
end

function MusicController:Init()
	
end


return MusicController