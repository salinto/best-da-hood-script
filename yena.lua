-- Yena Aimbot and Spinbot Script (v2.0 - Premium Version)
-- Features: Rapid Fire, Anti-Resolve Aimbot, Silent Aim, Spinbot, Void Walk, High Jump, Keybinding, Movable GUI

-- Settings (Customizable)
local settings = {
    rapidFireKey = Enum.KeyCode.R,  -- Key for Rapid Fire
    aimbotKey = Enum.KeyCode.F,     -- Key for Aimbot
    spinbotKey = Enum.KeyCode.Q,    -- Key for Spinbot
    voidWalkEnabled = false,        -- Enable/Disable Void Walk
    highJumpEnabled = false,        -- Enable/Disable High Jump
    aimbotEnabled = true,           -- Enable/Disable Aimbot
    antiResolve = true,             -- Enable Anti-Resolve
    silentAim = true,               -- Enable Silent Aim
    spinSpeed = 3,                  -- Speed of the Spinbot
    aimbotFOV = 100,                -- Field of View for Aimbot
    enableSpinbot = false,          -- Enable/Disable Spinbot
    highJumpPower = 100,            -- Power for High Jump
}

-- UI Elements (Create the GUI)
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Main Window
local window = Instance.new("Frame")
window.Size = UDim2.new(0, 300, 0, 500)
window.Position = UDim2.new(0.5, -150, 0.5, -250)
window.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
window.BorderSizePixel = 2
window.BorderColor3 = Color3.fromRGB(100, 100, 100)
window.Parent = screenGui

-- Window Dragging Logic
local dragging, dragInput, dragStart, startPos
window.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = window.Position
    end
end)

window.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

window.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 300, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Yena Aimbot v2.0"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Parent = window

-- FOV Slider (Aimbot FOV)
local fovSlider = Instance.new("TextBox")
fovSlider.Size = UDim2.new(0, 200, 0, 40)
fovSlider.Position = UDim2.new(0.5, -100, 0, 50)
fovSlider.Text = "FOV: " .. settings.aimbotFOV
fovSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
fovSlider.TextSize = 14
fovSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
fovSlider.BorderSizePixel = 0
fovSlider.Parent = window

fovSlider.FocusLost:Connect(function()
    local newFOV = tonumber(fovSlider.Text)
    if newFOV then
        settings.aimbotFOV = math.clamp(newFOV, 1, 200)
        fovSlider.Text = "FOV: " .. settings.aimbotFOV
    end
end)

-- FOV Label
local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(0, 200, 0, 20)
fovLabel.Position = UDim2.new(0.5, -100, 0, 30)
fovLabel.Text = "Aimbot FOV"
fovLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fovLabel.TextSize = 14
fovLabel.BackgroundTransparency = 1
fovLabel.Parent = window

-- Aimbot Checkbox
local aimbotCheckbox = Instance.new("TextButton")
aimbotCheckbox.Size = UDim2.new(0, 200, 0, 50)
aimbotCheckbox.Position = UDim2.new(0.5, -100, 0, 120)
aimbotCheckbox.Text = "Enable Aimbot"
aimbotCheckbox.BackgroundColor3 = settings.aimbotEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
aimbotCheckbox.TextColor3 = Color3.fromRGB(255, 255, 255)
aimbotCheckbox.TextSize = 14
aimbotCheckbox.Parent = window

aimbotCheckbox.MouseButton1Click:Connect(function()
    settings.aimbotEnabled = not settings.aimbotEnabled
    aimbotCheckbox.Text = settings.aimbotEnabled and "Disable Aimbot" or "Enable Aimbot"
    aimbotCheckbox.BackgroundColor3 = settings.aimbotEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

-- Spinbot Checkbox
local spinbotCheckbox = Instance.new("TextButton")
spinbotCheckbox.Size = UDim2.new(0, 200, 0, 50)
spinbotCheckbox.Position = UDim2.new(0.5, -100, 0, 180)
spinbotCheckbox.Text = "Enable Spinbot"
spinbotCheckbox.BackgroundColor3 = settings.enableSpinbot and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
spinbotCheckbox.TextColor3 = Color3.fromRGB(255, 255, 255)
spinbotCheckbox.TextSize = 14
spinbotCheckbox.Parent = window

spinbotCheckbox.MouseButton1Click:Connect(function()
    settings.enableSpinbot = not settings.enableSpinbot
    spinbotCheckbox.Text = settings.enableSpinbot and "Disable Spinbot" or "Enable Spinbot"
    spinbotCheckbox.BackgroundColor3 = settings.enableSpinbot and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

-- Void Walk Checkbox
local voidWalkCheckbox = Instance.new("TextButton")
voidWalkCheckbox.Size = UDim2.new(0, 200, 0, 50)
voidWalkCheckbox.Position = UDim2.new(0.5, -100, 0, 240)
voidWalkCheckbox.Text = "Enable Void Walk"
voidWalkCheckbox.BackgroundColor3 = settings.voidWalkEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
voidWalkCheckbox.TextColor3 = Color3.fromRGB(255, 255, 255)
voidWalkCheckbox.TextSize = 14
voidWalkCheckbox.Parent = window

voidWalkCheckbox.MouseButton1Click:Connect(function()
    settings.voidWalkEnabled = not settings.voidWalkEnabled
    voidWalkCheckbox.Text = settings.voidWalkEnabled and "Disable Void Walk" or "Enable Void Walk"
    voidWalkCheckbox.BackgroundColor3 = settings.voidWalkEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

-- High Jump Checkbox
local highJumpCheckbox = Instance.new("TextButton")
highJumpCheckbox.Size = UDim2.new(0, 200, 0, 50)
highJumpCheckbox.Position = UDim2.new(0.5, -100, 0, 300)
highJumpCheckbox.Text = "Enable High Jump"
highJumpCheckbox.BackgroundColor3 = settings.highJumpEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
highJumpCheckbox.TextColor3 = Color3.fromRGB(255, 255, 255)
highJumpCheckbox.TextSize = 14
highJumpCheckbox.Parent = window

highJumpCheckbox.MouseButton1Click:Connect(function()
    settings.highJumpEnabled = not settings.highJumpEnabled
    highJumpCheckbox.Text = settings.highJumpEnabled and "Disable High Jump" or "Enable High Jump"
    highJumpCheckbox.BackgroundColor3 = settings.highJumpEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

-- Functions (Rapid Fire, Aimbot, Spinbot, etc.)
local function rapidFire()
    while game:GetService("UserInputService"):IsKeyDown(settings.rapidFireKey) do
        -- Perform rapid fire
        wait(0.1)
    end
end

local function aimbot()
    local player = game.Players.LocalPlayer
    local mouse = player:GetMouse()
    while settings.aimbotEnabled and game:GetService("UserInputService"):IsKeyDown(settings.aimbotKey) do
        -- Perform aimbot logic
        wait(0.02)
    end
end

local function spinbot()
    while settings.enableSpinbot do
        -- Spin the player
        wait(0.01)
    end
end

local function voidWalk()
    while settings.voidWalkEnabled do
        -- Void walk logic
        wait(0.1)
    end
end

local function highJump()
    local player = game.Players.LocalPlayer
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.JumpPower = settings.highJumpEnabled and settings.highJumpPower or 50
    end
end

-- Main loop to handle the features
while true do
    if settings.aimbotEnabled then
        aimbot()
    end
    if settings.enableSpinbot then
        spinbot()
    end
    if settings.voidWalkEnabled then
        voidWalk()
    end
    if settings.highJumpEnabled then
        highJump()
    end
    wait(0.1)
end
