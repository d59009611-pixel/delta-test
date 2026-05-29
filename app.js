/**
 * ============================================
 * BLOX FRUITS PREMIUM HUB - APP.JS
 * JavaScript Logic for Delta Executor Bridge
 * ============================================
 */

// ============================================
// CONFIGURATION & STATE MANAGEMENT
// ============================================

const CONFIG = {
    SCRIPT_NAME: 'BloxFruitsHub',
    VERSION: '3.2.1',
    EXECUTOR: 'Delta',
    LOADING_DURATION: 2000,
    NOTIFICATION_DURATION: 3000,
    COMMAND_QUEUE: 'bloxfruits_commands',
    POLL_INTERVAL: 50
};

// Global state for all features
const STATE = {
    // Main Farm
    autoFarm: false,
    smoothTeleport: true,
    autoClicker: true,
    autoQuest: true,
    autoMastery: false,
    masteryType: 'fruit',
    
    // Stats
    autoMelee: false,
    autoDefense: false,
    autoSword: false,
    autoGun: false,
    autoDF: false,
    
    // Teleports
    currentSea: 1,
    currentIsland: null,
    
    // ESP
    playerEsp: false,
    nameTags: true,
    distanceEsp: true,
    healthBar: true,
    avatarThumb: false,
    fruitEsp: false,
    swordDealerEsp: false,
    dealerAlert: true,
    dealerTracer: true,
    fruitEspToggle: false,
    fruitBox: true,
    fruitName: true,
    fruitIcon: false,
    hakiEsp: false,
    berryEsp: true,
    chestEsp: true,
    
    // Shop
    autoBuy: false,
    autoSwords: false,
    autoSuperhuman: false,
    autoDeathStep: false,
    autoWaterKungFu: false,
    fruitSniper: false,
    autoRebuy: true,
    targetFruit: ''
};

// Command queue for Lua communication
let commandQueue = [];

// ============================================
// DOM ELEMENTS
// ============================================

const DOM = {
    loadingScreen: null,
    appContainer: null,
    mainFrame: null,
    toggleButton: null,
    closeButton: null,
    sidebarTabs: null,
    tabContents: null,
    notification: null,
    islandSelect: null,
    targetFruit: null,
    seaBtns: null,
    masteryBtns: null
};

// ============================================
// INITIALIZATION
// ============================================

document.addEventListener('DOMContentLoaded', () => {
    initDOM();
    initLoadingScreen();
    initEventListeners();
    initCommandProcessor();
    log('Application initialized successfully');
});

function initDOM() {
    DOM.loadingScreen = document.getElementById('loadingScreen');
    DOM.appContainer = document.getElementById('appContainer');
    DOM.mainFrame = document.getElementById('mainFrame');
    DOM.toggleButton = document.getElementById('toggleButton');
    DOM.closeButton = document.getElementById('closeButton');
    DOM.sidebarTabs = document.querySelectorAll('.sidebar-tab');
    DOM.tabContents = document.querySelectorAll('.tab-content');
    DOM.notification = document.getElementById('notification');
    DOM.islandSelect = document.getElementById('islandSelect');
    DOM.targetFruit = document.getElementById('targetFruit');
    DOM.seaBtns = document.querySelectorAll('.sea-btn');
    DOM.masteryBtns = document.querySelectorAll('.mastery-btn');
}

function initLoadingScreen() {
    setTimeout(() => {
        DOM.loadingScreen.classList.add('hidden');
        DOM.appContainer.classList.remove('hidden');
        showNotification('Welcome to Blox Fruits Premium Hub!', 'success');
    }, CONFIG.LOADING_DURATION);
}

