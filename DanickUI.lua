local UI = {}

function UI:CreateWindow(titleText)
	local player = game.Players.LocalPlayer
	local UIS = game:GetService("UserInputService")

	-- удалить старый
	if player.PlayerGui:FindFirstChild("CustomHub") then
		player.PlayerGui.CustomHub:Destroy()
	end

	local gui = Instance.new("ScreenGui", player.PlayerGui)
	gui.Name = "CustomHub"
	gui.ResetOnSpawn = false

	-- MAIN
	local main = Instance.new("Frame", gui)
	main.Size = UDim2.new(0, 650, 0, 360)
	main.Position = UDim2.new(0.5, -325, 0.5, -180)
	main.BackgroundColor3 = Color3.fromRGB(18,18,18)
	Instance.new("UICorner", main).CornerRadius = UDim.new(0,10)
	main.BackgroundTransparency = 1

	game:GetService("TweenService"):Create(main, TweenInfo.new(0.3), {
		BackgroundTransparency = 0
	}):Play()

	-- DRAG
	local dragging, dragStart, startPos
	main.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = main.Position
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
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

	-- CLOSE
	local close = Instance.new("TextButton", main)
	close.Size = UDim2.new(0,25,0,25)
	close.Position = UDim2.new(1,-30,0,5)
	close.Text = "X"
	close.BackgroundColor3 = Color3.fromRGB(40,40,40)
	close.TextColor3 = Color3.new(1,1,1)
	close.Font = Enum.Font.GothamBold
	close.TextSize = 14
	Instance.new("UICorner", close).CornerRadius = UDim.new(0,6)

	close.MouseButton1Click:Connect(function()
		gui:Destroy()
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

	local tabY = 50
	local tabs = {}
	local currentTab = nil

	local content = Instance.new("Frame", main)
	content.Size = UDim2.new(1,-160,1,-10)
	content.Position = UDim2.new(0,155,0,5)
	content.BackgroundTransparency = 1

	local TweenService = game:GetService("TweenService")

	function UI:SwitchTab(tabFrame)
		for _,t in pairs(tabs) do
			if t.Visible then
				TweenService:Create(t, TweenInfo.new(0.2), {
					BackgroundTransparency = 1
				}):Play()

				task.wait(0.1)
				t.Visible = false
			end
		end

		tabFrame.Visible = true
		tabFrame.BackgroundTransparency = 1

		TweenService:Create(tabFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
			BackgroundTransparency = 0
		}):Play()
	end

	function UI:CreateTab(name)
		local btn = Instance.new("TextButton", sidebar)
		btn.Size = UDim2.new(1,0,0,30)
		btn.Position = UDim2.new(0,0,0,tabY)
		tabY = tabY + 35
		btn.Text = name
		btn.BackgroundTransparency = 1
		btn.TextColor3 = Color3.fromRGB(200,200,200)
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 14

		local tabFrame = Instance.new("ScrollingFrame", content)
		tabFrame.Size = UDim2.new(1,0,1,0)
		tabFrame.CanvasSize = UDim2.new(0,0,0,0)
		tabFrame.ScrollBarThickness = 4
		tabFrame.BackgroundTransparency = 1
		tabFrame.Visible = false

		local grid = Instance.new("UIGridLayout", tabFrame)
		grid.CellSize = UDim2.new(0,240,0,150)
		grid.CellPadding = UDim2.new(0,10,0,10)

		grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			tabFrame.CanvasSize = UDim2.new(0,0,0,grid.AbsoluteContentSize.Y + 10)
		end)

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
						game:GetService("TweenService"):Create(btn, TweenInfo.new(0.15), {
						BackgroundColor3 = Color3.fromRGB(0,170,255)
					}):Play()
					else
						dot:TweenPosition(UDim2.new(0,2,0,2),"Out","Quad",0.15,true)
						game:GetService("TweenService"):Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60,60,60)}):Play()
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
end
	-- MOBILE BUTTON
	local mobileBtn = Instance.new("TextButton", gui)
	mobileBtn.Size = UDim2.new(0,50,0,50)
	mobileBtn.Position = UDim2.new(0,10,0.5,-25)
	mobileBtn.Text = "UI"
	mobileBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
	mobileBtn.TextColor3 = Color3.new(1,1,1)
	mobileBtn.Font = Enum.Font.GothamBold
	mobileBtn.TextSize = 16
	Instance.new("UICorner", mobileBtn).CornerRadius = UDim.new(1,0)

	mobileBtn.MouseButton1Click:Connect(function()
		main.Visible = not main.Visible
	end)
return UI
