--[[ 
    OffenseWare UI Library V8.5 (Ultimate + ColorPicker)
    - Full Abyss Theme
    - Built-in ColorPicker
    - Auto Mobile/PC Detection
    - Smooth Animations
]]

local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- // THEME (Abyss Dark) //
local Theme = {
    Main = Color3.fromRGB(170, 60, 255),     -- OffenseWare Purple
    Background = Color3.fromRGB(18, 18, 22), -- Deep Dark
    Sidebar = Color3.fromRGB(22, 22, 26),    -- Sidebar
    Content = Color3.fromRGB(20, 20, 24),    -- Page BG
    Element = Color3.fromRGB(30, 30, 35),    -- Element BG
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(140, 140, 140),
    Outline = Color3.fromRGB(45, 45, 50),
    Ripple = Color3.fromRGB(255, 255, 255)
}

-- // UTILS //
local function GetSafeParent()
    local success, parent = pcall(function() return gethui() end)
    if success and parent then return parent end
    return game:GetService("CoreGui"):FindFirstChild("RobloxGui") or LocalPlayer:WaitForChild("PlayerGui")
end

local function Tween(obj, props, time, style, dir)
    TweenService:Create(obj, TweenInfo.new(time or 0.3, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props):Play()
end

local function CreateRipple(Parent)
    local Ripple = Instance.new("ImageLabel")
    Ripple.Name = "Ripple"
    Ripple.Parent = Parent
    Ripple.BackgroundColor3 = Theme.Ripple
    Ripple.BackgroundTransparency = 1
    Ripple.BorderSizePixel = 0
    Ripple.Image = "rbxassetid://266543268"
    Ripple.ImageTransparency = 0.9
    Ripple.Position = UDim2.new(0, Mouse.X - Parent.AbsolutePosition.X, 0, Mouse.Y - Parent.AbsolutePosition.Y)
    Ripple.Size = UDim2.new(0, 0, 0, 0)
    Ripple.ZIndex = 3
    
    local TweenSize = TweenService:Create(Ripple, TweenInfo.new(0.4), {Size = UDim2.new(0, 400, 0, 400), ImageTransparency = 1})
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
            Tween(object, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.05)
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
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -170)
    MainFrame.Size = UDim2.new(0, 500, 0, 340)
    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
        MainFrame.Size = UDim2.new(0, 460, 0, 300) -- Mobile Size
    end
    
    local MainCorner = Instance.new("UICorner"); MainCorner.CornerRadius = UDim.new(0, 8); MainCorner.Parent = MainFrame
    local MainStroke = Instance.new("UIStroke"); MainStroke.Parent = MainFrame; MainStroke.Color = Theme.Outline; MainStroke.Thickness = 1

    -- SHADOW
    local Shadow = Instance.new("ImageLabel")
    Shadow.Parent = MainFrame; Shadow.BackgroundTransparency = 1; Shadow.Position = UDim2.new(0, -25, 0, -25); Shadow.Size = UDim2.new(1, 50, 1, 50); Shadow.ZIndex = -1
    Shadow.Image = "rbxassetid://6015897843"; Shadow.ImageColor3 = Color3.fromRGB(0,0,0); Shadow.ImageTransparency = 0.4

    -- SIDEBAR
    local Sidebar = Instance.new("Frame")
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.Size = UDim2.new(0, 140, 1, 0)
    local SideCorner = Instance.new("UICorner"); SideCorner.CornerRadius = UDim.new(0, 8); SideCorner.Parent = Sidebar
    local SideCover = Instance.new("Frame"); SideCover.Parent = Sidebar; SideCover.BorderSizePixel = 0; SideCover.BackgroundColor3 = Theme.Sidebar; SideCover.Size = UDim2.new(0, 10, 1, 0); SideCover.Position = UDim2.new(1, -10, 0, 0)

    -- HEADER
    local Title = Instance.new("TextLabel")
    Title.Parent = Sidebar; Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0, 15, 0, 18); Title.Size = UDim2.new(1, -15, 0, 20)
    Title.Font = Enum.Font.GothamBold; Title.Text = HubName; Title.TextColor3 = Theme.Main; Title.TextSize = 17; Title.TextXAlignment = Enum.TextXAlignment.Left

    local SubTitle = Instance.new("TextLabel")
    SubTitle.Parent = Sidebar; SubTitle.BackgroundTransparency = 1; SubTitle.Position = UDim2.new(0, 15, 0, 38); SubTitle.Size = UDim2.new(1, -15, 0, 15)
    SubTitle.Font = Enum.Font.Gotham; SubTitle.Text = "VERSION 8.5"; SubTitle.TextColor3 = Theme.TextDim; SubTitle.TextSize = 11; SubTitle.TextXAlignment = Enum.TextXAlignment.Left

    -- TABS
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Parent = Sidebar; TabContainer.BackgroundTransparency = 1; TabContainer.Position = UDim2.new(0, 0, 0, 65); TabContainer.Size = UDim2.new(1, 0, 1, -75); TabContainer.ScrollBarThickness = 0
    local TabList = Instance.new("UIListLayout"); TabList.Parent = TabContainer; TabList.SortOrder = Enum.SortOrder.LayoutOrder; TabList.Padding = UDim.new(0, 4)
    local TabPad = Instance.new("UIPadding"); TabPad.Parent = TabContainer; TabPad.PaddingLeft = UDim.new(0, 10); TabPad.PaddingTop = UDim.new(0, 5)

    -- PAGES
    local PageContainer = Instance.new("Frame")
    PageContainer.Parent = MainFrame; PageContainer.BackgroundColor3 = Theme.Content; PageContainer.BackgroundTransparency = 1; PageContainer.Position = UDim2.new(0, 150, 0, 15); PageContainer.Size = UDim2.new(1, -160, 1, -30)

    -- NOTIFICATIONS
    local NotifContainer = Instance.new("Frame"); NotifContainer.Parent = OffenseWare; NotifContainer.BackgroundTransparency = 1; NotifContainer.Position = UDim2.new(1, -270, 1, -20); NotifContainer.Size = UDim2.new(0, 250, 1, 0); NotifContainer.AnchorPoint = Vector2.new(0, 1)
    local NotifList = Instance.new("UIListLayout"); NotifList.Parent = NotifContainer; NotifList.SortOrder = Enum.SortOrder.LayoutOrder; NotifList.Padding = UDim.new(0, 5); NotifList.VerticalAlignment = Enum.VerticalAlignment.Bottom

    function Library:Notify(Title, Text, Time)
        local Frame = Instance.new("Frame"); Frame.Parent = NotifContainer; Frame.BackgroundColor3 = Theme.Element; Frame.Size = UDim2.new(1, 0, 0, 0); Frame.ClipsDescendants = true
        local FC = Instance.new("UICorner"); FC.CornerRadius = UDim.new(0, 6); FC.Parent = Frame
        local FS = Instance.new("UIStroke"); FS.Parent = Frame; FS.Color = Theme.Outline; FS.Thickness = 1
        
        local TLab = Instance.new("TextLabel"); TLab.Parent = Frame; TLab.BackgroundTransparency = 1; TLab.Position = UDim2.new(0, 10, 0, 5); TLab.Size = UDim2.new(1, -20, 0, 20); TLab.Font = Enum.Font.GothamBold; TLab.Text = Title; TLab.TextColor3 = Theme.Main; TLab.TextSize = 13; TLab.TextXAlignment = Enum.TextXAlignment.Left
        local DLab = Instance.new("TextLabel"); DLab.Parent = Frame; DLab.BackgroundTransparency = 1; DLab.Position = UDim2.new(0, 10, 0, 22); DLab.Size = UDim2.new(1, -20, 0, 30); DLab.Font = Enum.Font.Gotham; DLab.Text = Text; DLab.TextColor3 = Theme.Text; DLab.TextSize = 12; DLab.TextXAlignment = Enum.TextXAlignment.Left; DLab.TextWrapped = true

        Tween(Frame, {Size = UDim2.new(1, 0, 0, 60)}, 0.3)
        task.delay(Time or 3, function()
            Tween(Frame, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
            task.wait(0.3)
            Frame:Destroy()
        end)
    end

-- TOGGLE BUTTON / KEY
    local function ToggleUI() MainFrame.Visible = not MainFrame.Visible end
    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
        local MBtn = Instance.new("TextButton"); MBtn.Parent = OffenseWare; MBtn.BackgroundColor3 = Theme.Main; MBtn.Position = UDim2.new(0, 50, 0, 50); MBtn.Size = UDim2.new(0, 45, 0, 45); MBtn.Text = "OW"; MBtn.TextColor3 = Theme.Text; MBtn.Font = Enum.Font.GothamBlack
        local MC = Instance.new("UICorner"); MC.CornerRadius = UDim.new(1,0); MC.Parent = MBtn
        MakeDraggable(MBtn, MBtn); MBtn.MouseButton1Click:Connect(ToggleUI)
    else
        UserInputService.InputBegan:Connect(function(i,g) if not g and i.KeyCode == Enum.KeyCode.RightShift then ToggleUI() end end)
    end
    
    local DB = Instance.new("Frame"); DB.Parent = MainFrame; DB.BackgroundTransparency = 1; DB.Size = UDim2.new(1, 0, 0, 40); MakeDraggable(DB, MainFrame)

    local WinFuncs = {}
    local FirstTab = true

    function WinFuncs:CreateTab(Name)
        local TabBtn = Instance.new("TextButton")
        local Page = Instance.new("ScrollingFrame")
        
        TabBtn.Parent = TabContainer; TabBtn.BackgroundColor3 = Theme.Sidebar; TabBtn.BackgroundTransparency = 1; TabBtn.Size = UDim2.new(1, -10, 0, 32); TabBtn.Text = Name; TabBtn.Font = Enum.Font.GothamMedium; TabBtn.TextColor3 = Theme.TextDim; TabBtn.TextSize = 13; TabBtn.TextXAlignment = Enum.TextXAlignment.Left; TabBtn.AutoButtonColor = false
        local TPad = Instance.new("UIPadding"); TPad.Parent = TabBtn; TPad.PaddingLeft = UDim.new(0, 12)
        local TCor = Instance.new("UICorner"); TCor.CornerRadius = UDim.new(0, 6); TCor.Parent = TabBtn
        local Ind = Instance.new("Frame"); Ind.Parent = TabBtn; Ind.BackgroundColor3 = Theme.Main; Ind.Size = UDim2.new(0, 3, 0, 16); Ind.Position = UDim2.new(0, -12, 0.5, -8); Ind.Visible = false; Ind.BorderSizePixel = 0
        local IndC = Instance.new("UICorner"); IndC.CornerRadius = UDim.new(1,0); IndC.Parent = Ind

        Page.Parent = PageContainer; Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 2; Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        local PList = Instance.new("UIListLayout"); PList.Parent = Page; PList.Padding = UDim.new(0, 6); PList.SortOrder = Enum.SortOrder.LayoutOrder
        local PPad = Instance.new("UIPadding"); PPad.Parent = Page; PPad.PaddingRight = UDim.new(0, 5); PPad.PaddingTop = UDim.new(0, 5)

        if FirstTab then TabBtn.TextColor3 = Theme.Text; Ind.Visible = true; Page.Visible = true; FirstTab = false end

        TabBtn.MouseButton1Click:Connect(function()
            for _,v in pairs(TabContainer:GetChildren()) do if v:IsA("TextButton") then Tween(v, {TextColor3 = Theme.TextDim}); if v:FindFirstChild("Frame") then v.Frame.Visible = false end end end
            for _,v in pairs(PageContainer:GetChildren()) do v.Visible = false end
            Page.Visible = true; Tween(TabBtn, {TextColor3 = Theme.Text}); Ind.Visible = true
        end)

        local Elements = {}

        function Elements:Section(Text)
            local Sec = Instance.new("TextLabel"); Sec.Parent = Page; Sec.BackgroundTransparency = 1; Sec.Size = UDim2.new(1, 0, 0, 20); Sec.Text = Text; Sec.TextColor3 = Theme.TextDim; Sec.TextSize = 11; Sec.Font = Enum.Font.GothamBold; Sec.TextXAlignment = Enum.TextXAlignment.Left
            local SPad = Instance.new("UIPadding"); SPad.Parent = Sec; SPad.PaddingLeft = UDim.new(0, 2); SPad.PaddingTop = UDim.new(0, 5)
        end

        function Elements:CreateButton(Text, Callback)
            local Btn = Instance.new("TextButton"); Btn.Parent = Page; Btn.BackgroundColor3 = Theme.Element; Btn.Size = UDim2.new(1, 0, 0, 34); Btn.Text = Text; Btn.Font = Enum.Font.Gotham; Btn.TextColor3 = Theme.Text; Btn.TextSize = 13; Btn.AutoButtonColor = false; Btn.ClipsDescendants = true
            local BC = Instance.new("UICorner"); BC.CornerRadius = UDim.new(0, 4); BC.Parent = Btn
            local BS = Instance.new("UIStroke"); BS.Parent = Btn; BS.Color = Theme.Outline; BS.Thickness = 1
            Btn.MouseEnter:Connect(function() Tween(BS, {Color = Theme.Main}) end)
            Btn.MouseLeave:Connect(function() Tween(BS, {Color = Theme.Outline}) end)
            Btn.MouseButton1Click:Connect(function() CreateRipple(Btn); pcall(Callback) end)
        end

        function Elements:CreateToggle(Text, Default, Callback)
            local Toggled = Default or false
            local Tog = Instance.new("TextButton"); Tog.Parent = Page; Tog.BackgroundColor3 = Theme.Element; Tog.Size = UDim2.new(1, 0, 0, 34); Tog.Text = ""; Tog.AutoButtonColor = false
            local TC = Instance.new("UICorner"); TC.CornerRadius = UDim.new(0, 4); TC.Parent = Tog
            local TS = Instance.new("UIStroke"); TS.Parent = Tog; TS.Color = Theme.Outline; TS.Thickness = 1
            local Lab = Instance.new("TextLabel"); Lab.Parent = Tog; Lab.BackgroundTransparency = 1; Lab.Position = UDim2.new(0, 10, 0, 0); Lab.Size = UDim2.new(1, -50, 1, 0); Lab.Font = Enum.Font.Gotham; Lab.Text = Text; Lab.TextColor3 = Theme.Text; Lab.TextSize = 13; Lab.TextXAlignment = Enum.TextXAlignment.Left
            local Switch = Instance.new("Frame"); Switch.Parent = Tog; Switch.BackgroundColor3 = Toggled and Theme.Main or Color3.fromRGB(50,50,55); Switch.Position = UDim2.new(1, -44, 0.5, -10); Switch.Size = UDim2.new(0, 34, 0, 20)
            local SC = Instance.new("UICorner"); SC.CornerRadius = UDim.new(1, 0); SC.Parent = Switch
            local Dot = Instance.new("Frame"); Dot.Parent = Switch; Dot.BackgroundColor3 = Color3.fromRGB(255,255,255); Dot.Size = UDim2.new(0, 16, 0, 16); Dot.Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            local DC = Instance.new("UICorner"); DC.CornerRadius = UDim.new(1, 0); DC.Parent = Dot
            Tog.MouseButton1Click:Connect(function() Toggled = not Toggled; Tween(Switch, {BackgroundColor3 = Toggled and Theme.Main or Color3.fromRGB(50,50,55)}); Tween(Dot, {Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}); pcall(Callback, Toggled) end)
        end

        function Elements:CreateSlider(Text, Min, Max, Default, Callback)
            local Value = Default or Min
            local SliderFrame = Instance.new("Frame"); SliderFrame.Parent = Page; SliderFrame.BackgroundColor3 = Theme.Element; SliderFrame.Size = UDim2.new(1, 0, 0, 45)
            local SC = Instance.new("UICorner"); SC.CornerRadius = UDim.new(0, 4); SC.Parent = SliderFrame
            local SS = Instance.new("UIStroke"); SS.Parent = SliderFrame; SS.Color = Theme.Outline; SS.Thickness = 1
            local Lab = Instance.new("TextLabel"); Lab.Parent = SliderFrame; Lab.BackgroundTransparency = 1; Lab.Position = UDim2.new(0, 10, 0, 5); Lab.Size = UDim2.new(1, -20, 0, 20); Lab.Font = Enum.Font.Gotham; Lab.Text = Text; Lab.TextColor3 = Theme.Text; Lab.TextSize = 13; Lab.TextXAlignment = Enum.TextXAlignment.Left
            local Val = Instance.new("TextLabel"); Val.Parent = SliderFrame; Val.BackgroundTransparency = 1; Val.Position = UDim2.new(1, -40, 0, 5); Val.Size = UDim2.new(0, 30, 0, 20); Val.Font = Enum.Font.GothamBold; Val.Text = tostring(Value); Val.TextColor3 = Theme.Main; Val.TextSize = 13
            local Bar = Instance.new("Frame"); Bar.Parent = SliderFrame; Bar.BackgroundColor3 = Theme.Sidebar; Bar.Position = UDim2.new(0, 10, 0, 30); Bar.Size = UDim2.new(1, -20, 0, 6)
            local BC = Instance.new("UICorner"); BC.CornerRadius = UDim.new(1, 0); BC.Parent = Bar
            local Fill = Instance.new("Frame"); Fill.Parent = Bar; Fill.BackgroundColor3 = Theme.Main; Fill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
            local FC = Instance.new("UICorner"); FC.CornerRadius = UDim.new(1, 0); FC.Parent = Fill
            local Trig = Instance.new("TextButton"); Trig.Parent = SliderFrame; Trig.BackgroundTransparency = 1; Trig.Size = UDim2.new(1, 0, 1, 0); Trig.Text = ""
            local function Update(i)
                local pos = math.clamp((i.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local newVal = math.floor(Min + ((Max - Min) * pos))
                Tween(Fill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.05); Val.Text = tostring(newVal); pcall(Callback, newVal)
            end
            local dragging = false
            Trig.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true; Update(i) end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
            UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then Update(i) end end)
        end

        function Elements:CreateDropdown(Text, Items, Default, Callback)
            local DropOpen = false
            local Selected = Default or "None"
            local DropFrame = Instance.new("Frame"); DropFrame.Parent = Page; DropFrame.BackgroundColor3 = Theme.Element; DropFrame.Size = UDim2.new(1, 0, 0, 34); DropFrame.ClipsDescendants = true
            local DC = Instance.new("UICorner"); DC.CornerRadius = UDim.new(0, 4); DC.Parent = DropFrame
            local DS = Instance.new("UIStroke"); DS.Parent = DropFrame; DS.Color = Theme.Outline; DS.Thickness = 1
            local Trig = Instance.new("TextButton"); Trig.Parent = DropFrame; Trig.BackgroundTransparency = 1; Trig.Size = UDim2.new(1, 0, 0, 34); Trig.Text = ""
            local Lab = Instance.new("TextLabel"); Lab.Parent = DropFrame; Lab.BackgroundTransparency = 1; Lab.Position = UDim2.new(0, 10, 0, 0); Lab.Size = UDim2.new(0.6, 0, 0, 34); Lab.Font = Enum.Font.Gotham; Lab.Text = Text; Lab.TextColor3 = Theme.Text; Lab.TextSize = 13; Lab.TextXAlignment = Enum.TextXAlignment.Left
            local SelLab = Instance.new("TextLabel"); SelLab.Parent = DropFrame; SelLab.BackgroundTransparency = 1; SelLab.Position = UDim2.new(0.6, 0, 0, 0); SelLab.Size = UDim2.new(0.4, -25, 0, 34); SelLab.Font = Enum.Font.GothamBold; SelLab.Text = Selected; SelLab.TextColor3 = Theme.Main; SelLab.TextSize = 13; SelLab.TextXAlignment = Enum.TextXAlignment.Right
            local Arrow = Instance.new("ImageLabel"); Arrow.Parent = DropFrame; Arrow.BackgroundTransparency = 1; Arrow.Position = UDim2.new(1, -22, 0.5, -8); Arrow.Size = UDim2.new(0, 16, 0, 16); Arrow.Image = "rbxassetid://6034818372"; Arrow.ImageColor3 = Theme.TextDim
            local Container = Instance.new("Frame"); Container.Parent = DropFrame; Container.BackgroundTransparency = 1; Container.Position = UDim2.new(0, 0, 0, 36); Container.Size = UDim2.new(1, 0, 0, 0)
            local CList = Instance.new("UIListLayout"); CList.Parent = Container; CList.SortOrder = Enum.SortOrder.LayoutOrder; CList.Padding = UDim.new(0, 2)
            for _, Item in pairs(Items) do
                local ItemBtn = Instance.new("TextButton"); ItemBtn.Parent = Container; ItemBtn.BackgroundColor3 = Theme.Sidebar; ItemBtn.Size = UDim2.new(1, -4, 0, 28); ItemBtn.Text = Item; ItemBtn.TextColor3 = Theme.TextDim; ItemBtn.Font = Enum.Font.Gotham; ItemBtn.TextSize = 12; ItemBtn.BorderColor3 = Theme.Background; ItemBtn.BorderSizePixel = 0
                local IC = Instance.new("UICorner"); IC.CornerRadius = UDim.new(0, 4); IC.Parent = ItemBtn
                ItemBtn.MouseButton1Click:Connect(function() Selected = Item; SelLab.Text = Selected; pcall(Callback, Item); DropOpen = false; Tween(DropFrame, {Size = UDim2.new(1, 0, 0, 34)}, 0.3); Tween(Arrow, {Rotation = 0}, 0.3); Tween(DS, {Color = Theme.Outline}) end)
            end
            Trig.MouseButton1Click:Connect(function() DropOpen = not DropOpen; local TargetH = DropOpen and (40 + (#Items * 30)) or 34; Tween(DropFrame, {Size = UDim2.new(1, 0, 0, TargetH)}, 0.3); Tween(Arrow, {Rotation = DropOpen and 180 or 0}, 0.3); Tween(DS, {Color = DropOpen and Theme.Main or Theme.Outline}) end)
        end

        function Elements:CreateColorPicker(Text, Default, Callback)
            local ColorVal = Default or Color3.fromRGB(255, 255, 255); local HSV = {H = 0, S = 1, V = 1}; local PickerOpen = false
            local CPFrame = Instance.new("Frame"); CPFrame.Parent = Page; CPFrame.BackgroundColor3 = Theme.Element; CPFrame.Size = UDim2.new(1, 0, 0, 34); CPFrame.ClipsDescendants = true
            local CC = Instance.new("UICorner"); CC.CornerRadius = UDim.new(0, 4); CC.Parent = CPFrame
            local CS = Instance.new("UIStroke"); CS.Parent = CPFrame; CS.Color = Theme.Outline; CS.Thickness = 1
            local Lab = Instance.new("TextLabel"); Lab.Parent = CPFrame; Lab.BackgroundTransparency = 1; Lab.Position = UDim2.new(0, 10, 0, 0); Lab.Size = UDim2.new(0.5, 0, 0, 34); Lab.Font = Enum.Font.Gotham; Lab.Text = Text; Lab.TextColor3 = Theme.Text; Lab.TextSize = 13; Lab.TextXAlignment = Enum.TextXAlignment.Left
            local Preview = Instance.new("TextButton"); Preview.Parent = CPFrame; Preview.BackgroundColor3 = ColorVal; Preview.Position = UDim2.new(1, -45, 0, 7); Preview.Size = UDim2.new(0, 35, 0, 20); Preview.Text = ""; Preview.AutoButtonColor = false
            local PC = Instance.new("UICorner"); PC.CornerRadius = UDim.new(0, 4); PC.Parent = Preview
            local Trig = Instance.new("TextButton"); Trig.Parent = CPFrame; Trig.BackgroundTransparency = 1; Trig.Size = UDim2.new(1, 0, 0, 34); Trig.Text = ""
            local Container = Instance.new("Frame"); Container.Parent = CPFrame; Container.BackgroundTransparency = 1; Container.Position = UDim2.new(0, 0, 0, 34); Container.Size = UDim2.new(1, 0, 0, 116)
            local SVMap = Instance.new("ImageLabel"); SVMap.Parent = Container; SVMap.Image = "rbxassetid://4155801252"; SVMap.Position = UDim2.new(0, 10, 0, 10); SVMap.Size = UDim2.new(1, -40, 0, 100); SVMap.BackgroundColor3 = Color3.fromHSV(HSV.H, 1, 1); SVMap.BorderSizePixel = 0
            local SVC = Instance.new("UICorner"); SVC.CornerRadius = UDim.new(0, 4); SVC.Parent = SVMap
            local Marker = Instance.new("Frame"); Marker.Parent = SVMap; Marker.BackgroundColor3 = Color3.fromRGB(255,255,255); Marker.Size = UDim2.new(0, 4, 0, 4); Marker.Position = UDim2.new(1, -2, 0, -2); Marker.BorderColor3 = Color3.fromRGB(0,0,0); Marker.BorderSizePixel = 1
            local HueBar = Instance.new("ImageLabel"); HueBar.Parent = Container; HueBar.Image = "rbxassetid://3678880020"; HueBar.Position = UDim2.new(1, -25, 0, 10); HueBar.Size = UDim2.new(0, 15, 0, 100); HueBar.BackgroundColor3 = Color3.fromRGB(255,255,255); HueBar.BorderSizePixel = 0
            local HC = Instance.new("UICorner"); HC.CornerRadius = UDim.new(0, 4); HC.Parent = HueBar
            local HueMark = Instance.new("Frame"); HueMark.Parent = HueBar; HueMark.BackgroundColor3 = Color3.fromRGB(255,255,255); HueMark.Size = UDim2.new(1, 0, 0, 2); HueMark.Position = UDim2.new(0, 0, 0, 0); HueMark.BorderSizePixel = 0
            
            local function UpdateColor() ColorVal = Color3.fromHSV(HSV.H, HSV.S, HSV.V); Preview.BackgroundColor3 = ColorVal; SVMap.BackgroundColor3 = Color3.fromHSV(HSV.H, 1, 1); pcall(Callback, ColorVal) end
            local DraggingHue, DraggingSV = false, false
            HueBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then DraggingHue = true end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then DraggingHue = false end end)
            UserInputService.InputChanged:Connect(function(i) if DraggingHue and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local Y = math.clamp((i.Position.Y - HueBar.AbsolutePosition.Y) / HueBar.AbsoluteSize.Y, 0, 1); HSV.H = 1 - Y; HueMark.Position = UDim2.new(0, 0, Y, 0); UpdateColor() end end)
            SVMap.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then DraggingSV = true end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then DraggingSV = false end end)
            UserInputService.InputChanged:Connect(function(i) if DraggingSV and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local X = math.clamp((i.Position.X - SVMap.AbsolutePosition.X) / SVMap.AbsoluteSize.X, 0, 1); local Y = math.clamp((i.Position.Y - SVMap.AbsolutePosition.Y) / SVMap.AbsoluteSize.Y, 0, 1); HSV.S = X; HSV.V = 1 - Y; Marker.Position = UDim2.new(X, -2, Y, -2); UpdateColor() end end)
            Trig.MouseButton1Click:Connect(function() PickerOpen = not PickerOpen; Tween(CPFrame, {Size = UDim2.new(1, 0, 0, PickerOpen and 150 or 34)}) end)
        end

        return Elements
    end
    return WinFuncs
end
return Library                    
