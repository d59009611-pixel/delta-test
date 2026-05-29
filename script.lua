-- ====================================================================
-- ИСПРАВЛЕННЫЙ ХАБ С РАБОЧЕЙ СКОРОСТЬЮ И КНОПКОЙ ЗАКРЫТИЯ (Х)
-- ====================================================================

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local SpeedButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton") -- Кнопка закрытия

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- Главное окно
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 250, 0, 180)
MainFrame.Active = true
MainFrame.Draggable = true

-- Заголовок
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "MY FIRST HUB v1.3"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

-- КНОПКА ЗАКРЫТИЯ (Х) в углу менюшки
CloseButton.Name = "CloseButton"
CloseButton.Parent = MainFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Красная
CloseButton.Position = UDim2.new(0.85, 0, 0, 0) -- В правом верхнем углу
CloseButton.Size = UDim2.new(0, 37, 0, 40)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18

-- Кнопка скорости
SpeedButton.Name = "SpeedButton"
SpeedButton.Parent = MainFrame
SpeedButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
SpeedButton.Position = UDim2.new(0.1, 0, 0.45, 0)
SpeedButton.Size = UDim2.new(0.8, 0, 0, 50)
SpeedButton.Font = Enum.Font.SourceSansBold
SpeedButton.Text = "БЕГ (45): ВЫКЛ"
SpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedButton.TextSize = 16

_G.SpeedActive = false

-- Логика кнопки скорости (Усиленный обход защиты)
SpeedButton.MouseButton1Click:Connect(function()
    _G.SpeedActive = not _G.SpeedActive
    
    local player = game.Players.LocalPlayer
    
    if _G.SpeedActive then
        SpeedButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
        SpeedButton.Text = "БЕГ (45): ВКЛ"
        
        -- Сверхбыстрый поток для обхода систем возврата скорости игры
        task.spawn(function()
            while _G.SpeedActive do
                task.wait() -- Работает на каждом кадре игры (максимальная агрессивность)
                pcall(function()
                    if player.Character and player.Character:FindFirstChild("Humanoid") then
                        player.Character.Humanoid.WalkSpeed = 45
                    end
                end)
            end
        end)
    else
        SpeedButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        SpeedButton.Text = "БЕГ (45): ВЫКЛ"
        
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

-- ЛОГИКА ДЛЯ КНОПКИ ЗАКРЫТИЯ (Х)
CloseButton.MouseButton1Click:Connect(function()
    _G.SpeedActive = false -- Отключаем скорость перед закрытием
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 16 -- Возвращаем стандартную скорость
    end
    ScreenGui:Destroy() -- Полностью удаляем менюшку с экрана
end)
