local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/snuggg3/nexus-ui/refs/heads/main/source.luau"))()
local Window = Library:CreateWindow("Project Nexus")

queue_on_teleport(game:HttpGet("https://raw.githubusercontent.com/snuggg3/nexus-ui/refs/heads/main/games/Old%20A%20Bizarre%20Day.luau"))

Window.MainGui.Destroying:Connect(function()
    shared.NexusLib = nil
end)

local plugs = {
    "https://raw.githubusercontent.com/snuggg3/nexus-ui/refs/heads/main/plugs/util.luau",
    "https://raw.githubusercontent.com/snuggg3/nexus-ui/refs/heads/main/plugs/player.luau"
}

for _, url in pairs(plugs) do
    task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet(url))()
        end)
    end)
end

local local_player = game:GetService("Players").LocalPlayer

local ItemFarmTab = Window:CreateTab("Item Farm")

local map_size = workspace.Map.NEWMAP:GetExtentsSize() --Vector3.new(6068, 512, 7091)
local map_pivot = workspace.Map.NEWMAP:GetPivot().Position --Vector3.new(-1778.78, 405.34, 13447.03)
local min_bounds = map_pivot - (map_size / 2)
local max_bounds = map_pivot + (map_size / 2)

local items_to_farm = {}
local is_auto_farming = false

local function is_inside_map(pos)
	return pos.X >= min_bounds.X
		and pos.X <= max_bounds.X
		and pos.Y >= min_bounds.Y
		and pos.Y <= max_bounds.Y
		and pos.Z >= min_bounds.Z
		and pos.Z <= max_bounds.Z
end

local function item_auto_farm()
	while is_auto_farming do
		local character = local_player.Character

		if not character then
			task.wait(1)
			continue
		end
		
		local humanoid = character:FindFirstChildWhichIsA("Humanoid")
		
		if not humanoid then
            task.wait(1)
			continue
		end
		
		local start_pivot = character:GetPivot()

		for _, item in workspace:GetChildren() do
			if not is_auto_farming or humanoid.Health <= 0 then
				break
			end

			if item:IsA("Tool") and items_to_farm[item.Name] then
				local handle = item:FindFirstChild("Handle")
				if handle and is_inside_map(handle.Position) then
					character:PivotTo(handle.CFrame)
					task.wait(0.3)
					character:PivotTo(start_pivot)
					task.wait(0.1)
				end
			end
		end
        task.wait(1)
	end
end

local item_list = { "Arrow", "Rokakaka Fruit", "Requiem Arrow", "Holy Corpse", "Frog", "Nostalgic Relic", "Shadow Camera", "Shiny Gem", "Dio's Diary", "Vampire Mask" }
for _, name in item_list do
	ItemFarmTab:CreateSwitch(name, false, function(value)
		items_to_farm[name] = value
	end)
end

ItemFarmTab:CreateSwitch("Auto Farm", false, function(value)
	is_auto_farming = value
	if value then
		task.spawn(item_auto_farm)
	end
end)
