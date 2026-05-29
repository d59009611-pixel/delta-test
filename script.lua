-- ====================================================================
-- ХАБ С НАСТРОЕННОЙ БЕЗОПАСНОЙ СКОРОСТЬЮ
-- ====================================================================

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local SpeedButton = Instance.new("TextButton")

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 250, 0, 180)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "MY FIRST HUB v1.2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

SpeedButton.Name = "SpeedButton"
SpeedButton.Parent = MainFrame
SpeedButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
SpeedButton.Position = UDim2.new(0.1, 0, 0.4, 0)
SpeedButton.Size = UDim2.new(0.8, 0, 0, 50)
SpeedButton.Font = Enum.Font.SourceSansBold
SpeedButton.Text = "БЕГ (45): ВЫКЛ"
SpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedButton.TextSize = 16

_G.SpeedActive = false

SpeedButton.MouseButton1Click:Connect(function()
    _G.SpeedActive = not _G.SpeedActive
    
    local player = game.Players.LocalPlayer
    
    if _G.SpeedActive then
        SpeedButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
        SpeedButton.Text = "БЕГ (45): ВКЛ"
        
        task.spawn(function()
            while _G.SpeedActive do
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    -- МЫ ПОМЕНЯЛИ СКОРОСТЬ С 100 НА 45 ДЛЯ СТАБИЛЬНОСТИ
                    player.Character.Humanoid.WalkSpeed = 45 
                end
                task.wait(0.1)
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
