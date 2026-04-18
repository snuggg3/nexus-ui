local UIS = game:GetService("UserInputService")
local Library = {}
Library.__index = Library

local Theme = {
	Background = Color3.fromRGB(26, 26, 26),
	Light = Color3.fromRGB(38, 38, 38),
	Accent = Color3.fromRGB(200, 40, 40),
	Text = Color3.fromRGB(235, 235, 235),
}

local FONT = Enum.Font.Code
local TEXT_SIZE = 15
local ELEMENT_PADDING = 10

function Library:CreateWindow(title)
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "NexusUI"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

	local Main = Instance.new("Frame", ScreenGui)
	Main.Size = UDim2.new(0, 440, 0, 300)
	Main.Position = UDim2.new(0.5, -220, 0.5, -150)
	Main.BackgroundColor3 = Theme.Background
	Main.BorderSizePixel = 0

	local dragging, dragStart, startPos
	local function updateDrag(input)
		local delta = input.Position - dragStart
		Main.Position =
			UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	local Top = Instance.new("Frame", Main)
	Top.Size = UDim2.new(1, 0, 0, 28)
	Top.BackgroundColor3 = Theme.Light
	Top.BorderSizePixel = 0

	Top.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = Main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			updateDrag(input)
		end
	end)

	local Title = Instance.new("TextLabel", Top)
	Title.Size = UDim2.new(1, -40, 1, 0)
	Title.Position = UDim2.new(0, 10, 0, 0)
	Title.BackgroundTransparency = 1
	Title.Text = title
	Title.TextColor3 = Theme.Text
	Title.Font = FONT
	Title.TextSize = TEXT_SIZE
	Title.TextXAlignment = Enum.TextXAlignment.Left

	local Close = Instance.new("TextButton", Top)
	Close.Size = UDim2.new(0, 28, 1, 0)
	Close.Position = UDim2.new(1, -28, 0, 0)
	Close.BackgroundColor3 = Theme.Accent
	Close.Text = "X"
	Close.TextColor3 = Theme.Text
	Close.Font = FONT
	Close.TextSize = TEXT_SIZE
	Close.MouseButton1Click:Connect(function()
		ScreenGui:Destroy()
	end)

	local TabButtons = Instance.new("Frame", Main)
	TabButtons.Size = UDim2.new(0, 110, 1, -28)
	TabButtons.Position = UDim2.new(0, 0, 0, 28)
	TabButtons.BackgroundColor3 = Theme.Light
	TabButtons.BorderSizePixel = 0
	local TabList = Instance.new("UIListLayout", TabButtons)
	TabList.Padding = UDim.new(0, 2)

	local Content = Instance.new("Frame", Main)
	Content.Size = UDim2.new(1, -110, 1, -28)
	Content.Position = UDim2.new(0, 110, 0, 28)
	Content.BackgroundTransparency = 1

	local Window = {}
	Window.MainGui = ScreenGui

	local firstTab = true
	local currentButton = nil

	function Window:CreateTab(name)
		local Button = Instance.new("TextButton", TabButtons)
		Button.Size = UDim2.new(1, 0, 0, 28)
		Button.BackgroundColor3 = Theme.Background
		Button.Text = name
		Button.TextColor3 = Theme.Text
		Button.Font = FONT
		Button.TextSize = TEXT_SIZE
		Button.BorderSizePixel = 0

		local TabFrame = Instance.new("ScrollingFrame", Content)
		TabFrame.Size = UDim2.new(1, 0, 1, 0)
		TabFrame.BackgroundTransparency = 1
		TabFrame.Visible = false
		TabFrame.BorderSizePixel = 0
		TabFrame.ScrollBarThickness = 2
		TabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

		local Padding = Instance.new("UIPadding", TabFrame)
		Padding.PaddingLeft = UDim.new(0, ELEMENT_PADDING)
		Padding.PaddingTop = UDim.new(0, ELEMENT_PADDING)

		local Layout = Instance.new("UIListLayout", TabFrame)
		Layout.Padding = UDim.new(0, 6)
		Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			TabFrame.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 20)
		end)

		local function SelectTab()
			for _, v in pairs(Content:GetChildren()) do
				if v:IsA("ScrollingFrame") then
					v.Visible = false
				end
			end
			if currentButton then
				currentButton.BackgroundColor3 = Theme.Background
			end
			currentButton = Button
			Button.BackgroundColor3 = Theme.Accent
			TabFrame.Visible = true
		end

		Button.MouseButton1Click:Connect(SelectTab)
		if firstTab then
			firstTab = false
			task.defer(SelectTab)
		end

		local Tab = {}

		function Tab:CreateButton(text, callback)
			local Btn = Instance.new("TextButton", TabFrame)
			Btn.Size = UDim2.new(1, -15, 0, 28)
			Btn.BackgroundColor3 = Theme.Light
			Btn.Text = text
			Btn.TextColor3 = Theme.Text
			Btn.Font = FONT
			Btn.TextSize = TEXT_SIZE
			Btn.BorderSizePixel = 0
			Btn.MouseButton1Click:Connect(callback or function() end)
		end

		function Tab:CreateSwitch(text, default, callback)
			local Toggle = Instance.new("TextButton", TabFrame)
			Toggle.Size = UDim2.new(1, -15, 0, 28)
			Toggle.BackgroundColor3 = Theme.Light
			Toggle.TextColor3 = Theme.Text
			Toggle.Font = FONT
			Toggle.TextSize = TEXT_SIZE
			Toggle.BorderSizePixel = 0
			local state = default or false
			local function Update()
				Toggle.Text = text .. ": " .. (state and "ON" or "OFF")
				Toggle.TextColor3 = state and Theme.Accent or Theme.Text
			end
			Update()
			Toggle.MouseButton1Click:Connect(function()
				state = not state
				Update()
				if callback then
					callback(state)
				end
			end)
		end

		function Tab:CreateSlider(text, min, max, default, callback)
			local Frame = Instance.new("Frame", TabFrame)
			Frame.Size = UDim2.new(1, -15, 0, 45)
			Frame.BackgroundColor3 = Theme.Light
			Frame.BorderSizePixel = 0

			local Label = Instance.new("TextLabel", Frame)
			Label.Size = UDim2.new(1, -10, 0, 20)
			Label.Position = UDim2.new(0, 5, 0, 0)
			Label.BackgroundTransparency = 1
			Label.Text = text .. ": " .. tostring(default)
			Label.TextColor3 = Theme.Text
			Label.Font = FONT
			Label.TextSize = TEXT_SIZE
			Label.TextXAlignment = Enum.TextXAlignment.Left

			local Bar = Instance.new("Frame", Frame)
			Bar.Size = UDim2.new(1, -20, 0, 6)
			Bar.Position = UDim2.new(0, 10, 0, 30)
			Bar.BackgroundColor3 = Theme.Background
			Bar.BorderSizePixel = 0

			local Fill = Instance.new("Frame", Bar)
			Fill.BackgroundColor3 = Theme.Accent
			Fill.Size = UDim2.new(0, 0, 1, 0)
			Fill.BorderSizePixel = 0

			local dragging = false
			local function SetValue(percent)
				percent = math.clamp(percent, 0, 1)
				Fill.Size = UDim2.new(percent, 0, 1, 0)
				local value = math.floor(min + (max - min) * percent)
				Label.Text = text .. ": " .. value
				if callback then
					callback(value)
				end
			end

			Bar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
					SetValue((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X)
				end
			end)

			UIS.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					SetValue((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X)
				end
			end)

			UIS.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)

			task.defer(function()
				SetValue((default - min) / (max - min))
			end)
		end

		function Tab:CreateDropdown(text, list, callback)
			local open = false
			local DropFrame = Instance.new("Frame", TabFrame)
			DropFrame.Size = UDim2.new(1, -15, 0, 28)
			DropFrame.BackgroundColor3 = Theme.Light
			DropFrame.ClipsDescendants = true
			DropFrame.BorderSizePixel = 0

			local Button = Instance.new("TextButton", DropFrame)
			Button.Size = UDim2.new(1, 0, 0, 28)
			Button.BackgroundColor3 = Theme.Light
			Button.Text = text .. " v"
			Button.TextColor3 = Theme.Text
			Button.Font = FONT
			Button.TextSize = TEXT_SIZE
			Button.BorderSizePixel = 0

			local OptionContainer = Instance.new("Frame", DropFrame)
			OptionContainer.Position = UDim2.new(0, 0, 0, 28)
			OptionContainer.Size = UDim2.new(1, 0, 0, #list * 24)
			OptionContainer.BackgroundTransparency = 1

			local OptLayout = Instance.new("UIListLayout", OptionContainer)

			for _, option in ipairs(list) do
				local Opt = Instance.new("TextButton", OptionContainer)
				Opt.Size = UDim2.new(1, 0, 0, 24)
				Opt.BackgroundColor3 = Theme.Background
				Opt.Text = option
				Opt.TextColor3 = Theme.Text
				Opt.Font = FONT
				Opt.TextSize = TEXT_SIZE
				Opt.BorderSizePixel = 0
				Opt.MouseButton1Click:Connect(function()
					Button.Text = text .. ": " .. option
					open = false
					DropFrame.Size = UDim2.new(1, -15, 0, 28)
					callback(option)
				end)
			end

			Button.MouseButton1Click:Connect(function()
				open = not open
				DropFrame.Size = open and UDim2.new(1, -15, 0, 28 + (#list * 24)) or UDim2.new(1, -15, 0, 28)
			end)
		end

		return Tab
	end

	return Window
end

return Library