function initEventListeners() {
    // Close button
    DOM.closeButton.addEventListener('click', minimizeMenu);
    
    // Toggle button
    DOM.toggleButton.addEventListener('click', restoreMenu);
    
    // Sidebar tabs
    DOM.sidebarTabs.forEach(tab => {
        tab.addEventListener('click', () => switchTab(tab.dataset.tab));
    });
    
    // Toggle switches
    document.querySelectorAll('.toggle-switch input').forEach(toggle => {
        toggle.addEventListener('change', handleToggleChange);
    });
    
    // Sea buttons
    DOM.seaBtns.forEach(btn => {
        btn.addEventListener('click', () => selectSea(btn.dataset.sea));
    });
    
    // Mastery buttons
    DOM.masteryBtns.forEach(btn => {
        btn.addEventListener('click', () => selectMastery(btn.dataset.type));
    });
    
    // Teleport button
    document.getElementById('teleportBtn').addEventListener('click', handleTeleport);
    
    // Sniper button
    document.getElementById('startSniperBtn').addEventListener('click', handleStartSniper);
    
    // Copy script button
    document.getElementById('copyScriptBtn').addEventListener('click', copyLuaScript);
    
    // Island select change
    DOM.islandSelect.addEventListener('change', (e) => {
        STATE.currentIsland = e.target.value;
        log(`Island selected: ${e.target.options[e.target.selectedIndex].text}`);
    });
    
    // Target fruit change
    DOM.targetFruit.addEventListener('change', (e) => {
        STATE.targetFruit = e.target.value;
        if (e.target.value) {
            showNotification(`Target fruit set: ${e.target.options[e.target.selectedIndex].text}`, 'info');
        }
    });
    
    // Make toggle button draggable
    makeDraggable(DOM.toggleButton);
}

// ============================================
// MENU CONTROL
// ============================================

function minimizeMenu() {
    DOM.mainFrame.style.opacity = '0';
    DOM.mainFrame.style.pointerEvents = 'none';
    
    setTimeout(() => {
        DOM.mainFrame.classList.add('hidden');
        DOM.toggleButton.classList.remove('hidden');
        sendCommand('MINIMIZE_MENU', {});
    }, 250);
    
    log('Menu minimized');
}

function restoreMenu() {
    DOM.toggleButton.classList.add('hidden');
    DOM.mainFrame.classList.remove('hidden');
    
    setTimeout(() => {
        DOM.mainFrame.style.opacity = '1';
        DOM.mainFrame.style.pointerEvents = 'auto';
        sendCommand('RESTORE_MENU', {});
    }, 50);
    
    log('Menu restored');
}

// ============================================
// TAB SYSTEM
// ============================================

function switchTab(tabName) {
    // Update sidebar tabs
    DOM.sidebarTabs.forEach(tab => {
        tab.classList.remove('active');
        if (tab.dataset.tab === tabName) {
            tab.classList.add('active');
        }
    });
    
    // Update tab contents
    DOM.tabContents.forEach(content => {
        content.classList.remove('active');
        if (content.dataset.tab === tabName) {
            content.classList.add('active');
        }
    });
    
    log(`Switched to tab: ${tabName}`);
}

// ============================================
// TOGGLE HANDLING
// ============================================

function handleToggleChange(e) {
    const feature = e.target.dataset.feature;
    const newState = e.target.checked;
    
    if (feature) {
        STATE[feature] = newState;
        sendCommand('TOGGLE_FEATURE', { feature, enabled: newState });
        
        const status = newState ? 'enabled' : 'disabled';
        showNotification(`${feature} ${status}`, newState ? 'success' : 'info');
        
        log(`Feature ${feature} ${status}`);
    }
}

// ============================================
// SELECTION HANDLERS
// ============================================

function selectSea(seaNumber) {
    DOM.seaBtns.forEach(btn => {
        btn.classList.remove('active');
        if (btn.dataset.sea === seaNumber) {
            btn.classList.add('active');
        }
    });
    
    STATE.currentSea = parseInt(seaNumber);
    sendCommand('SELECT_SEA', { sea: STATE.currentSea });
    showNotification(`Selected Sea ${seaNumber}`, 'info');
    log(`Sea ${seaNumber} selected`);
}

function selectMastery(type) {
    DOM.masteryBtns.forEach(btn => {
        btn.classList.remove('active');
        if (btn.dataset.type === type) {
            btn.classList.add('active');
        }
    });
    
    STATE.masteryType = type;
    sendCommand('SELECT_MASTERY', { type });
    showNotification(`Mastery type: ${type.toUpperCase()}`, 'info');
    log(`Mastery type set to ${type}`);
}

// ============================================
// ACTION HANDLERS
// ============================================

