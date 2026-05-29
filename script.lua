-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- Drawing API для линий (ESP Lines)
local Drawing = Drawing or loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/Drawing/main/Drawing.lua"))()

-- Character setup
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloxFruitsHub"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 340, 0, 400)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(80, 80, 80)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- Toggle Button (Circular)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 20, 0.5, -25)
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "⚡"
ToggleButton.TextColor3 = Color3.fromRGB(255, 215, 0)
ToggleButton.TextSize = 24
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Visible = false
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(255, 215, 0)
ToggleStroke.Thickness = 2
ToggleStroke.Parent = ToggleButton

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -80, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "BLOX FRUITS HUB"
TitleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Close/Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 35, 0, 35)
MinimizeButton.Position = UDim2.new(1, -40, 0, 5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "X"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 18
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = TitleBar

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 8)
MinimizeCorner.Parent = MinimizeButton

-- Content Container
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -60)
ContentFrame.Position = UDim2.new(0, 10, 0, 55)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ScrollBarThickness = 4
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
ContentFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = ContentFrame

-- SPEED SECTION
local SpeedSection = Instance.new("Frame")
SpeedSection.Name = "SpeedSection"
SpeedSection.Size = UDim2.new(1, 0, 0, 100)
SpeedSection.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SpeedSection.BorderSizePixel = 0
SpeedSection.LayoutOrder = 1
SpeedSection.Parent = ContentFrame

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 8)
SpeedCorner.Parent = SpeedSection

local SpeedTitle = Instance.new("TextLabel")
SpeedTitle.Size = UDim2.new(1, -10, 0, 25)
SpeedTitle.Position = UDim2.new(0, 5, 0, 5)
SpeedTitle.BackgroundTransparency = 1
SpeedTitle.Text = "⚡ WALK SPEED"
SpeedTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedTitle.TextSize = 14
SpeedTitle.Font = Enum.Font.GothamBold
SpeedTitle.Parent = SpeedSection

local SpeedButtonsFrame = Instance.new("Frame")
SpeedButtonsFrame.Size = UDim2.new(1, -10, 0, 60)
SpeedButtonsFrame.Position = UDim2.new(0, 5, 0, 35)
SpeedButtonsFrame.BackgroundTransparency = 1
SpeedButtonsFrame.Parent = SpeedSection

local SpeedLayout = Instance.new("UIListLayout")
SpeedLayout.FillDirection = Enum.FillDirection.Horizontal
SpeedLayout.SortOrder = Enum.SortOrder.LayoutOrder
SpeedLayout.Padding = UDim.new(0, 8)
SpeedLayout.Parent = SpeedButtonsFrame

-- ESP SECTION
local ESPSection = Instance.new("Frame")
ESPSection.Name = "ESPSection"
ESPSection.Size = UDim2.new(1, 0, 0, 200)
ESPSection.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ESPSection.BorderSizePixel = 0
ESPSection.LayoutOrder = 2
ESPSection.Parent = ContentFrame

local ESPCorner = Instance.new("UICorner")
ESPCorner.CornerRadius = UDim.new(0, 8)
ESPCorner.Parent = ESPSection

local ESPTitle = Instance.new("TextLabel")
ESPTitle.Size = UDim2.new(1, -10, 0, 25)
ESPTitle.Position = UDim2.new(0, 5, 0, 5)
ESPTitle.BackgroundTransparency = 1
ESPTitle.Text = "👁️ WALLHACK ESP"
ESPTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPTitle.TextSize = 14
ESPTitle.Font = Enum.Font.GothamBold
ESPTitle.Parent = ESPSection

local ESPButton = Instance.new("TextButton")
ESPButton.Name = "ESPButton"
ESPButton.Size = UDim2.new(1, -20, 0, 40)
ESPButton.Position = UDim2.new(0, 10, 0, 35)
ESPButton.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
ESPButton.BorderSizePixel = 0
ESPButton.Text = "ВКЛЮЧИТЬ ESP"
ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPButton.TextSize = 16
ESPButton.Font = Enum.Font.GothamBold
ESPButton.Parent = ESPSection

