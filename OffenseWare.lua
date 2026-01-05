--[[ 
    OffenseWare UI Library V3
    - Auto Device Detection (PC = RightShift, Mobile = Button)
    - Modern Sidebar Design (Fluent Inspired)
    - OffenseWare Theme (Purple/Black)
]]

local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- // DETECTION //
local IsMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
if not IsMobile and UserInputService.TouchEnabled and UserInputService.KeyboardEnabled then
    IsMobile = false -- Hybrid devices (Laptops with touch) treated as PC
end

-- // THEME //
local Theme = {
    Main = Color3.fromRGB(140, 20, 255),    -- Neon Purple
    Bg = Color3.fromRGB(20, 20, 25),        -- Deep Dark
    Sidebar = Color3.fromRGB(25, 25, 30),   -- Sidebar Dark
    Element = Color3.fromRGB(35, 35, 40),   -- Button Color
    Text = Color3.fromRGB(240, 240, 240),   -- Whiteish
    TextDim = Color3.fromRGB(150, 150, 150) -- Gray Text
}

-- // UTILS //
local function GetSafeParent()
    local success, parent = pcall(function() return gethui() end)
    if success and parent then return parent end
    return game:GetService("CoreGui"):FindFirstChild("RobloxGui") or LocalPlayer:WaitForChild("PlayerGui")
end

local function MakeDraggable(trigger, object)
    local dragging, dragInput, dragStart, startPos
    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = object.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    trigger.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            TweenService:Create(object, TweenInfo.new(0.05), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
        end
    end)
end

