--[[ 
    OffenseWare UI Library - Delta Fixed
    Struktur beibehalten, Mobile-Kompatibilität hinzugefügt
]]

local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer

-- Fix: Delta/Mobile Dragging Support
local function MakeDraggable(topbarobject, object)
	local Dragging, DragInput, DragStart, StartPosition
	topbarobject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = input.Position
			StartPosition = object.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then Dragging = false end
			end)
		end
	end)
	topbarobject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			DragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == DragInput and Dragging then
			local Delta = input.Position - DragStart
			object.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
		end
	end)
end

function Library:CreateWindow(HubName)
    local OffenseWare = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local TopBar = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local TabContainer = Instance.new("ScrollingFrame")
    local PageContainer = Instance.new("Frame")
    
    -- DELTA FIX: Nutze gethui() oder PlayerGui direkt
    local function GetSafeParent()
        local success, res = pcall(function() return gethui() end)
        if success then return res end
        return LocalPlayer:WaitForChild("PlayerGui")
    end

    OffenseWare.Name = "OffenseWareLib"
    OffenseWare.Parent = GetSafeParent()
    OffenseWare.ResetOnSpawn = false
    OffenseWare.IgnoreGuiInset = true -- Wichtig für Handy-Bildschirme

    -- Main Frame
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = OffenseWare
    MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
    MainFrame.Size = UDim2.new(0, 450, 0, 300) -- Mobile-optimierte Größe
    MainFrame.Visible = true -- Sicherstellen, dass es sichtbar ist
    
    local Border = Instance.new("UIStroke")
    Border.Parent = MainFrame
    Border.Thickness = 2
    Border.Color = Color3.fromRGB(200, 40, 40)

    -- Top Bar
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    MakeDraggable(TopBar, MainFrame)

    -- Mobile Close/Toggle Button (Hinzugefügt)
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = TopBar
    CloseBtn.Size = UDim2.new(0, 35, 0, 35)
    CloseBtn.Position = UDim2.new(1, -35, 0, 0)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 20
    CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Font = Enum.Font.Code
    Title.Text = HubName or "OffenseWare"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Der restliche Tab-Code von deiner Repo
    TabContainer.Parent = MainFrame
    TabContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    TabContainer.Position = UDim2.new(0, 0, 0, 37)
    TabContainer.Size = UDim2.new(0, 110, 1, -37)
    TabContainer.ScrollBarThickness = 0
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = TabContainer

    PageContainer.Parent = MainFrame
    PageContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    PageContainer.Position = UDim2.new(0, 110, 0, 37)
    PageContainer.Size = UDim2.new(1, -110, 1, -37)

    local WindowFunctions = {}
    local FirstTab = true

    function WindowFunctions:CreateTab(TabName)
        local TabButton = Instance.new("TextButton")
        local Page = Instance.new("ScrollingFrame")
        
        TabButton.Parent = TabContainer
        TabButton.Size = UDim2.new(1, 0, 0, 35)
        TabButton.Text = TabName
        TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        TabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabButton.Font = Enum.Font.Code

        Page.Parent = PageContainer
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = Page
        PageLayout.Padding = UDim.new(0, 5)

        if FirstTab then
            Page.Visible = true
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            FirstTab = false
        end

        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(PageContainer:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(TabContainer:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(150, 150, 150) end end
            Page.Visible = true
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        local TabFunctions = {}
        function TabFunctions:CreateButton(BtnText, Callback)
            local Btn = Instance.new("TextButton")
            Btn.Parent = Page
            Btn.Size = UDim2.new(1, -10, 0, 40)
            Btn.Text = BtnText
            Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            local UIC = Instance.new("UICorner"); UIC.Parent = Btn
            Btn.MouseButton1Click:Connect(function() pcall(Callback) end)
        end
        
        return TabFunctions
    end
    
    return WindowFunctions
end

return Library
