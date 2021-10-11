-- Data Handler
-- whibri
-- July 27, 2021



local DataHandler = {}

function DataHandler:TAB(profile) --TesterAlphaBeta
    local toAward = { -- Change when certain game phase is over
        Tester = true;
        Alpha = false;
        Beta = false;
    }

    --[[
    profile.IsTester = toAward.IsTester
    profile.IsAlphaPlayer = toAward.IsAlphaPlayer
    profile.IsBetaPlayer = toAward.IsBetaPlayer
    ]]

    for role, bool in pairs(toAward) do
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