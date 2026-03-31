-- HoverboardSystem.lua

HoverboardSystem = {}
HoverboardSystem.__index = HoverboardSystem

-- Constants
local DOUBLE_SPRINT_SPEED = 2 \* 16 -- Assuming normal sprint speed is 16
tokens = 0  -- Number of tokens collected
local MAX_ENERGY = 100
local energy = MAX_ENERGY

-- Function to initialize the hoverboard system
function HoverboardSystem:new(player)
    local obj = setmetatable({}, HoverboardSystem)
    obj.player = player
    obj.isUsingHoverboard = false
    return obj
end

-- Function to toggle hoverboard
function HoverboardSystem:toggleHoverboard()
    self.isUsingHoverboard = not self.isUsingHoverboard
    if self.isUsingHoverboard then
        self:startRiding()
    else
        self:stopRiding()
    end
end

-- Function to start riding hoverboard
function HoverboardSystem:startRiding()
    if energy > 0 then
        self.player.speed = DOUBLE_SPRINT_SPEED
        self:depleteEnergy()
        print(self.player.name .. " is now riding the hoverboard!")
    else
        print("Not enough energy to use hoverboard!")
    end
end

-- Function to stop riding hoverboard
function HoverboardSystem:stopRiding()
    self.player.speed = 16 -- revert to normal speed
    print(self.player.name .. " has stopped riding the hoverboard.")
end

-- Function to deplete energy over time
function HoverboardSystem:depleteEnergy()
    while self.isUsingHoverboard and energy > 0 do
        energy = energy - 1 -- Deplete energy by 1 each second
        wait(1) -- Wait for 1 second before next depletion
        print("Energy: " .. energy)
    end
    if energy <= 0 then
        self:stopRiding()
    end
end

-- Function to collect tokens
function HoverboardSystem:collectToken()
    tokens = tokens + 1
    energy = math.min(energy + 10, MAX_ENERGY) -- Refill energy by 10 up to max
    print(self.player.name .. " collected a token! Total tokens: " .. tokens)
end

-- Example usage:
-- local player = {name = "Player1", speed = 16}
-- local hoverboard = HoverboardSystem:new(player)
-- hoverboard:toggleHoverboard() -- Start riding
-- wait(5)
-- hoverboard:toggleHoverboard() -- Stop riding
-- hoverboard:collectToken() -- Collect a token
