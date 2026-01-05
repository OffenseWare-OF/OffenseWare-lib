--[[ 
    OffenseWare UI Library V6 (Modern Acrylic)
    - Full Acrylic/Blur Background (Built-in Module)
    - Smooth Quint Tweening
    - Modern Glow/Shadow Effects
    - Sidebar Navigation
]]

local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- // ACRYLIC MODULE (Built-in) //
local Acrylic = {}
do
    local function CreateBlur(parent)
        local Blur = Instance.new("BlurEffect")
        Blur.Name = "AcrylicBlur"
        Blur.Size = 0
        Blur.Parent = parent
        return Blur
    end
    
    function Acrylic.Enable()
        -- Wir nutzen Lighting Blur für den Effekt
        local ExistingBlur = Lighting:FindFirstChild("OffenseWareBlur")
        if not ExistingBlur then
            local Blur = Instance.new("BlurEffect")
            Blur.Name = "OffenseWareBlur"
            Blur.Size = 20 -- Stärke des Blurs
            Blur.Parent = Lighting
        end
    end
    
    function Acrylic.Disable()
        local Blur = Lighting:FindFirstChild("OffenseWareBlur")
        if Blur then Blur:Destroy() end
    end
end

-- // THEME (Modern Dark/Purple) //
local Theme = {
    MainColor = Color3.fromRGB(160, 50, 255),  -- Neon Purple
    Background = Color3.fromRGB(25, 25, 30),   -- Base Dark
    Acrylic = 0.5,                             -- Transparency (0-1)
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(160, 160, 160),
    Element = Color3.fromRGB(40, 40, 45),
    Glow = "rbxassetid://5028857472"           -- Soft Shadow ID
}

-- // UTILS //
local function GetSafeParent()
    local success, parent = pcall(function() return gethui() end)
    if success and parent then return parent end
    return game:GetService("CoreGui"):FindFirstChild("RobloxGui") or LocalPlayer:WaitForChild("PlayerGui")
end

local function Tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props):Play()
end

