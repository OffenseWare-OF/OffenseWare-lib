--[[ 
    OffenseWare UI Library - Delta Rescue Version
    Target: Mobile / PlayerGui Force
]]

local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 1. SICHERSTELLEN, DASS WIR DAS RICHTIGE PARENT HABEN
-- Wir erzwingen PlayerGui, da CoreGui auf Delta oft spinnt.
local function GetParent()
    return LocalPlayer:WaitForChild("PlayerGui")
end

-- 2. ALTE UI LÖSCHEN (Cleanup)
-- Falls das Script schonmal lief, löschen wir die alte UI, um Bugs zu vermeiden.
pcall(function()
    if LocalPlayer.PlayerGui:FindFirstChild("OffenseWare_Mobile") then
        LocalPlayer.PlayerGui.OffenseWare_Mobile:Destroy()
    end
end)

function Library:CreateWindow(HubName)
    print("Starte UI Erstellung...") -- Debug Print

    local OffenseWare = Instance.new("ScreenGui")
    OffenseWare.Name = "OffenseWare_Mobile"
    OffenseWare.Parent = GetParent()
    OffenseWare.ResetOnSpawn = false
    OffenseWare.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    OffenseWare.IgnoreGuiInset = true -- WICHTIG FÜR MOBILE (Damit es nicht hinter der Topbar verschwindet)

    local MainFrame = Instance.new("Frame")
    local TopBar = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local TabContainer = Instance.new("ScrollingFrame")
    local PageContainer = Instance.new("Frame")
    
    -- TOGGLE BUTTON (Damit du es öffnen kannst)
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "ToggleUI"
    ToggleBtn.Parent = OffenseWare
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0) -- Hellgrün damit man es sieht
    ToggleBtn.Position = UDim2.new(0, 20, 0, 50) -- Oben Links, unter der Roblox Leiste
    ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
    ToggleBtn.Font = Enum.Font.SourceSansBold
    ToggleBtn.Text = "MENU"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.TextSize = 14
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = ToggleBtn
    
    -- Main Frame Setup
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = OffenseWare
    MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150) -- Mittig
    MainFrame.Size = UDim2.new(0, 400, 0, 300)
    MainFrame.Visible = false -- Startet unsichtbar, Button drücken!
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Parent = MainFrame
    MainStroke.Color = Color3.fromRGB(200, 40, 40)
    MainStroke.Thickness = 2

    -- Toggle Logik
    ToggleBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)
    
    -- Einfache Drag Funktion für Mobile
    local function AddDrag(obj)
        local dragging, dragInput, dragStart, startPos
        obj.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = obj.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        obj.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end
    AddDrag(ToggleBtn) -- Button bewegbar machen
    AddDrag(MainFrame) -- Fenster bewegbar machen

    -- TopBar
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BorderSizePixel = 0
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 8)
    TopBarCorner.Parent = TopBar
    
    -- Fix für die unteren Ecken der Topbar
    local TopFill = Instance.new("Frame")
    TopFill.Parent = TopBar
    TopFill.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    TopFill.BorderSizePixel = 0
    TopFill.Size = UDim2.new(1, 0, 0, 10)
    TopFill.Position = UDim2.new(0, 0, 1, -10)

    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Font = Enum.Font.Code
    Title.Text = HubName
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Container Setup
    TabContainer.Parent = MainFrame
    TabContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    TabContainer.Size = UDim2.new(0, 110, 1, -40)
    TabContainer.BorderSizePixel = 0
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabContainer

    local TabList = Instance.new("UIListLayout")
    TabList.Parent = TabContainer
    TabList.Padding = UDim.new(0, 5)
    
    local TabPad = Instance.new("UIPadding")
    TabPad.Parent = TabContainer
    TabPad.PaddingTop = UDim.new(0, 10)

    PageContainer.Parent = MainFrame
    PageContainer.BackgroundTransparency = 1
    PageContainer.Position = UDim2.new(0, 110, 0, 40)
    PageContainer.Size = UDim2.new(1, -110, 1, -40)

    local Funcs = {}
    local FirstPage = true

    function Funcs:CreateTab(Name)
        local TabBtn = Instance.new("TextButton")
        local Page = Instance.new("ScrollingFrame")
        local PageList = Instance.new("UIListLayout")
        
        TabBtn.Parent = TabContainer
        TabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(1, 0, 0, 35)
        TabBtn.Font = Enum.Font.SourceSansBold
        TabBtn.Text = Name
        TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabBtn.TextSize = 16
        
        Page.Parent = PageContainer
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        
        PageList.Parent = Page
        PageList.Padding = UDim.new(0, 8)
        PageList.SortOrder = Enum.SortOrder.LayoutOrder
        
        local PagePad = Instance.new("UIPadding")
        PagePad.Parent = Page
        PagePad.PaddingTop = UDim.new(0, 10)
        PagePad.PaddingLeft = UDim.new(0, 10)
        PagePad.PaddingRight = UDim.new(0, 10)

        if FirstPage then
            Page.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            FirstPage = false
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(PageContainer:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(TabContainer:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(180, 180, 180) end end
            Page.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        local TabItems = {}

        function TabItems:CreateButton(Text, Callback)
            local Btn = Instance.new("TextButton")
            Btn.Parent = Page
            Btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            Btn.Size = UDim2.new(1, -5, 0, 40)
            Btn.Font = Enum.Font.SourceSans
            Btn.Text = Text
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.TextSize = 16
            
            local UIC = Instance.new("UICorner")
            UIC.Parent = Btn
            
            Btn.MouseButton1Click:Connect(function()
                pcall(Callback)
            end)
        end
        
        -- Toggle Fix
        function TabItems:CreateToggle(Text, Default, Callback)
            local ToggleVal = Default or false
            local TFrame = Instance.new("TextButton") -- Button statt Frame für besseren Klick
            TFrame.Parent = Page
            TFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            TFrame.Size = UDim2.new(1, -5, 0, 40)
            TFrame.Text = ""
            TFrame.AutoButtonColor = false
            
            local TC = Instance.new("UICorner")
            TC.Parent = TFrame
            
            local TLab = Instance.new("TextLabel")
            TLab.Parent = TFrame
            TLab.BackgroundTransparency = 1
            TLab.Position = UDim2.new(0, 10, 0, 0)
            TLab.Size = UDim2.new(0.7, 0, 1, 0)
            TLab.Text = Text
            TLab.TextColor3 = Color3.fromRGB(255, 255, 255)
            TLab.TextSize = 16
            TLab.TextXAlignment = Enum.TextXAlignment.Left
            TLab.Font = Enum.Font.SourceSans

            local Status = Instance.new("Frame")
            Status.Parent = TFrame
            Status.Position = UDim2.new(1, -30, 0.5, -10)
            Status.Size = UDim2.new(0, 20, 0, 20)
            Status.BackgroundColor3 = ToggleVal and Color3.fromRGB(200, 40, 40) or Color3.fromRGB(80, 80, 80)
            
            local SC = Instance.new("UICorner"); SC.Parent = Status; SC.CornerRadius = UDim.new(0, 4)

            TFrame.MouseButton1Click:Connect(function()
                ToggleVal = not ToggleVal
                Status.BackgroundColor3 = ToggleVal and Color3.fromRGB(200, 40, 40) or Color3.fromRGB(80, 80, 80)
                pcall(Callback, ToggleVal)
            end)
        end

        function TabItems:CreateSlider(Text, Min, Max, Default, Callback)
            local Val = Default or Min
            local SFrame = Instance.new("Frame")
            SFrame.Parent = Page
            SFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            SFrame.Size = UDim2.new(1, -5, 0, 50)
            
            local SC = Instance.new("UICorner"); SC.Parent = SFrame
            
            local SLabel = Instance.new("TextLabel")
            SLabel.Parent = SFrame
            SLabel.BackgroundTransparency = 1
            SLabel.Position = UDim2.new(0, 10, 0, 5)
            SLabel.Size = UDim2.new(1, -20, 0, 20)
            SLabel.Text = Text .. ": " .. tostring(Val)
            SLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            SLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local Bar = Instance.new("Frame")
            Bar.Parent = SFrame
            Bar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Bar.Position = UDim2.new(0, 10, 0, 30)
            Bar.Size = UDim2.new(1, -20, 0, 10)
            local BC = Instance.new("UICorner"); BC.Parent = Bar
            
            local Fill = Instance.new("Frame")
            Fill.Parent = Bar
            Fill.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
            Fill.Size = UDim2.new((Val - Min) / (Max - Min), 0, 1, 0)
            local FC = Instance.new("UICorner"); FC.Parent = Fill
            
            local Trigger = Instance.new("TextButton")
            Trigger.Parent = SFrame
            Trigger.BackgroundTransparency = 1
            Trigger.Size = UDim2.new(1, 0, 1, 0)
            Trigger.Text = ""
            
            local dragging = false
            local function Update(input)
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local res = math.floor(Min + ((Max - Min) * pos))
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                SLabel.Text = Text .. ": " .. tostring(res)
                pcall(Callback, res)
            end
            
            Trigger.InputBegan:Connect(function(inp) 
                if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true; Update(inp)
                end
            end)
            UserInputService.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)
            UserInputService.InputChanged:Connect(function(inp)
                if dragging and (inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseMovement) then Update(inp) end
            end)
        end

        return TabItems
    end

    print("UI Erfolgreich geladen!")
    return Funcs
end

return Library