-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- Colors
local COLORS = {
    Background = Color3.fromRGB(12, 12, 18),
    Surface = Color3.fromRGB(20, 20, 30),
    NeonPurple = Color3.fromRGB(170, 0, 255),
    NeonPink = Color3.fromRGB(255, 0, 170),
    White = Color3.fromRGB(255, 255, 255),
    Gray = Color3.fromRGB(150, 150, 150),
    Green = Color3.fromRGB(0, 255, 100),
    Red = Color3.fromRGB(255, 50, 50),
    Yellow = Color3.fromRGB(255, 215, 0),
    Blue = Color3.fromRGB(0, 200, 255)
}

-- ESP States
local ESPStates = {
    Players = false,
    SwordDealer = false,
    DevilFruits = false,
    Berries = false,
    Chests = false
}

-- ESP Objects Storage
local ESPObjects = {
    Players = {},
    SwordDealer = {},
    DevilFruits = {},
    Berries = {},
    Chests = {}
}

-- Drawing Lines Storage
local TracerLines = {}

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NeonBloxHub"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 380, 0, 520)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -260)
MainFrame.BackgroundColor3 = COLORS.Background
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

-- Gradient Background
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, COLORS.Background),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 15, 35)),
    ColorSequenceKeypoint.new(1, COLORS.Background)
})
UIGradient.Rotation = 45
UIGradient.Parent = MainFrame

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 20)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = COLORS.NeonPurple
MainStroke.Thickness = 2
MainStroke.Transparency = 0.3
MainStroke.Parent = MainFrame

-- Glow Effect
local Glow = Instance.new("ImageLabel")
Glow.Name = "Glow"
Glow.Size = UDim2.new(1, 40, 1, 40)
Glow.Position = UDim2.new(0, -20, 0, -20)
Glow.BackgroundTransparency = 1
Glow.Image = "rbxassetid://4996891970"
Glow.ImageColor3 = COLORS.NeonPurple
Glow.ImageTransparency = 0.9
Glow.ZIndex = 0
Glow.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = COLORS.Surface
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 20)
HeaderCorner.Parent = Header

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 20)
HeaderFix.Position = UDim2.new(0, 0, 1, -20)
HeaderFix.BackgroundColor3 = COLORS.Surface
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "NEON BLOX HUB"
Title.TextColor3 = COLORS.White
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.Parent = Header

-- Subtitle
local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(0.7, 0, 0, 20)
Subtitle.Position = UDim2.new(0, 20, 0.6, 0)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "PREMIUM EDITION"
Subtitle.TextColor3 = COLORS.NeonPurple
Subtitle.TextSize = 12
Subtitle.Font = Enum.Font.Gotham
Subtitle.Parent = Header

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 40, 0, 40)
MinimizeBtn.Position = UDim2.new(1, -55, 0, 10)
MinimizeBtn.BackgroundColor3 = COLORS.Surface
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Text = "✕"
MinimizeBtn.TextColor3 = COLORS.Red
MinimizeBtn.TextSize = 20
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = Header

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(1, 0)
MinimizeCorner.Parent = MinimizeBtn

local MinimizeStroke = Instance.new("UIStroke")
MinimizeStroke.Color = COLORS.Red
MinimizeStroke.Thickness = 1.5
MinimizeStroke.Parent = MinimizeBtn

-- Toggle Button (Circular, Draggable)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(0, 55, 0, 55)
ToggleBtn.Position = UDim2.new(0, 25, 0.5, -27)
ToggleBtn.BackgroundColor3 = COLORS.Surface
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Text = "⚡"
ToggleBtn.TextColor3 = COLORS.NeonPurple
ToggleBtn.TextSize = 28
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Visible = false
ToggleBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtn

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = COLORS.NeonPurple
ToggleStroke.Thickness = 2
ToggleStroke.Parent = ToggleBtn

