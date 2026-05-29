--[[
    ============================================================================
    BLOX FRUITS PREMIUM HUB - LOADER SCRIPT
    Delta Executor Bridge Script for Web GUI Communication
    ============================================================================
    
    INSTRUCTIONS:
    1. Open Delta Executor
    2. Join Blox Fruits game
    3. Paste this script into the executor
    4. Click "Play" or "Execute"
    5. The web GUI will load automatically
    
    ============================================================================
]]

-- ===========================================================================
-- CORE SERVICES
-- ===========================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local UserSettings = game:GetService("UserSettings")
local Lighting = game:GetService("Lighting")

-- ===========================================================================
-- CONFIGURATION
-- ===========================================================================

local CONFIG = {
    SCRIPT_NAME = "BloxFruitsHub",
    VERSION = "3.2.1",
  
    ============================================================================
]]

-- ===========================================================================
-- CORE SERVICES
-- ===========================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local UserSettings = game:GetService("UserSettings")
local Lighting = game:GetService("Lighting")

-- ===========================================================================
-- CONFIGURATION
-- ===========================================================================

local CONFIG = {
    SCRIPT_NAME = "BloxFruitsHub",
    VERSION = "3.2.1",
    WEB_URL = "https://raw.githubusercontent.com/d59009611-pixel/delta-test/refs/heads/main/index.html",
    GUI_NAME = "BloxFruitsHub_Gui",
    ESP_GUI_NAME = "BloxFruitsHub_ESP",
    COMMAND_POLL_INTERVAL = 0.1,
    MAX_COMMAND_RETRIES = 3
}

-- ===========================================================================
-- PLAYER & CHARACTER SETUP
-- ===========================================================================

    GUI_NAME = "BloxFruitsHub_Gui",
    ESP_GUI_NAME = "BloxFruitsHub_ESP",
    COMMAND_POLL_INTERVAL = 0.1,
    MAX_COMMAND_RETRIES = 3
}

-- ===========================================================================
-- PLAYER & CHARACTER SETUP
-- ===========================================================================

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera

-- Update character on respawn
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    print("[BloxFruitsHub] Character respawned, reinitializing...")
end)

-- ===========================================================================
-- FEATURE STATE MANAGEMENT
-- ===========================================================================

local Features = {
    -- Main Farm
    AutoFarm = false,
    SmoothTeleport = true,
    AutoClicker = true,
    AutoQuest = true,
    AutoMastery = false,
    MasteryType = "Fruit",
    
    -- Stats
    AutoMelee = false,
    AutoDefense = false,
    AutoSword = false,
    AutoGun = false,
    AutoDF = false,
    
    -- Teleports
    CurrentSea = 1,
    CurrentIsland = nil,
    
    -- ESP
    PlayerESP = false,
    NameTags = true,
    DistanceESP = true,
    HealthBar = true,
    AvatarThumb = false,
    FruitESP_Display = false,
    SwordDealerESP = false,
    DealerAlert = true,
    DealerTracer = true,
    DealerDistance = true,
    FruitESP_Toggle = false,
    FruitBox = true,
    FruitName = true,
    FruitIcon = false,
    FruitDistance = true,
    HakiESP = false,
    BerryESP = true,
    ChestESP = true,
    MaterialIcon = true,
    
    -- Shop
    AutoBuy = false,
    AutoSwords = false,
    AutoSuperhuman = false,
    AutoDeathStep = false,
    AutoWaterKungFu = false,
    FruitSniper = false,
    AutoRebuy = true,
    TargetFruit = "",
    SniperMode = true
}

-- ===========================================================================
-- TELEPORT LOCATIONS DATABASE
-- ===========================================================================

