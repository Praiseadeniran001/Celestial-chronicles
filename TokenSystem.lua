-- TokenSystem.lua

-- Token spawning, collection, and energy restoration system

-- Table to hold the tokens
local tokens = {}

-- Function to spawn tokens
local function spawnToken(x, y)
    local token = {x = x, y = y, collected = false}
    table.insert(tokens, token)
end

-- Function to collect tokens
local function collectToken(player, token)
    if not token.collected then
        token.collected = true
        player.energy = player.energy + 10  -- Restore 10 energy
        print("Token collected! Energy restored.")
    else
        print("Token already collected.")
    end
end

-- Function to restore energy periodically
local function restoreEnergy(player)
    while true do
        wait(30)  -- Wait for 30 seconds
        player.energy = player.energy + 1  -- Restore 1 energy
        print("Energy restored! Current energy: " .. player.energy)
    end
end

-- Example usage

-- Spawn a token at coordinates (10, 15)
spawnToken(10, 15)

-- Simulating a player
local player = {energy = 50}

-- Collect the first token
collectToken(player, tokens[1])

-- Start energy restoration in a separate thread
restoreEnergy(player)  

return tokens, player