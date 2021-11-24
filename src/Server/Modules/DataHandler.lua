-- Data Handler
-- whibri
-- July 27, 2021



local DataHandler = {}

function DataHandler:TAB(profile) --TesterAlphaBeta
    print("called")
    local toAward = { -- Change when certain game phase is over
        Tester = false;
        Alpha = true;
        Beta = false;
    }

    --[[
    profile.IsTester = toAward.IsTester
    profile.IsAlphaPlayer = toAward.IsAlphaPlayer
    profile.IsBetaPlayer = toAward.IsBetaPlayer
    ]]

    for role, bool in pairs(toAward) do
        if bool == false then continue end

        for objectName, v in pairs(profile) do
            if v == true then continue end
            
            if role == objectName then
                profile[objectName] = bool
            end
        end
    end
end

function DataHandler:RunOnCall()
    -- Runs needed things
end

return DataHandler