local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local UserSettings = game:GetService("UserSettings")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera

local SCRIPT_NAME = "BloxFruitsHub_Premium"
local SCRIPT_VERSION = "3.2.1"
local GUI_WIDTH = 280
local GUI_HEIGHT = 300

local Colors = {
    Background = Color3.fromRGB(15, 15, 15),
    BackgroundLight = Color3.fromRGB(25, 25, 25),
    Accent = Color3.fromRGB(139, 92, 246),
    AccentLight = Color3.fromRGB(168, 85, 247),
    Active = Color3.fromRGB(16, 185, 129),
    Inactive = Color3.fromRGB(82, 82, 82),
    Warning = Color3.fromRGB(245, 158, 11),
    Error = Color3.fromRGB(239, 68, 68),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(156, 163, 175),
    Gold = Color3.fromRGB(255, 215, 0),
    Green = Color3.fromRGB(34, 197, 94)
}

local Features = {
    AutoFarm = {Enabled = false, SmoothTeleport = true, AutoClicker = true, AutoQuest = true},
    AutoMastery = {Enabled = false, Type = "Fruit"},
    AutoStats = {Enabled = false, AutoMelee = false, AutoDefense = false, AutoSword = false, AutoGun = false, AutoDF = false},
    PlayerESP = {Enabled = false, ShowName = true, ShowDistance = true, ShowHealth = true, ShowAvatar = true},
    SwordDealerESP = {Enabled = false, ShowAlert = true, ShowTracer = true, ShowDistance = true},
    FruitESP = {Enabled = false, ShowBox = true, ShowName = true, ShowDistance = true},
    HakiESP = {Enabled = false, ShowBerry = true, ShowChest = true},
    AutoBuy = {Enabled = false, AutoSwords = false, AutoSuperhuman = false, AutoDeathStep = false},
    FruitSniper = {Enabled = false, TargetFruit = "", AutoRebuy = true}
}

local Teleports = {
    Sea1 = {
        ["Prelude Island"] = Vector3.new(-50, 100, 0),
        ["Jail"] = Vector3.new(-200, 100, -200),
        ["Mysterious Island"] = Vector3.new(500, 100, 500),
        ["Snow Mountain"] = Vector3.new(1000, 100, 500),
        ["Desert"] = Vector3.new(1500, 100, 1000),
        ["Castle on Sea"] = Vector3.new(2000, 100, 1500),
        ["Forest"] = Vector3.new(2500, 100, 2000),
        ["Skylands"] = Vector3.new(3000, 100, 2500),
        ["Haka Island"] = Vector3.new(3500, 100, 3000)
    },
    Sea2 = {
        ["Risky Island"] = Vector3.new(4500, 100, 4000),
        ["Fried Island"] = Vector3.new(5000, 100, 4500),
        ["Alpine Village"] = Vector3.new(5500, 100, 5000),
        ["Candy Island"] = Vector3.new(6000, 100, 5500),
        ["Pink Island"] = Vector3.new(6500, 100, 6000),
        ["Radiation Zone"] = Vector3.new(7000, 100, 6500),
        ["Volcano"] = Vector3.new(7500, 100, 7000),
        ["King's Castle"] = Vector3.new(8000, 100, 7500),
        ["Corrupted Ship"] = Vector3.new(8500, 100, 8000)
    },
    Sea3 = {
        ["Green Zone"] = Vector3.new(9500, 100, 9000),
        ["Hunting Ground"] = Vector3.new(10000, 100, 9500),
        ["Red Zone"] = Vector3.new(10500, 100, 10000),
        ["Magma Vessel"] = Vector3.new(11000, 100, 10500),
        ["Hokage Island"] = Vector3.new(11500, 100, 11000),
        ["Shadow Amethyst"] = Vector3.new(12000, 100, 11500),
        ["Snow Village"] = Vector3.new(12500, 100, 12000),
        ["Rainbow Castle"] = Vector3.new(13000, 100, 12500),
        ["Flaming Castle"] = Vector3.new(14000, 100, 13500)
    }
}

local ESPGui
local MainFrame
local ToggleButton
local ESPLabels = {}
local TracerLines = {}
local ThumbnailCache = {}

local function SafeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        warn("[BloxFruitsHub] Error:", tostring(result))
        return false
    end
    return result
end

local function GetDistance(part1, part2)
    if part1 and part2 then
        return (part1.Position - part2.Position).Magnitude
    end
    return math.huge
end

local function IsOnScreen(worldPosition)
    local onScreen, screenPosition = Camera:WorldToViewportPoint(worldPosition)
    return onScreen and screenPosition.Z > 0
end

local function WaitForChild(obj, childName, timeout)
    timeout = timeout or 30
    local start = tick()
    while tick() - start < timeout do
        if obj:FindFirstChild(childName) then
            return obj:FindFirstChild(childName)
        end
        task.wait(0.1)
    end
    return nil
end

local function GetPlayerStats()
    local stats = LocalPlayer:FindFirstChild("leaderstats")
    if stats then
        return {
            Money = stats:FindFirstChild("Money") and stats.Money.Value or 0,
            Fragments = stats:FindFirstChild("Fragments") and stats.Fragments.Value or 0,
            Level = stats:FindFirstChild("Level") and stats.Level.Value or 0,
            Stats = stats:FindFirstChild("Stats") and stats.Stats.Value or 0,
            Melee = stats:FindFirstChild("Melee") and stats.Melee.Value or 0,
            Defense = stats:FindFirstChild("Defense") and stats.Defense.Value or 0,
            Sword = stats:FindFirstChild("Sword") and stats.Sword.Value or 0,
            Gun = stats:FindFirstChild("Gun") and stats.Gun.Value or 0,
            DF = stats:FindFirstChild("DF") and stats.DF.Value or 0
        }
    end
    return nil
end

local function GetPlayerFruit()
    local fruits = LocalPlayer:FindFirstChild("Fruits")
    if fruits then
        local currentFruit = fruits:FindFirstChild("Current")
        if currentFruit then
            return currentFruit.Value or nil
        end
    end
    return nil
end