local Teleports = {
    Sea1 = {
        prelude = Vector3.new(-50, 100, 0),
        jail = Vector3.new(-200, 100, -200),
        mysterious = Vector3.new(500, 100, 500),
        snow = Vector3.new(1000, 100, 500),
        desert = Vector3.new(1500, 100, 1000),
        castle = Vector3.new(2000, 100, 1500),
        forest = Vector3.new(2500, 100, 2000),
        skylands = Vector3.new(3000, 100, 2500),
        haka = Vector3.new(3500, 100, 3000),
        secondsea = Vector3.new(4000, 100, 3500)
    },
    Sea2 = {
        risky = Vector3.new(4500, 100, 4000),
        fried = Vector3.new(5000, 100, 4500),
        alpine = Vector3.new(5500, 100, 5000),
        candy = Vector3.new(6000, 100, 5500),
        pink = Vector3.new(6500, 100, 6000),
        radiation = Vector3.new(7000, 100, 6500),
        volcano = Vector3.new(7500, 100, 7000),
        kingscastle = Vector3.new(8000, 100, 7500),
        corrupted = Vector3.new(8500, 100, 8000),
        thirdsea = Vector3.new(9000, 100, 8500)
    },
    Sea3 = {
        greenzone = Vector3.new(9500, 100, 9000),
        hunting = Vector3.new(10000, 100, 9500),
        redzone = Vector3.new(10500, 100, 10000),
        magma = Vector3.new(11000, 100, 10500),
        hokage = Vector3.new(11500, 100, 11000),
        shadow = Vector3.new(12000, 100, 11500),
        snowvillage = Vector3.new(12500, 100, 12000),
        rainbow = Vector3.new(13000, 100, 12500),
        skylands_s3 = Vector3.new(13500, 100, 13000),
        flaming = Vector3.new(14000, 100, 13500)
    }
}

-- ===========================================================================
-- UTILITY FUNCTIONS
-- ===========================================================================

-- Safe call wrapper to prevent script crashes
local function SafeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        warn(string.format("[%s] Error in function: %s", CONFIG.SCRIPT_NAME, tostring(result)))
        return false, result
    end
    return true, result
end

-- Get distance between two parts
local function GetDistance(part1, part2)
    if part1 and part2 then
        return (part1.Position - part2.Position).Magnitude
    end
    return math.huge
end

-- Check if position is on screen
local function IsOnScreen(worldPosition)
    local onScreen, screenPosition = Camera:WorldToViewportPoint(worldPosition)
    return onScreen and screenPosition.Z > 0
end

-- Wait for child with timeout
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

-- Get player stats from leaderstats
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

-- Get player's current fruit
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

-- Get player's current sword
local function GetPlayerSword()
    local swords = LocalPlayer:FindFirstChild("Swords")
    if swords then
        local currentSword = swords:FindFirstChild("Current")
        if currentSword then
            return currentSword.Value or nil
        end
    end
    return nil
end

-- ===========================================================================
-- TELEPORT SYSTEM
-- ===========================================================================

-- Smooth teleport using TweenService (bypasses anti-cheat)
local function SmoothTeleport(targetPosition)
    return SafeCall(function()
        if not HumanoidRootPart then return end
        
        local targetCFrame = CFrame.new(targetPosition.X, targetPosition.Y + 5, targetPosition.Z)
        local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(HumanoidRootPart, tweenInfo, {CFrame = targetCFrame})
        
        tween:Play()
        tween.Completed:Wait()
    end)
end

-- Instant teleport (no tween)
local function InstantTeleport(targetPosition)
    return SafeCall(function()
        if not HumanoidRootPart then return end
        HumanoidRootPart.CFrame = CFrame.new(targetPosition)
    end)
end

-- Teleport to specific location
local function TeleportTo(sea, island)
    local seaKey = "Sea" .. sea
    if Teleports[seaKey] and Teleports[seaKey][island] then
        local position = Teleports[seaKey][island]
        if Features.SmoothTeleport then
            SmoothTeleport(position)
        else
            InstantTeleport(position)
        end
        print(string.format("[%s] Teleported to: %s (Sea %s)", CONFIG.SCRIPT_NAME, island, sea))
        return true
    else
        warn(string.format("[%s] Invalid teleport location: Sea %s, %s", CONFIG.SCRIPT_NAME, sea, island))
        return false
    end
end

-- ===========================================================================
-- AUTO FARM SYSTEM
-- ===========================================================================

-- Find quest NPC
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

