local Library = shared.NexusLib
local Window = Library:CreateWindow("Project Nexus")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")

local local_player = Players.LocalPlayer
local DEFAULT_WALKSPEED = StarterPlayer.CharacterWalkSpeed
local DEFAULT_JUMPPOWER = StarterPlayer.CharacterJumpPower

local connections = {
	walkspeed_cnct = nil,
	jumppower_cnct = nil,
}

Window.MainGui.Destroying:Connect(function()
	if connections.walkspeed_cnct then
		connections.walkspeed_cnct:Disconnect()
	end
end)

local PlayerTab = Window:CreateTab("Player")

PlayerTab:CreateSlider("WalkSpeed", 0, 999, DEFAULT_WALKSPEED, function(value)
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

PlayerTab:CreateSlider("JumpPower", 0, 999, DEFAULT_JUMPPOWER, function(value)
	if connections.jumppower_cnct then
		connections.jumppower_cnct:Disconnect()
	end

	connections.jumppower_cnct = RunService.RenderStepped:Connect(function()
		local character = local_player.Character
		local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")

		if humanoid then
			humanoid.JumpPower = value
		end
	end)
end)