local function CreateScreenGui()
    local gui = Instance.new("ScreenGui")
    gui.Name = SCRIPT_NAME .. "_Gui"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    return gui
end

local function CreateMainFrame(screenGui)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, GUI_WIDTH, 0, GUI_HEIGHT)
    frame.Position = UDim2.new(0.5, -GUI_WIDTH/2, 0.5, -GUI_HEIGHT/2)
    frame.BackgroundColor3 = Colors.Background
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Colors.Accent
    stroke.Transparency = 0.5
    stroke.Thickness = 2
    stroke.Parent = frame
    
    return frame
end

local function CreateHeader(frame)
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 50)
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    header.BorderSizePixel = 0
    header.Parent = frame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = header
    
    local border = Instance.new("Frame")
    border.Size = UDim2.new(1, 0, 0, 2)
    border.Position = UDim2.new(0, 0, 1, -2)
    border.BackgroundColor3 = Colors.Accent
    border.BorderSizePixel = 0
    border.Parent = header
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -50, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🍎 BLOX FRUITS"
    title.TextColor3 = Colors.Text
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    local version = Instance.new("TextLabel")
    version.Size = UDim2.new(1, -50, 0, 20)
    version.Position = UDim2.new(0, 10, 0, 25)
    version.BackgroundTransparency = 1
    version.Text = "v" .. SCRIPT_VERSION
    version.TextColor3 = Colors.AccentLight
    version.TextSize = 12
    version.Font = Enum.Font.Gotham
    version.TextXAlignment = Enum.TextXAlignment.Left
    version.Parent = header
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -40, 0.5, -15)
    closeBtn.BackgroundColor3 = Colors.Error
    closeBtn.BorderSizePixel = 0
    closeBtn.ZIndex = 100
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Colors.Text
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = header
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0.5, 0)
    closeCorner.Parent = closeBtn
    
    return header, closeBtn
end

local function CreateSidebar(frame)
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 60, 1, -50)
    sidebar.Position = UDim2.new(0, 0, 0, 50)
    sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    sidebar.BorderSizePixel = 0
    sidebar.Parent = frame
    
    local tabs = {
        {Name = "🎯", Tab = "farm"},
        {Name = "📊", Tab = "stats"},
        {Name = "🗺️", Tab = "teleports"},
        {Name = "👁️", Tab = "esp"},
        {Name = "🛒", Tab = "shop"}
    }
    
    local tabButtons = {}
    local tabHeight = 50
    
    for i, tab in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, tabHeight)
        btn.Position = UDim2.new(0, 0, 0, (i-1) * tabHeight)
        btn.BackgroundTransparency = 1
        btn.Text = tab.Name
        btn.TextColor3 = Colors.TextDim
        btn.TextSize = 24
        btn.Font = Enum.Font.GothamBold
        btn.Parent = sidebar
        tabButtons[i] = {Button = btn, Tab = tab.Tab}
        
        btn.MouseButton1Click:Connect(function()
            for _, t in ipairs(tabButtons) do
                t.Button.TextColor3 = Colors.TextDim
                t.Button.BackgroundTransparency = 1
            end
            btn.TextColor3 = Colors.AccentLight
            btn.BackgroundTransparency = 0.9
            btn.BackgroundColor3 = Colors.Accent
        end)
    end
    
    tabButtons[1].Button.TextColor3 = Colors.AccentLight
    tabButtons[1].Button.BackgroundTransparency = 0.9
    tabButtons[1].Button.BackgroundColor3 = Colors.Accent
    
    return sidebar, tabButtons
end

local function CreateContentArea(frame)
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -70, 1, -50)
    content.Position = UDim2.new(0, 60, 0, 50)
    content.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 4
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.Parent = frame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = content
    
    return content
end

local function CreateToggleSwitch(parent, featureName, defaultState)
    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0, 44, 0, 24)
    toggle.BackgroundColor3 = Colors.Inactive
    toggle.BorderSizePixel = 0
    toggle.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = toggle
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(0, 18, 0, 18)
    slider.Position = UDim2.new(0, 3, 0.5, -9)
    slider.BackgroundColor3 = Colors.Text
    slider.BorderSizePixel = 0
    slider.Parent = toggle
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0.5, 0)
    sliderCorner.Parent = slider
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Position = UDim2.new(0, 0, 0, 0)
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Parent = toggle
    
    local isActive = defaultState or false
    
    local function UpdateToggle(state)
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        if state then
            toggle.BackgroundColor3 = Colors.Active
            TweenService:Create(slider, tweenInfo, {Position = UDim2.new(0, 23, 0.5, -9)}):Play()
        else
            toggle.BackgroundColor3 = Colors.Inactive
            TweenService:Create(slider, tweenInfo, {Position = UDim2.new(0, 3, 0.5, -9)}):Play()
        end
    end
    
    btn.MouseButton1Click:Connect(function()
        isActive = not isActive
        Features[featureName].Enabled = isActive
        UpdateToggle(isActive)
    end)
    
    return toggle, btn, function(state)
        isActive = state
        Features[featureName].Enabled = state
        UpdateToggle(state)
    end
end

local function CreateFeatureRow(parent, title, featureName, yPos)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -20, 0, 45)
    row.Position = UDim2.new(0, 10, 0, yPos)
    row.BackgroundColor3 = Colors.BackgroundLight
    row.BorderSizePixel = 0
    row.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = row
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -60, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Colors.Text
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = row
    
    local toggle, toggleBtn, updateFunc = CreateToggleSwitch(row, featureName, false)
    toggle.Position = UDim2.new(1, -55, 0.5, -12)
    
    return row, toggle, toggleBtn, updateFunc
end

local function CreateToggleButton(screenGui)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 40, 0, 40)
    btn.Position = UDim2.new(1, -50, 0, 15)
    btn.BackgroundColor3 = Colors.Accent
    btn.BorderSizePixel = 0
    btn.ZIndex = 1000
    btn.Text = ""
    btn.Visible = false
    btn.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.5, 0)
    corner.Parent = btn
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(1, 0, 1, 0)
    icon.Position = UDim2.new(0, 0, 0, 0)
    icon.BackgroundTransparency = 1
    icon.Text = "⚙️"
    icon.TextColor3 = Colors.Text
    icon.TextSize = 20
    icon.Font = Enum.Font.GothamBold
    icon.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Colors.AccentLight
    stroke.Transparency = 0.5
    stroke.Thickness = 2
    stroke.Parent = btn
    
    return btn
