--[[ 
    OffenseWare UI Library
    - Auto Device Detection
    - Purple/Black Theme
]]

local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- // UTILITY: Auto Detection //
local IsMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

-- // UTILITY: Draggable Function //
local function MakeDraggable(triggerObject, moveObject)
    local dragging = false
    local dragInput, dragStart, startPos

    triggerObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = moveObject.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    triggerObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            -- Tween für weicheres Bewegen
            TweenService:Create(moveObject, TweenInfo.new(0.05), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
end

-- // UTILITY: Safe Parent //
local function GetSafeParent()
    local success, parent = pcall(function() return gethui() end)
    if success and parent then return parent end
    
    if game:GetService("CoreGui"):FindFirstChild("RobloxGui") then
        return game:GetService("CoreGui")
    end
    return LocalPlayer:WaitForChild("PlayerGui")
end

-- // COLORS //
local Theme = {
    MainColor = Color3.fromRGB(140, 20, 255), -- OffenseWare Purple
    Background = Color3.fromRGB(20, 20, 25),  -- Dark Black
    Sidebar    = Color3.fromRGB(25, 25, 30),  -- Sidebar Dark
    ContentBG  = Color3.fromRGB(30, 30, 35),  -- Content Area
    Element    = Color3.fromRGB(40, 40, 45),  -- Buttons/Toggles
    Text       = Color3.fromRGB(255, 255, 255),
    TextDim    = Color3.fromRGB(150, 150, 150)
}

-- // MAIN LIBRARY //
function Library:CreateWindow(HubName)
    local OffenseWare = Instance.new("ScreenGui")
    OffenseWare.Name = "OffenseWareLib"
    OffenseWare.Parent = GetSafeParent()
    OffenseWare.ResetOnSpawn = false
    OffenseWare.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    OffenseWare.IgnoreGuiInset = true

    -- 1. MAIN WINDOW
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = OffenseWare
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
    MainFrame.Size = UDim2.new(0, 500, 0, 320)
    if IsMobile then MainFrame.Size = UDim2.new(0, 460, 0, 280) end -- Handy Größe angepasst
    MainFrame.Visible = true
    
    local MainCorner = Instance.new("UICorner"); MainCorner.CornerRadius = UDim.new(0, 6); MainCorner.Parent = MainFrame
    local MainStroke = Instance.new("UIStroke"); MainStroke.Parent = MainFrame; MainStroke.Color = Theme.MainColor; MainStroke.Thickness = 2

    -- 2. TOP BAR (Header)
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Theme.MainColor
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    
    local TopCorner = Instance.new("UICorner"); TopCorner.CornerRadius = UDim.new(0, 6); TopCorner.Parent = TopBar
    
    -- Filler um die unteren runden Ecken der TopBar zu verstecken
    local TopFiller = Instance.new("Frame")
    TopFiller.Parent = TopBar
    TopFiller.BackgroundColor3 = Theme.MainColor
    TopFiller.BorderSizePixel = 0
    TopFiller.Position = UDim2.new(0, 0, 1, -10)
    TopFiller.Size = UDim2.new(1, 0, 0, 10)

    MakeDraggable(TopBar, MainFrame)

    -- TITLE
    local Title = Instance.new("TextLabel")
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Size = UDim2.new(0.8, 0, 1, 0)
    Title.Font = Enum.Font.Code
    Title.Text = HubName or "OffenseWare"
    Title.TextColor3 = Theme.Text
    Title.TextSize = 22
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- CLOSE BUTTON
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = TopBar
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(1, -40, 0, 0)
    CloseBtn.Size = UDim2.new(0, 40, 1, 0)
    CloseBtn.Font = Enum.Font.SourceSansBold
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Theme.Text
    CloseBtn.TextSize = 20
    CloseBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
    end)

    -- 3. SIDEBAR (Tab Container - Left)
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "Sidebar"
    TabContainer.Parent = MainFrame
    TabContainer.BackgroundColor3 = Theme.Sidebar
    TabContainer.Position = UDim2.new(0, 0, 0, 40) -- Unter der TopBar
    TabContainer.Size = UDim2.new(0, 130, 1, -40) -- Links, Breite 130
    TabContainer.ScrollBarThickness = 0
    TabContainer.BorderSizePixel = 0
    
    local TabContainerCorner = Instance.new("UICorner"); TabContainerCorner.CornerRadius = UDim.new(0, 6); TabContainerCorner.Parent = TabContainer
    -- Filler für Sidebar oben rechts Ecken
    local SidebarFiller = Instance.new("Frame"); SidebarFiller.Parent = TabContainer; SidebarFiller.BackgroundColor3 = Theme.Sidebar; SidebarFiller.BorderSizePixel = 0; SidebarFiller.Size = UDim2.new(0, 10, 0, 10); SidebarFiller.Position = UDim2.new(1, -10, 0, 0)

    local TabList = Instance.new("UIListLayout")
    TabList.Parent = TabContainer
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 5)
    
    local TabPad = Instance.new("UIPadding")
    TabPad.Parent = TabContainer
    TabPad.PaddingTop = UDim.new(0, 10)
    TabPad.PaddingLeft = UDim.new(0, 5)

    -- 4. PAGE CONTAINER (Content - Right)
    local PageContainer = Instance.new("Frame")
    PageContainer.Name = "Content"
    PageContainer.Parent = MainFrame
    PageContainer.BackgroundColor3 = Theme.ContentBG
    PageContainer.BackgroundTransparency = 1
    PageContainer.Position = UDim2.new(0, 135, 0, 45) -- Rechts neben Sidebar
    PageContainer.Size = UDim2.new(1, -140, 1, -50)
    
    -- // TOGGLE LOGIC (Auto Detect) //
    local function ToggleUI()
        MainFrame.Visible = not MainFrame.Visible
    end

    if IsMobile then
        -- MOBILE: Zeige Button
        local MobileToggle = Instance.new("TextButton")
        MobileToggle.Name = "MobileToggle"
        MobileToggle.Parent = OffenseWare
        MobileToggle.BackgroundColor3 = Theme.MainColor
        MobileToggle.Position = UDim2.new(0, 50, 0, 50)
        MobileToggle.Size = UDim2.new(0, 50, 0, 50)
        MobileToggle.Font = Enum.Font.Code
        MobileToggle.Text = "OW"
        MobileToggle.TextColor3 = Theme.Text
        MobileToggle.TextSize = 20
        
        local ToggleCorner = Instance.new("UICorner"); ToggleCorner.CornerRadius = UDim.new(1, 0); ToggleCorner.Parent = MobileToggle
        local ToggleStroke = Instance.new("UIStroke"); ToggleStroke.Parent = MobileToggle; ToggleStroke.Thickness = 2; ToggleStroke.Color = Theme.Text
        
        MakeDraggable(MobileToggle, MobileToggle)
        MobileToggle.MouseButton1Click:Connect(ToggleUI)
    else
        -- PC: Keybind
        UserInputService.InputBegan:Connect(function(input, gpe)
            if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
                ToggleUI()
            end
        end)
    end

    local WindowFunctions = {}
    local FirstTab = true

    function WindowFunctions:CreateTab(TabName)
        local TabBtn = Instance.new("TextButton")
        local Page = Instance.new("ScrollingFrame")
        local PageList = Instance.new("UIListLayout")
        local PagePad = Instance.new("UIPadding")

        -- TAB BUTTON STYLE
        TabBtn.Name = TabName
        TabBtn.Parent = TabContainer
        TabBtn.BackgroundColor3 = Theme.Sidebar
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(1, -10, 0, 35)
        TabBtn.Font = Enum.Font.Code
        TabBtn.Text = TabName
        TabBtn.TextColor3 = Theme.TextDim
        TabBtn.TextSize = 14
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        
        local TabBtnCorner = Instance.new("UICorner"); TabBtnCorner.CornerRadius = UDim.new(0, 6); TabBtnCorner.Parent = TabBtn
        local TabBtnPad = Instance.new("UIPadding"); TabBtnPad.Parent = TabBtn; TabBtnPad.PaddingLeft = UDim.new(0, 10)

        -- PAGE STYLE
        Page.Name = TabName .. "_Page"
        Page.Parent = PageContainer
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Theme.MainColor
        
        PageList.Parent = Page
        PageList.SortOrder = Enum.SortOrder.LayoutOrder
        PageList.Padding = UDim.new(0, 5)
        
        PagePad.Parent = Page
        PagePad.PaddingTop = UDim.new(0, 5)
        PagePad.PaddingLeft = UDim.new(0, 5)
        PagePad.PaddingRight = UDim.new(0, 5)

        if FirstTab then
            Page.Visible = true
            TabBtn.TextColor3 = Theme.MainColor
            TabBtn.BackgroundTransparency = 0.9
            TabBtn.BackgroundColor3 = Theme.MainColor
            FirstTab = false
        end

        TabBtn.MouseButton1Click:Connect(function()
            -- Reset other tabs
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then 
                    TweenService:Create(v, TweenInfo.new(0.3), {TextColor3 = Theme.TextDim, BackgroundTransparency = 1}):Play()
                end
            end
            -- Hide other pages
            for _, v in pairs(PageContainer:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            
            -- Activate current
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.3), {TextColor3 = Theme.MainColor, BackgroundTransparency = 0.9, BackgroundColor3 = Theme.MainColor}):Play()
        end)

        local TabFuncs = {}

        -- BUTTON ELEMENT
        function TabFuncs:CreateButton(Text, Callback)
            local Btn = Instance.new("TextButton")
            Btn.Parent = Page
            Btn.BackgroundColor3 = Theme.Element
            Btn.Size = UDim2.new(1, 0, 0, 40)
            Btn.Font = Enum.Font.SourceSansBold
            Btn.Text = Text
            Btn.TextColor3 = Theme.Text
            Btn.TextSize = 16
            
            local UIC = Instance.new("UICorner"); UIC.CornerRadius = UDim.new(0, 6); UIC.Parent = Btn
            
            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.MainColor}):Play()
                task.wait(0.1)
                TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundColor3 = Theme.Element}):Play()
                pcall(Callback)
            end)
        end

        -- TOGGLE ELEMENT
        function TabFuncs:CreateToggle(Text, Default, Callback)
            local Toggled = Default or false
            local ToggleFrame = Instance.new("TextButton")
            ToggleFrame.Parent = Page
            ToggleFrame.BackgroundColor3 = Theme.Element
            ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
            ToggleFrame.Text = ""
            ToggleFrame.AutoButtonColor = false
            
            local UIC = Instance.new("UICorner"); UIC.CornerRadius = UDim.new(0, 6); UIC.Parent = ToggleFrame

            local Title = Instance.new("TextLabel")
            Title.Parent = ToggleFrame
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 10, 0, 0)
            Title.Size = UDim2.new(0.7, 0, 1, 0)
            Title.Font = Enum.Font.SourceSansBold
            Title.Text = Text
            Title.TextColor3 = Theme.Text
            Title.TextSize = 16
            Title.TextXAlignment = Enum.TextXAlignment.Left

            local Indicator = Instance.new("Frame")
            Indicator.Parent = ToggleFrame
            Indicator.BackgroundColor3 = Toggled and Theme.MainColor or Color3.fromRGB(60, 60, 60)
            Indicator.Position = UDim2.new(1, -30, 0.5, -10)
            Indicator.Size = UDim2.new(0, 20, 0, 20)
            local IndCorner = Instance.new("UICorner"); IndCorner.CornerRadius = UDim.new(0, 4); IndCorner.Parent = Indicator

            ToggleFrame.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                if Toggled then
                    TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = Theme.MainColor}):Play()
                else
                    TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                end
                pcall(Callback, Toggled)
            end)
        end

        -- SLIDER ELEMENT
        function TabFuncs:CreateSlider(Text, Min, Max, Default, Callback)
            local Value = Default or Min
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Parent = Page
            SliderFrame.BackgroundColor3 = Theme.Element
            SliderFrame.Size = UDim2.new(1, 0, 0, 50)
            local UIC = Instance.new("UICorner"); UIC.CornerRadius = UDim.new(0, 6); UIC.Parent = SliderFrame

            local Label = Instance.new("TextLabel")
            Label.Parent = SliderFrame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 10, 0, 5)
            Label.Size = UDim2.new(1, -20, 0, 20)
            Label.Font = Enum.Font.SourceSansBold
            Label.Text = Text .. ": " .. tostring(Value)
            Label.TextColor3 = Theme.Text
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local Bar = Instance.new("Frame")
            Bar.Parent = SliderFrame
            Bar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            Bar.Position = UDim2.new(0, 10, 0, 30)
            Bar.Size = UDim2.new(1, -20, 0, 8)
            local BarCorner = Instance.new("UICorner"); BarCorner.CornerRadius = UDim.new(0, 4); BarCorner.Parent = Bar

            local Fill = Instance.new("Frame")
            Fill.Parent = Bar
            Fill.BackgroundColor3 = Theme.MainColor
            Fill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
            local FillCorner = Instance.new("UICorner"); FillCorner.CornerRadius = UDim.new(0, 4); FillCorner.Parent = Fill

            local Trigger = Instance.new("TextButton")
            Trigger.Parent = SliderFrame
            Trigger.BackgroundTransparency = 1
            Trigger.Size = UDim2.new(1, 0, 1, 0)
            Trigger.Text = ""

            local function Update(input)
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local newVal = math.floor(Min + ((Max - Min) * pos))
                TweenService:Create(Fill, TweenInfo.new(0.05), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
                Label.Text = Text .. ": " .. tostring(newVal)
                pcall(Callback, newVal)
            end

            local dragging = false
            Trigger.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    Update(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    Update(input)
                end
            end)
        end

        return TabFuncs
    end

    return WindowFunctions
end

return Library
