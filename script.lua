-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpeedHub"
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(60, 60, 60)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.BorderSizePixel = 0
Title.Text = "SPEED HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Speed Buttons Container
local ButtonContainer = Instance.new("Frame")
ButtonContainer.Name = "ButtonContainer"
ButtonContainer.Size = UDim2.new(1, -20, 1, -60)
ButtonContainer.Position = UDim2.new(0, 10, 0, 50)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = ButtonContainer

-- Speed Configuration
local speeds = {
    {name = "LOW", value = 45},
    {name = "MEDIUM", value = 80},
    {name = "MAX", value = 150}
}

local currentSpeed = 16
local activeButton = nil
local speedButtons = {}

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

-- Function to update button colors
local function updateButtonColors(activeBtn)
    for _, btn in ipairs(speedButtons) do
        if btn == activeBtn then
            btn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end
end

-- Create Speed Buttons
for i, speedData in ipairs(speeds) do
    local button = Instance.new("TextButton")
    button.Name = speedData.name .. "Button"
    button.Size = UDim2.new(1, 0, 0, 40)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.BorderSizePixel = 0
    button.Text = speedData.name .. " SPEED (" .. speedData.value .. ")"
    button.TextColor3 = Color3.fromRGB(200, 200, 200)
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.LayoutOrder = i
    button.Parent = ButtonContainer
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    table.insert(speedButtons, button)
    
    button.MouseButton1Click:Connect(function()
        currentSpeed = speedData.value
        activeButton = button
        updateButtonColors(button)
        
        -- Apply speed immediately
        if humanoid then
            oldNewIndex(humanoid, "WalkSpeed", currentSpeed)
        end
    end)
end

-- RunService Stepped Loop for persistent speed
RunService.Stepped:Connect(function()
    if player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.WalkSpeed ~= currentSpeed then
            oldNewIndex(hum, "WalkSpeed", currentSpeed)
        end
    end
end)

-- Character Added Handler
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    
    -- Reapply speed after respawn
    task.wait(0.1)
    if activeButton then
        oldNewIndex(humanoid, "WalkSpeed", currentSpeed)
    end
end)

-- Close Button Handler
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Dragging functionality
local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

Title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
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

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Initialize default state
updateButtonColors(nil)