end

local function CreateTabContent(content, tabName)
    local tab = Instance.new("Frame")
    tab.Name = tabName
    tab.Size = UDim2.new(1, 0, 0, 400)
    tab.Position = UDim2.new(0, 0, 0, 0)
    tab.BackgroundTransparency = 1
    tab.Parent = content
    
    return tab
end

local function CreateFarmTab(content)
    local tab = CreateTabContent(content, "farm")
    tab.Visible = true
    
    CreateFeatureRow(tab, "Auto Farm Level", "AutoFarm", 0)
    CreateFeatureRow(tab, "Smooth Teleport", "AutoFarm", 50)
    CreateFeatureRow(tab, "Auto Clicker", "AutoFarm", 100)
    CreateFeatureRow(tab, "Auto Quest", "AutoFarm", 150)
    CreateFeatureRow(tab, "Auto Mastery", "AutoMastery", 200)
end

local function CreateStatsTab(content)
    local tab = CreateTabContent(content, "stats")
    tab.Visible = false
    
    CreateFeatureRow(tab, "Auto Stats", "AutoStats", 0)
    CreateFeatureRow(tab, "Auto Melee", "AutoStats", 50)
    CreateFeatureRow(tab, "Auto Defense", "AutoStats", 100)
    CreateFeatureRow(tab, "Auto Sword", "AutoStats", 150)
    CreateFeatureRow(tab, "Auto Gun", "AutoStats", 200)
    CreateFeatureRow(tab, "Auto Devil Fruit", "AutoStats", 250)
end