local ESPCorner2 = Instance.new("UICorner")
ESPCorner2.CornerRadius = UDim.new(0, 6)
ESPCorner2.Parent = ESPButton

-- ESP Info Labels
local ESPInfo = Instance.new("TextLabel")
ESPInfo.Size = UDim2.new(1, -20, 0, 100)
ESPInfo.Position = UDim2.new(0, 10, 0, 80)
ESPInfo.BackgroundTransparency = 1
ESPInfo.Text = "🟢 Игроки: Ник + Линия\n🟡 Сундуки: Box ESP\n🟣 Фрукты: FRUIT HERE!\n🔵 NPC: Имена"
ESPInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
ESPInfo.TextSize = 12
ESPInfo.Font = Enum.Font.Gotham
ESPInfo.TextXAlignment = Enum.TextXAlignment.Left
ESPInfo.Parent = ESPSection

-- Speed Configuration
local speeds = {
    {name = "LOW\n(45)", value = 45},
    {name = "MED\n(80)", value = 80},
    {name = "MAX\n(150)", value = 150}
}

local currentSpeed = 16
local activeSpeedButton = nil
local speedButtons = {}

-- ESP Configuration
local espEnabled = false
local espObjects = {
    Players = {},
    Chests = {},
    Fruits = {},
    NPCs = {}
}
local espLines = {} -- Drawing lines

-- Colors
local colors = {
    Players = Color3.fromRGB(0, 255, 100),
    Chests = Color3.fromRGB(255, 215, 0),
    Fruits = Color3.fromRGB(200, 0, 255),
    NPCs = Color3.fromRGB(0, 200, 255)
}

-- Metatable Hook for Anti-Cheat Bypass
local rawMeta = getrawmetatable(game)
local oldIndex = rawMeta.__index
local oldNewIndex = rawMeta.__newindex

setreadonly(rawMeta, false)

rawMeta.__index = newcclosure(function(self, key)
    if self == humanoid and key == "WalkSpeed" then
        return currentSpeed
    end
    return oldIndex(self, key)
end)

rawMeta.__newindex = newcclosure(function(self, key, value)
    if self == humanoid and key == "WalkSpeed" then
        if value ~= currentSpeed then
            return
        end
    end
    return oldNewIndex(self, key, value)
end)

setreadonly(rawMeta, true)

-- ESP Functions
local function createPlayerESP(targetPlayer)
    if targetPlayer == player then return end
    
    local function setupCharacter(char)
        if espObjects.Players[targetPlayer] then
            for _, obj in pairs(espObjects.Players[targetPlayer]) do
                if obj then obj:Destroy() end
            end
        end
        
        local espTable = {}
        
        -- Highlight
        local highlight = Instance.new("Highlight")
        highlight.FillColor = colors.Players
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.7
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = char
        table.insert(espTable, highlight)
        
        -- BillboardGui
        local billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0, 150, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 4, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = char
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = targetPlayer.Name
        nameLabel.TextColor3 = colors.Players
        nameLabel.TextStrokeTransparency = 0
        nameLabel.TextSize = 14
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.Parent = billboard
        
        local distLabel = Instance.new("TextLabel")
        distLabel.Size = UDim2.new(1, 0, 0.5, 0)
        distLabel.Position = UDim2.new(0, 0, 0.5, 0)
        distLabel.BackgroundTransparency = 1
        distLabel.Text = "0m"
        distLabel.TextColor3 = colors.Players
        distLabel.TextStrokeTransparency = 0
        distLabel.TextSize = 12
        distLabel.Font = Enum.Font.Gotham
        distLabel.Parent = billboard
        
        table.insert(espTable, billboard)
        
        -- Drawing Line
        local line = Drawing.new("Line")
        line.Visible = false
        line.Thickness = 1.5
        line.Color = colors.Players
        line.Transparency = 1
        espLines[targetPlayer] = line
        
        espObjects.Players[targetPlayer] = espTable
        
        -- Update loop
        spawn(function()
            while espEnabled and targetPlayer.Parent and char.Parent do
                local myChar = player.Character
                local theirRoot = char:FindFirstChild("HumanoidRootPart")
                local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                
                if theirRoot and myRoot then
                    local dist = (myRoot.Position - theirRoot.Position).Magnitude
                    distLabel.Text = math.floor(dist) .. "m"
                    
                    -- Update line
                    local theirPos, theirVisible = camera:WorldToViewportPoint(theirRoot.Position)
                    local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
                    
                    if theirVisible then
                        line.Visible = true
                        line.From = screenCenter
                        line.To = Vector2.new(theirPos.X, theirPos.Y)
                    else
                        line.Visible = false
                    end
                end
                task.wait(0.1)
            end
            line.Visible = false
        end)
    end
    
    if targetPlayer.Character then
        setupCharacter(targetPlayer.Character)
    end
    
    targetPlayer.CharacterAdded:Connect(setupCharacter)
