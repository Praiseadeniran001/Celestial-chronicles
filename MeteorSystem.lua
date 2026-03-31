-- Meteor Fall System for Roblox Studio
-- Place this script in ServerScriptService

local MeteorSystem = {}

-- Configuration
local CONFIG = {
	meteorSpawnHeight = 300,           -- Height above the ground where meteors spawn
	spawnInterval = 5,                 -- Time between meteor spawns in seconds
	fallSpeed = 50,                    -- Speed at which meteor falls
	impactDamage = 25,                 -- Damage dealt to players on impact
	aoeDamageRadius = 100,             -- Radius of AOE damage
	craterSize = 50,                   -- Size of crater created
	craterDepth = 20,                  -- Depth of crater
	debrisSpawnCount = 15,             -- Number of debris pieces to spawn
	debrisMaxSize = 5,                 -- Maximum size of debris
	damageCooldown = 2,                -- Cooldown between damage applications to same player
}

-- Store the template meteor part name
local TEMPLATE_METEOR_NAME = "Meteor"

-- Table to track damage cooldowns
local damageTracker = {}

-- Function to get or create the template meteor
local function getTemplateMeteor()
	local meteor = Instance.new("Part")
	meteor.Name = TEMPLATE_METEOR_NAME
	meteor.Shape = Enum.PartType.Ball
	meteor.Size = Vector3.new(5, 5, 5)
	meteor.Color = Color3.fromRGB(100, 100, 100)
	meteor.Material = Enum.Material.Rock
	meteor.CanCollide = true
	meteor.TopSurface = Enum.SurfaceType.Smooth
	meteor.BottomSurface = Enum.SurfaceType.Smooth
	
	-- Add velocity
	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Velocity = Vector3.new(0, -CONFIG.fallSpeed, 0)
	bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	bodyVelocity.Parent = meteor
	
	return meteor
end

-- Function to find a safe spawn location
local function getRandomSpawnLocation()
	local terrain = workspace.Terrain
	local randomX = math.random(-200, 200)
	local randomZ = math.random(-200, 200)
	return Vector3.new(randomX, CONFIG.meteorSpawnHeight, randomZ)
end

-- Function to create a crater
local function createCrater(position)
	local crater = Instance.new("Part")
	crater.Name = "Crater"
	crater.Shape = Enum.PartType.Block
	crater.Size = Vector3.new(CONFIG.craterSize, CONFIG.craterDepth, CONFIG.craterSize)
	crater.Color = Color3.fromRGB(80, 80, 80)
	crater.Material = Enum.Material.Rock
	crater.CanCollide = true
	crater.Position = position - Vector3.new(0, CONFIG.craterDepth / 2, 0)
	crater.TopSurface = Enum.SurfaceType.Smooth
	crater.BottomSurface = Enum.SurfaceType.Smooth
	crater.Anchored = true
	crater.Parent = workspace
	
	-- Add decal effect to make crater look more realistic
	local decal = Instance.new("Texture")
	decal.Texture = "rbxasset://textures/Granite.png"
	decal.Face = Enum.NormalId.Top
	decal.Parent = crater
	
	return crater
end

-- Function to spawn debris
local function spawnDebris(position)
	for i = 1, CONFIG.debrisSpawnCount do
		local debris = Instance.new("Part")
		debris.Name = "Debris"
		debris.Shape = Enum.PartType.Block
		debris.Size = Vector3.new(
			math.random(1, CONFIG.debrisMaxSize),
			math.random(1, CONFIG.debrisMaxSize),
			math.random(1, CONFIG.debrisMaxSize)
		)
		debris.Color = Color3.fromRGB(
			math.random(70, 120),
			math.random(70, 120),
			math.random(70, 120)
		)
		debris.Material = Enum.Material.Rock
		debris.CanCollide = true
		
		-- Spawn around the impact point
		local offsetX = math.random(-CONFIG.aoeDamageRadius, CONFIG.aoeDamageRadius)
		local offsetZ = math.random(-CONFIG.aoeDamageRadius, CONFIG.aoeDamageRadius)
		debris.Position = position + Vector3.new(offsetX, 10, offsetZ)
		
		-- Add velocity for debris effect
		debris.Velocity = Vector3.new(
			math.random(-30, 30),
			math.random(10, 30),
			math.random(-30, 30)
		)
		
		debris.Parent = workspace
		
		-- Remove debris after 10 seconds
		game:GetService("Debris"):AddItem(debris, 10)
	end
