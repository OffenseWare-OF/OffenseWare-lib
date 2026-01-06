--[[ 
    OffenseWare UI Library V7 (Luna Edition)
    - Base: OffenseWare V6 (Mobile Friendly, Sidebar, Acrylic)
    - Style: Luna Interface Suite (Ripples, Dropdowns, Notifications)
]]

local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- // LUNA THEME //
local Theme = {
    Main = Color3.fromRGB(160, 50, 255),    -- Neon Purple
    Background = Color3.fromRGB(20, 20, 24), -- Deep Dark (Luna Style)
    Sidebar = Color3.fromRGB(25, 25, 30),
    Element = Color3.fromRGB(32, 32, 38),   -- Slightly lighter
    Text = Color3.fromRGB(240, 240, 240),
    TextDim = Color3.fromRGB(160, 160, 160),
    Outline = Color3.fromRGB(50, 50, 60),
    Ripple = Color3.fromRGB(255, 255, 255)
}

-- // UTILS //
local function GetSafeParent()
    local success, parent = pcall(function() return gethui() end)
    if success and parent then return parent end
    return game:GetService("CoreGui"):FindFirstChild("RobloxGui") or LocalPlayer:WaitForChild("PlayerGui")
end

local function Tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

-- RIPPLE EFFECT (From Luna)
local function CreateRipple(Parent)
    local Ripple = Instance.new("ImageLabel")
    Ripple.Name = "Ripple"
    Ripple.Parent = Parent
    Ripple.BackgroundColor3 = Theme.Ripple
    Ripple.BackgroundTransparency = 1
    Ripple.BorderSizePixel = 0
    Ripple.Image = "rbxassetid://266543268"
    Ripple.ImageTransparency = 0.8
    Ripple.Position = UDim2.new(0, Mouse.X - Parent.AbsolutePosition.X, 0, Mouse.Y - Parent.AbsolutePosition.Y)
    Ripple.Size = UDim2.new(0, 0, 0, 0)
    Ripple.ZIndex = 2
    
    local TweenSize = TweenService:Create(Ripple, TweenInfo.new(0.5), {Size = UDim2.new(0, 500, 0, 500), ImageTransparency = 1})
    TweenSize:Play()
    TweenSize.Completed:Connect(function() Ripple:Destroy() end)
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
    MainFrame.Parent = OffenseWare
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -160)
    MainFrame.Size = UDim2.new(0, 500, 0, 320)
    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
        MainFrame.Size = UDim2.new(0, 460, 0, 280)
    end
    
    local MainCorner = Instance.new("UICorner"); MainCorner.CornerRadius = UDim.new(0, 6); MainCorner.Parent = MainFrame
    local MainStroke = Instance.new("UIStroke"); MainStroke.Parent = MainFrame; MainStroke.Color = Theme.Outline; MainStroke.Thickness = 1

    -- SHADOW
    local Shadow = Instance.new("ImageLabel")
    Shadow.Parent = MainFrame; Shadow.BackgroundTransparency = 1; Shadow.Position = UDim2.new(0, -15, 0, -15); Shadow.Size = UDim2.new(1, 30, 1, 30); Shadow.ZIndex = -1
    Shadow.Image = "rbxassetid://5554236805"; Shadow.ImageColor3 = Color3.fromRGB(0,0,0); Shadow.ImageTransparency = 0.5

    -- SIDEBAR
    local Sidebar = Instance.new("Frame")
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.Size = UDim2.new(0, 130, 1, 0)
    local SideCorner = Instance.new("UICorner"); SideCorner.CornerRadius = UDim.new(0, 6); SideCorner.Parent = Sidebar
    local SideCover = Instance.new("Frame"); SideCover.Parent = Sidebar; SideCover.BorderSizePixel = 0; SideCover.BackgroundColor3 = Theme.Sidebar; SideCover.Size = UDim2.new(0, 10, 1, 0); SideCover.Position = UDim2.new(1, -10, 0, 0)

    -- TITLE
    local Title = Instance.new("TextLabel")
    Title.Parent = Sidebar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 15)
    Title.Size = UDim2.new(1, -15, 0, 20)
    Title.Font = Enum.Font.GothamBold
    Title.Text = HubName
    Title.TextColor3 = Theme.Text
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- TAB CONTAINER
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Parent = Sidebar; TabContainer.BackgroundTransparency = 1; TabContainer.Position = UDim2.new(0, 0, 0, 50); TabContainer.Size = UDim2.new(1, 0, 1, -50); TabContainer.ScrollBarThickness = 0
    local TabList = Instance.new("UIListLayout"); TabList.Parent = TabContainer; TabList.SortOrder = Enum.SortOrder.LayoutOrder; TabList.Padding = UDim.new(0, 5)
    local TabPad = Instance.new("UIPadding"); TabPad.Parent = TabContainer; TabPad.PaddingLeft = UDim.new(0, 10); TabPad.PaddingTop = UDim.new(0, 5)

    -- PAGE CONTAINER
    local PageContainer = Instance.new("Frame")
    PageContainer.Parent = MainFrame; PageContainer.BackgroundTransparency = 1; PageContainer.Position = UDim2.new(0, 140, 0, 10); PageContainer.Size = UDim2.new(1, -150, 1, -20)

    -- NOTIFICATION CONTAINER
    local NotifyContainer = Instance.new("Frame")
    NotifyContainer.Parent = OffenseWare
    NotifyContainer.BackgroundTransparency = 1
    NotifyContainer.Position = UDim2.new(1, -310, 1, -20) -- Bottom Right
    NotifyContainer.Size = UDim2.new(0, 300, 1, 0)
    NotifyContainer.AnchorPoint = Vector2.new(0, 1)
    local NotifyList = Instance.new("UIListLayout"); NotifyList.Parent = NotifyContainer; NotifyList.SortOrder = Enum.SortOrder.LayoutOrder; NotifyList.Padding = UDim.new(0, 5); NotifyList.VerticalAlignment = Enum.VerticalAlignment.Bottom

    -- NOTIFY FUNCTION
    function Library:Notify(TitleText, DescText, Duration)
        local Notif = Instance.new("Frame")
        Notif.Parent = NotifyContainer
        Notif.BackgroundColor3 = Theme.Sidebar
        Notif.Size = UDim2.new(1, 0, 0, 60)
        Notif.BackgroundTransparency = 1 -- Anim Start
        
        local NC = Instance.new("UICorner"); NC.CornerRadius = UDim.new(0, 6); NC.Parent = Notif
        local NS = Instance.new("UIStroke"); NS.Parent = Notif; NS.Color = Theme.Outline; NS.Transparency = 1

        local NTitle = Instance.new("TextLabel"); NTitle.Parent = Notif; NTitle.BackgroundTransparency = 1; NTitle.Position = UDim2.new(0, 10, 0, 5); NTitle.Size = UDim2.new(1, -20, 0, 20); NTitle.Font = Enum.Font.GothamBold; NTitle.Text = TitleText; NTitle.TextColor3 = Theme.Main; NTitle.TextSize = 14; NTitle.TextXAlignment = Enum.TextXAlignment.Left; NTitle.TextTransparency = 1
        local NDesc = Instance.new("TextLabel"); NDesc.Parent = Notif; NDesc.BackgroundTransparency = 1; NDesc.Position = UDim2.new(0, 10, 0, 25); NDesc.Size = UDim2.new(1, -20, 0, 30); NDesc.Font = Enum.Font.Gotham; NDesc.Text = DescText; NDesc.TextColor3 = Theme.TextDim; NDesc.TextSize = 12; NDesc.TextXAlignment = Enum.TextXAlignment.Left; NDesc.TextYAlignment = Enum.TextYAlignment.Top; NDesc.TextTransparency = 1; NDesc.TextWrapped = true

        -- Animation In
        Tween(Notif, {BackgroundTransparency = 0.1})
        Tween(NS, {Transparency = 0})
        Tween(NTitle, {TextTransparency = 0})
        Tween(NDesc, {TextTransparency = 0})

        task.delay(Duration or 3, function()
            Tween(Notif, {BackgroundTransparency = 1})
            Tween(NS, {Transparency = 1})
            Tween(NTitle, {TextTransparency = 1})
            Tween(NDesc, {TextTransparency = 1})
            task.wait(0.3)
            Notif:Destroy()
        end)
    end

    -- TOGGLE UI
    local function ToggleUI() MainFrame.Visible = not MainFrame.Visible end
    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
        local MobBtn = Instance.new("TextButton"); MobBtn.Parent = OffenseWare; MobBtn.BackgroundColor3 = Theme.Main; MobBtn.Position = UDim2.new(0, 50, 0, 50); MobBtn.Size = UDim2.new(0, 45, 0, 45); MobBtn.Text = "OW"; MobBtn.TextColor3 = Theme.Text; MobBtn.Font = Enum.Font.GothamBold
        local MC = Instance.new("UICorner"); MC.CornerRadius = UDim.new(1,0); MC.Parent = MobBtn
        MakeDraggable(MobBtn, MobBtn); MobBtn.MouseButton1Click:Connect(ToggleUI)
    else
        UserInputService.InputBegan:Connect(function(i,g) if not g and i.KeyCode == Enum.KeyCode.RightShift then ToggleUI() end end)
    end

    -- DRAG BAR
    local DragBar = Instance.new("Frame"); DragBar.Parent = MainFrame; DragBar.BackgroundTransparency = 1; DragBar.Size = UDim2.new(1, 0, 0, 40); MakeDraggable(DragBar, MainFrame)

    local WinFuncs = {}
    local FirstTab = true

    function WinFuncs:CreateTab(Name)
        local TabBtn = Instance.new("TextButton")
        local Page = Instance.new("ScrollingFrame")
        
        TabBtn.Parent = TabContainer; TabBtn.BackgroundTransparency = 1; TabBtn.Size = UDim2.new(1, -10, 0, 32); TabBtn.Text = Name; TabBtn.Font = Enum.Font.GothamMedium; TabBtn.TextColor3 = Theme.TextDim; TabBtn.TextSize = 13; TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        local TPad = Instance.new("UIPadding"); TPad.Parent = TabBtn; TPad.PaddingLeft = UDim.new(0, 10)
        local TCorner = Instance.new("UICorner"); TCorner.CornerRadius = UDim.new(0, 6); TCorner.Parent = TabBtn

        Page.Parent = PageContainer; Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 2
        local PList = Instance.new("UIListLayout"); PList.Parent = Page; PList.Padding = UDim.new(0, 6); PList.SortOrder = Enum.SortOrder.LayoutOrder
        local PPad = Instance.new("UIPadding"); PPad.Parent = Page; PPad.PaddingRight = UDim.new(0, 5); PPad.PaddingTop = UDim.new(0, 5)

        if FirstTab then TabBtn.TextColor3 = Theme.Main; TabBtn.BackgroundTransparency = 0.9; TabBtn.BackgroundColor3 = Theme.Main; Page.Visible = true; FirstTab = false end

        TabBtn.MouseButton1Click:Connect(function()
            for _,v in pairs(TabContainer:GetChildren()) do if v:IsA("TextButton") then Tween(v, {TextColor3 = Theme.TextDim, BackgroundTransparency = 1}) end end
            for _,v in pairs(PageContainer:GetChildren()) do v.Visible = false end
            Page.Visible = true
            Tween(TabBtn, {TextColor3 = Theme.Main, BackgroundTransparency = 0.9, BackgroundColor3 = Theme.Main})
        end)

        local Elements = {}

        function Elements:CreateButton(Text, Callback)
            local Btn = Instance.new("TextButton")
            Btn.Parent = Page; Btn.BackgroundColor3 = Theme.Element; Btn.Size = UDim2.new(1, 0, 0, 34); Btn.Text = Text; Btn.Font = Enum.Font.Gotham; Btn.TextColor3 = Theme.Text; Btn.TextSize = 13; Btn.AutoButtonColor = false; Btn.ClipsDescendants = true
            local BC = Instance.new("UICorner"); BC.CornerRadius = UDim.new(0, 4); BC.Parent = Btn
            
            Btn.MouseButton1Click:Connect(function()
                CreateRipple(Btn) -- Luna Ripple Effect
                pcall(Callback)
            end)
        end

        function Elements:CreateToggle(Text, Default, Callback)
            local Toggled = Default or false
            local Tog = Instance.new("TextButton")
            Tog.Parent = Page; Tog.BackgroundColor3 = Theme.Element; Tog.Size = UDim2.new(1, 0, 0, 34); Tog.Text = ""; Tog.AutoButtonColor = false
            local TC = Instance.new("UICorner"); TC.CornerRadius = UDim.new(0, 4); TC.Parent = Tog
            
            local Lab = Instance.new("TextLabel"); Lab.Parent = Tog; Lab.BackgroundTransparency = 1; Lab.Position = UDim2.new(0, 10, 0, 0); Lab.Size = UDim2.new(1, -50, 1, 0); Lab.Font = Enum.Font.Gotham; Lab.Text = Text; Lab.TextColor3 = Theme.Text; Lab.TextSize = 13; Lab.TextXAlignment = Enum.TextXAlignment.Left

            local Box = Instance.new("Frame"); Box.Parent = Tog; Box.BackgroundColor3 = Toggled and Theme.Main or Color3.fromRGB(45,45,50); Box.Position = UDim2.new(1, -26, 0.5, -8); Box.Size = UDim2.new(0, 16, 0, 16)
            local BC = Instance.new("UICorner"); BC.CornerRadius = UDim.new(0, 4); BC.Parent = Box

            Tog.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                Tween(Box, {BackgroundColor3 = Toggled and Theme.Main or Color3.fromRGB(45,45,50)})
                pcall(Callback, Toggled)
            end)
        end

        function Elements:CreateSlider(Text, Min, Max, Default, Callback)
            local Value = Default or Min
            local SFrame = Instance.new("Frame")
            SFrame.Parent = Page; SFrame.BackgroundColor3 = Theme.Element; SFrame.Size = UDim2.new(1, 0, 0, 45)
            local SC = Instance.new("UICorner"); SC.CornerRadius = UDim.new(0, 4); SC.Parent = SFrame

            local Lab = Instance.new("TextLabel"); Lab.Parent = SFrame; Lab.BackgroundTransparency = 1; Lab.Position = UDim2.new(0, 10, 0, 5); Lab.Size = UDim2.new(1, -20, 0, 20); Lab.Font = Enum.Font.Gotham; Lab.Text = Text; Lab.TextColor3 = Theme.Text; Lab.TextSize = 13; Lab.TextXAlignment = Enum.TextXAlignment.Left
            local Val = Instance.new("TextLabel"); Val.Parent = SFrame; Val.BackgroundTransparency = 1; Val.Position = UDim2.new(1, -40, 0, 5); Val.Size = UDim2.new(0, 30, 0, 20); Val.Font = Enum.Font.GothamBold; Val.Text = tostring(Value); Val.TextColor3 = Theme.Main; Val.TextSize = 13

            local Bar = Instance.new("Frame"); Bar.Parent = SFrame; Bar.BackgroundColor3 = Color3.fromRGB(25, 25, 30); Bar.Position = UDim2.new(0, 10, 0, 30); Bar.Size = UDim2.new(1, -20, 0, 6)
            local BC = Instance.new("UICorner"); BC.CornerRadius = UDim.new(1, 0); BC.Parent = Bar
            local Fill = Instance.new("Frame"); Fill.Parent = Bar; Fill.BackgroundColor3 = Theme.Main; Fill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
            local FC = Instance.new("UICorner"); FC.CornerRadius = UDim.new(1, 0); FC.Parent = Fill

            local Trig = Instance.new("TextButton"); Trig.Parent = SFrame; Trig.BackgroundTransparency = 1; Trig.Size = UDim2.new(1, 0, 1, 0); Trig.Text = ""
            
            local function Update(i)
                local pos = math.clamp((i.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
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

        -- DROPDOWN (New Feature!)
        function Elements:CreateDropdown(Text, Items, Default, Callback)
            local DropOpen = false
            local DropFrame = Instance.new("Frame")
            DropFrame.Parent = Page; DropFrame.BackgroundColor3 = Theme.Element; DropFrame.Size = UDim2.new(1, 0, 0, 34); DropFrame.ClipsDescendants = true
            local DC = Instance.new("UICorner"); DC.CornerRadius = UDim.new(0, 4); DC.Parent = DropFrame
            
            local DBtn = Instance.new("TextButton"); DBtn.Parent = DropFrame; DBtn.BackgroundTransparency = 1; DBtn.Size = UDim2.new(1, 0, 0, 34); DBtn.Text = ""; DBtn.ZIndex = 2
            local Lab = Instance.new("TextLabel"); Lab.Parent = DropFrame; Lab.BackgroundTransparency = 1; Lab.Position = UDim2.new(0, 10, 0, 0); Lab.Size = UDim2.new(1, -40, 0, 34); Lab.Font = Enum.Font.Gotham; Lab.Text = Text .. ": " .. (Default or "None"); Lab.TextColor3 = Theme.Text; Lab.TextSize = 13; Lab.TextXAlignment = Enum.TextXAlignment.Left
            local Arrow = Instance.new("TextLabel"); Arrow.Parent = DropFrame; Arrow.BackgroundTransparency = 1; Arrow.Position = UDim2.new(1, -30, 0, 0); Arrow.Size = UDim2.new(0, 30, 0, 34); Arrow.Font = Enum.Font.GothamBold; Arrow.Text = "+"; Arrow.TextColor3 = Theme.TextDim; Arrow.TextSize = 18

            local Container = Instance.new("Frame"); Container.Parent = DropFrame; Container.BackgroundTransparency = 1; Container.Position = UDim2.new(0, 0, 0, 34); Container.Size = UDim2.new(1, 0, 0, 0)
            local CList = Instance.new("UIListLayout"); CList.Parent = Container; CList.SortOrder = Enum.SortOrder.LayoutOrder

            for _, Item in pairs(Items) do
                local IB = Instance.new("TextButton"); IB.Parent = Container; IB.BackgroundColor3 = Theme.Element; IB.Size = UDim2.new(1, 0, 0, 30); IB.Text = Item; IB.TextColor3 = Theme.TextDim; IB.Font = Enum.Font.Gotham; IB.TextSize = 12
                IB.MouseButton1Click:Connect(function()
                    Lab.Text = Text .. ": " .. Item
                    pcall(Callback, Item)
                    DropOpen = false
                    Tween(DropFrame, {Size = UDim2.new(1, 0, 0, 34)})
                    Arrow.Text = "+"
                end)
            end

            DBtn.MouseButton1Click:Connect(function()
                DropOpen = not DropOpen
                local TargetHeight = DropOpen and (34 + (#Items * 30)) or 34
                Tween(DropFrame, {Size = UDim2.new(1, 0, 0, TargetHeight)})
                Arrow.Text = DropOpen and "-" or "+"
            end)
        end

        return Elements
    end
    return WinFuncs
end
return Library
