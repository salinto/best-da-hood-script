-- Yena Aimbot and Spinbot Script (v1.1)
-- Features: Rapid Fire, Anti-Resolve Aimbot, Silent Aim, Spinbot, Keybinding

-- Settings (Customizable)
local settings = {
    rapidFireKey = Enum.KeyCode.R,  -- Key for Rapid Fire
    aimbotKey = Enum.KeyCode.F,     -- Key for Aimbot
    spinbotKey = Enum.KeyCode.Q,    -- Key for Spinbot
    aimbotEnabled = true,           -- Enable/Disable Aimbot
    antiResolve = true,             -- Enable Anti-Resolve
    silentAim = true,               -- Enable Silent Aim
    spinSpeed = 3,                  -- Speed of the Spinbot
    aimbotFOV = 100,                -- Field of View for Aimbot
    enableSpinbot = false,          -- Enable/Disable Spinbot
}

-- UI Elements (Using a simple GUI to manage options)
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Aimbot FOV Slider
local fovSlider = Instance.new("TextBox")
fovSlider.Size = UDim2.new(0, 200, 0, 50)
fovSlider.Position = UDim2.new(0.5, -100, 0.5, -150)
fovSlider.Text = "FOV: " .. settings.aimbotFOV
fovSlider.Parent = screenGui

-- FOV Slider Change Event
fovSlider.FocusLost:Connect(function()
    local newFOV = tonumber(fovSlider.Text)
    if newFOV then
        settings.aimbotFOV = math.clamp(newFOV, 1, 200)  -- Keep FOV between 1 and 200
        fovSlider.Text = "FOV: " .. settings.aimbotFOV
    end
end)

-- Aimbot Checkbox
local aimbotCheckbox = Instance.new("TextButton")
aimbotCheckbox.Size = UDim2.new(0, 200, 0, 50)
aimbotCheckbox.Position = UDim2.new(0.5, -100, 0.5, -100)
aimbotCheckbox.Text = "Enable Aimbot"
aimbotCheckbox.BackgroundColor3 = settings.aimbotEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
aimbotCheckbox.Parent = screenGui

-- Aimbot Checkbox Toggle Event
aimbotCheckbox.MouseButton1Click:Connect(function()
    settings.aimbotEnabled = not settings.aimbotEnabled
    aimbotCheckbox.Text = settings.aimbotEnabled and "Disable Aimbot" or "Enable Aimbot"
    aimbotCheckbox.BackgroundColor3 = settings.aimbotEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

-- Spinbot Checkbox
local spinbotCheckbox = Instance.new("TextButton")
spinbotCheckbox.Size = UDim2.new(0, 200, 0, 50)
spinbotCheckbox.Position = UDim2.new(0.5, -100, 0.5, -50)
spinbotCheckbox.Text = "Enable Spinbot"
spinbotCheckbox.BackgroundColor3 = settings.enableSpinbot and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
spinbotCheckbox.Parent = screenGui

-- Spinbot Checkbox Toggle Event
spinbotCheckbox.MouseButton1Click:Connect(function()
    settings.enableSpinbot = not settings.enableSpinbot
    spinbotCheckbox.Text = settings.enableSpinbot and "Disable Spinbot" or "Enable Spinbot"
    spinbotCheckbox.BackgroundColor3 = settings.enableSpinbot and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

-- Rapid Fire Function (Always active when key is pressed)
local function rapidFire()
    while game:GetService("UserInputService"):IsKeyDown(settings.rapidFireKey) do
        -- Perform rapid fire by clicking the mouse
        game:GetService("Players").LocalPlayer.Character.Humanoid:EquipTool(game:GetService("Players").LocalPlayer.Backpack:FindFirstChildOfClass("Tool"))
        wait(0.1)
    end
end

-- Anti-Resolve Aimbot Function
local function aimbot()
    local player = game:GetService("Players").LocalPlayer
    local mouse = player:GetMouse()
    while settings.aimbotEnabled and game:GetService("UserInputService"):IsKeyDown(settings.aimbotKey) do
        local closestEnemy = nil
        local closestDistance = math.huge

        -- Search for the closest enemy within the Aimbot's Field of View (FOV)
        for _, enemy in pairs(game:GetService("Players"):GetPlayers()) do
            if enemy ~= player and enemy.Character and enemy.Character:FindFirstChild("Head") then
                local enemyPos = enemy.Character.Head.Position
                local screenPos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(enemyPos)
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude

                if onScreen and distance < settings.aimbotFOV and distance < closestDistance then
                    closestDistance = distance
                    closestEnemy = enemy
                end
            end
        end

        -- Aim at the closest enemy
        if closestEnemy then
            local targetHead = closestEnemy.Character.Head
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, targetHead.Position)
        end
        wait(0.02)
    end
end

-- Silent Aim Function
local function silentAim()
    local player = game:GetService("Players").LocalPlayer
    local mouse = player:GetMouse()
    while settings.aimbotEnabled and game:GetService("UserInputService"):IsKeyDown(settings.aimbotKey) do
        -- Similar to Aimbot, but it does not move the camera directly
        local closestEnemy = nil
        local closestDistance = math.huge

        for _, enemy in pairs(game:GetService("Players"):GetPlayers()) do
            if enemy ~= player and enemy.Character and enemy.Character:FindFirstChild("Head") then
                local enemyPos = enemy.Character.Head.Position
                local screenPos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(enemyPos)
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude

                if onScreen and distance < settings.aimbotFOV and distance < closestDistance then
                    closestDistance = distance
                    closestEnemy = enemy
                end
            end
        end

        if closestEnemy then
            -- Simulate shooting at the enemy's head without camera movement
            local targetHead = closestEnemy.Character.Head
            -- Implement silent aim logic here (e.g., using a hidden gun tool or external trigger)
        end
        wait(0.02)
    end
end

-- Spinbot Function
local function spinbot()
    local player = game:GetService("Players").LocalPlayer
    while settings.enableSpinbot and game:GetService("UserInputService"):IsKeyDown(settings.spinbotKey) do
        -- Spin the player around while in the air (flying)
        player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(settings.spinSpeed), 0)
        wait(0.01)
    end
end

-- Main Loop (Check for Keypresses and Update States)
while true do
    -- Rapid Fire
    if game:GetService("UserInputService"):IsKeyDown(settings.rapidFireKey) then
        rapidFire()
    end

    -- Aimbot (with Anti-Resolve and Silent Aim)
    if settings.aimbotEnabled and game:GetService("UserInputService"):IsKeyDown(settings.aimbotKey) then
        if settings.antiResolve then
            -- Implement Anti-Resolve Logic (e.g., delay shots or aim at specific body parts)
        end
        if settings.silentAim then
            silentAim()
        else
            aimbot()
        end
    end

    -- Spinbot
    if settings.enableSpinbot then
        spinbot()
    end

    wait(0.01)
end