local function CreateTeleportsTab(content)
    local tab = CreateTabContent(content, "teleports")
    tab.Visible = false
    
    local seaLabel = Instance.new("TextLabel")
    seaLabel.Size = UDim2.new(1, -20, 0, 25)
    seaLabel.Position = UDim2.new(0, 10, 0, 0)
    seaLabel.BackgroundTransparency = 1
    seaLabel.Text = "🌊 Select Sea:"
    seaLabel.TextColor3 = Colors.Text
    seaLabel.TextSize = 14
    seaLabel.Font = Enum.Font.GothamBold
    seaLabel.TextXAlignment = Enum.TextXAlignment.Left
    seaLabel.Parent = tab
    
    local seaDropdown = Instance.new("TextButton")
    seaDropdown.Size = UDim2.new(1, -20, 0, 35)
    seaDropdown.Position = UDim2.new(0, 10, 0, 30)
    seaDropdown.BackgroundColor3 = Colors.BackgroundLight
    seaDropdown.Text = "Sea 1"
    seaDropdown.TextColor3 = Colors.AccentLight
    seaDropdown.TextSize = 14
    seaDropdown.Font = Enum.Font.Gotham
    seaDropdown.Parent = tab
    
    local seaCorner = Instance.new("UICorner")
    seaCorner.CornerRadius = UDim.new(0, 8)
    seaCorner.Parent = seaDropdown
    
    local currentSea = 1
    
    seaDropdown.MouseButton1Click:Connect(function()
        currentSea = (currentSea % 3) + 1
        seaDropdown.Text = "Sea " .. currentSea
    end)
    
    local islandLabel = Instance.new("TextLabel")
    islandLabel.Size = UDim2.new(1, -20, 0, 25)
    islandLabel.Position = UDim2.new(0, 10, 0, 75)
    islandLabel.BackgroundTransparency = 1
    islandLabel.Text = "🏝️ Select Island:"
    islandLabel.TextColor3 = Colors.Text
    islandLabel.TextSize = 14
    islandLabel.Font = Enum.Font.GothamBold
    islandLabel.TextXAlignment = Enum.TextXAlignment.Left
    islandLabel.Parent = tab
    
    local islandDropdown = Instance.new("TextButton")
    islandDropdown.Size = UDim2.new(1, -20, 0, 35)
    islandDropdown.Position = UDim2.new(0, 10, 0, 105)
    islandDropdown.BackgroundColor3 = Colors.BackgroundLight
    islandDropdown.Text = "Select Island..."
    islandDropdown.TextColor3 = Colors.TextDim
    islandDropdown.TextSize = 14
    islandDropdown.Font = Enum.Font.Gotham
    islandDropdown.Parent = tab
    
    local islandCorner = Instance.new("UICorner")
    islandCorner.CornerRadius = UDim.new(0, 8)
    islandCorner.Parent = islandDropdown
    
    local currentIsland = nil
    local islandList = {}
    local islandIndex = 0
    
    for sea, islands in pairs(Teleports) do
        for islandName, _ in pairs(islands) do
            table.insert(islandList, islandName)
        end
    end
    
    islandDropdown.MouseButton1Click:Connect(function()
        islandIndex = (islandIndex % #islandList) + 1
        islandDropdown.Text = islandList[islandIndex]
        currentIsland = islandList[islandIndex]
    end)
    
    local teleportBtn = Instance.new("TextButton")
    teleportBtn.Size = UDim2.new(1, -20, 0, 40)
    teleportBtn.Position = UDim2.new(0, 10, 0, 150)
    teleportBtn.BackgroundColor3 = Colors.Accent
    teleportBtn.Text = "🚀 Teleport"
    teleportBtn.TextColor3 = Colors.Text
    teleportBtn.TextSize = 16
    teleportBtn.Font = Enum.Font.GothamBold
    teleportBtn.Parent = tab
    
    local teleportCorner = Instance.new("UICorner")
    teleportCorner.CornerRadius = UDim.new(0, 10)
    teleportCorner.Parent = teleportBtn
    
    teleportBtn.MouseButton1Click:Connect(function()
        SafeCall(function()
            local seaKey = "Sea" .. currentSea
            if Teleports[seaKey] and currentIsland then
                local pos = Teleports[seaKey][currentIsland]
                if pos then
                    HumanoidRootPart.CFrame = CFrame.new(pos)
                    print("[BloxFruitsHub] Teleported to:", currentIsland)
                end
            end
        end)
    end)
end

local function CreateESPTab(content)
    local tab = CreateTabContent(content, "esp")
    tab.Visible = false
    
    local playerEspLabel = Instance.new("TextLabel")
    playerEspLabel.Size = UDim2.new(1, -20, 0, 25)
    playerEspLabel.Position = UDim2.new(0, 10, 0, 0)
    playerEspLabel.BackgroundTransparency = 1
    playerEspLabel.Text = "👤 Player ESP"
    playerEspLabel.TextColor3 = Colors.AccentLight
    playerEspLabel.TextSize = 14
    playerEspLabel.Font = Enum.Font.GothamBold
    playerEspLabel.TextXAlignment = Enum.TextXAlignment.Left
    playerEspLabel.Parent = tab
    
    CreateFeatureRow(tab, "Enable Player ESP", "PlayerESP", 30)
    CreateFeatureRow(tab, "Show Names", "PlayerESP", 80)
    CreateFeatureRow(tab, "Show Distance", "PlayerESP", 130)
    CreateFeatureRow(tab, "Show Health Bar", "PlayerESP", 180)
    CreateFeatureRow(tab, "Show Avatar", "PlayerESP", 230)
    
    local dealerEspLabel = Instance.new("TextLabel")
    dealerEspLabel.Size = UDim2.new(1, -20, 0, 25)
    dealerEspLabel.Position = UDim2.new(0, 10, 0, 280)
    dealerEspLabel.BackgroundTransparency = 1
    dealerEspLabel.Text = "⚔️ Sword Dealer ESP"
    dealerEspLabel.TextColor3 = Colors.AccentLight
    dealerEspLabel.TextSize = 14
    dealerEspLabel.Font = Enum.Font.GothamBold
    dealerEspLabel.TextXAlignment = Enum.TextXAlignment.Left
    dealerEspLabel.Parent = tab
    
    CreateFeatureRow(tab, "Enable Dealer ESP", "SwordDealerESP", 310)
    CreateFeatureRow(tab, "Screen Alert", "SwordDealerESP", 360)
    CreateFeatureRow(tab, "Tracer Line", "SwordDealerESP", 410)
    
    local fruitEspLabel = Instance.new("TextLabel")
    fruitEspLabel.Size = UDim2.new(1, -20, 0, 25)
    fruitEspLabel.Position = UDim2.new(0, 10, 0, 460)
    fruitEspLabel.BackgroundTransparency = 1
    fruitEspLabel.Text = "🍎 Devil Fruit ESP"
    fruitEspLabel.TextColor3 = Colors.AccentLight
    fruitEspLabel.TextSize = 14
    fruitEspLabel.Font = Enum.Font.GothamBold
    fruitEspLabel.TextXAlignment = Enum.TextXAlignment.Left
    fruitEspLabel.Parent = tab
    
    CreateFeatureRow(tab, "Enable Fruit ESP", "FruitESP", 490)
    CreateFeatureRow(tab, "3D Box", "FruitESP", 540)
    CreateFeatureRow(tab, "Show Name", "FruitESP", 590)
    
    local hakiEspLabel = Instance.new("TextLabel")
    hakiEspLabel.Size = UDim2.new(1, -20, 0, 25)
    hakiEspLabel.Position = UDim2.new(0, 10, 0, 640)
    hakiEspLabel.BackgroundTransparency = 1
    hakiEspLabel.Text = "🌟 Berry & Haki ESP"
    hakiEspLabel.TextColor3 = Colors.AccentLight
    hakiEspLabel.TextSize = 14
    hakiEspLabel.Font = Enum.Font.GothamBold
    hakiEspLabel.TextXAlignment = Enum.TextXAlignment.Left
    hakiEspLabel.Parent = tab
    
    CreateFeatureRow(tab, "Enable Haki ESP", "HakiESP", 670)
    CreateFeatureRow(tab, "Show Berries", "HakiESP", 720)
    CreateFeatureRow(tab, "Show Chests", "HakiESP", 770)
end

local function CreateShopTab(content)
    local tab = CreateTabContent(content, "shop")
    tab.Visible = false
    
    local autoBuyLabel = Instance.new("TextLabel")
    autoBuyLabel.Size = UDim2.new(1, -20, 0, 25)
    autoBuyLabel.Position = UDim2.new(0, 10, 0, 0)
    autoBuyLabel.BackgroundTransparency = 1
    autoBuyLabel.Text = "🛒 Auto Buy"
    autoBuyLabel.TextColor3 = Colors.AccentLight
    autoBuyLabel.TextSize = 14
    autoBuyLabel.Font = Enum.Font.GothamBold
    autoBuyLabel.TextXAlignment = Enum.TextXAlignment.Left
    autoBuyLabel.Parent = tab
    
    CreateFeatureRow(tab, "Enable Auto Buy", "AutoBuy", 30)
    CreateFeatureRow(tab, "Auto Swords", "AutoBuy", 80)
    CreateFeatureRow(tab, "Auto Superhuman", "AutoBuy", 130)
    CreateFeatureRow(tab, "Auto Death Step", "AutoBuy", 180)
    
    local sniperLabel = Instance.new("TextLabel")
    sniperLabel.Size = UDim2.new(1, -20, 0, 25)
    sniperLabel.Position = UDim2.new(0, 10, 0, 230)
    sniperLabel.BackgroundTransparency = 1
    sniperLabel.Text = "🎯 Fruit Sniper"
    sniperLabel.TextColor3 = Colors.AccentLight
    sniperLabel.TextSize = 14
    sniperLabel.Font = Enum.Font.GothamBold
    sniperLabel.TextXAlignment = Enum.TextXAlignment.Left
    sniperLabel.Parent = tab
    
    CreateFeatureRow(tab, "Enable Fruit Sniper", "FruitSniper", 260)
    CreateFeatureRow(tab, "Auto Rebuy", "FruitSniper", 310)
    
    local targetLabel = Instance.new("TextLabel")
    targetLabel.Size = UDim2.new(1, -20, 0, 25)
    targetLabel.Position = UDim2.new(0, 10, 0, 360)
    targetLabel.BackgroundTransparency = 1
    targetLabel.Text = "🎯 Target Fruit:"
    targetLabel.TextColor3 = Colors.Text
    targetLabel.TextSize = 14
    targetLabel.Font = Enum.Font.GothamBold
    targetLabel.TextXAlignment = Enum.TextXAlignment.Left
    targetLabel.Parent = tab
    
    local targetDropdown = Instance.new("TextButton")
    targetDropdown.Size = UDim2.new(1, -20, 0, 35)
    targetDropdown.Position = UDim2.new(0, 10, 0, 390)
    targetDropdown.BackgroundColor3 = Colors.BackgroundLight
    targetDropdown.Text = "Select Fruit..."
    targetDropdown.TextColor3 = Colors.TextDim
    targetDropdown.TextSize = 14
    targetDropdown.Font = Enum.Font.Gotham
    targetDropdown.Parent = tab
    
    local targetCorner = Instance.new("UICorner")
    targetCorner.CornerRadius = UDim.new(0, 8)
    targetCorner.Parent = targetDropdown
    
    local fruits = {"Buddha", "Leopard", "Spirit", "Portal", "Shadow", "Control", "Light", "Dough", "Magma", "Blizzard", "Paw", "Gravity"}
    local fruitIndex = 0
    
    targetDropdown.MouseButton1Click:Connect(function()
        fruitIndex = (fruitIndex % #fruits) + 1
        targetDropdown.Text = fruits[fruitIndex]
        Features.FruitSniper.TargetFruit = fruits[fruitIndex]
    end)
end

local function CreateESPGui()
    local gui = Instance.new("ScreenGui")
    gui.Name = SCRIPT_NAME .. "_ESP"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    return gui
end

local function CreateESPLabel(target, labelText, labelColor, position)
    local label = ESPLabels[target]
    
    if not label then
        label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 140, 0, 35)
        label.BackgroundTransparency = 1
        label.TextColor3 = labelColor or Colors.Text
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.Gotham
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 10
        label.Parent = ESPGui
        ESPLabels[target] = label
    end
    
    if position then
        label.Position = UDim2.new(0, position.X - 70, 0, position.Y - 45)
    end
    
    label.Text = labelText
    return label
end

local function CreateHealthBar(target, health, maxHealth, position)
    local barContainer = ESPLabels[target .. "_HealthBar"]
    
    if not barContainer then
        barContainer = Instance.new("Frame")
        barContainer.Size = UDim2.new(0, 140, 0, 6)
        barContainer.BackgroundTransparency = 1
        barContainer.ZIndex = 10
        barContainer.Parent = ESPGui
        ESPLabels[target .. "_HealthBar"] = barContainer
        
        local bar = Instance.new("Frame")
        bar.Name = "HealthFill"
        bar.Size = UDim2.new(1, 0, 1, 0)
        bar.BackgroundColor3 = Colors.Active
        bar.BorderSizePixel = 0
        bar.Parent = barContainer
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 2)
        corner.Parent = bar
    end
    
    if position then
        barContainer.Position = UDim2.new(0, position.X - 70, 0, position.Y - 37)
    end
    
    local healthPercent = health / maxHealth
    local healthFill = barContainer:FindFirstChild("HealthFill")
    if healthFill then
        healthFill.Size = UDim2.new(math.clamp(healthPercent, 0, 1), 0, 1, 0)
        
        if healthPercent > 0.6 then
            healthFill.BackgroundColor3 = Colors.Active
        elseif healthPercent > 0.3 then
            healthFill.BackgroundColor3 = Colors.Warning
        else
            healthFill.BackgroundColor3 = Colors.Error
        end
    end
    
    return barContainer
