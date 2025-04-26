--// Load Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

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

--// Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

--// Variables for toggles and keybinds
local ForcehitEnabled = false
local SpinbotEnabled = false
local SpinbotSpeed = 50
local SpinbotKey = Enum.KeyCode.Q
local RapidFireEnabled = false
local RapidFireKey = Enum.KeyCode.Space
local SilentAimEnabled = false
local ESPEnabled = false
local FOVSize = 100
local GodModeEnabled = false
local GodFistEnabled = false
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Transparency = 0.5
FOVCircle.Visible = false

--// Key Bindings UI
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

CombatTab:CreateToggle({
    Name = "Enable God Mode",
    CurrentValue = false,
    Callback = function(Value)
        GodModeEnabled = Value
    end,
})

CombatTab:CreateToggle({
    Name = "Enable God Fist",
    CurrentValue = false,
    Callback = function(Value)
        GodFistEnabled = Value
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

--// Keybind UI for Spinbot and other features
CombatTab:CreateKeybind({
    Name = "Spinbot Key",
    CurrentKey = SpinbotKey,
    Callback = function(Key)
        SpinbotKey = Key
    end,
})

CombatTab:CreateKeybind({
    Name = "Rapid Fire Key",
    CurrentKey = RapidFireKey,
    Callback = function(Key)
        RapidFireKey = Key
    end,
})

MiscsTab:CreateKeybind({
    Name = "Silent Aim Key",
    CurrentKey = Enum.KeyCode.E,
    Callback = function(Key)
        SilentAimEnabled = not SilentAimEnabled  -- Toggle on key press
    end,
})

--// Function to handle keypresses for toggling
local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    -- Spinbot toggle on key press
    if input.KeyCode == SpinbotKey then
        SpinbotEnabled = not SpinbotEnabled
    end

    -- Rapid Fire toggle on key press
    if input.KeyCode == RapidFireKey then
        RapidFireEnabled = not RapidFireEnabled
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

    -- God Mode & God Fist Logic
    if GodModeEnabled then
        LocalPlayer.Character:FindFirstChild("Humanoid").Health = math.huge
    end
    if GodFistEnabled then
        -- Implement God Fist logic here
    end

    -- Skeleton ESP
    if ESPEnabled then
        for player, skeleton in pairs(ESP) do
            local character = player.Character
            if character then
                local rootPos, onScreen = Camera:WorldToViewportPoint(character.HumanoidRootPart.Position)
                if onScreen then
                    -- Draw skeleton lines between the parts
                    for partName, line in pairs(skeleton) do
                        local part = character:FindFirstChild(partName)
                        if part then
                            local partPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                            if onScreen then
                                line.From = rootPos
                                line.To = Vector2.new(partPos.X, partPos.Y)
                                line.Visible = true
                            else
                                line.Visible = false
                            end
                        end
                    end
                else
                    for _, line in pairs(skeleton) do
                        line.Visible = false
                    end
                end
            end
        end
    end
end)
