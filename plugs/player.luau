local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/snuggg3/nexus-ui/refs/heads/main/source.luau"))()
local Window = Library:CreateWindow("Project Nexus")

local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")

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
    connections.walkspeed_cnct = RunService.RenderStepped:Connect(function()
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end)
end)