-- Find quest mobs near NPC
local function FindQuestMobs(questNPC, maxDistance)
    maxDistance = maxDistance or 200
    local mobs = {}
    local questArea = questNPC and (questNPC:FindFirstChild("HumanoidRootPart") or questNPC.PrimaryPart)
    
    if questArea then
        for _, mob in ipairs(workspace:GetDescendants()) do
            if mob:IsA("Model") and mob.Name:find("Mob") then
                local mobPart = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChildWhichIsA("BasePart")
                if mobPart then
                    local dist = GetDistance(questArea, mobPart)
                    if dist < maxDistance then
                        table.insert(mobs, { mob = mob, part = mobPart, distance = dist })
                    end
                end
            end
        end
    end
    
    -- Sort by distance
    table.sort(mobs, function(a, b) return a.distance < b.distance end)
    return mobs
end

-- Auto click combat
local function AutoClickCombat(targetMob)
    return SafeCall(function()
        local mobPart = targetMob:FindFirstChild("HumanoidRootPart") or targetMob:FindFirstChildWhichIsA("BasePart")
        if mobPart and Humanoid then
            Humanoid:MoveTowards(mobPart.Position)
            
            -- Simulate mouse click
            if UserInputService then
                UserInputService:MouseButton1Down(Vector2.new(500, 500))
                task.wait(0.03)
                UserInputService:MouseButton1Up(Vector2.new(500, 500))
            end
        end
    end)
end

-- Main auto farm loop
local function AutoFarmLoop()
    while true do
        task.wait(0.5)
        
        if Features.AutoFarm then
            SafeCall(function()
                local questNPC = FindQuestNPC()
                
                if questNPC then
                    local questPart = questNPC:FindFirstChild("HumanoidRootPart") or questNPC.PrimaryPart
                    
                    -- Auto quest acceptance
                    if questPart and Features.AutoQuest then
                        local dist = GetDistance(HumanoidRootPart, questPart)
                        
                        if dist > 50 then
                            if Features.SmoothTeleport then
                                SmoothTeleport(questPart.Position)
                            else
                                HumanoidRootPart.CFrame = CFrame.new(questPart.Position + Vector3.new(0, 5, 0))
                            end
                        else
                            -- Try to accept quest
                            SafeCall(function()
                                local acceptQuest = ReplicatedStorage:FindFirstChild("AcceptQuest")
                                if acceptQuest and acceptQuest:IsA("RemoteEvent") then
                                    acceptQuest:FireServer()
                                end
                            end)
                        end
                    end
                    
                    -- Auto clicker combat
                    if Features.AutoClicker then
                        local mobs = FindQuestMobs(questNPC, 100)
                        
                        if #mobs > 0 then
                            local closestMob = mobs[1]
                            if closestMob and closestMob.distance < 50 then
                                AutoClickCombat(closestMob.mob)
                            end
                        end
                    end
                end
            end)
        end
    end
end

-- ===========================================================================
-- AUTO MASTERY SYSTEM
-- ===========================================================================

local function AutoMasteryLoop()
    while true do
        task.wait(0.5)
        
        if Features.AutoMastery then
            SafeCall(function()
                local target = nil
                local closestDist = math.huge
                
                -- Find closest valid mob
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
                
                -- Attack target
                if target then
                    local targetHumanoid = target:FindFirstChild("Humanoid")
                    
                    if Features.MasteryType == "Fruit" then
                        SafeCall(function()
                            local useAbility = ReplicatedStorage:FindFirstChild("UseAbility")
                            if useAbility and useAbility:IsA("RemoteEvent") then
                                useAbility:FireServer(1)
                            end
                        end)
                    elseif Features.MasteryType == "Sword" then
                        SafeCall(function()
                            local useSword = ReplicatedStorage:FindFirstChild("UseSwordAbility")
                            if useSword and useSword:IsA("RemoteEvent") then
                                useSword:FireServer()
                            end
                        end)
                    elseif Features.MasteryType == "Gun" then
                        SafeCall(function()
                            local shoot = ReplicatedStorage:FindFirstChild("Shoot")
                            if shoot and shoot:IsA("RemoteEvent") then
                                shoot:FireServer()
                            end
                        end)
                    end
                    
                    -- Finish low health enemies
                    if targetHumanoid and targetHumanoid.Health < 20 then
                        SafeCall(function()
                            local finishMove = ReplicatedStorage:FindFirstChild("FinishMove")
                            if finishMove and finishMove:IsA("RemoteEvent") then
                                finishMove:FireServer()
                            end
                        end)
                    end
                end
            end)
        end
    end
