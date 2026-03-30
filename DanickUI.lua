local UI = {}

function UI:CreateWindow(titleText)
	local player = game.Players.LocalPlayer
	local UIS = game:GetService("UserInputService")

	if player.PlayerGui:FindFirstChild("CustomHub") then
		player.PlayerGui.CustomHub:Destroy()
	end

	local gui = Instance.new("ScreenGui", player.PlayerGui)
	gui.Name = "CustomHub"
	gui.ResetOnSpawn = false

	local main = Instance.new("Frame", gui)
	main.Size = UDim2.new(0, 650, 0, 360)
	main.Position = UDim2.new(0.5, -325, 0.5, -180)
	main.BackgroundColor3 = Color3.fromRGB(18,18,18)
	Instance.new("UICorner", main).CornerRadius = UDim.new(0,10)

	-- DRAG
	local dragging, dragStart, startPos
	main.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = main.Position
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			main.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)

	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	-- RIGHT SHIFT
	UIS.InputBegan:Connect(function(input, gp)
		if not gp and input.KeyCode == Enum.KeyCode.RightShift then
			main.Visible = not main.Visible
		end
	end)

	-- SIDEBAR
	local sidebar = Instance.new("Frame", main)
	sidebar.Size = UDim2.new(0,150,1,0)
	sidebar.BackgroundColor3 = Color3.fromRGB(12,12,12)
	Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0,10)

	local title = Instance.new("TextLabel", sidebar)
	title.Text = titleText
	title.Size = UDim2.new(1,0,0,45)
	title.BackgroundTransparency = 1
	title.TextColor3 = Color3.new(1,1,1)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 18

	local content = Instance.new("Frame", main)
	content.Size = UDim2.new(1,-160,1,-10)
	content.Position = UDim2.new(0,155,0,5)
	content.BackgroundTransparency = 1

	local layout = Instance.new("UIGridLayout", tabFrame)
	layout.CellSize = UDim2.new(0,240,0,150)
	layout.CellPadding = UDim2.new(0,10,0,10)
	layout.SortOrder = Enum.SortOrder.LayoutOrder

	local tabs = {}
	local currentTab = nil

	function UI:SwitchTab(tabFrame)
		for _,t in pairs(tabs) do
			t.Visible = false
		end
		tabFrame.Visible = true
	end

	function UI:CreateTab(name)
		local btn = Instance.new("TextButton", sidebar)
		btn.Size = UDim2.new(1,0,0,30)
		btn.Text = name
		btn.BackgroundTransparency = 1
		btn.TextColor3 = Color3.fromRGB(200,200,200)
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 14

		local tabFrame = Instance.new("Frame", content)
		tabFrame.Size = UDim2.new(1,0,1,0)
		tabFrame.Visible = false

		table.insert(tabs, tabFrame)

		btn.MouseButton1Click:Connect(function()
			UI:SwitchTab(tabFrame)
		end)

		if not currentTab then
			currentTab = tabFrame
			tabFrame.Visible = true
		end

		local Tab = {}

		function Tab:CreateSection(name)
			local section = Instance.new("Frame", tabFrame)
			section.Size = UDim2.new(0,230,0,150)
			section.BackgroundColor3 = Color3.fromRGB(25,25,25)
			Instance.new("UICorner", section).CornerRadius = UDim.new(0,10)

			local title = Instance.new("TextLabel", section)
			title.Text = name
			title.Size = UDim2.new(1,0,0,25)
			title.BackgroundTransparency = 1
			title.TextColor3 = Color3.new(1,1,1)
			title.Font = Enum.Font.GothamBold
			title.TextSize = 14

			local y = 30

			local Section = {}

			function Section:CreateToggle(text, callback)
				local lbl = Instance.new("TextLabel", section)
				lbl.Text = text
				lbl.Position = UDim2.new(0,10,0,y)
				lbl.Size = UDim2.new(0.6,0,0,22)
				lbl.BackgroundTransparency = 1
				lbl.TextColor3 = Color3.fromRGB(220,220,220)
				lbl.Font = Enum.Font.Gotham
				lbl.TextSize = 13
				
				local btn = Instance.new("TextButton", section)
				btn.Size = UDim2.new(0,40,0,18)
				btn.Position = UDim2.new(1,-50,0,y+2)
				btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
				btn.Text = ""
				Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)

				local dot = Instance.new("Frame", btn)
				dot.Size = UDim2.new(0,14,0,14)
				dot.Position = UDim2.new(0,2,0,2)
				dot.BackgroundColor3 = Color3.new(1,1,1)
				Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)

				local state = false
				
				btn.MouseButton1Click:Connect(function()
					state = not state
					if state then
						dot:TweenPosition(UDim2.new(1,-16,0,2),"Out","Quad",0.15,true)
						btn.BackgroundColor3 = Color3.fromRGB(0,170,255)
					else
						dot:TweenPosition(UDim2.new(0,2,0,2),"Out","Quad",0.15,true)
						btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
					end
					if callback then
						callback(state)
					end
				end)

				y = y + 25
			end

			return Section
		end

		return Tab
	end

	return UI
end

return UI