function handleTeleport() {
    const island = STATE.currentIsland;
    const sea = STATE.currentSea;
    
    if (!island) {
        showNotification('Please select an island first!', 'error');
        return;
    }
    
    const islandName = DOM.islandSelect.options[DOM.islandSelect.selectedIndex].text;
    sendCommand('TELEPORT', { sea, island, islandName });
    showNotification(`Teleporting to ${islandName}...`, 'success');
    log(`Teleporting to ${islandName} (Sea ${sea})`);
}

function handleStartSniper() {
    const targetFruit = STATE.targetFruit;
    
    if (!targetFruit) {
        showNotification('Please select a target fruit first!', 'error');
        return;
    }
    
    const fruitName = DOM.targetFruit.options[DOM.targetFruit.selectedIndex].text;
    STATE.fruitSniper = true;
    document.getElementById('fruitSniper').checked = true;
    
    sendCommand('START_SNIPER', { targetFruit, fruitName, autoRebuy: STATE.autoRebuy });
    showNotification(`Fruit Sniper started for ${fruitName}!`, 'success');
    log(`Fruit sniper started for ${fruitName}`);
}

// ============================================
// COMMAND SYSTEM
// ============================================

function sendCommand(type, payload) {
    const command = {
        type,
        payload,
        timestamp: Date.now(),
        id: generateCommandId()
    };
    
    commandQueue.push(command);
    processCommandQueue();
    log(`Command sent: ${type}`);
}