local function MakeDraggable(trigger, object)
    local dragging, dragInput, dragStart, startPos
    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = object.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    trigger.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Tween(object, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.1)
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

    -- Enable Blur
    Acrylic.Enable()

    -- MAIN FRAME
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = OffenseWare
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BackgroundTransparency = 0.3 -- Wichtig für Acrylic Effekt
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -160)
    MainFrame.Size = UDim2.new(0, 500, 0, 320)
    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
        MainFrame.Size = UDim2.new(0, 460, 0, 280) -- Mobile Size
    end
    
    local MainCorner = Instance.new("UICorner"); MainCorner.CornerRadius = UDim.new(0, 8); MainCorner.Parent = MainFrame
    local MainStroke = Instance.new("UIStroke"); MainStroke.Parent = MainFrame; MainStroke.Color = Theme.MainColor; MainStroke.Thickness = 1.5; MainStroke.Transparency = 0.5

    -- GLOW SHADOW
    local Glow = Instance.new("ImageLabel")
    Glow.Name = "Glow"
    Glow.Parent = MainFrame
    Glow.BackgroundTransparency = 1
    Glow.Position = UDim2.new(0, -15, 0, -15)
    Glow.Size = UDim2.new(1, 30, 1, 30)
    Glow.Image = Theme.Glow
    Glow.ImageColor3 = Theme.MainColor
    Glow.ImageTransparency = 0.6
    Glow.ScaleType = Enum.ScaleType.Slice
    Glow.SliceCenter = Rect.new(24, 24, 276, 276)
    Glow.ZIndex = -1

    -- DRAG BAR
    local DragBar = Instance.new("Frame")
    DragBar.Parent = MainFrame; DragBar.BackgroundTransparency = 1; DragBar.Size = UDim2.new(1, 0, 0, 40)
    MakeDraggable(DragBar, MainFrame)

    -- SIDEBAR
    local Sidebar = Instance.new("Frame")
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Sidebar.BackgroundTransparency = 0.5
    Sidebar.Size = UDim2.new(0, 140, 1, 0)
    local SideCorner = Instance.new("UICorner"); SideCorner.CornerRadius = UDim.new(0, 8); SideCorner.Parent = Sidebar
    -- Versteckt rechte Ecken der Sidebar für nahtlosen Übergang
    local SideCover = Instance.new("Frame"); SideCover.Parent = Sidebar; SideCover.BorderSizePixel = 0; SideCover.BackgroundColor3 = Color3.fromRGB(0,0,0); SideCover.BackgroundTransparency = 0.5; SideCover.Size = UDim2.new(0, 10, 1, 0); SideCover.Position = UDim2.new(1, -10, 0, 0)

    -- TITLE
    local Title = Instance.new("TextLabel")
    Title.Parent = Sidebar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 15)
    Title.Size = UDim2.new(1, -15, 0, 20)
    Title.Font = Enum.Font.GothamBold
    Title.Text = HubName
    Title.TextColor3 = Theme.Text
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- LINE
    local Line = Instance.new("Frame")
    Line.Parent = Sidebar
    Line.BackgroundColor3 = Theme.MainColor
    Line.BorderSizePixel = 0
    Line.Position = UDim2.new(0, 15, 0, 45)
    Line.Size = UDim2.new(0, 30, 0, 2)

    -- CONTAINER
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Parent = Sidebar; TabContainer.BackgroundTransparency = 1; TabContainer.Position = UDim2.new(0, 0, 0, 60); TabContainer.Size = UDim2.new(1, 0, 1, -60); TabContainer.ScrollBarThickness = 0
    local TabList = Instance.new("UIListLayout"); TabList.Parent = TabContainer; TabList.SortOrder = Enum.SortOrder.LayoutOrder; TabList.Padding = UDim.new(0, 5)
    local TabPad = Instance.new("UIPadding"); TabPad.Parent = TabContainer; TabPad.PaddingLeft = UDim.new(0, 10); TabPad.PaddingTop = UDim.new(0, 5)

    local PageContainer = Instance.new("Frame")
    PageContainer.Parent = MainFrame; PageContainer.BackgroundTransparency = 1; PageContainer.Position = UDim2.new(0, 150, 0, 15); PageContainer.Size = UDim2.new(1, -160, 1, -30)

    -- TOGGLE LOGIC
    local function ToggleUI()
        MainFrame.Visible = not MainFrame.Visible
        if MainFrame.Visible then Acrylic.Enable() else Acrylic.Disable() end
    end

    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
        local MobBtn = Instance.new("TextButton")
        MobBtn.Parent = OffenseWare; MobBtn.BackgroundColor3 = Theme.MainColor; MobBtn.Position = UDim2.new(0, 50, 0, 50); MobBtn.Size = UDim2.new(0, 45, 0, 45); MobBtn.Text = "OW"; MobBtn.TextColor3 = Theme.Text; MobBtn.Font = Enum.Font.GothamBold
        local MC = Instance.new("UICorner"); MC.CornerRadius = UDim.new(1,0); MC.Parent = MobBtn
        MakeDraggable(MobBtn, MobBtn)
        MobBtn.MouseButton1Click:Connect(ToggleUI)
    else
        UserInputService.InputBegan:Connect(function(i,g) if not g and i.KeyCode == Enum.KeyCode.RightShift then ToggleUI() end end)
    end

    local WinFuncs = {}
    local FirstTab = true

    function WinFuncs:CreateTab(Name)
        local TabBtn = Instance.new("TextButton")
        local Page = Instance.new("ScrollingFrame")
        
        TabBtn.Parent = TabContainer
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(1, -10, 0, 30)
        TabBtn.Text = Name
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextColor3 = Theme.TextDim
        TabBtn.TextSize = 14
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        local TPad = Instance.new("UIPadding"); TPad.Parent = TabBtn; TPad.PaddingLeft = UDim.new(0, 10)
        local TCorner = Instance.new("UICorner"); TCorner.CornerRadius = UDim.new(0, 6); TCorner.Parent = TabBtn

        Page.Parent = PageContainer
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        local PList = Instance.new("UIListLayout"); PList.Parent = Page; PList.Padding = UDim.new(0, 8); PList.SortOrder = Enum.SortOrder.LayoutOrder
        local PPad = Instance.new("UIPadding"); PPad.Parent = Page; PPad.PaddingRight = UDim.new(0, 5)

        if FirstTab then
            TabBtn.TextColor3 = Theme.MainColor
            TabBtn.BackgroundTransparency = 0.9
            TabBtn.BackgroundColor3 = Theme.MainColor
            Page.Visible = true
            FirstTab = false
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _,v in pairs(TabContainer:GetChildren()) do if v:IsA("TextButton") then Tween(v, {TextColor3 = Theme.TextDim, BackgroundTransparency = 1}) end end
            for _,v in pairs(PageContainer:GetChildren()) do v.Visible = false end
            Page.Visible = true
            Tween(TabBtn, {TextColor3 = Theme.MainColor, BackgroundTransparency = 0.9, BackgroundColor3 = Theme.MainColor})
        end)

        local Elements = {}
        
        function Elements:CreateButton(Text, Callback)
            local Btn = Instance.new("TextButton")
            Btn.Parent = Page
            Btn.BackgroundColor3 = Theme.Element
            Btn.Size = UDim2.new(1, 0, 0, 36)
            Btn.Text = Text
            Btn.Font = Enum.Font.Gotham
            Btn.TextColor3 = Theme.Text
            Btn.TextSize = 14
            Btn.AutoButtonColor = false
            local BC = Instance.new("UICorner"); BC.CornerRadius = UDim.new(0, 6); BC.Parent = Btn
            
            Btn.MouseEnter:Connect(function() Tween(Btn, {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}) end)
            Btn.MouseLeave:Connect(function() Tween(Btn, {BackgroundColor3 = Theme.Element}) end)
            Btn.MouseButton1Click:Connect(function()
                Tween(Btn, {TextSize = 12}, 0.1)
                task.wait(0.1)
                Tween(Btn, {TextSize = 14}, 0.1)
                pcall(Callback)
            end)
        end

        function Elements:CreateToggle(Text, Default, Callback)
            local Toggled = Default or false
            local Tog = Instance.new("TextButton")
            Tog.Parent = Page; Tog.BackgroundColor3 = Theme.Element; Tog.Size = UDim2.new(1, 0, 0, 36); Tog.Text = ""; Tog.AutoButtonColor = false
            local TC = Instance.new("UICorner"); TC.CornerRadius = UDim.new(0, 6); TC.Parent = Tog
            
            local Lab = Instance.new("TextLabel")
            Lab.Parent = Tog; Lab.BackgroundTransparency = 1; Lab.Position = UDim2.new(0, 10, 0, 0); Lab.Size = UDim2.new(0.7, 0, 1, 0)
            Lab.Font = Enum.Font.Gotham; Lab.Text = Text; Lab.TextColor3 = Theme.Text; Lab.TextSize = 14; Lab.TextXAlignment = Enum.TextXAlignment.Left

            local Switch = Instance.new("Frame")
            Switch.Parent = Tog; Switch.BackgroundColor3 = Color3.fromRGB(30, 30, 35); Switch.Position = UDim2.new(1, -50, 0.5, -10); Switch.Size = UDim2.new(0, 40, 0, 20)
            local SC = Instance.new("UICorner"); SC.CornerRadius = UDim.new(1, 0); SC.Parent = Switch
            local SCStroke = Instance.new("UIStroke"); SCStroke.Parent = Switch; SCStroke.Color = Color3.fromRGB(60,60,60); SCStroke.Thickness = 1

            local Dot = Instance.new("Frame")
            Dot.Parent = Switch; Dot.BackgroundColor3 = Color3.fromRGB(150, 150, 150); Dot.Size = UDim2.new(0, 16, 0, 16); Dot.Position = UDim2.new(0, 2, 0.5, -8)
            local DC = Instance.new("UICorner"); DC.CornerRadius = UDim.new(1, 0); DC.Parent = Dot

            local function Update()
                local TargetPos = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                local TargetCol = Toggled and Theme.MainColor or Color3.fromRGB(150, 150, 150)
                local StrokeCol = Toggled and Theme.MainColor or Color3.fromRGB(60, 60, 60)
                Tween(Dot, {Position = TargetPos, BackgroundColor3 = TargetCol})
                Tween(SCStroke, {Color = StrokeCol})
            end
            if Toggled then Update() end

            Tog.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                Update()
                pcall(Callback, Toggled)
            end)
        end

        function Elements:CreateSlider(Text, Min, Max, Default, Callback)
            local Value = Default or Min
            local SFrame = Instance.new("Frame")
            SFrame.Parent = Page; SFrame.BackgroundColor3 = Theme.Element; SFrame.Size = UDim2.new(1, 0, 0, 50)
            local SC = Instance.new("UICorner"); SC.CornerRadius = UDim.new(0, 6); SC.Parent = SFrame

            local Lab = Instance.new("TextLabel"); Lab.Parent = SFrame; Lab.BackgroundTransparency = 1; Lab.Position = UDim2.new(0, 10, 0, 5); Lab.Size = UDim2.new(1, -20, 0, 20)
            Lab.Font = Enum.Font.Gotham; Lab.Text = Text; Lab.TextColor3 = Theme.Text; Lab.TextSize = 14; Lab.TextXAlignment = Enum.TextXAlignment.Left

            local Val = Instance.new("TextLabel"); Val.Parent = SFrame; Val.BackgroundTransparency = 1; Val.Position = UDim2.new(1, -40, 0, 5); Val.Size = UDim2.new(0, 30, 0, 20)
            Val.Font = Enum.Font.GothamBold; Val.Text = tostring(Value); Val.TextColor3 = Theme.MainColor; Val.TextSize = 14

            local Bar = Instance.new("Frame"); Bar.Parent = SFrame; Bar.BackgroundColor3 = Color3.fromRGB(25, 25, 30); Bar.Position = UDim2.new(0, 10, 0, 30); Bar.Size = UDim2.new(1, -20, 0, 6)
            local BC = Instance.new("UICorner"); BC.CornerRadius = UDim.new(1, 0); BC.Parent = Bar

            local Fill = Instance.new("Frame"); Fill.Parent = Bar; Fill.BackgroundColor3 = Theme.MainColor; Fill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
            local FC = Instance.new("UICorner"); FC.CornerRadius = UDim.new(1, 0); FC.Parent = Fill

            local Trig = Instance.new("TextButton"); Trig.Parent = SFrame; Trig.BackgroundTransparency = 1; Trig.Size = UDim2.new(1, 0, 1, 0); Trig.Text = ""

            local function Update(input)
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local newVal = math.floor(Min + ((Max - Min) * pos))
                Tween(Fill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.05)
                Val.Text = tostring(newVal)
                pcall(Callback, newVal)
            end

            local dragging = false
            Trig.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true; Update(i) end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
            UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then Update(i) end end)
        end
        return Elements
    end
    return WinFuncs
end
return Library