local ToggleGlow = Instance.new("ImageLabel")
ToggleGlow.Size = UDim2.new(1.5, 0, 1.5, 0)
ToggleGlow.Position = UDim2.new(-0.25, 0, -0.25, 0)
ToggleGlow.BackgroundTransparency = 1
ToggleGlow.Image = "rbxassetid://4996891970"
ToggleGlow.ImageColor3 = COLORS.NeonPurple
ToggleGlow.ImageTransparency = 0.8
ToggleGlow.Parent = ToggleBtn

-- Content Frame
local Content = Instance.new("ScrollingFrame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -30, 1, -80)
Content.Position = UDim2.new(0, 15, 0, 70)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 3
Content.ScrollBarImageColor3 = COLORS.NeonPurple
Content.CanvasSize = UDim2.new(0, 0, 0, 800)
Content.Parent = MainFrame

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.FillDirection = Enum.FillDirection.Vertical
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 15)
ContentLayout.Parent = Content

-- Function to Create Toggle Section
local function CreateToggleSection(name, description, color, layoutOrder)
    local Section = Instance.new("Frame")
    Section.Name = name .. "Section"
    Section.Size = UDim2.new(1, 0, 0, 80)
    Section.BackgroundColor3 = COLORS.Surface
    Section.BorderSizePixel = 0
    Section.LayoutOrder = layoutOrder
    Section.Parent = Content
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 15)
    SectionCorner.Parent = Section
    
    local SectionStroke = Instance.new("UIStroke")
    SectionStroke.Color = color
    SectionStroke.Thickness = 1
    SectionStroke.Transparency = 0.5
    SectionStroke.Parent = Section
    
    -- Icon
    local Icon = Instance.new("TextLabel")
    Icon.Size = UDim2.new(0, 50, 0, 50)
    Icon.Position = UDim2.new(0, 15, 0, 15)
    Icon.BackgroundColor3 = COLORS.Background
    Icon.BorderSizePixel = 0
    Icon.Text = name == "Players" and "👤" or name == "SwordDealer" and "⚔️" or name == "DevilFruits" and "🍎" or name == "Berries" and "🫐" or "📦"
    Icon.TextSize = 28
    Icon.Parent = Section
    
    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(1, 0)
    IconCorner.Parent = Icon
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.5, 0, 0, 25)
    Title.Position = UDim2.new(0, 75, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = name:gsub("([A-Z])", " %1"):upper()
    Title.TextColor3 = COLORS.White
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Section
    
    -- Description
    local Desc = Instance.new("TextLabel")
    Desc.Size = UDim2.new(0.5, 0, 0, 40)
    Desc.Position = UDim2.new(0, 75, 0, 35)
    Desc.BackgroundTransparency = 1
    Desc.Text = description
    Desc.TextColor3 = COLORS.Gray
    Desc.TextSize = 11
    Desc.Font = Enum.Font.Gotham
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.TextWrapped = true
    Desc.Parent = Section
    
    -- Toggle Button
    local Toggle = Instance.new("TextButton")
    Toggle.Name = "Toggle"
    Toggle.Size = UDim2.new(0, 70, 0, 35)
    Toggle.Position = UDim2.new(1, -85, 0.5, -17.5)
    Toggle.BackgroundColor3 = COLORS.Background
    Toggle.BorderSizePixel = 0
    Toggle.Text = "OFF"
    Toggle.TextColor3 = COLORS.Gray
    Toggle.TextSize = 14
    Toggle.Font = Enum.Font.GothamBold
    Toggle.Parent = Section
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = Toggle
    
    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Color = COLORS.Gray
    ToggleStroke.Thickness = 1.5
    ToggleStroke.Parent = Toggle
    
    -- Status Indicator
    local Status = Instance.new("Frame")
    Status.Name = "Status"
    Status.Size = UDim2.new(0, 8, 0, 8)
    Status.Position = UDim2.new(0, -12, 0.5, -4)
    Status.BackgroundColor3 = COLORS.Red
    Status.BorderSizePixel = 0
    Status.Parent = Toggle
    
    local StatusCorner = Instance.new("UICorner")
    StatusCorner.CornerRadius = UDim.new(1, 0)
    StatusCorner.Parent = Status
    
    return Section, Toggle, Status, ToggleStroke
end

-- Create Sections
local PlayerSection, PlayerToggle, PlayerStatus, PlayerStroke = CreateToggleSection("Players", "Nick, Health, Fruit, Distance, Avatar", COLORS.Green, 1)
local DealerSection, DealerToggle, DealerStatus, DealerStroke = CreateToggleSection("SwordDealer", "Legendary Sword Dealer Tracker", COLORS.Yellow, 2)
local FruitSection, FruitToggle, FruitStatus, FruitStroke = CreateToggleSection("DevilFruits", "Devil Fruits with 3D Box & Icon", COLORS.NeonPurple, 3)
local BerrySection, BerryToggle, BerryStatus, BerryStroke = CreateToggleSection("Berries", "Haki Materials & Berries", COLORS.Blue, 4)
local ChestSection, ChestToggle, ChestStatus, ChestStroke = CreateToggleSection("Chests", "Gold, Silver, Diamond Chests", COLORS.Yellow, 5)

-- ESP Functions
local function ClearESP(category)
    for obj, items in pairs(ESPObjects[category]) do
        for _, item in ipairs(items) do
            if item then item:Destroy() end
        end
    end
    ESPObjects[category] = {}
    
    if category == "Players" or category == "SwordDealer" then
        for _, line in pairs(TracerLines) do
            if line then line:Remove() end
        end
        TracerLines = {}
    end
end

local function CreatePlayerESP(targetPlayer)
    if targetPlayer == player then return end
    
    local character = targetPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local head = character:FindFirstChild("Head")
    local root = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not head then return end
    
    -- Get Avatar
    local userId = targetPlayer.UserId
    local thumbType = Enum.ThumbnailType.HeadShot
    local thumbSize = Enum.ThumbnailSize.Size420x420
    local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
    
    local espItems = {}
    
    -- Highlight
    local highlight = Instance.new("Highlight")
    highlight.FillColor = COLORS.Green
    highlight.OutlineColor = COLORS.White
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = character
    table.insert(espItems, highlight)
    
    -- Main Billboard
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 120)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head
    
    -- Avatar Image
    local avatarFrame = Instance.new("ImageLabel")
    avatarFrame.Size = UDim2.new(0, 50, 0, 50)
    avatarFrame.Position = UDim2.new(0.5, -25, 0, 5)
    avatarFrame.BackgroundColor3 = COLORS.Background
    avatarFrame.Image = content
    avatarFrame.Parent = billboard
    
    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(1, 0)
    avatarCorner.Parent = avatarFrame
    
    local avatarStroke = Instance.new("UIStroke")
    avatarStroke.Color = COLORS.Green
    avatarStroke.Thickness = 2
    avatarStroke.Parent = avatarFrame
    
    -- Name
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.Position = UDim2.new(0, 0, 0, 58)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = targetPlayer.Name
    nameLabel.TextColor3 = COLORS.Green
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = billboard
    
    -- Health Bar Background
    local hpBg = Instance.new("Frame")
    hpBg.Size = UDim2.new(0.8, 0, 0, 6)
    hpBg.Position = UDim2.new(0.1, 0, 0, 80)
    hpBg.BackgroundColor3 = COLORS.Background
    hpBg.BorderSizePixel = 0
    hpBg.Parent = billboard
    
    local hpBgCorner = Instance.new("UICorner")
    hpBgCorner.CornerRadius = UDim.new(1, 0)
    hpBgCorner.Parent = hpBg
    
    -- Health Bar Fill
    local hpFill = Instance.new("Frame")
    hpFill.Size = UDim2.new(1, 0, 1, 0)
    hpFill.BackgroundColor3 = COLORS.Green
    hpFill.BorderSizePixel = 0
    hpFill.Parent = hpBg
    
    local hpFillCorner = Instance.new("UICorner")
    hpFillCorner.CornerRadius = UDim.new(1, 0)
    hpFillCorner.Parent = hpFill
    
    -- HP Text
    local hpText = Instance.new("TextLabel")
    hpText.Size = UDim2.new(1, 0, 0, 15)
    hpText.Position = UDim2.new(0, 0, 0, 88)
    hpText.BackgroundTransparency = 1
    hpText.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
    hpText.TextColor3 = COLORS.White
    hpText.TextStrokeTransparency = 0
    hpText.TextSize = 11
    hpText.Font = Enum.Font.Gotham
    hpText.Parent = billboard
    
    -- Distance
    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(1, 0, 0, 15)
    distLabel.Position = UDim2.new(0, 0, 0, 103)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "0m"
    distLabel.TextColor3 = COLORS.Gray
    distLabel.TextStrokeTransparency = 0
    distLabel.TextSize = 11
    distLabel.Font = Enum.Font.Gotham
    distLabel.Parent = billboard
    
    -- Fruit Info (if has)
    local fruitLabel = Instance.new("TextLabel")
    fruitLabel.Size = UDim2.new(1, 0, 0, 15)
    fruitLabel.Position = UDim2.new(0, 0, 1, 5)
    fruitLabel.BackgroundTransparency = 1
    fruitLabel.Text = ""
    fruitLabel.TextColor3 = COLORS.NeonPurple
    fruitLabel.TextStrokeTransparency = 0
    fruitLabel.TextSize = 10
    fruitLabel.Font = Enum.Font.GothamBold
    fruitLabel.Parent = billboard
    
    table.insert(espItems, billboard)
    
    -- Tracer Line
    local line = Drawing.new("Line")
    line.Visible = false
    line.Thickness = 2
    line.Color = COLORS.Green
    line.Transparency = 0.8
    TracerLines[targetPlayer] = line
    
    ESPObjects.Players[targetPlayer] = espItems
    
    -- Update Loop
    spawn(function()
        while ESPStates.Players and targetPlayer.Parent do
            local myChar = player.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            
            if humanoid and myRoot and root then
                local dist = (myRoot.Position - root.Position).Magnitude
                distLabel.Text = math.floor(dist) .. "m"
                
                local hpPercent = humanoid.Health / humanoid.MaxHealth
                hpFill.Size = UDim2.new(hpPercent, 0, 1, 0)
                hpText.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                
                -- Check for fruit
                local backpack = targetPlayer:FindFirstChild("Backpack")
                if backpack then
                    for _, tool in ipairs(backpack:GetChildren()) do
                        if tool:IsA("Tool") and (tool.Name:find("Fruit") or tool.Name:find("Blox")) then
                            fruitLabel.Text = "🍎 " .. tool.Name
                            break
                        end
                    end
                end
                
                -- Update Tracer
                local pos, visible = camera:WorldToViewportPoint(root.Position)
                if visible then
                    line.Visible = true
                    line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                    line.To = Vector2.new(pos.X, pos.Y)
                else
                    line.Visible = false
                end
            end
            
            task.wait(0.05)
        end
        line.Visible = false
    end)
