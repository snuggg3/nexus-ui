local Library = shared.NexusLib
local Window = Library:CreateWindow("Project Nexus")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")

local local_player = Players.LocalPlayer
local default_walkspeed = StarterPlayer.CharacterWalkSpeed

local connections = {
    walkspeed_cnct = nil
}

Window.MainGui.Destroying:Connect(function()
    if connections.walkspeed_cnct then
        connections.walkspeed_cnct:Disconnect()
    end
end)

local PlayerTab = Window:CreateTab("Player")

PlayerTab:CreateSlider("WalkSpeed", 0, 999, default_walkspeed, function(value)
    local character = local_player.Character
    if not character then
        return
    end

    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
    if not humanoid then
        return
    end

    connections.walkspeed_cnct = RunService.RenderStepped:Connect(function()
        humanoid.WalkSpeed = value
    end)
end)