end

-- ===========================================================================
-- AUTO STATS SYSTEM
-- ===========================================================================

local function AutoStatsLoop()
    while true do
        task.wait(1)
        
        SafeCall(function()
            local stats = GetPlayerStats()
            
            if stats and stats.Stats > 0 then
                local statChoice = ReplicatedStorage:FindFirstChild("StatChoice")
                
                if not statChoice or not statChoice:IsA("RemoteEvent") then
                    return
                end
                
                -- Priority order for stat allocation
                if Features.AutoMelee then
                    statChoice:FireServer("Melee")
                    return
                end
                
                if Features.AutoDefense then
                    statChoice:FireServer("Defense")
                    return
                end
                
                if Features.AutoSword then
                    statChoice:FireServer("Sword")
                    return
                end
                
                if Features.AutoGun then
                    statChoice:FireServer("Gun")
                    return
                end
                
                if Features.AutoDF then
                    statChoice:FireServer("DF")
                    return
                end
            end
        end)
    end
end

-- ===========================================================================
-- ESP SYSTEM
-- ===========================================================================

local ESPGui = nil
local ESPLabels = {}
local TracerLines = {}
local ThumbnailCache = {}

-- Create ESP ScreenGui
local function CreateESPGui()
    ESPGui = Instance.new("ScreenGui")
    ESPGui.Name = CONFIG.ESP_GUI_NAME
    ESPGui.ResetOnSpawn = false
    ESPGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ESPGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Create ESP label
local function CreateESPLabel(targetId, labelText, labelColor, position)
    local label = ESPLabels[targetId]
    local color = labelColor or Color3.fromRGB(255, 255, 255)
    
    if not label then
        label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 140, 0, 35)
        label.BackgroundTransparency = 1
        label.TextColor3 = color
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.Gotham
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 10
        label.Parent = ESPGui
        ESPLabels[targetId] = label
    end
    
    if position then
        label.Position = UDim2.new(0, position.X - 70, 0, position.Y - 45)
    end
    
    label.Text = labelText
    return label
end

-- Create health bar
local function CreateHealthBar(targetId, health, maxHealth, position)
    local barContainer = ESPLabels[targetId .. "_HealthBar"]
    
    if not barContainer then
        barContainer = Instance.new("Frame")
        barContainer.Size = UDim2.new(0, 140, 0, 6)
        barContainer.BackgroundTransparency = 1
        barContainer.ZIndex = 10
        barContainer.Parent = ESPGui
        ESPLabels[targetId .. "_HealthBar"] = barContainer
        
        local bar = Instance.new("Frame")
        bar.Name = "HealthFill"
        bar.Size = UDim2.new(1, 0, 1, 0)
        bar.BackgroundColor3 = Color3.fromRGB(16, 185, 129)
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
            healthFill.BackgroundColor3 = Color3.fromRGB(16, 185, 129)
        elseif healthPercent > 0.3 then
            healthFill.BackgroundColor3 = Color3.fromRGB(245, 158, 11)
        else
            healthFill.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
        end
    end
    
    return barContainer
end

-- Create tracer line
local function CreateTracer(targetPart, color)
    local tracer = TracerLines[targetPart]
    local tracerColor = color or Color3.fromRGB(139, 92, 246)
    
    if not tracer then
        local line = Instance.new("Beam")
        line.Color = ColorSequence.new(tracerColor)
        line.Transparency = NumberSequence.new(0.3, 0.7)
        line.Width = 0.4
        line.Parent = targetPart
        TracerLines[targetPart] = line
    end
    
    return tracer
end