end

local function CreateSwordDealerESP(dealer)
    if ESPObjects.SwordDealer[dealer] then return end
    
    local espItems = {}
    
    -- Big Alert Text
    local alert = Instance.new("TextLabel")
    alert.Size = UDim2.new(0, 400, 0, 50)
    alert.Position = UDim2.new(0.5, -200, 0, 100)
    alert.BackgroundTransparency = 1
    alert.Text = "⚔️ SWORD DEALER SPAWNED! ⚔️"
    alert.TextColor3 = COLORS.Yellow
    alert.TextStrokeColor3 = COLORS.Red
    alert.TextStrokeTransparency = 0
    alert.TextSize = 28
    alert.Font = Enum.Font.GothamBlack
    alert.Parent = ScreenGui
    
    TweenService:Create(alert, TweenInfo.new(0.5, Enum.EasingStyle.Elastic), {TextSize = 32}):Play()
    
    table.insert(espItems, alert)
    
    -- Highlight
    local highlight = Instance.new("Highlight")
    highlight.FillColor = COLORS.Yellow
    highlight.OutlineColor = COLORS.Red
    highlight.FillTransparency = 0.3
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = dealer
    table.insert(espItems, highlight)
    
    -- Billboard
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 250, 0, 80)
    billboard.StudsOffset = Vector3.new(0, 5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = dealer
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = COLORS.Background
    bg.BackgroundTransparency = 0.3
    bg.Parent = billboard
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 10)
    bgCorner.Parent = bg
    
    local bgStroke = Instance.new("UIStroke")
    bgStroke.Color = COLORS.Yellow
    bgStroke.Thickness = 2
    bgStroke.Parent = bg
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -10, 0.5, 0)
    title.Position = UDim2.new(0, 5, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = "LEGENDARY SWORD DEALER"
    title.TextColor3 = COLORS.Yellow
    title.TextStrokeTransparency = 0
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.Parent = bg
    
    local dist = Instance.new("TextLabel")
    dist.Size = UDim2.new(1, -10, 0.5, -5)
    dist.Position = UDim2.new(0, 5, 0.5, 0)
    dist.BackgroundTransparency = 1
    dist.Text = "0m"
    dist.TextColor3 = COLORS.White
    dist.TextStrokeTransparency = 0
    dist.TextSize = 20
    dist.Font = Enum.Font.GothamBlack
    dist.Parent = bg
    
    table.insert(espItems, billboard)
    
    -- Tracer
    local line = Drawing.new("Line")
    line.Visible = false
    line.Thickness = 3
    line.Color = COLORS.Yellow
    TracerLines[dealer] = line
    
    ESPObjects.SwordDealer[dealer] = espItems
    
    -- Update
    spawn(function()
        while ESPStates.SwordDealer and dealer.Parent do
            local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            local dealerPos = dealer:GetPivot().Position
            
            if myRoot then
                local distance = (myRoot.Position - dealerPos).Magnitude
                dist.Text = math.floor(distance) .. "m"
                
                local pos, visible = camera:WorldToViewportPoint(dealerPos)
                if visible then
                    line.Visible = true
                    line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                    line.To = Vector2.new(pos.X, pos.Y)
                    line.Color = distance < 100 and COLORS.Green or distance < 500 and COLORS.Yellow or COLORS.Red
                else
                    line.Visible = false
                end
            end
            task.wait(0.05)
        end
        line.Visible = false
    end)
end

local function CreateDevilFruitESP(fruit)
    if ESPObjects.DevilFruits[fruit] then return end
    
    local espItems = {}
    
    -- 3D Box (using 6 faces)
    local box = Instance.new("Model")
    box.Name = "ESPBox"
    
    local parts = {}
    for i = 1, 6 do
        local face = Instance.new("Part")
        face.Size = Vector3.new(3, 3, 0.1)
        face.Anchored = true
        face.CanCollide = false
        face.Transparency = 0.7
        face.Color = COLORS.NeonPurple
        face.Material = Enum.Material.Neon
        face.Parent = box
        table.insert(parts, face)
    end
    
    -- Position box faces
    local cf = fruit.CFrame
    parts[1].CFrame = cf * CFrame.new(0, 0, -1.5) -- Front
    parts[2].CFrame = cf * CFrame.new(0, 0, 1.5) -- Back
    parts[3].CFrame = cf * CFrame.new(-1.5, 0, 0) * CFrame.Angles(0, math.pi/2, 0) -- Left
    parts[4].CFrame = cf * CFrame.new(1.5, 0, 0) * CFrame.Angles(0, math.pi/2, 0) -- Right
    parts[5].CFrame = cf * CFrame.new(0, 1.5, 0) * CFrame.Angles(math.pi/2, 0, 0) -- Top
    parts[6].CFrame = cf * CFrame.new(0, -1.5, 0) * CFrame.Angles(math.pi/2, 0, 0) -- Bottom
    
    box.Parent = Workspace
    
    -- Highlight
    local highlight = Instance.new("Highlight")
    highlight.FillColor = COLORS.NeonPurple
    highlight.OutlineColor = COLORS.White
    highlight.FillTransparency = 0.5
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = fruit
    
    -- Billboard
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 100)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = fruit
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = COLORS.Background
    bg.BackgroundTransparency = 0.2
    bg.Parent = billboard
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 10)
    bgCorner.Parent = bg
    
    local bgStroke = Instance.new("UIStroke")
    bgStroke.Color = COLORS.NeonPurple
    bgStroke.Thickness = 2
    bgStroke.Parent = bg
    
    -- Fruit Icon (using emoji based on name)
    local fruitName = fruit.Name
    local icon = "🍎"
    if fruitName:find("Bomb") then icon = "💣"
    elseif fruitName:find("Spike") then icon = "🌵"
    elseif fruitName:find("Chop") then icon = "✂️"
    elseif fruitName:find("Spring") then icon = "🌀"
    elseif fruitName:find("Smoke") then icon = "💨"
    elseif fruitName:find("Flame") then icon = "🔥"
    elseif fruitName:find("Ice") then icon = "❄️"
    elseif fruitName:find("Sand") then icon = "🏜️"
    elseif fruitName:find("Dark") then icon = "🌑"
    elseif fruitName:find("Light") then icon = "⚡"
    elseif fruitName:find("Rubber") then icon = "🎈"
    elseif fruitName:find("Barrier") then icon = "🛡️"
    end
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 40, 0, 40)
    iconLabel.Position = UDim2.new(0.5, -20, 0, 5)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextSize = 35
    iconLabel.Parent = bg
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -10, 0, 25)
    nameLabel.Position = UDim2.new(0, 5, 0, 45)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = fruitName:upper()
    nameLabel.TextColor3 = COLORS.NeonPurple
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextSize = 16
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = bg
    
    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(1, -10, 0, 20)
    distLabel.Position = UDim2.new(0, 5, 0, 70)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "0m"
    distLabel.TextColor3 = COLORS.White
    distLabel.TextStrokeTransparency = 0
    distLabel.TextSize = 14
    distLabel.Font = Enum.Font.Gotham
    distLabel.Parent = bg
    
    table.insert(espItems, box)
    table.insert(espItems, highlight)
    table.insert(espItems, billboard)
    
    ESPObjects.DevilFruits[fruit] = espItems
    
    -- Update box position
    spawn(function()
        while ESPStates.DevilFruits and fruit.Parent do
            local cf = fruit.CFrame
            parts[1].CFrame = cf * CFrame.new(0, 0, -1.5)
            parts[2].CFrame = cf * CFrame.new(0, 0, 1.5)
            parts[3].CFrame = cf * CFrame.new(-1.5, 0, 0) * CFrame.Angles(0, math.pi/2, 0)
            parts[4].CFrame = cf * CFrame.new(1.5, 0, 0) * CFrame.Angles(0, math.pi/2, 0)
            parts[5].CFrame = cf * CFrame.new(0, 1.5, 0) * CFrame.Angles(math.pi/2, 0, 0)
            parts[6].CFrame = cf * CFrame.new(0, -1.5, 0) * CFrame.Angles(math.pi/2, 0, 0)
            
            local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if myRoot then
                local distance = (myRoot.Position - fruit.Position).Magnitude
                distLabel.Text = math.floor(distance) .. "m"
            end
            
            task.wait(0.03)
        end
    end)
