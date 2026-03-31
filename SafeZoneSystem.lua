-- SafeZoneSystem.lua

-- Safe Zone Class
SafeZone = {}

function SafeZone:new(x, y, width, height)
    local obj = {x = x, y = y, width = width, height = height, players = {}, meteors = {}}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function SafeZone:isInSafeZone(player)
    return player.x > self.x and player.x < (self.x + self.width) and \
           player.y > self.y and player.y < (self.y + self.height)
end

function SafeZone:enter(player)
    table.insert(self.players, player)
    player.isProtected = true  -- Protect player from damage
    print(player.name .. " has entered the safe zone.")
end

function SafeZone:exit(player)
    for i, p in ipairs(self.players) do
        if p == player then
            table.remove(self.players, i)
            player.isProtected = false
            print(player.name .. " has exited the safe zone.")
            break
        end
    end
end

function SafeZone:markSpawnArea()
    -- Code to visually mark the spawn area (e.g., draw a rectangle on the screen)
    print("Spawn area marked at: " .. self.x .. ", " .. self.y)
end

function SafeZone:preventMeteors()
    for i, meteor in ipairs(self.meteors) do
        if self:isInSafeZone(meteor) then
            print("Meteor intercepted at safe zone.")
            table.remove(self.meteors, i)
        end
    end
end

-- Example Usage
local safeZone = SafeZone:new(100, 100, 200, 200)
safeZone:markSpawnArea()

-- Place this within your game loop to check for meteors
-- safeZone:preventMeteors()  -- Call this function to prevent meteors from falling in the safe zone

-- Call safeZone:enter(player) and safeZone:exit(player) to manage player protection as they enter or leave the safe zone.