end

local function createChestESP(chest)
    if espObjects.Chests[chest] then return end
    
    local espTable = {}
    
    -- Highlight
    local highlight = Instance.new("Highlight")
    highlight.FillColor = colors.Chests
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = chest
    table.insert(espTable, highlight)
    
    -- Billboard
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 120, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = chest
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = chest.Name
    nameLabel.TextColor3 = colors.Chests
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = billboard
    
    table.insert(espTable, billboard)
    
    -- 3D Box (using parts)
    local box = Instance.new("BoxHandleAdornment")
    box.Size = chest.Size + Vector3.new(0.5, 0.5, 0.5)
    box.CFrame = chest.CFrame
    box.Color3 = colors.Chests
    box.Transparency = 0.7
    box.AlwaysOnTop = true
    box.Adornee = chest
    box.Parent = chest
    table.insert(espTable, box)
    
    espObjects.Chests[chest] = espTable
end

local function createFruitESP(fruit)
    if espObjects.Fruits[fruit] then return end
    
    local espTable = {}
    
    -- Highlight
    local highlight = Instance.new("Highlight")
    highlight.FillColor = colors.Fruits
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.3
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = fruit
    table.insert(espTable, highlight)
    
    -- Large Billboard
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 300, 0, 100)
    billboard.StudsOffset = Vector3.new(0, 5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = fruit
    
    local mainLabel = Instance.new("TextLabel")
    mainLabel.Size = UDim2.new(1, 0, 0.6, 0)
    mainLabel.BackgroundTransparency = 1
    mainLabel.Text = "🍎 FRUIT HERE!"
    mainLabel.TextColor3 = colors.Fruits
    mainLabel.TextStrokeTransparency = 0
    mainLabel.TextSize = 24
    mainLabel.Font = Enum.Font.GothamBold
    mainLabel.Parent = billboard
    
    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(1, 0, 0.4, 0)
    distLabel.Position = UDim2.new(0, 0, 0.6, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "0m"
    distLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    distLabel.TextStrokeTransparency = 0
    distLabel.TextSize = 18
    distLabel.Font = Enum.Font.GothamBold
    distLabel.Parent = billboard
    
    table.insert(espTable, billboard)
    
    espObjects.Fruits[fruit] = espTable
    
    -- Distance update
    spawn(function()
        while espEnabled and fruit.Parent do
            local myChar = player.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myRoot and fruit:IsA("BasePart") then
                local dist = (myRoot.Position - fruit.Position).Magnitude
                distLabel.Text = math.floor(dist) .. "m"
            end
            task.wait(0.2)
        end
    end)
end

local function createNPCESP(npc)
    if espObjects.NPCs[npc] then return end
    
    local head = npc:FindFirstChild("Head") or npc:FindFirstChildWhichIsA("BasePart")
    if not head then return end
    
    local espTable = {}
    
    -- Highlight
    local highlight = Instance.new("Highlight")
    highlight.FillColor = colors.NPCs
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.8
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = npc
    table.insert(espTable, highlight)
    
    -- Billboard
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 150, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = npc.Name
    nameLabel.TextColor3 = colors.NPCs
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextSize = 13
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = billboard
    
    table.insert(espTable, billboard)
    
    espObjects.NPCs[npc] = espTable
end

-- ESP Scanner
local function scanWorkspace()
    while espEnabled do
        -- Scan Chests
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj.Name:find("Chest") and obj:IsA("BasePart") then
                createChestESP(obj)
            end
        end
        
        -- Scan Fruits
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj.Name:find("Fruit") or obj.Name:find("Fruit") then
                createFruitESP(obj)
            end
        end
        
        -- Scan NPCs
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj ~= character then
                if obj.Name:find("Quest") or obj.Name:find("NPC") or obj.Name:find("Pirate") or obj.Name:find("Marine") then
                    createNPCESP(obj)
                end
            end
        end
        
        task.wait(1)
    end
end

-- Toggle ESP
local function toggleESP()
    espEnabled = not espEnabled
    
    if espEnabled then
        ESPButton.BackgroundColor3 = Color3.fromRGB(20, 150, 20)
        ESPButton.Text = "ВЫКЛЮЧИТЬ ESP"
        
        -- Enable for existing players
        for _, p in ipairs(Players:GetPlayers()) do
            createPlayerESP(p)
        end
        
        -- Start scanner
        spawn(scanWorkspace)
    else
        ESPButton.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
        ESPButton.Text = "ВКЛЮЧИТЬ ESP"
        
        -- Clear all ESP
        for category, objects in pairs(espObjects) do
            for _, espTable in pairs(objects) do
                for _, obj in ipairs(espTable) do
                    if obj then obj:Destroy() end
                end
            end
        end
        
        for _, line in pairs(espLines) do
            if line then line.Visible = false end
        end
        
        espObjects = {Players = {}, Chests = {}, Fruits = {}, NPCs = {}}
    end
end

ESPButton.MouseButton1Click:Connect(toggleESP)

-- Create Speed Buttons
for i, speedData in ipairs(speeds) do
    local button = Instance.new("TextButton")
    button.Name = speedData.name .. "Button"
    button.Size = UDim2.new(0.33, -5, 1, 0)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.BorderSizePixel = 0
    button.Text = speedData.name
    button.TextColor3 = Color3.fromRGB(200, 200, 200)
    button.TextSize = 11
    button.Font = Enum.Font.GothamBold
    button.LayoutOrder = i
    button.Parent = SpeedButtonsFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    table.insert(speedButtons, button)
    
    button.MouseButton1Click:Connect(function()
        currentSpeed = speedData.value
        
        for _, btn in ipairs(speedButtons) do
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        
        button.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        if humanoid then
            oldNewIndex(humanoid, "WalkSpeed", currentSpeed)
        end
    end)
end

-- Toggle Logic
MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ToggleButton.Visible = true
end)

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ToggleButton.Visible = false
end)

