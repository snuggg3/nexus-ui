local Library = shared.NexusLib
local Window = Library:CreateWindow("Project Nexus")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")

local local_player = Players.LocalPlayer
local default_walkspeed = StarterPlayer.CharacterWalkSpeed

local connections = {
	walkspeed_cnct = nil,
}

Window.MainGui.Destroying:Connect(function()
	if connections.walkspeed_cnct then
		connections.walkspeed_cnct:Disconnect()
	end
end)

local PlayerTab = Window:CreateTab("Player")

PlayerTab:CreateSlider("WalkSpeed", 0, 999, default_walkspeed, function(value)
	if connections.walkspeed_cnct then
		connections.walkspeed_cnct:Disconnect()
	end

	connections.walkspeed_cnct = RunService.RenderStepped:Connect(function()
		local character = local_player.Character
		local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")

		if humanoid then
			humanoid.WalkSpeed = value
		end
	end)
end)
