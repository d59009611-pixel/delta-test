--// Delta Executor | Blox Fruits WalkSpeed Bypass
--// Метод: __newindex хук + RunService.Stepped

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// Настройки
local Settings = {
    WalkSpeed = 45,
    DefaultSpeed = 16,
    Enabled = false,
    Connection = nil,
    HookActive = false
}

--// Создание GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpeedHub_" .. math.random(1000, 9999)
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

--// Основной Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 220, 0, 120)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -60)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

--// Закругление и тень
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0.5, 0, 0.5, 4)
Shadow.Size = UDim2.new(1, 24, 1, 24)
Shadow.ZIndex = -1
Shadow.Image = "rbxassetid://6015897843"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.3
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
Shadow.Parent = MainFrame

--// Градиент заголовка
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 65)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 50))
})
TitleGradient.Rotation = 90
TitleGradient.Parent = TitleBar

--// Заголовок
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ Speed Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

--// Кнопка закрытия (X)
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.Position = UDim2.new(1, -30, 0, 2)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseButton.TextSize = 20
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

--// Кнопка переключения скорости
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0.8, 0, 0, 40)
ToggleButton.Position = UDim2.new(0.1, 0, 0.5, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "OFF | Speed: 45"
ToggleButton.TextColor3 = Color3.fromRGB(200, 200, 200)
ToggleButton.TextSize = 14
ToggleButton.Font = Enum.Font.GothamSemibold
ToggleButton.Parent = MainFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(80, 80, 100)
ToggleStroke.Thickness = 1
ToggleStroke.Parent = ToggleButton

--// Drag функционал
local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
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
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

--// Анимации
local function AnimateButton(button, isActive)
    local targetColor = isActive and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(60, 60, 80)
    local targetStroke = isActive and Color3.fromRGB(0, 200, 120) or Color3.fromRGB(80, 80, 100)
    
    TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
    TweenService:Create(ToggleStroke, TweenInfo.new(0.2), {Color = targetStroke}):Play()
end

--// МЕТОД ОБХОДА: Хукинг метатаблицы Humanoid
local mt = getrawmetatable(game)
local oldIndex = mt.__index
local oldNewIndex = mt.__newindex
setreadonly(mt, false)

--// Хранилище для Humanoid'ов
local Humanoids = {}
local OriginalSpeeds = {}

--// Функция получения Humanoid
local function GetHumanoid()
    local character = LocalPlayer.Character
    if character then
        return character:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

--// __newindex хук - блокирует сброс скорости игрой
mt.__newindex = newcclosure(function(self, key, value)
    if key == "WalkSpeed" and Humanoids[self] and Settings.Enabled then
        -- Если игра пытается сбросить на дефолт, блокируем и ставим наше значение
        if value == Settings.DefaultSpeed or value < Settings.WalkSpeed then
            value = Settings.WalkSpeed
        end
    end
    return oldNewIndex(self, key, value)
end)

--// __index хук - возвращает наше значение при проверке
mt.__index = newcclosure(function(self, key)
    if key == "WalkSpeed" and Humanoids[self] and Settings.Enabled then
        return Settings.WalkSpeed
    end
    return oldIndex(self, key)
end)

setreadonly(mt, true)

--// Stepped соединение - постоянное принудительное применение
local function StartBypass()
    if Settings.Connection then return end
    
    Settings.Connection = RunService.Stepped:Connect(function()
        if not Settings.Enabled then return end
        
        local humanoid = GetHumanoid()
        if humanoid then
            -- Регистрируем humanoid в таблице
            if not Humanoids[humanoid] then
                Humanoids[humanoid] = true
                OriginalSpeeds[humanoid] = humanoid.WalkSpeed
            end
            
            -- Принудительная установка через rawset (обходя __newindex)
            rawset(humanoid, "WalkSpeed", Settings.WalkSpeed)
            
            -- Дополнительная защита: если античит использует свойства
            pcall(function()
                humanoid:SetAttribute("RealWalkSpeed", Settings.WalkSpeed)
            end)
        end
    end)
end

local function StopBypass()
    if Settings.Connection then
        Settings.Connection:Disconnect()
        Settings.Connection = nil
    end
    
    -- Восстановление оригинальных скоростей
    for humanoid, _ in pairs(Humanoids) do
        if humanoid and humanoid.Parent then
            humanoid.WalkSpeed = OriginalSpeeds[humanoid] or 16
        end
    end
    Humanoids = {}
end

--// Обработчик кнопки
ToggleButton.MouseButton1Click:Connect(function()
    Settings.Enabled = not Settings.Enabled
    
    if Settings.Enabled then
        ToggleButton.Text = "ON | Speed: " .. Settings.WalkSpeed
        ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        AnimateButton(ToggleButton, true)
        StartBypass()
        
        -- Мгновенное применение
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.WalkSpeed = Settings.WalkSpeed
        end
    else
        ToggleButton.Text = "OFF | Speed: " .. Settings.WalkSpeed
        ToggleButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        AnimateButton(ToggleButton, false)
        StopBypass()
        
        -- Возврат к нормальной скорости
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.WalkSpeed = Settings.DefaultSpeed
        end
    end
end)

--// Закрытие меню
CloseButton.MouseButton1Click:Connect(function()
    Settings.Enabled = false
    StopBypass()
    
    -- Анимация закрытия
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(0.3)
    ScreenGui:Destroy()
end)

--// Эффекты при наведении
CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 50, 50)}):Play()
end)

CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 100, 100)}):Play()
end)

ToggleButton.MouseEnter:Connect(function()
    if not Settings.Enabled then
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 90)}):Play()
    end
end)

ToggleButton.MouseLeave:Connect(function()
    if not Settings.Enabled then
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}):Play()
    end
end)

--// Авто-обновление при респавне
LocalPlayer.CharacterAdded:Connect(function(char)
    if Settings.Enabled then
        task.wait(0.5) -- Ждем загрузки Humanoid
        local humanoid = char:WaitForChild("Humanoid")
        humanoid.WalkSpeed = Settings.WalkSpeed
    end
end)

--// Анимация появления
MainFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.new(0, 220, 0, 120)}):Play()

print("⚡ Speed Hub загружен! GUI создано в CoreGui.")
