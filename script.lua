-- ====================================================================
-- ШАБЛОН СКРИПТА С МЕНЮ ДЛЯ DELTA EXECUTOR (Blox Fruits)
-- ====================================================================

-- 1. СОЗДАЕМ ГЛАВНОЕ ОКНО (ИНТЕРФЕЙС)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local FarmButton = Instance.new("TextButton")

-- Настраиваем привязку к экрану игрока
ScreenGui.Parent = game:GetService("CoreGui") -- Специальная папка для чит-меню
ScreenGui.ResetOnSpawn = false

-- Внешний вид главного окошка (Темная стильная тема)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35) -- Темно-серый
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0) -- По центру экрана
MainFrame.Size = UDim2.new(0, 250, 0, 180) -- Размер окошка
MainFrame.Active = true
MainFrame.Draggable = true -- Меню можно перетаскивать пальцем по экрану!

-- Заголовок менюшки
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "MY FIRST HUB v1.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

-- Кнопка включения / выключения Авто-Фарма
FarmButton.Name = "FarmButton"
FarmButton.Parent = MainFrame
FarmButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Изначально красная (выключено)
FarmButton.Position = UDim2.new(0.1, 0, 0.4, 0)
FarmButton.Size = UDim2.new(0.8, 0, 0, 50)
FarmButton.Font = Enum.Font.SourceSansBold
FarmButton.Text = "АВТО-ФАРМ: ВЫКЛ"
FarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmButton.TextSize = 16

-- 2. ЛОГИКА РАБОТЫ КНОПКИ
_G.FarmActive = false -- Статус фарма по умолчанию

FarmButton.MouseButton1Click:Connect(function()
    _G.FarmActive = not _G.FarmActive -- Меняем статус (вкл/выкл)
    
    if _G.FarmActive then
        -- Если включили
        FarmButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50) -- Зеленый цвет
        FarmButton.Text = "АВТО-ФАРМ: РАБОТАЕТ"
        
        -- Здесь запускается цикл самого фарма (наша логика с Z-координатами)
        task.spawn(function()
            while _G.FarmActive do
                print("Скрипт ищет мобов на карте...")
                task.wait(1) -- Проверка раз в секунду
            end
        end)
        
    else
        -- Если выключили
        FarmButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Красный цвет
        FarmButton.Text = "АВТО-ФАРМ: ВЫКЛ"
    end
end)
