local Library = loadstring(game:HttpGet("https://pastebin.com/raw/z0Lt0dfq"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local local_player = Players.LocalPlayer

local UI = setmetatable({}, Library)
local Window = UI:CreateWindow("Menu")

local MainTab = Window:CreateTab("Main")
local FarmTab = Window:CreateTab("Farm")
local UtilTab = Window:CreateTab("Util")

--== MAIN TAB ==--

local speed_connection
local jumppower_connection

--[[MainTab:CreateButton("Print", function()
	print("Hello")
end)]]

--[[MainTab:CreateSwitch("Test", false, function(v)
	print("Switch:", v)
end)]]

MainTab:CreateSlider("Speed", 0, 1000, 16, function(v)
	local character = local_player.Character
	if not character then
		return
	end

	local humanoid = character:FindFirstChildWhichIsA("Humanoid")
	if not humanoid then
		return
	end

	humanoid.WalkSpeed = v

	if speed_connection then
		speed_connection:Disconnect()
	end
	speed_connection = RunService.RenderStepped:Connect(function()
		humanoid.WalkSpeed = v
	end)
end)

MainTab:CreateSlider("Jump Power", 0, 1000, 50, function(v)
	local character = local_player.Character
	if not character then
		return
	end

	local humanoid = character:FindFirstChildWhichIsA("Humanoid")
	if not humanoid then
		return
	end

	humanoid.JumpPower = v

	if jumppower_connection then
		jumppower_connection:Disconnect()
	end
	jumppower_connection = RunService.RenderStepped:Connect(function()
		humanoid.JumpPower = v
	end)
end)

MainTab:CreateSlider("Gravity", 0, 1000, 196, function(v)
	workspace.Gravity = v
end)

MainTab:CreateSlider("Field Of View", 0, 120, 70, function(v)
	workspace.CurrentCamera.FieldOfView = v
end)

MainTab:CreateDropdown("Choose", { "A", "B", "C", "D" }, function(v)
	print("Selected:", v)
end)

--== FARM TAB ==--

local item_to_farm

FarmTab:CreateSwitch("Farm Item", false, function(v)
	if not item_to_farm then
		return
	end
	print(item_to_farm)
end)

FarmTab:CreateDropdown(
	"Item to farm",
	{ "Stand Arrow", "Easter Egg", "Golden Egg", "Requiem Arrow", "Rokakaka Fruit", "Vampire Mask", "Hamon Headband" },
	function(v)
		item_to_farm = v
	end
)

--== UTIL TAB ==--

UtilTab:CreateButton("Execute Infinite Yield", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

UtilTab:CreateButton("Execute Owl Hub", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/CriShoux/OwlHub/master/OwlHub.txt"))()
end)

--== OTHER STUFF ==--

Window.MainGui.Destroying:Connect(function()
	if speed_connection then
		speed_connection:Disconnect()
	end
	if jumppower_connection then
		jumppower_connection:Disconnect()
	end
	print("Destroyed, cleaned up.")
end)