end

local function CreateTracer(targetPart, color)
    local tracer = TracerLines[targetPart]
    
    if not tracer then
        local line = Instance.new("Beam")
        line.Color = ColorSequence.new(color or Colors.Accent)
        line.Transparency = NumberSequence.new(0.3, 0.7)
        line.Width = 0.4
        line.Parent = targetPart
        TracerLines[targetPart] = line
    end
    
    return tracer
end

local function GetPlayerThumbnail(playerId)
    local cached = ThumbnailCache[playerId]
    if cached then
        return cached
    end
    
    local success, thumbnailUrl = pcall(function()
        return Players:GetUserThumbnailAsync(playerId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    end)
    
    if success and thumbnailUrl then
        ThumbnailCache[playerId] = thumbnailUrl
        return thumbnailUrl
    end
    return nil
end

local function CreateAvatarThumbnail(player, position)
    local thumbnail = ESPLabels[player.UserId .. "_Avatar"]
    
    if not thumbnail then
        thumbnail = Instance.new("ImageLabel")
        thumbnail.Size = UDim2.new(0, 28, 0, 28)
        thumbnail.BackgroundTransparency = 1
        thumbnail.Image = "rbxassetid://6035504008"
        thumbnail.ZIndex = 10
        thumbnail.Parent = ESPGui
        ESPLabels[player.UserId .. "_Avatar"] = thumbnail
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0.5, 0)
        corner.Parent = thumbnail
    end
    
    if position then
        thumbnail.Position = UDim2.new(0, position.X + 75, 0, position.Y - 45)
    end
    
    local thumbnailUrl = GetPlayerThumbnail(player.UserId)
    if thumbnailUrl then
        thumbnail.Image = thumbnailUrl
    end
    
    return thumbnail
end

local function Create3DBox(part, color)
    local box = ESPLabels[part]
    
    if not box then
        box = Instance.new("BillboardGui")
        box.Size = UDim2.new(0, 80, 0, 80)
        box.StudsOffset = Vector3.new(0, 1.5, 0)
        box.AlwaysOnTop = true
        box.Parent = part
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1
        frame.BorderSizePixel = 2
        frame.BorderColor3 = color or Colors.Accent
        frame.Parent = box
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = frame
        
        ESPLabels[part] = box
    end
    
    return box
end

