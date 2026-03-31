-- PlayerMovementSystem.lua

PlayerMovementSystem = {}

function PlayerMovementSystem:dash()
    -- Logic for dashing
end

function PlayerMovementSystem:sprint()
    -- Logic for sprinting
end

function PlayerMovementSystem:move(t)
    -- Logic for player movement
    if self:isDodgingMeteor() then
        self:dash()
    elseif self:isSprinting() then
        self:sprint()
    end
end

function PlayerMovementSystem:isDodgingMeteor()
    -- Logic to check if player is dodging meteor
end

function PlayerMovementSystem:isSprinting()
    -- Logic to check if player is sprinting
end

return PlayerMovementSystem