-- // LIBRARY START //
function Library:CreateWindow(HubName)
    local OffenseWare = Instance.new("ScreenGui")
    OffenseWare.Name = "OffenseWareLib"
    OffenseWare.Parent = GetSafeParent()
    OffenseWare.IgnoreGuiInset = true
    OffenseWare.ResetOnSpawn = false

    -- MAIN FRAME
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = OffenseWare
    MainFrame.BackgroundColor3 = Theme.Bg
    MainFrame.BackgroundTransparency = 0.05 -- Slight transparent modern feel
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    if IsMobile then MainFrame.Size = UDim2.new(0, 450, 0, 300) end -- Smaller on mobile
    
    local MainCorner = Instance.new("UICorner"); MainCorner.CornerRadius = UDim.new(0, 8); MainCorner.Parent = MainFrame
    local MainStroke = Instance.new("UIStroke"); MainStroke.Parent = MainFrame; MainStroke.Color = Theme.Main; MainStroke.Thickness = 1.5

    -- SHADOW
    local Shadow = Instance.new("ImageLabel")
    Shadow.Parent = MainFrame
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.ZIndex = -1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Theme.Main
    Shadow.ImageTransparency = 0.6

    -- SIDEBAR
    local Sidebar = Instance.new("Frame")
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.Size = UDim2.new(0, 130, 1, 0)
    local SideCorner = Instance.new("UICorner"); SideCorner.CornerRadius = UDim.new(0, 8); SideCorner.Parent = Sidebar
    local SideCover = Instance.new("Frame"); SideCover.Parent = Sidebar; SideCover.BackgroundColor3 = Theme.Sidebar; SideCover.BorderSizePixel = 0; SideCover.Size = UDim2.new(0, 10, 1, 0); SideCover.Position = UDim2.new(1, -10, 0, 0) -- Hides right corner
    
    -- TITLE
    local Title = Instance.new("TextLabel")
    Title.Parent = Sidebar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 15)
    Title.Size = UDim2.new(1, -20, 0, 20)
    Title.Font = Enum.Font.GothamBold
    Title.Text = HubName
    Title.TextColor3 = Theme.Main
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Div = Instance.new("Frame")
    Div.Parent = Sidebar; Div.BackgroundColor3 = Color3.fromRGB(50,50,50); Div.BorderSizePixel = 0; Div.Position = UDim2.new(0, 10, 0, 45); Div.Size = UDim2.new(1, -20, 0, 1)

    -- TAB CONTAINER
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Parent = Sidebar
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, 0, 0, 55)
    TabContainer.Size = UDim2.new(1, 0, 1, -65)
    TabContainer.ScrollBarThickness = 0
    local TabList = Instance.new("UIListLayout"); TabList.Parent = TabContainer; TabList.SortOrder = Enum.SortOrder.LayoutOrder; TabList.Padding = UDim.new(0, 5)
    local TabPad = Instance.new("UIPadding"); TabPad.Parent = TabContainer; TabPad.PaddingLeft = UDim.new(0, 10); TabPad.PaddingTop = UDim.new(0, 5)

    -- PAGE CONTAINER
    local PageContainer = Instance.new("Frame")
    PageContainer.Parent = MainFrame
    PageContainer.BackgroundTransparency = 1
    PageContainer.Position = UDim2.new(0, 140, 0, 10)
    PageContainer.Size = UDim2.new(1, -150, 1, -20)

    -- DRAGGABLE LOGIC
    local DragBar = Instance.new("Frame")
    DragBar.Parent = MainFrame
    DragBar.BackgroundTransparency = 1
    DragBar.Size = UDim2.new(1, 0, 0, 30)
    MakeDraggable(DragBar, MainFrame)
    MakeDraggable(Sidebar, MainFrame) -- Can also drag from sidebar

    -- // TOGGLE VISIBILITY LOGIC //
    local function ToggleUI()
        MainFrame.Visible = not MainFrame.Visible
    end

    if IsMobile then
        -- MOBILE: Floating Button
        local ToggleBtn = Instance.new("TextButton")
        ToggleBtn.Name = "ToggleBtn"
        ToggleBtn.Parent = OffenseWare
        ToggleBtn.BackgroundColor3 = Theme.Main
        ToggleBtn.Position = UDim2.new(0, 50, 0, 50)
        ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
        ToggleBtn.Text = "OW"
        ToggleBtn.Font = Enum.Font.GothamBold
        ToggleBtn.TextColor3 = Theme.Text
        ToggleBtn.TextSize = 14
        local TCorner = Instance.new("UICorner"); TCorner.CornerRadius = UDim.new(1, 0); TCorner.Parent = ToggleBtn
        local TStroke = Instance.new("UIStroke"); TStroke.Parent = ToggleBtn; TStroke.Color = Theme.Text; TStroke.Thickness = 2
        
        MakeDraggable(ToggleBtn, ToggleBtn)
        
        ToggleBtn.MouseButton1Click:Connect(ToggleUI)
    else
        -- PC: Keybind (Right Shift)
        UserInputService.InputBegan:Connect(function(input, gpe)
            if input.KeyCode == Enum.KeyCode.RightShift then
                ToggleUI()
            end
        end)
        
        -- Notification for PC Users
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "OffenseWare Loaded";
            Text = "Press Right Shift to toggle UI";
            Duration = 5;
        })
    end

    -- // TABS LOGIC //
    local WindowFuncs = {}
    local FirstTab = true

    function WindowFunctions:CreateTab(Name, Icon)
        local TabBtn = Instance.new("TextButton")
        local Page = Instance.new("ScrollingFrame")
        local PageList = Instance.new("UIListLayout")
        
        -- Tab Button Styling
        TabBtn.Parent = TabContainer
        TabBtn.BackgroundColor3 = Theme.Bg
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(1, -10, 0, 30)
        TabBtn.Text = Name
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextColor3 = Theme.TextDim
        TabBtn.TextSize = 14
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        local TabCorner = Instance.new("UICorner"); TabCorner.CornerRadius = UDim.new(0, 6); TabCorner.Parent = TabBtn
        local TabPadBtn = Instance.new("UIPadding"); TabPadBtn.Parent = TabBtn; TabPadBtn.PaddingLeft = UDim.new(0, 8)

        -- Page Styling
        Page.Parent = PageContainer
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Theme.Main
        
        PageList.Parent = Page; PageList.SortOrder = Enum.SortOrder.LayoutOrder; PageList.Padding = UDim.new(0, 6)
        local PagePad = Instance.new("UIPadding"); PagePad.Parent = Page; PagePad.PaddingRight = UDim.new(0, 6)

        -- Activate First Tab
        if FirstTab then
            TabBtn.TextColor3 = Theme.Main
            TabBtn.BackgroundTransparency = 0.9
            TabBtn.BackgroundColor3 = Theme.Main
            Page.Visible = true
            FirstTab = false
        end

        TabBtn.MouseButton1Click:Connect(function()
            -- Reset all tabs
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.3), {TextColor3 = Theme.TextDim, BackgroundTransparency = 1}):Play()
                end
            end
            -- Hide all pages
            for _, v in pairs(PageContainer:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            -- Activate this tab
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.3), {TextColor3 = Theme.Main, BackgroundTransparency = 0.9, BackgroundColor3 = Theme.Main}):Play()
        end)

        local Elements = {}

        -- BUTTON
        function Elements:CreateButton(Text, Callback)
            local Btn = Instance.new("TextButton")
            Btn.Parent = Page
            Btn.BackgroundColor3 = Theme.Element
            Btn.Size = UDim2.new(1, 0, 0, 35)
            Btn.Text = Text
            Btn.Font = Enum.Font.GothamMedium
            Btn.TextColor3 = Theme.Text
            Btn.TextSize = 14
            local BC = Instance.new("UICorner"); BC.CornerRadius = UDim.new(0, 6); BC.Parent = Btn
            
            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Main, TextColor3 = Color3.new(1,1,1)}):Play()
                task.wait(0.1)
                TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundColor3 = Theme.Element, TextColor3 = Theme.Text}):Play()
                pcall(Callback)
            end)
        end

        -- TOGGLE
        function Elements:CreateToggle(Text, Default, Callback)
            local Toggled = Default or false
            local TogFrame = Instance.new("TextButton")
            TogFrame.Parent = Page
            TogFrame.BackgroundColor3 = Theme.Element
            TogFrame.Size = UDim2.new(1, 0, 0, 35)
            TogFrame.Text = ""
            TogFrame.AutoButtonColor = false
            local TC = Instance.new("UICorner"); TC.CornerRadius = UDim.new(0, 6); TC.Parent = TogFrame

            local Lab = Instance.new("TextLabel")
            Lab.Parent = TogFrame
            Lab.BackgroundTransparency = 1
            Lab.Position = UDim2.new(0, 10, 0, 0)
            Lab.Size = UDim2.new(0.7, 0, 1, 0)
            Lab.Font = Enum.Font.GothamMedium
            Lab.Text = Text
            Lab.TextColor3 = Theme.Text
            Lab.TextSize = 14
            Lab.TextXAlignment = Enum.TextXAlignment.Left

            local Indicator = Instance.new("Frame")
            Indicator.Parent = TogFrame
            Indicator.Position = UDim2.new(1, -45, 0.5, -10)
            Indicator.Size = UDim2.new(0, 35, 0, 20)
            Indicator.BackgroundColor3 = Toggled and Theme.Main or Color3.fromRGB(60,60,60)
            local IC = Instance.new("UICorner"); IC.CornerRadius = UDim.new(1, 0); IC.Parent = Indicator

            local Circle = Instance.new("Frame")
            Circle.Parent = Indicator
            Circle.BackgroundColor3 = Color3.new(1,1,1)
            Circle.Size = UDim2.new(0, 16, 0, 16)
            Circle.Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            local CC = Instance.new("UICorner"); CC.CornerRadius = UDim.new(1, 0); CC.Parent = Circle

            TogFrame.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                local TargetPos = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                local TargetCol = Toggled and Theme.Main or Color3.fromRGB(60,60,60)
                
                TweenService:Create(Circle, TweenInfo.new(0.2), {Position = TargetPos}):Play()
                TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = TargetCol}):Play()
                pcall(Callback, Toggled)
            end)
        end

        -- SLIDER
        function Elements:CreateSlider(Text, Min, Max, Default, Callback)
            local Value = Default or Min
            local SFrame = Instance.new("Frame")
            SFrame.Parent = Page
            SFrame.BackgroundColor3 = Theme.Element
            SFrame.Size = UDim2.new(1, 0, 0, 45)
            local SC = Instance.new("UICorner"); SC.CornerRadius = UDim.new(0, 6); SC.Parent = SFrame

            local SLab = Instance.new("TextLabel")
            SLab.Parent = SFrame
            SLab.BackgroundTransparency = 1
            SLab.Position = UDim2.new(0, 10, 0, 5)
            SLab.Size = UDim2.new(1, -20, 0, 20)
            SLab.Font = Enum.Font.GothamMedium
            SLab.Text = Text
            SLab.TextColor3 = Theme.Text
            SLab.TextSize = 14
            SLab.TextXAlignment = Enum.TextXAlignment.Left

            local ValLab = Instance.new("TextLabel")
            ValLab.Parent = SFrame
            ValLab.BackgroundTransparency = 1
            ValLab.Position = UDim2.new(1, -40, 0, 5)
            ValLab.Size = UDim2.new(0, 30, 0, 20)
            ValLab.Font = Enum.Font.GothamBold
            ValLab.Text = tostring(Value)
            ValLab.TextColor3 = Theme.Main
            ValLab.TextSize = 14

            local Bar = Instance.new("Frame")
            Bar.Parent = SFrame
            Bar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            Bar.Position = UDim2.new(0, 10, 0, 30)
            Bar.Size = UDim2.new(1, -20, 0, 6)
            local BarC = Instance.new("UICorner"); BarC.CornerRadius = UDim.new(1, 0); BarC.Parent = Bar

            local Fill = Instance.new("Frame")
            Fill.Parent = Bar
            Fill.BackgroundColor3 = Theme.Main
            Fill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
            local FillC = Instance.new("UICorner"); FillC.CornerRadius = UDim.new(1, 0); FillC.Parent = Fill

            local Trigger = Instance.new("TextButton")
            Trigger.Parent = SFrame; Trigger.BackgroundTransparency = 1; Trigger.Size = UDim2.new(1,0,1,0); Trigger.Text = ""

            local function Update(input)
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local newVal = math.floor(Min + ((Max - Min) * pos))
                TweenService:Create(Fill, TweenInfo.new(0.05), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
                ValLab.Text = tostring(newVal)
                pcall(Callback, newVal)
            end

            local dragging = false
            Trigger.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true; Update(i) end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
            UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then Update(i) end end)
        end

        return Elements
    end

    return WindowFuncs
end

return Library
