--// Ensure Rayfield Library is Loaded
local Rayfield
local success, err = pcall(function()
    Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success then
    warn("Failed to load Rayfield library: " .. err)
    return -- Exit if Rayfield failed to load
end

--// Create Window and UI Elements
local Window = Rayfield:CreateWindow({
    Name = "jugg | Premium v1.2",
    LoadingTitle = "jugg | Loading...",
    LoadingSubtitle = "by jugg dev",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "JuggPremium",
        FileName = "Settings"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = true,
    KeySettings = {
        Title = "jugg | Key System",
        Subtitle = "Key = juggsarecool",
        Note = "Join Discord for key.",
        FileName = "juggKeySave",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"juggsarecool"}
    }
})

--// Services and Variables
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local ForcehitEnabled = false
local SpinbotEnabled = false
local SpinbotSpeed = 50
local SpinbotKey = Enum.KeyCode.Q
local SilentAimEnabled = false
local ESPEnabled = false
local FOVSize = 100
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Transparency = 0.5
FOVCircle.Visible = false

--// Combat and Miscs Tabs
local CombatTab = Window:CreateTab("Combat", 4483362458)
local MiscsTab = Window:CreateTab("Miscs", 4483362458)

local CombatSection = CombatTab:CreateSection("Main Combat Features")
local MiscsSection = MiscsTab:CreateSection("Visuals and Aim Assists")

-- Combat Tab Toggles
CombatTab:CreateToggle({
    Name = "Enable Silent Aim",
    CurrentValue = false,
    Callback = function(Value)
        SilentAimEnabled = Value
    end,
})

CombatTab:CreateToggle({
    Name = "Enable Spinbot",
    CurrentValue = false,
    Callback = function(Value)
        SpinbotEnabled = Value
    end,
})

CombatTab:CreateSlider({
    Name = "Spinbot Speed",
    Range = {0, 200},
    Increment = 5,
    Suffix = "°/s",
    CurrentValue = SpinbotSpeed,
    Callback = function(Value)
        SpinbotSpeed = Value
    end,
})

-- Miscs Tab Toggles and Sliders
MiscsTab:CreateToggle({
    Name = "Show FOV Circle",
    CurrentValue = false,
    Callback = function(Value)
        FOVCircle.Visible = Value
    end,
})

MiscsTab:CreateSlider({
    Name = "FOV Size",
    Range = {50, 500},
    Increment = 5,
    Suffix = "px",
    CurrentValue = FOVSize,
    Callback = function(Value)
        FOVSize = Value
    end,
})

MiscsTab:CreateToggle({
    Name = "Enable Skeleton ESP",
    CurrentValue = false,
    Callback = function(Value)
        ESPEnabled = Value
    end,
})

-- Keybind UI for Spinbot and other features
CombatTab:CreateKeybind({
    Name = "Spinbot Key",
    CurrentKey = SpinbotKey,
    Callback = function(Key)
        SpinbotKey = Key
    end,
})

--// Function to handle keypresses for toggling features
local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    -- Spinbot toggle on key press
    if input.KeyCode == SpinbotKey then
        SpinbotEnabled = not SpinbotEnabled
    end
end)

--// Render Loop
RunService.RenderStepped:Connect(function()
    if FOVCircle.Visible then
        FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
        FOVCircle.Radius = FOVSize
    end

    -- Implement Spinbot (Teleporting to and spinning around the target)
    if SpinbotEnabled then
        local character = LocalPlayer.Character
        local closest = getClosestPlayer()
        if character and closest then
            -- Teleport to closest player's position
            character.HumanoidRootPart.CFrame = closest.Character.HumanoidRootPart.CFrame
            -- Spin around the closest player
            local targetPosition = closest.Character.HumanoidRootPart.Position
            local direction = (targetPosition - character.HumanoidRootPart.Position).unit
            character.HumanoidRootPart.CFrame = CFrame.new(targetPosition) * CFrame.Angles(0, math.rad(SpinbotSpeed), 0)
        end
    end
end)

-- Function to get closest player
function getClosestPlayer()
    local closestPlayer = nil
    local closestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                if distance < closestDistance and distance <= FOVSize then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end

    return closestPlayer
end