-- Dragging for MainFrame
local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Dragging for Toggle Button
local toggleDragging = false
local toggleDragStart = nil
local toggleStartPos = nil

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        toggleDragging = true
        toggleDragStart = input.Position
        toggleStartPos = ToggleButton.Position
    end
end)

ToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if toggleDragging then
            local delta = input.Position - toggleDragStart
            ToggleButton.Position = UDim2.new(
                toggleStartPos.X.Scale,
                toggleStartPos.X.Offset + delta.X,
                toggleStartPos.Y.Scale,
                toggleStartPos.Y.Offset + delta.Y
            )
        end
    end
end)

ToggleButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        toggleDragging = false
    end
end)

-- RunService for Speed
RunService.Stepped:Connect(function()
    if player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.WalkSpeed ~= currentSpeed then
            oldNewIndex(hum, "WalkSpeed", currentSpeed)
        end
    end
end)

-- Character Added
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    
    task.wait(0.1)
    if activeSpeedButton then
        oldNewIndex(humanoid, "WalkSpeed", currentSpeed)
    end
end)

-- New Player Handler
Players.PlayerAdded:Connect(function(p)
    if espEnabled then
        createPlayerESP(p)
    end
end)

-- Initialize
for _, btn in ipairs(speedButtons) do
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
end
