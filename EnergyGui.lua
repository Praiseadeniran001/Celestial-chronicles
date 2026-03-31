local EnergyGui = {}
EnergyGui.currentEnergy = 100 -- Starting energy
EnergyGui.instructions = "Use the hoverboard to move. Energy regenerates over time."
EnergyGui.tokenCounter = 0 -- Initial token count

function EnergyGui.updateEnergy(newEnergy)
    EnergyGui.currentEnergy = newEnergy
    -- Code to update the energy bar display would go here
end

function EnergyGui.collectToken()
    EnergyGui.tokenCounter = EnergyGui.tokenCounter + 1
    -- Code to update the token display would go here
end

function EnergyGui.displayStatus()
    print("Current Energy: " .. EnergyGui.currentEnergy)
    print("Instructions: " .. EnergyGui.instructions)
    print("Tokens Collected: " .. EnergyGui.tokenCounter)
end

-- Simulate energy regeneration over time (example)
while EnergyGui.currentEnergy < 100 do
    EnergyGui.currentEnergy = EnergyGui.currentEnergy + 1
    EnergyGui.displayStatus()
    wait(1) -- Wait for 1 second before the next update
end

return EnergyGui