function generateCommandId() {
    return `cmd_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
}

function processCommandQueue() {
    if (commandQueue.length === 0) return;
    
    const command = commandQueue[0];
    const jsonCommand = JSON.stringify(command);
    
    // Method 1: Clipboard-based communication
    writeToClipboard(jsonCommand);
    
    // Method 2: Console log for debugging
    console.log(`[BLOXFRUITS_HUB] ${jsonCommand}`);
    
    // Method 3: Custom event for WebView bridge
    window.dispatchEvent(new CustomEvent('bloxfruits_command', { detail: command }));
    
    // Remove from queue after processing
    setTimeout(() => {
        commandQueue.shift();
        if (commandQueue.length > 0) {
            processCommandQueue();
        }
    }, CONFIG.POLL_INTERVAL);
}

function writeToClipboard(text) {
    // Try modern clipboard API first
    if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(text).catch(() => {
            fallbackClipboard(text);
        });
    } else {
        fallbackClipboard(text);
    }
}

function fallbackClipboard(text) {
    const textArea = document.createElement('textarea');
    textArea.value = text;
    textArea.style.position = 'fixed';
    textArea.style.opacity = '0';
    document.body.appendChild(textArea);
    textArea.select();
    
    try {
        document.execCommand('copy');
    } catch (err) {
        log('Clipboard write failed:', err);
    }
    
    document.body.removeChild(textArea);
}

function initCommandProcessor() {
    // Listen for commands from Lua via custom events
    window.addEventListener('bloxfruits_response', (e) => {
        handleLuaResponse(e.detail);
    });
    
    // Periodically check clipboard for Lua responses
    setInterval(checkClipboard, CONFIG.POLL_INTERVAL * 10);
}

function checkClipboard() {
    // This would be implemented in the Lua script to write responses
    // For now, it's a placeholder for future implementation
}

function handleLuaResponse(response) {
    log('Lua response:', response);
    
    switch (response.type) {
        case 'STATUS_UPDATE':
            updateStatsFromLua(response.payload);
            break;
        case 'NOTIFICATION':
            showNotification(response.payload.message, response.payload.type);
            break;
        case 'ERROR':
            showNotification(response.payload.message, 'error');
            break;
    }
}

// ============================================
// STAT UPDATES
// ============================================

function updateStatsFromLua(stats) {
    const statElements = {
        melee: document.getElementById('meleeValue'),
        defense: document.getElementById('defenseValue'),
        sword: document.getElementById('swordValue'),
        gun: document.getElementById('gunValue'),
        df: document.getElementById('dfValue'),
        points: document.getElementById('pointsValue')
    };
    
    for (const [key, element] of Object.entries(statElements)) {
        if (element && stats[key] !== undefined) {
            element.textContent = stats[key];
        }
    }
}

// ============================================
// NOTIFICATION SYSTEM
// ============================================

function showNotification(message, type = 'info') {
    const notification = DOM.notification;
    const content = notification.querySelector('.notification-content');
    const icon = content.querySelector('.notification-icon');
    const text = content.querySelector('.notification-text');
    
    text.textContent = message;
    
    // Update icon based on type
    icon.style.background = getNotificationColor(type);
    
    notification.classList.remove('hidden');
    
    // Small delay to allow display:none to apply
    setTimeout(() => {
        notification.classList.add('show');
    }, 10);
    
    setTimeout(() => {
        notification.classList.remove('show');
        setTimeout(() => {
            notification.classList.add('hidden');
        }, 300);
    }, CONFIG.NOTIFICATION_DURATION);
}

function getNotificationColor(type) {
    switch (type) {
        case 'success':
            return 'linear-gradient(135deg, #10b981, #059669)';
        case 'error':
            return 'linear-gradient(135deg, #ef4444, #dc2626)';
        case 'warning':
            return 'linear-gradient(135deg, #f59e0b, #d97706)';
        default:
            return 'linear-gradient(135deg, #8b5cf6, #a855f7)';
    }
}

// ============================================
// DRAGGABLE ELEMENTS
// ============================================

function makeDraggable(element) {
    let isDragging = false;
    let startX, startY, initialLeft, initialTop;
    
    element.addEventListener('mousedown', startDrag);
    element.addEventListener('touchstart', startDrag, { passive: false });
    
    function startDrag(e) {
        isDragging = true;
        const clientX = e.clientX || e.touches[0].clientX;
        const clientY = e.clientY || e.touches[0].clientY;
        
        startX = clientX;
        startY = clientY;
        initialLeft = element.offsetLeft;
        initialTop = element.offsetTop;
        
        element.style.cursor = 'grabbing';
        
        document.addEventListener('mousemove', onDrag);
        document.addEventListener('mouseup', stopDrag);
        document.addEventListener('touchmove', onDrag, { passive: false });
        document.addEventListener('touchend', stopDrag);
    }
    
    function onDrag(e) {
        if (!isDragging) return;
        e.preventDefault();
        
        const clientX = e.clientX || e.touches[0].clientX;
        const clientY = e.clientY || e.touches[0].clientY;
        
        const deltaX = clientX - startX;
        const deltaY = clientY - startY;
        
        element.style.left = `${initialLeft + deltaX}px`;
        element.style.top = `${initialTop + deltaY}px`;
        element.style.right = 'auto';
    }
    
    function stopDrag() {
        isDragging = false;
        element.style.cursor = 'pointer';
        
        document.removeEventListener('mousemove', onDrag);
        document.removeEventListener('mouseup', stopDrag);
        document.removeEventListener('touchmove', onDrag);
        document.removeEventListener('touchend', stopDrag);
    }
}

// ============================================
// LUA SCRIPT GENERATION
// ============================================

function copyLuaScript() {
    const luaScript = generateLuaScript();
    writeToClipboard(luaScript);
    showNotification('Lua script copied to clipboard!', 'success');
    log('Lua script copied');
}

function generateLuaScript() {
    return `--[[
    ============================================
    BLOX FRUITS PREMIUM HUB - LUA BRIDGE SCRIPT
    Delta Executor v${CONFIG.VERSION}
    ============================================
    
    This script loads the web GUI and handles
    all in-game functionality.
    
    ============================================
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera

-- Feature State
local Features = {
    AutoFarm = false,
    SmoothTeleport = true,
    AutoClicker = true,
    AutoQuest = true,
    AutoMastery = false,
    MasteryType = "Fruit",
    AutoMelee = false,
    AutoDefense = false,
    AutoSword = false,
    AutoGun = false,
    AutoDF = false,
    PlayerESP = false,
    NameTags = true,
    DistanceESP = true,
    HealthBar = true,
    AvatarThumb = false,
    FruitESP = false,
    SwordDealerESP = false,
    DealerAlert = true,
    DealerTracer = true,
    FruitESP_Toggle = false,
    FruitBox = true,
    FruitName = true,
    FruitIcon = false,
    HakiESP = false,
    BerryESP = true,
    ChestESP = true,
    AutoBuy = false,
    AutoSwords = false,
    AutoSuperhuman = false,
    AutoDeathStep = false,
    AutoWaterKungFu = false,
    FruitSniper = false,
    AutoRebuy = true,
    TargetFruit = ""
}

-- Teleport Locations
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
        haka = Vector3.new(3500, 100, 3000)
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
        corrupted = Vector3.new(8500, 100, 8000)
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
        flaming = Vector3.new(14000, 100, 13500)
    }
}

-- Safe Call Wrapper
local function SafeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        warn("[BloxFruitsHub] Error:", tostring(result))
        return false
    end
    return result
end

-- Get Distance
local function GetDistance(part1, part2)
    if part1 and part2 then
        return (part1.Position - part2.Position).Magnitude
    end
    return math.huge
end

-- Smooth Teleport
local function SmoothTeleport(targetPosition)
    if not Features.SmoothTeleport then
        HumanoidRootPart.CFrame = CFrame.new(targetPosition)
        return
    end
    
    local targetCFrame = CFrame.new(targetPosition.X, targetPosition.Y + 5, targetPosition.Z)
    local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(HumanoidRootPart, tweenInfo, {CFrame = targetCFrame})
    
    SafeCall(function()
        tween:Play()
        tween.Completed:Wait()
    end)
end

-- Teleport Handler
local function HandleTeleport(sea, island)
    local seaKey = "Sea" .. sea
    if Teleports[seaKey] and Teleports[seaKey][island] then
        SmoothTeleport(Teleports[seaKey][island])
        print("[BloxFruitsHub] Teleported to:", island)
    end
end

-- Auto Farm System
local function AutoFarmLoop()
    while true do
        task.wait(0.5)
        
        if Features.AutoFarm then
            SafeCall(function()
                -- Find quest NPC
                local questNPC = nil
                for _, npc in ipairs(workspace:GetDescendants()) do
                    if (npc.Name:find("Quest") or npc.Name:find("Npc")) and npc:IsA("Model") then
                        if npc:FindFirstChild("Humanoid") then
                            questNPC = npc
                            break
                        end
                    end
                end
                
                if questNPC then
                    local questPart = questNPC:FindFirstChild("HumanoidRootPart") or questNPC.PrimaryPart
                    
                    if questPart and Features.AutoQuest then
                        local dist = GetDistance(HumanoidRootPart, questPart)
                        
                        if dist > 50 then
                            SmoothTeleport(questPart.Position)
                        else
                            SafeCall(function()
                                ReplicatedStorage:FindFirstChild("AcceptQuest"):FireServer()
                            end)
                        end
                    end
                    
                    -- Auto clicker
                    if Features.AutoClicker then
                        for _, mob in ipairs(workspace:GetDescendants()) do
                            if mob:IsA("Model") and mob.Name:find("Mob") then
                                local mobPart = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChildWhichIsA("BasePart")
                                if mobPart then
                                    local dist = GetDistance(HumanoidRootPart, mobPart)
                                    if dist < 100 then
                                        Humanoid:MoveTowards(mobPart.Position)
                                        
                                        if UserInputService then
                                            SafeCall(function()
                                                UserInputService:MouseButton1Down(Vector2.new(500, 500))
                                                task.wait(0.03)
                                                UserInputService:MouseButton1Up(Vector2.new(500, 500))
                                            end)
                                        end
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end

-- Auto Stats System
local function AutoStatsLoop()
    while true do
        task.wait(1)
        
        SafeCall(function()
            local stats = LocalPlayer:FindFirstChild("leaderstats")
            if stats then
                local statPoints = stats:FindFirstChild("Stats")
                if statPoints and statPoints.Value > 0 then
                    if Features.AutoMelee then
                        SafeCall(function()
                            ReplicatedStorage:FindFirstChild("StatChoice"):FireServer("Melee")
                        end)
                    end
                    
                    if Features.AutoDefense then
                        SafeCall(function()
                            ReplicatedStorage:FindFirstChild("StatChoice"):FireServer("Defense")
                        end)
                    end
                    
                    if Features.AutoSword then
                        SafeCall(function()
                            ReplicatedStorage:FindFirstChild("StatChoice"):FireServer("Sword")
                        end)
                    end
                    
                    if Features.AutoGun then
                        SafeCall(function()
                            ReplicatedStorage:FindFirstChild("StatChoice"):FireServer("Gun")
                        end)
                    end
                    
                    if Features.AutoDF then
                        SafeCall(function()
                            ReplicatedStorage:FindFirstChild("StatChoice"):FireServer("DF")
                        end)
                    end
                end
            end
        end)
    end
end

-- ESP System
local ESPGui = nil
local ESPLabels = {}

local function CreateESPGui()
    ESPGui = Instance.new("ScreenGui")
    ESPGui.Name = "BloxFruitsHub_ESP"
    ESPGui.ResetOnSpawn = false
    ESPGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

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
                                    labelText = player.Name .. "\\n"
                                end
                                if Features.DistanceESP then
                                    labelText = labelText .. string.format("%.0f m", dist) .. "\\n"
                                end
                                if Features.HealthBar then
                                    labelText = labelText .. string.format("HP: %d/%d", math.floor(health), math.floor(maxHealth))
                                end
                                
                                -- Create or update label
                                local label = ESPLabels[player.UserId]
                                if not label then
                                    label = Instance.new("TextLabel")
                                    label.Size = UDim2.new(0, 140, 0, 35)
                                    label.BackgroundTransparency = 1
                                    label.TextColor3 = Color3.fromRGB(255, 255, 255)
                                    label.TextStrokeTransparency = 0
                                    label.Font = Enum.Font.Gotham
                                    label.TextSize = 12
                                    label.TextXAlignment = Enum.TextXAlignment.Left
                                    label.ZIndex = 10
                                    label.Parent = ESPGui
                                    ESPLabels[player.UserId] = label
                                end
                                
                                label.Position = UDim2.new(0, screenPos.X - 70, 0, screenPos.Y - 45)
                                label.Text = labelText
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
                                local labelText = "⚔️ SWORD DEALER\\n"
                                
                                if Features.DealerDistance then
                                    labelText = labelText .. string.format("%.0f m", dist)
                                end
                                
                                local label = ESPLabels["SwordDealer"]
                                if not label then
                                    label = Instance.new("TextLabel")
                                    label.Size = UDim2.new(0, 140, 0, 35)
                                    label.BackgroundTransparency = 1
                                    label.TextColor3 = Color3.fromRGB(139, 92, 246)
                                    label.TextStrokeTransparency = 0
                                    label.Font = Enum.Font.GothamBold
                                    label.TextSize = 14
                                    label.TextXAlignment = Enum.TextXAlignment.Left
                                    label.ZIndex = 10
                                    label.Parent = ESPGui
                                    ESPLabels["SwordDealer"] = label
                                end
                                
                                label.Position = UDim2.new(0, screenPos.X - 70, 0, screenPos.Y - 45)
                                label.Text = labelText
                            end
                        end
                    end
                end
            end
            
            -- Fruit ESP
            if Features.FruitESP_Toggle then
                for _, fruit in ipairs(workspace:GetDescendants()) do
                    if fruit:IsA("Model") and fruit.Name:find("Blox Fruit") then
                        local primary = fruit:FindFirstChild("PrimaryPart") or fruit:FindFirstChildWhichIsA("BasePart")
                        if primary then
                            local onScreen, screenPos = Camera:WorldToViewportPoint(primary.Position)
                            if onScreen and screenPos.Z > 0 then
                                local dist = GetDistance(HumanoidRootPart, primary)
                                local fruitName = fruit.Name:match("(.+)-") or "Unknown"
                                local labelText = ""
                                
                                if Features.FruitName then
                                    labelText = "🍎 " .. fruitName .. "\\n"
                                end
                                if Features.FruitDistance then
                                    labelText = labelText .. string.format("%.0f m", dist)
                                end
                                
                                local label = ESPLabels[primary]
                                if not label then
                                    label = Instance.new("TextLabel")
                                    label.Size = UDim2.new(0, 140, 0, 35)
                                    label.BackgroundTransparency = 1
                                    label.TextColor3 = Color3.fromRGB(255, 215, 0)
                                    label.TextStrokeTransparency = 0
                                    label.Font = Enum.Font.Gotham
                                    label.TextSize = 12
                                    label.TextXAlignment = Enum.TextXAlignment.Left
                                    label.ZIndex = 10
                                    label.Parent = ESPGui
                                    ESPLabels[primary] = label
                                end
                                
                                label.Position = UDim2.new(0, screenPos.X - 70, 0, screenPos.Y - 45)
                                label.Text = labelText
                            end
                        end
                    end
                end
            end
        end)
    end
end

-- Fruit Sniper System
local function FruitSniperLoop()
    while true do
        task.wait(0.05)
        
        if Features.FruitSniper and Features.TargetFruit ~= "" then
            SafeCall(function()
                for _, npc in ipairs(workspace:GetDescendants()) do
                    if npc.Name:find("Blox Fruit Dealer") then
                        for _, fruit in ipairs(npc:GetDescendants()) do
                            if fruit.Name:find("Blox Fruit") then
                                local fruitName = fruit.Name:match("(.+)-") or fruit.Name
                                
                                if fruitName:find(Features.TargetFruit) then
                                    print("[BloxFruitsHub] Found target fruit:", fruitName)
                                    
                                    SafeCall(function()
                                        ReplicatedStorage:FindFirstChild("BuyFruit"):FireServer(fruit)
                                    end)
                                    
                                    if not Features.AutoRebuy then
                                        Features.FruitSniper = false
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
end

-- Command Handler (for web GUI communication)
local function HandleCommand(command)
    local success, data = pcall(function()
        return loadstring("return " .. command)()
    end)
    
    if success and data then
        if data.type == "TOGGLE_FEATURE" then
            if Features[data.payload.feature] ~= nil then
                Features[data.payload.feature] = data.payload.enabled
                print("[BloxFruitsHub] Feature toggled:", data.payload.feature, data.payload.enabled)
            end
        elseif data.type == "TELEPORT" then
            HandleTeleport(data.payload.sea, data.payload.island)
        elseif data.type == "START_SNIPER" then
            Features.FruitSniper = true
            Features.TargetFruit = data.payload.targetFruit
            Features.AutoRebuy = data.payload.autoRebuy
            print("[BloxFruitsHub] Fruit sniper started for:", data.payload.fruitName)
        end
    end
end

-- Initialize Script
CreateESPGui()

coroutine.wrap(function()
    AutoFarmLoop()
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

-- Print startup message
print("========================================")
print("  BLOX FRUITS PREMIUM HUB")
print("  Delta Executor v" .. CONFIG.VERSION)
print("========================================")
print("Features Loaded:")
print("  ✓ Auto Farm Level")
print("  ✓ Auto Mastery")
print("  ✓ Auto Stats Allocation")
print("  ✓ Teleport System")
print("  ✓ Player ESP")
print("  ✓ Sword Dealer ESP")
print("  ✓ Devil Fruit ESP")
print("  ✓ Haki Material ESP")
print("  ✓ Auto Buy")
print("  ✓ Fruit Sniper")
print("========================================")
print("Web GUI Bridge Ready!")
print("========================================")
`;
}

// ============================================
// UTILITY FUNCTIONS
// ============================================

function log(..., args) {
    console.log(`[${CONFIG.SCRIPT_NAME}]`, ...args);
}

function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

function throttle(func, limit) {
    let inThrottle;
    return function(...args) {
        if (!inThrottle) {
            func.apply(this, args);
            inThrottle = true;
            setTimeout(() => inThrottle = false, limit);
        }
    };
}

// ============================================
// CLEANUP
// ============================================

window.addEventListener('beforeunload', () => {
    log('Cleaning up...');
    sendCommand('CLEANUP', {});
});

// Export for debugging
window.BloxFruitsHub = {
    CONFIG,
    STATE,
    sendCommand,
    showNotification,
    generateLuaScript
};

console.log('%c BLOX FRUITS PREMIUM HUB ', 'background: linear-gradient(135deg, #8b5cf6, #a855f7); color: white; font-size: 16px; font-weight: bold; padding: 10px; border-radius: 5px;');
console.log('%c Version: ' + CONFIG.VERSION, 'color: #a855f7; font-size: 12px;');
console.log('%c Executor: ' + CONFIG.EXECUTOR, 'color: #10b981; font-size: 12px;');
console.log('%c Use window.BloxFruitsHub for debugging ', 'color: #f59e0b; font-size: 12px;');