end

local function CreateBerryESP(berry)
    if ESPObjects.Berries[berry] then return end
    
    local espItems = {}
    
    -- Highlight
    local highlight = Instance.new("Highlight")
    highlight.FillColor = COLORS.Blue
    highlight.OutlineColor = COLORS.White
    highlight.FillTransparency = 0.4
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = berry
    
    -- Billboard
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 150, 0, 60)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = berry
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = COLORS.Background
    bg.BackgroundTransparency = 0.3
    bg.Parent = billboard
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 8)
    bgCorner.Parent = bg
    
    local bgStroke = Instance.new("UIStroke")
    bgStroke.Color = COLORS.Blue
    bgStroke.Thickness = 1.5
    bgStroke.Parent = bg
    
    -- Berry Icon
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 30, 0, 30)
    icon.Position = UDim2.new(0, 5, 0.5, -15)
    icon.BackgroundTransparency = 1
    icon.Text = "🫐"
    icon.TextSize = 25
    icon.Parent = bg
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -40, 0.6, 0)
    nameLabel.Position = UDim2.new(0, 35, 0, 5)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = "ЯГОДА ДЛЯ ХАКИ"
    nameLabel.TextColor3 = COLORS.Blue
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextSize = 12
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = bg
    
    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(1, -40, 0.4, 0)
    distLabel.Position = UDim2.new(0, 35, 0.6, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "0m"
    distLabel.TextColor3 = COLORS.Gray
    distLabel.TextStrokeTransparency = 0
    distLabel.TextSize = 11
    distLabel.Font = Enum.Font.Gotham
    distLabel.Parent = bg
    
    table.insert(espItems, highlight)
    table.insert(espItems, billboard)
    
    ESPObjects.Berries[berry] = espItems
    
    -- Update
    spawn(function()
        while ESPStates.Berries and berry.Parent do
            local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if myRoot then
                local distance = (myRoot.Position - berry.Position).Magnitude
                distLabel.Text = math.floor(distance) .. "m"
            end
            task.wait(0.1)
        end
    end)
end

local function CreateChestESP(chest)
    if ESPObjects.Chests[chest] then return end
    
    local chestType = "UNKNOWN"
    local color = COLORS.White
    
    if chest.Name:find("Gold") then
        chestType = "GOLD CHEST"
        color = COLORS.Yellow
    elseif chest.Name:find("Silver") then
        chestType = "SILVER CHEST"
        color = Color3.fromRGB(192, 192, 192)
    elseif chest.Name:find("Diamond") then
        chestType = "DIAMOND CHEST"
        color = Color3.fromRGB(185, 242, 255)
    end
    
    local espItems = {}
    
    -- Highlight
    local highlight = Instance.new("Highlight")
    highlight.FillColor = color
    highlight.OutlineColor = COLORS.White
    highlight.FillTransparency = 0.5
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = chest
    
    -- Billboard
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 140, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = chest
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = COLORS.Background
    bg.BackgroundTransparency = 0.4
    bg.Parent = billboard
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 6)
    bgCorner.Parent = bg
    
    local bgStroke = Instance.new("UIStroke")
    bgStroke.Color = color
    bgStroke.Thickness = 2
    bgStroke.Parent = bg
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 25, 0, 25)
    icon.Position = UDim2.new(0, 5, 0.5, -12)
    icon.BackgroundTransparency = 1
    icon.Text = "📦"
    icon.TextSize = 20
    icon.Parent = bg
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -35, 0.6, 0)
    nameLabel.Position = UDim2.new(0, 30, 0, 5)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = chestType
    nameLabel.TextColor3 = color
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextSize = 12
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = bg
    
    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(1, -35, 0.4, 0)
    distLabel.Position = UDim2.new(0, 30, 0.6, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "0m"
    distLabel.TextColor3 = COLORS.Gray
    distLabel.TextStrokeTransparency = 0
    distLabel.TextSize = 10
    distLabel.Font = Enum.Font.Gotham
    distLabel.Parent = bg
    
    table.insert(espItems, highlight)
    table.insert(espItems, billboard)
    
    ESPObjects.Chests[chest] = espItems
    
    -- Update
    spawn(function()
        while ESPStates.Chests and chest.Parent do
            local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if myRoot then
                local distance = (myRoot.Position - chest.Position).Magnitude
                distLabel.Text = math.floor(distance) .. "m"
            end
            task.wait(0.1)
        end
    end)
end

-- ESP Scanner
local function StartESPScanner()
    while true do
        if ESPStates.SwordDealer then
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj.Name:find("SwordDealer") or obj.Name:find("LegendaryDealer") then
                    CreateSwordDealerESP(obj)
                end
            end
        end
        
        if ESPStates.DevilFruits then
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj:IsA("Tool") or (obj:IsA("Part") and (obj.Name:find("Fruit") or obj.Name:find("Fruit"))) then
                    if not obj:FindFirstChildOfClass("Humanoid") then
                        CreateDevilFruitESP(obj)
                    end
                end
            end
        end
        
        if ESPStates.Berries then
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj.Name:find("Berry") or obj.Name:find("Flower") or obj.Name:find("Haki") or obj.Name:find("Material") then
                    CreateBerryESP(obj)
                end
            end
        end
        
        if ESPStates.Chests then
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj.Name:find("Chest") and obj:IsA("BasePart") then
                    CreateChestESP(obj)
                end
            end
        end
        
        task.wait(2)
    end
end

-- Toggle Functions
local function ToggleESP(type, toggleBtn, status, stroke)
    ESPStates[type] = not ESPStates[type]
    
    if ESPStates[type] then
        toggleBtn.Text = "ON"
        toggleBtn.TextColor3 = COLORS.Green
        status.BackgroundColor3 = COLORS.Green
        stroke.Color = COLORS.Green
        
        if type == "Players" then
            for _, p in ipairs(Players:GetPlayers()) do
                CreatePlayerESP(p)
            end
        end
    else
        toggleBtn.Text = "OFF"
        toggleBtn.TextColor3 = COLORS.Gray
        status.BackgroundColor3 = COLORS.Red
        stroke.Color = COLORS.Gray
        ClearESP(type)
    end
end

-- Connect Toggles
PlayerToggle.MouseButton1Click:Connect(function()
    ToggleESP("Players", PlayerToggle, PlayerStatus, PlayerStroke)
end)

DealerToggle.MouseButton1Click:Connect(function()
    ToggleESP("SwordDealer", DealerToggle, DealerStatus, DealerStroke)
end)

FruitToggle.MouseButton1Click:Connect(function()
    ToggleESP("DevilFruits", FruitToggle, FruitStatus, FruitStroke)
end)

BerryToggle.MouseButton1Click:Connect(function()
    ToggleESP("Berries", BerryToggle, BerryStatus, BerryStroke)
end)

ChestToggle.MouseButton1Click:Connect(function()
    ToggleESP("Chests", ChestToggle, ChestStatus, ChestStroke)
end)

-- Player Added
Players.PlayerAdded:Connect(function(p)
    if ESPStates.Players then
        CreatePlayerESP(p)
    end
end)

-- Minimize / Toggle Logic
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ToggleBtn.Visible = true
end)

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ToggleBtn.Visible = false
end)

-- Dragging Main Frame
local dragging = false
local dragInput, dragStart, startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Dragging Toggle Button
local toggleDragging = false
local toggleDragStart, toggleStartPos

ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        toggleDragging = true
        toggleDragStart = input.Position
        toggleStartPos = ToggleBtn.Position
    end
end)

ToggleBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if toggleDragging then
            local delta = input.Position - toggleDragStart
            ToggleBtn.Position = UDim2.new(toggleStartPos.X.Scale, toggleStartPos.X.Offset + delta.X, toggleStartPos.Y.Scale, toggleStartPos.Y.Offset + delta.Y)
        end
    end
end)

ToggleBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        toggleDragging = false
    end
end)

-- Start Scanner
spawn(StartESPScanner)

-- Glow Animation
spawn(function()
    while true do
        for i = 0.7, 0.9, 0.01 do
            Glow.ImageTransparency = i
            task.wait(0.05)
        end
        for i = 0.9, 0.7, -0.01 do
            Glow.ImageTransparency = i
            task.wait(0.05)
        end
    end
end)