end

-- Function to deal damage to players in AOE
local function damagePlayersInAOE(position)
	local playersToRemove = {}
	
	-- Clean up old damage records
	for playerKey, lastDamageTime in pairs(damageTracker) do
		if tick() - lastDamageTime > CONFIG.damageCooldown then
			playersToRemove[#playersToRemove + 1] = playerKey
		end
	end
	
	for _, playerKey in ipairs(playersToRemove) do
		damageTracker[playerKey] = nil
	end
	
	-- Find players in range
	for _, player in pairs(game:GetService("Players"):GetPlayers()) do
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local humanoidRootPart = player.Character.HumanoidRootPart
			local distance = (humanoidRootPart.Position - position).Magnitude
			
			if distance <= CONFIG.aoeDamageRadius then
				local playerKey = player.UserId
				
				-- Check if player is on cooldown
				if not damageTracker[playerKey] or (tick() - damageTracker[playerKey] > CONFIG.damageCooldown) then
					local humanoid = player.Character:FindFirstChild("Humanoid")
					if humanoid then
						humanoid:TakeDamage(CONFIG.impactDamage)
						damageTracker[playerKey] = tick()
						print(player.Name .. " took " .. CONFIG.impactDamage .. " damage from meteor!")
					end
				end
			end
		end
	end
end

-- Function to handle meteor impact
local function handleMeteorImpact(meteor)
	local impactPosition = meteor.Position
	
	-- Create crater
	createCrater(impactPosition)
	
	-- Spawn debris
	spawnDebris(impactPosition)
	
	-- Damage players
	damagePlayersInAOE(impactPosition)
	
	-- Create impact effect (you can customize this)
	local impactPart = Instance.new("Part")
	impactPart.Name = "ImpactEffect"
	impactPart.Shape = Enum.PartType.Ball
	impactPart.Size = Vector3.new(1, 1, 1)
	impactPart.Color = Color3.fromRGB(255, 100, 0)
	impactPart.CanCollide = false
	impactPart.Position = impactPosition
	impactPart.Parent = workspace
	game:GetService("Debris"):AddItem(impactPart, 0.5)
	
	-- Remove the meteor
	meteor:Destroy()
	
	print("Meteor impact at: " .. tostring(impactPosition))
end

-- Function to spawn a meteor
local function spawnMeteor()
	local templateMeteor = getTemplateMeteor()
	local spawnLocation = getRandomSpawnLocation()
	
	templateMeteor.Position = spawnLocation
	templateMeteor.Parent = workspace
	
	-- Detect collision/impact
	local touchConnection
	touchConnection = templateMeteor.Touched:Connect(function(hit)
		if hit.Parent ~= workspace.Terrain and not hit.Parent:IsDescendantOf(templateMeteor) then
			if hit.Parent:FindFirstChild("Humanoid") == nil then
				-- Hit ground or structure (not a player character directly)
				touchConnection:Disconnect()
				handleMeteorImpact(templateMeteor)
			end
		end
	end)
	
	-- Timeout safety (remove meteor if it doesn't hit anything after 60 seconds)
	task.delay(60, function()
		if templateMeteor.Parent then
			touchConnection:Disconnect()
			templateMeteor:Destroy()
		end
	end)
end

-- Main loop to spawn meteors at intervals
local function startMeteorSystem()
	print("Meteor System started!")
	
	while true do
		spawnMeteor()
		task.wait(CONFIG.spawnInterval)
	end
end

-- Start the system
startMeteorSystem()