local function ESPRenderLoop()
    while true do
        task.wait(0.05)
        
        SafeCall(function()
            if Features.PlayerESP.Enabled then
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local onScreen, screenPos = Camera:WorldToViewportPoint(hrp.Position)
                            if onScreen and screenPos.Z > 0 then
                                local dist = GetDistance(HumanoidRootPart, hrp)
                                local humanoid = player.Character:FindFirstChild("Humanoid")
                                local health = humanoid and humanoid.Health or 0
                                local maxHealth = humanoid and humanoid.MaxHealth or 100
                                
                                local labelText = ""
                                if Features.PlayerESP.ShowName then
                                    labelText = player.Name .. "\n"
                                end
                                if Features.PlayerESP.ShowDistance then
                                    labelText = labelText .. string.format("%.0f m", dist) .. "\n"
                                end
                                if Features.PlayerESP.ShowHealth then
                                    labelText = labelText .. string.format("HP: %d/%d", math.floor(health), math.floor(maxHealth))
                                end
                                
                                CreateESPLabel(player.UserId, labelText, Colors.Text, screenPos)
                                
                                if Features.PlayerESP.ShowHealth then
                                    CreateHealthBar(player.UserId .. "_Health", health, maxHealth, screenPos)
                                end
                                
                                if Features.PlayerESP.ShowAvatar then
                                    CreateAvatarThumbnail(player, screenPos)
                                end
                            end
                        end
                    end
                end
            end
            
            if Features.FruitESP.Enabled then
                for _, fruit in ipairs(workspace:GetDescendants()) do
                    if fruit:IsA("Model") and fruit.Name:find("Blox Fruit") then
                        local primary = fruit:FindFirstChild("PrimaryPart") or fruit:FindFirstChildWhichIsA("BasePart")
                        if primary then
                            local onScreen, screenPos = Camera:WorldToViewportPoint(primary.Position)
                            if onScreen and screenPos.Z > 0 then
                                local dist = GetDistance(HumanoidRootPart, primary)
                                
                                if Features.FruitESP.ShowBox then
                                    Create3DBox(primary, Colors.Accent)
                                end
                                
                                local fruitName = fruit.Name:match("(.+)-") or "Unknown"
                                local labelText = ""
                                
                                if Features.FruitESP.ShowName then
                                    labelText = "🍎 " .. fruitName .. "\n"
                                end
                                if Features.FruitESP.ShowDistance then
                                    labelText = labelText .. string.format("%.0f m", dist)
                                end
                                
                                CreateESPLabel(primary, labelText, Colors.Gold, screenPos)
                            end
                        end
                    end
                end
            end
            
            if Features.SwordDealerESP.Enabled then
                local dealerFound = false
                
                for _, npc in ipairs(workspace:GetDescendants()) do
                    if (npc.Name:find("Legendary") and npc.Name:find("Sword")) or npc.Name:find("Sword Dealer") then
                        local hrp = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChildWhichIsA("BasePart")
                        if hrp then
                            dealerFound = true
                            local onScreen, screenPos = Camera:WorldToViewportPoint(hrp.Position)
                            
                            if onScreen and screenPos.Z > 0 then
                                local dist = GetDistance(HumanoidRootPart, hrp)
                                
                                if Features.SwordDealerESP.ShowTracer then
                                    CreateTracer(hrp, Colors.Accent)
                                end
                                
                                local labelText = "⚔️ SWORD DEALER\n"
                                if Features.SwordDealerESP.ShowDistance then
                                    labelText = labelText .. string.format("%.0f m", dist)
                                end
                                
                                CreateESPLabel("SwordDealer", labelText, Colors.Accent, screenPos)
                            end
                            
                            if Features.SwordDealerESP.ShowAlert then
                                local alert = ESPGui:FindFirstChild("DealerAlert")
                                if not alert then
                                    alert = Instance.new("TextLabel")
                                    alert.Name = "DealerAlert"
                                    alert.Size = UDim2.new(0, 400, 0, 80)
                                    alert.Position = UDim2.new(0.5, -200, 0.2, 0)
                                    alert.BackgroundColor3 = Colors.Accent
                                    alert.BackgroundTransparency = 0.4
                                    alert.Text = "⚔️ SWORD DEALER SPAWNED! ⚔️"
                                    alert.TextColor3 = Colors.Text
                                    alert.TextStrokeTransparency = 0
                                    alert.Font = Enum.Font.GothamBold
                                    alert.TextSize = 28
                                    alert.TextYAlignment = Enum.TextYAlignment.Top
                                    alert.ZIndex = 100
                                    alert.Parent = ESPGui
                                    
                                    task.delay(8, function()
                                        if alert and alert.Parent then
                                            alert:Destroy()
                                        end
                                    end)
                                end
                            end
                        end
                    end
                end
                
                if not dealerFound then
                    local alert = ESPGui:FindFirstChild("DealerAlert")
                    if alert then
                        alert:Destroy()
                    end
                end
            end
            
            if Features.HakiESP.Enabled then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    local isBerry = obj.Name:find("Berry") or obj.Name:find("Haki")
                    local isChest = obj.Name:find("Chest") or obj.Name:find("Treasure")
                    
                    if (Features.HakiESP.ShowBerry and isBerry) or (Features.HakiESP.ShowChest and isChest) then
                        local part = obj:FindFirstChildWhichIsA("BasePart") or obj
                        if part then
                            local onScreen, screenPos = Camera:WorldToViewportPoint(part.Position)
                            if onScreen and screenPos.Z > 0 then
                                local dist = GetDistance(HumanoidRootPart, part)
                                
                                local labelText = ""
                                if isBerry then
                                    labelText = "🌟 HAKI MATERIAL\n"
                                else
                                    labelText = "📦 RARE CHEST\n"
                                end
                                labelText = labelText .. string.format("%.0f m", dist)
                                
                                CreateESPLabel(part, labelText, Colors.Green, screenPos)
                                
                                if Features.HakiESP.ShowChest or Features.HakiESP.ShowBerry then
                                    Create3DBox(part, Colors.Green)
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end

local function FindQuestNPC()
    for _, npc in ipairs(workspace:GetDescendants()) do
        if (npc.Name:find("Quest") or npc.Name:find("Npc")) and npc:IsA("Model") then
            local human = npc:FindFirstChild("Humanoid")
            if human then
                return npc
            end
        end
    end
    return nil
end

local function FindQuestMobs(questNPC)
    local mobs = {}
    local questArea = questNPC and questNPC.PrimaryPart
    
    if questArea then
        for _, mob in ipairs(workspace:GetDescendants()) do
            if mob:IsA("Model") and mob.Name:find("Mob") then
                local mobPart = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChildWhichIsA("BasePart")
                if mobPart then
                    local dist = GetDistance(questArea, mobPart)
                    if dist < 200 then
                        table.insert(mobs, mob)
                    end
                end
            end
        end
    end
    
    return mobs
end

local function SmoothTeleport(targetPosition)
    local startPos = HumanoidRootPart.CFrame
    local targetCFrame = CFrame.new(targetPosition.X, targetPosition.Y + 5, targetPosition.Z)
    
    local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(HumanoidRootPart, tweenInfo, {CFrame = targetCFrame})
    
    SafeCall(function()
        tween:Play()
        tween.Completed:Wait()
    end)
end

local function AutoClickCombat(targetMob)
    local mobPart = targetMob:FindFirstChild("HumanoidRootPart") or targetMob:FindFirstChildWhichIsA("BasePart")
    if mobPart then
        Humanoid:MoveTowards(mobPart.Position)
        
        SafeCall(function()
            UserInputService:MouseButton1Down(Vector2.new(500, 500))
            task.wait(0.03)
            UserInputService:MouseButton1Up(Vector2.new(500, 500))
        end)
    end
end

local function AutoFarmLoop()
    while true do
        task.wait(0.5)
        
        SafeCall(function()
            if Features.AutoFarm.Enabled then
                local questNPC = FindQuestNPC()
                
                if questNPC then
                    local questPart = questNPC:FindFirstChild("HumanoidRootPart") or questNPC.PrimaryPart
                    
                    if questPart and Features.AutoFarm.AutoQuest then
                        local dist = GetDistance(HumanoidRootPart, questPart)
                        
                        if dist > 50 then
                            if Features.AutoFarm.SmoothTeleport then
                                SmoothTeleport(questPart.Position)
                            else
                                HumanoidRootPart.CFrame = CFrame.new(questPart.Position + Vector3.new(0, 5, 0))
                            end
                        else
                            SafeCall(function()
                                ReplicatedStorage:FindFirstChild("AcceptQuest"):FireServer()
                            end)
                        end
                    end
                    
                    if Features.AutoFarm.AutoClicker then
                        local mobs = FindQuestMobs(questNPC)
                        
                        if #mobs > 0 then
                            local closestMob = mobs[1]
                            local closestDist = math.huge
                            
                            for _, mob in ipairs(mobs) do
                                local mobPart = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChildWhichIsA("BasePart")
                                if mobPart then
                                    local dist = GetDistance(HumanoidRootPart, mobPart)
                                    if dist < closestDist then
                                        closestDist = dist
                                        closestMob = mob
                                    end
                                end
                            end
                            
                            if closestMob and closestDist < 100 then
                                AutoClickCombat(closestMob)
                            end
                        end
                    end
                end
            end
        end)
    end
end

local function AutoMasteryLoop()
    while true do
        task.wait(0.5)
        
        SafeCall(function()
            if Features.AutoMastery.Enabled then
                local target = nil
                local closestDist = math.huge
                
                for _, mob in ipairs(workspace:GetDescendants()) do
                    if mob:IsA("Model") and mob.Name:find("Mob") then
                        local mobPart = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChildWhichIsA("BasePart")
                        local humanoid = mob:FindFirstChild("Humanoid")
                        
                        if mobPart and humanoid and humanoid.Health > 1 then
                            local dist = GetDistance(HumanoidRootPart, mobPart)
                            if dist < 50 and dist < closestDist then
                                closestDist = dist
                                target = mob
                            end
                        end
                    end
                end
                
                if target then
                    local targetHumanoid = target:FindFirstChild("Humanoid")
                    
                    if Features.AutoMastery.Type == "Fruit" then
                        SafeCall(function()
                            ReplicatedStorage:FindFirstChild("UseAbility"):FireServer(1)
                        end)
                    elseif Features.AutoMastery.Type == "Sword" then
                        SafeCall(function()
                            ReplicatedStorage:FindFirstChild("UseSwordAbility"):FireServer()
                        end)
                    elseif Features.AutoMastery.Type == "Gun" then
                        SafeCall(function()
                            ReplicatedStorage:FindFirstChild("Shoot"):FireServer()
                        end)
                    end
                    
                    if targetHumanoid and targetHumanoid.Health < 20 then
                        SafeCall(function()
                            ReplicatedStorage:FindFirstChild("FinishMove"):FireServer()
                        end)
                    end
                end
            end
        end)
    end
end

local function AutoStatsLoop()
    while true do
        task.wait(1)
        
        SafeCall(function()
            if Features.AutoStats.Enabled then
                local stats = GetPlayerStats()
                
                if stats and stats.Stats > 0 then
                    if Features.AutoStats.AutoMelee then
                        SafeCall(function()
                            ReplicatedStorage:FindFirstChild("StatChoice"):FireServer("Melee")
                        end)
                    end
                    
                    if Features.AutoStats.AutoDefense then
                        SafeCall(function()
                            ReplicatedStorage:FindFirstChild("StatChoice"):FireServer("Defense")
                        end)
                    end
                    
                    if Features.AutoStats.AutoSword then
                        SafeCall(function()
                            ReplicatedStorage:FindFirstChild("StatChoice"):FireServer("Sword")
                        end)
                    end
                    
                    if Features.AutoStats.AutoGun then
                        SafeCall(function()
                            ReplicatedStorage:FindFirstChild("StatChoice"):FireServer("Gun")
                        end)
                    end
                    
                    if Features.AutoStats.AutoDF then
                        SafeCall(function()
                            ReplicatedStorage:FindFirstChild("StatChoice"):FireServer("DF")
                        end)
                    end
                end
            end
        end)
    end
end

local function FindShopNPC()
    for _, npc in ipairs(workspace:GetDescendants()) do
        if npc.Name:find("Dealer") or npc.Name:find("Shop") or npc.Name:find("Blox Fruit Dealer") then
            return npc
        end
    end
    return nil
end

local function AutoBuyLoop()
    while true do
        task.wait(1)
        
        SafeCall(function()
            if Features.AutoBuy.Enabled then
                local shopNPC = FindShopNPC()
                local stats = GetPlayerStats()
                
                if shopNPC and stats then
                    if Features.AutoBuy.AutoSwords then
                        for _, item in ipairs(shopNPC:GetDescendants()) do
                            if item.Name:find("Sword") and item:IsA("Tool") then
                                SafeCall(function()
                                    ReplicatedStorage:FindFirstChild("BuyItem"):FireServer(item)
                                end)
                            end
                        end
                    end
                    
                    if Features.AutoBuy.AutoSuperhuman then
                        SafeCall(function()
                            ReplicatedStorage:FindFirstChild("BuyStyle"):FireServer("Superhuman")
                        end)
                    end
                    
                    if Features.AutoBuy.AutoDeathStep then
                        SafeCall(function()
                            ReplicatedStorage:FindFirstChild("BuyStyle"):FireServer("DeathStep")
                        end)
                    end
                end
            end
        end)
    end
end

local function FruitSniperLoop()
    while true do
        task.wait(0.05)
        
        SafeCall(function()
            if Features.FruitSniper.Enabled and Features.FruitSniper.TargetFruit ~= "" then
                local fruitDealer = FindShopNPC()
                
                if fruitDealer then
                    for _, fruit in ipairs(fruitDealer:GetDescendants()) do
                        if fruit.Name:find("Blox Fruit") then
                            local fruitName = fruit.Name:match("(.+)-") or fruit.Name
                            
                            if fruitName:find(Features.FruitSniper.TargetFruit) then
                                print("[BloxFruitsHub] Found target fruit:", fruitName)
                                
                                SafeCall(function()
                                    ReplicatedStorage:FindFirstChild("BuyFruit"):FireServer(fruit)
                                    print("[BloxFruitsHub] Attempted to buy:", fruitName)
                                end)
                                
                                if not Features.FruitSniper.AutoRebuy then
                                    Features.FruitSniper.Enabled = false
                                    print("[BloxFruitsHub] Fruit Sniper stopped")
                                end
                                
                                break
                            end
                        end
                    end
                end
            end
        end)
    end
end

local function InitializeUI()
    local screenGui = CreateScreenGui()
    MainFrame = CreateMainFrame(screenGui)
    local header, closeBtn = CreateHeader(MainFrame)
    local sidebar, tabButtons = CreateSidebar(MainFrame)
    local content = CreateContentArea(MainFrame)
    ToggleButton = CreateToggleButton(screenGui)
    
    CreateFarmTab(content)
    CreateStatsTab(content)
    CreateTeleportsTab(content)
    CreateESPTab(content)
    CreateShopTab(content)
    
    local currentTab = 1
    local tabs = {"farm", "stats", "teleports", "esp", "shop"}
    
    for i, tab in ipairs(tabButtons) do
        local btn = tab.Button
        local tabName = tab.Tab
        
        btn.MouseButton1Click:Connect(function()
            for j, t in ipairs(tabButtons) do
                t.Button.TextColor3 = Colors.TextDim
                t.Button.BackgroundTransparency = 1
                t.Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            end
            
            btn.TextColor3 = Colors.AccentLight
            btn.BackgroundTransparency = 0.9
            btn.BackgroundColor3 = Colors.Accent
            
            currentTab = i
            
            for j, tabContent in ipairs(content:GetChildren()) do
                if tabContent:IsA("Frame") then
                    tabContent.Visible = (tabs[j] == tabName)
                end
            end
        end)
    end
    
    closeBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        ToggleButton.Visible = true
    end)
    
    ToggleButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        ToggleButton.Visible = false
    end)
    
    ToggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            ToggleButton.InputChanged:Connect(function(input2)
                if input2.UserInputType == Enum.UserInputType.MouseMovement or input2.UserInputType == Enum.UserInputType.Touch then
                    ToggleButton.Position = UDim2.new(0, input2.Position.X - 20, 0, input2.Position.Y - 20)
                end
            end)
        end
    end)
