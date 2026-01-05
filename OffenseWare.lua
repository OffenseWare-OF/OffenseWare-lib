--[[ 
    OffenseWare UI Library - DELTA & MOBILE OPTIMIZED
    Style: Classic "Pepsi" / High-Contrast Red & Dark
]]

local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer

-- Funktion für sicheres Parenting (Wichtig für Delta Executor)
local function GetSafeParent()
    local Success, Parent = pcall(function() return gethui() end)
    if Success and Parent then return Parent end
    return LocalPlayer:WaitForChild("PlayerGui")
end

-- Dragging Funktion (Touch-kompatibel)
local function MakeDraggable(topbarobject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil

    local function Update(input)
        local Delta = input.Position - DragStart
        object.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
    end

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
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
            Update(input)
        end
    end)
end

function Library:CreateWindow(HubName)
    local OffenseWare = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local TopBar = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local DecorLine = Instance.new("Frame")
    local TabContainer = Instance.new("ScrollingFrame")
    local PageContainer = Instance.new("Frame")
    
    OffenseWare.Name = "OffenseWareLib"
    OffenseWare.Parent = GetSafeParent()
    OffenseWare.ResetOnSpawn = false
    OffenseWare.IgnoreGuiInset = true -- Für Mobile optimiert

    -- MOBILE TOGGLE BUTTON (Grüner Knopf zum Öffnen)
    local MobileToggle = Instance.new("TextButton")
    MobileToggle.Name = "MobileToggle"
    MobileToggle.Parent = OffenseWare
    MobileToggle.Size = UDim2.new(0, 45, 0, 45)
    MobileToggle.Position = UDim2.new(0, 10, 0, 50)
    MobileToggle.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    MobileToggle.Text = "OW"
    MobileToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    MobileToggle.Font = Enum.Font.Code
    MobileToggle.TextSize = 18
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = MobileToggle
    
    MobileToggle.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    -- Main Frame
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = OffenseWare
    MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
    MainFrame.Size = UDim2.new(0, 450, 0, 300) -- Etwas kleiner für Mobile
    
    local Border = Instance.new("UIStroke")
    Border.Parent = MainFrame
    Border.Thickness = 2
    Border.Color = Color3.fromRGB(200, 40, 40)

    -- Top Bar
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    
    MakeDraggable(TopBar, MainFrame)

    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Font = Enum.Font.Code
    Title.Text = HubName or "OffenseWare"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left

    DecorLine.Name = "DecorLine"
    DecorLine.Parent = MainFrame
    DecorLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    DecorLine.BorderSizePixel = 0
    DecorLine.Position = UDim2.new(0, 0, 0, 35)
    DecorLine.Size = UDim2.new(1, 0, 0, 2)

    TabContainer.Name = "TabContainer"
    TabContainer.Parent = MainFrame
    TabContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 0, 0, 37)
    TabContainer.Size = UDim2.new(0, 100, 1, -37)
    TabContainer.ScrollBarThickness = 0
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = TabContainer
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    PageContainer.Name = "PageContainer"
    PageContainer.Parent = MainFrame
    PageContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    PageContainer.BorderSizePixel = 0
    PageContainer.Position = UDim2.new(0, 100, 0, 37)
    PageContainer.Size = UDim2.new(1, -100, 1, -37)

    local WindowFunctions = {}
    local FirstTab = true

    function WindowFunctions:CreateTab(TabName)
        local TabButton = Instance.new("TextButton")
        local Page = Instance.new("ScrollingFrame")
        local PageLayout = Instance.new("UIListLayout")
        local PagePadding = Instance.new("UIPadding")

        TabButton.Name = TabName .. "Btn"
        TabButton.Parent = TabContainer
        TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, 0, 0, 35)
        TabButton.Font = Enum.Font.Code
        TabButton.Text = TabName
        TabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabButton.TextSize = 14

        Page.Name = TabName .. "Page"
        Page.Parent = PageContainer
        Page.Active = true
        Page.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Page.BorderSizePixel = 0
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.ScrollBarThickness = 2
        Page.Visible = false

        if FirstTab then
            Page.Visible = true
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            FirstTab = false
        end

        PageLayout.Parent = Page
        PageLayout.Padding = UDim.new(0, 6)
        PagePadding.Parent = Page
        PagePadding.PaddingTop = UDim.new(0, 10)
        PagePadding.PaddingLeft = UDim.new(0, 10)
        PagePadding.PaddingRight = UDim.new(0, 10)

        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(PageContainer:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then 
                    v.TextColor3 = Color3.fromRGB(150, 150, 150)
                end
            end
            Page.Visible = true
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        local TabFunctions = {}

        function TabFunctions:CreateButton(BtnText, Callback)
            local ButtonFrame = Instance.new("TextButton")
            local ButtonCorner = Instance.new("UICorner")
            ButtonFrame.Parent = Page
            ButtonFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            ButtonFrame.Size = UDim2.new(1, -5, 0, 40)
            ButtonFrame.Font = Enum.Font.SourceSansBold
            ButtonFrame.Text = BtnText
            ButtonFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
            ButtonFrame.TextSize = 16
            ButtonCorner.CornerRadius = UDim.new(0, 4)
            ButtonCorner.Parent = ButtonFrame
            ButtonFrame.MouseButton1Click:Connect(function() pcall(Callback) end)
        end

        function TabFunctions:CreateToggle(ToggleText, Default, Callback)
            local Toggled = Default or false
            local ToggleFrame = Instance.new("TextButton")
            local Indicator = Instance.new("Frame")
            ToggleFrame.Parent = Page
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            ToggleFrame.Size = UDim2.new(1, -5, 0, 40)
            ToggleFrame.Text = "  " .. ToggleText
            ToggleFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleFrame.TextXAlignment = Enum.TextXAlignment.Left
            ToggleFrame.Font = Enum.Font.SourceSansBold
            ToggleFrame.TextSize = 16
            
            Indicator.Parent = ToggleFrame
            Indicator.Size = UDim2.new(0, 20, 0, 20)
            Indicator.Position = UDim2.new(1, -30, 0.5, -10)
            Indicator.BackgroundColor3 = Toggled and Color3.fromRGB(200, 40, 40) or Color3.fromRGB(80, 80, 80)
            
            local IC = Instance.new("UICorner")
            IC.CornerRadius = UDim.new(0, 4)
            IC.Parent = Indicator

            ToggleFrame.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                Indicator.BackgroundColor3 = Toggled and Color3.fromRGB(200, 40, 40) or Color3.fromRGB(80, 80, 80)
                pcall(Callback, Toggled)
            end)
        end

        return TabFunctions
    end
    
    return WindowFunctions
end

return Library