-- Get player thumbnail
local function GetPlayerThumbnail(playerId)
    local cached = ThumbnailCache[playerId]
    if cached then
        return cached
    end
    
    local success, thumbnailUrl = SafeCall(function()
        return Players:GetUserThumbnailAsync(playerId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    end)
    
    if success and thumbnailUrl then
        ThumbnailCache[playerId] = thumbnailUrl
        return thumbnailUrl
    end
    return nil
end

-- Create 3D box
local function Create3DBox(part, color)
    local box = ESPLabels[part]
    local boxColor = color or Color3.fromRGB(139, 92, 246)
    
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
        frame.BorderColor3 = boxColor
        frame.Parent = box
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = frame
        
        ESPLabels[part] = box
    end
    
    return box
end

-- Main ESP render loop
local function ESPRenderLoop()
    while true do
        task.wait(0.05)
        
        SafeCall(function()
            -- Player ESP
            if Features.PlayerESP then
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
                                if Features.NameTags then
                                    labelText = player.Name .. "\n"
                                end
                                if Features.DistanceESP then
                                    labelText = labelText .. string.format("%.0f m", dist) .. "\n"
                                end
                                if Features.HealthBar then
                                    labelText = labelText .. string.format("HP: %d/%d", math.floor(health), math.floor(maxHealth))
                                end
                                
                                CreateESPLabel(player.UserId, labelText, Color3.fromRGB(255, 255, 255), screenPos)
                                
                                if Features.HealthBar then
                                    CreateHealthBar(player.UserId .. "_Health", health, maxHealth, screenPos)
                                end
                            end
                        end
                    end
                end
            end
            
            -- Sword Dealer ESP
            if Features.SwordDealerESP then
                local dealerFound = false
                
                for _, npc in ipairs(workspace:GetDescendants()) do
                    if (npc.Name:find("Legendary") and npc.Name:find("Sword")) or npc.Name:find("Sword Dealer") then
                        dealerFound = true
                        local hrp = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChildWhichIsA("BasePart")
                        
                        if hrp then
                            local onScreen, screenPos = Camera:WorldToViewportPoint(hrp.Position)
                            
                            if onScreen and screenPos.Z > 0 then
                                local dist = GetDistance(HumanoidRootPart, hrp)
                                
                                if Features.DealerTracer then
                                    CreateTracer(hrp, Color3.fromRGB(139, 92, 246))
                                end
                                
                                local labelText = "⚔️ SWORD DEALER\n"
                                if Features.DealerDistance then
                                    labelText = labelText .. string.format("%.0f m", dist)
                                end
                                
                                CreateESPLabel("SwordDealer", labelText, Color3.fromRGB(139, 92, 246), screenPos)
                            end
                            
                            -- Screen alert
                            if Features.DealerAlert then
                                local alert = ESPGui:FindFirstChild("DealerAlert")
                                if not alert then
                                    alert = Instance.new("TextLabel")
                                    alert.Name = "DealerAlert"
                                    alert.Size = UDim2.new(0, 400, 0, 80)
                                    alert.Position = UDim2.new(0.5, -200, 0.2, 0)
                                    alert.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
                                    alert.BackgroundTransparency = 0.4
                                    alert.Text = "⚔️ SWORD DEALER SPAWNED! ⚔️"
                                    alert.TextColor3 = Color3.fromRGB(255, 255, 255)
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
                
                -- Remove alert if dealer not found
                if not dealerFound then
                    local alert = ESPGui:FindFirstChild("DealerAlert")
                    if alert then
                        alert:Destroy()
                    end
                end
            end
            
            -- Devil Fruit ESP
            if Features.FruitESP_Toggle then
                for _, fruit in ipairs(workspace:GetDescendants()) do
                    if fruit:IsA("Model") and fruit.Name:find("Blox Fruit") then
                        local primary = fruit:FindFirstChild("PrimaryPart") or fruit:FindFirstChildWhichIsA("BasePart")
                        if primary then
                            local onScreen, screenPos = Camera:WorldToViewportPoint(primary.Position)
                            if onScreen and screenPos.Z > 0 then
                                local dist = GetDistance(HumanoidRootPart, primary)
                                
                                if Features.FruitBox then
                                    Create3DBox(primary, Color3.fromRGB(139, 92, 246))
                                end
                                
                                local fruitName = fruit.Name:match("(.+)-") or "Unknown"
                                local labelText = ""
                                
                                if Features.FruitName then
                                    labelText = "🍎 " .. fruitName .. "\n"
                                end
                                if Features.FruitDistance then
                                    labelText = labelText .. string.format("%.0f m", dist)
                                end
                                
                                CreateESPLabel(primary, labelText, Color3.fromRGB(255, 215, 0), screenPos)
                            end
                        end
                    end
                end
            end
            
            -- Haki Material ESP
            if Features.HakiESP then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    local isBerry = obj.Name:find("Berry") or obj.Name:find("Haki")
                    local isChest = obj.Name:find("Chest") or obj.Name:find("Treasure")
                    
                    if (Features.BerryESP and isBerry) or (Features.ChestESP and isChest) then
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
                                
                                CreateESPLabel(part, labelText, Color3.fromRGB(34, 197, 94), screenPos)
                                
                                if Features.MaterialIcon then
                                    Create3DBox(part, Color3.fromRGB(34, 197, 94))
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end

-- ===========================================================================
-- FRUIT SNIPER SYSTEM
-- ===========================================================================

local function FindFruitDealer()
    for _, npc in ipairs(workspace:GetDescendants()) do
        if npc.Name:find("Blox Fruit Dealer") or npc.Name:find("Fruit Dealer") then
            return npc
        end
    end
    return nil
end

local function FruitSniperLoop()
    while true do
        task.wait(0.05)
        
        if Features.FruitSniper and Features.TargetFruit ~= "" then
            SafeCall(function()
                local fruitDealer = FindFruitDealer()
                
                if fruitDealer then
                    for _, fruit in ipairs(fruitDealer:GetDescendants()) do
                        if fruit.Name:find("Blox Fruit") then
                            local fruitName = fruit.Name:match("(.+)-") or fruit.Name
                            
                            if fruitName:find(Features.TargetFruit) then
                                print(string.format("[%s] Found target fruit: %s", CONFIG.SCRIPT_NAME, fruitName))
                                
                                SafeCall(function()
                                    local buyFruit = ReplicatedStorage:FindFirstChild("BuyFruit")
                                    if buyFruit and buyFruit:IsA("RemoteEvent") then
                                        buyFruit:FireServer(fruit)
                                    end
                                end)
                                
                                if not Features.AutoRebuy then
                                    Features.FruitSniper = false
                                    print(string.format("[%s] Fruit Sniper stopped (AutoRebuy disabled)", CONFIG.SCRIPT_NAME))
                                end
                                
                                break
                            end
                        end
                    end
                end
            end)
        end
    end
end

-- ===========================================================================
-- AUTO BUY SYSTEM
-- ===========================================================================

local function FindShopNPC()
    for _, npc in ipairs(workspace:GetDescendants()) do
        if npc.Name:find("Dealer") or npc.Name:find("Shop") then
            return npc
        end
    end
    return nil
end

local function AutoBuyLoop()
    while true do
        task.wait(1)
        
        if Features.AutoBuy then
            SafeCall(function()
                local shopNPC = FindShopNPC()
                local stats = GetPlayerStats()
                
                if shopNPC and stats then
                    -- Auto buy swords
                    if Features.AutoSwords then
                        for _, item in ipairs(shopNPC:GetDescendants()) do
                            if item.Name:find("Sword") and item:IsA("Tool") then
                                SafeCall(function()
                                    local buyItem = ReplicatedStorage:FindFirstChild("BuyItem")
                                    if buyItem and buyItem:IsA("RemoteEvent") then
                                        buyItem:FireServer(item)
                                    end
                                end)
                            end
                        end
                    end
                    
                    -- Auto buy fighting styles
                    if Features.AutoSuperhuman then
                        SafeCall(function()
                            local buyStyle = ReplicatedStorage:FindFirstChild("BuyStyle")
                            if buyStyle and buyStyle:IsA("RemoteEvent") then
                                buyStyle:FireServer("Superhuman")
                            end
                        end)
                    end
                    
                    if Features.AutoDeathStep then
                        SafeCall(function()
                            local buyStyle = ReplicatedStorage:FindFirstChild("BuyStyle")
                            if buyStyle and buyStyle:IsA("RemoteEvent") then
                                buyStyle:FireServer("DeathStep")
                            end
                        end)
                    end
                    
                    if Features.AutoWaterKungFu then
                        SafeCall(function()
                            local buyStyle = ReplicatedStorage:FindFirstChild("BuyStyle")
                            if buyStyle and buyStyle:IsA("RemoteEvent") then
                                buyStyle:FireServer("WaterKungFu")
                            end
                        end)
                    end
                end
            end)
        end
    end
end

-- ===========================================================================
-- WEB GUI BRIDGE (FOR DELTA EXECUTOR)
-- ===========================================================================

local function LoadWebView()
    -- This function would be used if Delta Executor supports WebView
    -- For now, the web GUI is loaded separately and communicates via clipboard/events
    
    print(string.format("[%s] WebView loading not implemented for this executor", CONFIG.SCRIPT_NAME))
    print(string.format("[%s] Open the web GUI separately and use the bridge commands", CONFIG.SCRIPT_NAME))
end

-- Command handler for web GUI communication
local function HandleWebCommand(commandStr)
    local success, command = SafeCall(function()
        return loadstring("return " .. commandStr)()
    end)
    
    if success and command then
        if command.type == "TOGGLE_FEATURE" then
            if Features[command.payload.feature] ~= nil then
                Features[command.payload.feature] = command.payload.enabled
                print(string.format("[%s] Feature toggled: %s = %s", CONFIG.SCRIPT_NAME, command.payload.feature, tostring(command.payload.enabled)))
            end
        elseif command.type == "TELEPORT" then
            TeleportTo(command.payload.sea, command.payload.island)
        elseif command.type == "START_SNIPER" then
            Features.FruitSniper = true
            Features.TargetFruit = command.payload.targetFruit
            Features.AutoRebuy = command.payload.autoRebuy
            print(string.format("[%s] Fruit sniper started for: %s", CONFIG.SCRIPT_NAME, command.payload.fruitName))
        elseif command.type == "SELECT_SEA" then
            Features.CurrentSea = command.payload.sea
        elseif command.type == "SELECT_MASTERY" then
            Features.MasteryType = command.payload.type
        end
    end
end

-- ===========================================================================
-- CLEANUP FUNCTION
-- ===========================================================================

local function Cleanup()
    print(string.format("[%s] Cleaning up...", CONFIG.SCRIPT_NAME))
    
    -- Destroy ESP GUI
    if ESPGui and ESPGui.Parent then
        ESPGui:Destroy()
    end
    
    -- Clear ESP labels
    for _, label in pairs(ESPLabels) do
        if label and label.Parent then
            label:Destroy()
        end
    end
    
    -- Clear tracer lines
    for _, tracer in pairs(TracerLines) do
        if tracer and tracer.Parent then
            tracer:Destroy()
        end
    end
    
    print(string.format("[%s] Cleanup complete", CONFIG.SCRIPT_NAME))
end

-- ===========================================================================
-- INITIALIZATION
-- ===========================================================================

-- Create ESP GUI
CreateESPGui()

-- Start all loops
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
    ESPRenderLoop()
end)()

coroutine.wrap(function()
    FruitSniperLoop()
end)()

coroutine.wrap(function()
    AutoBuyLoop()
end)()

-- Print startup message
print("")
print("╔════════════════════════════════════════════╗")
print("║    BLOX FRUITS PREMIUM HUB                 ║")
print("║    Delta Executor v" .. CONFIG.VERSION .. "                           ║")
print("╠════════════════════════════════════════════╣")
print("║  Features Loaded:                          ║")
print("║    ✓ Auto Farm Level                       ║")
print("║    ✓ Auto Mastery (Fruit/Sword/Gun)        ║")
print("║    ✓ Auto Stats Allocation                 ║")
print("║    ✓ Teleport System (Sea 1/2/3)           ║")
print("║    ✓ Player ESP (Names, Health, Distance)  ║")
print("║    ✓ Legendary Sword Dealer ESP            ║")
print("║    ✓ Devil Fruit ESP (Box, Name, Icon)     ║")
print("║    ✓ Haki Material ESP (Berries, Chests)   ║")
print("║    ✓ Auto Buy (Swords, Styles)             ║")
print("║    ✓ Fruit Sniper (Instant Buy)            ║")
print("╠════════════════════════════════════════════╣")
print("║  Web GUI Bridge Ready!                     ║")
print("║  Open the web interface to control features║")
print("╚════════════════════════════════════════════╝")
print("")