end

local function InitializeSystems()
    ESPGui = CreateESPGui()
    
    coroutine.wrap(function()
        ESPRenderLoop()
    end)()
    
    coroutine.wrap(function()
        AutoFarmLoop()
    end)()
    
    coroutine.wrap(function()
        AutoMasteryLoop()
    end)()
    
    coroutine.wrap(function()
        AutoStatsLoop()
    end)()
    
    coroutine.wrap(function()
        AutoBuyLoop()
    end)()
    
    coroutine.wrap(function()
        FruitSniperLoop()
    end)()
end

local function Cleanup()
    if MainFrame and MainFrame.Parent then
        MainFrame:Destroy()
    end
    
    if ESPGui then
        ESPGui:Destroy()
    end
    
    for _, label in ipairs(ESPLabels) do
        if label and label.Parent then
            label:Destroy()
        end
    end
    
    for _, tracer in ipairs(TracerLines) do
        if tracer and tracer.Parent then
            tracer:Destroy()
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end)

InitializeUI()
InitializeSystems()

print("========================================")
print("  BLOX FRUITS PREMIUM SCRIPT HUB")
print("  Delta Executor v" .. SCRIPT_VERSION)
print("========================================")
print("Features Loaded:")
print("  ✓ Auto Farm Level")
print("  ✓ Auto Mastery (Fruit/Sword/Gun)")
print("  ✓ Auto Stats Allocation")
print("  ✓ Teleport System (Sea 1/2/3)")
print("  ✓ Player ESP (Names, Distance, Health, Avatar)")
print("  ✓ Legendary Sword Dealer ESP")
print("  ✓ Devil Fruit ESP (Box, Name, Distance)")
print("  ✓ Haki Material ESP (Berries, Chests)")
print("  ✓ Auto Buy (Swords, Styles)")
print("  ✓ Fruit Sniper")
print("========================================")
print("Click the purple toggle button to minimize!")
print("========================================")
