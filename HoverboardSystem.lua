-- Configuration Variables
local hoverboardSpeed = 32 -- Double sprint speed
local energyDrainRate = 1 -- Energy drained per second while riding
local energyRegenRate = 0.5 -- Energy regenerated per second when not riding
local maxEnergy = 100 -- Maximum energy
local currentEnergy = maxEnergy -- Current energy

-- Hoverboard Management
local function onPlayerJoin(player)
    -- Initialize player settings and visuals
    setupHoverboard(player)
end

local function setupHoverboard(player)
    -- Create visual hoverboard model under player
    local hoverboard = Instance.new('Part')
    hoverboard.Size = Vector3.new(2, 0.5, 1)
    hoverboard.Position = player.Character.HumanoidRootPart.Position - Vector3.new(0, 1, 0)
    hoverboard.Anchored = true
    hoverboard.Parent = workspace
    -- More hoverboard setup code...
end

local function onRiderMove(player)
    -- Manage player movement
    if isRiding(player) then
        if currentEnergy > 0 then
            player.Character.Humanoid.WalkSpeed = hoverboardSpeed
            drainEnergy()
        else
            -- Unable to ride due to insufficient energy
            stopRiding(player)
        end
    end
end

local function drainEnergy()
    currentEnergy = math.max(currentEnergy - energyDrainRate, 0)
end

local function regenerateEnergy()
    currentEnergy = math.min(currentEnergy + energyRegenRate, maxEnergy)
end

local function onTokenCollected(token)
    -- Handle token collection
    currentEnergy = math.min(currentEnergy + 10, maxEnergy) -- Example token value
    token:Destroy() -- Remove token from game
end

-- Main Loop
game.Players.PlayerAdded:Connect(onPlayerJoin)
game:GetService('RunService').Heartbeat:Connect(function()
    for _, player in pairs(game.Players:GetPlayers()) do
        onRiderMove(player)
        if not isRiding(player) then
            regenerateEnergy()
        end
    end
end)
