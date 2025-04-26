--// Load Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

--// Check if Rayfield is loaded
if not Rayfield then
    print("Rayfield failed to load!")
else
    print("Rayfield loaded successfully!")
end

--// Create Window
local Window = Rayfield:CreateWindow({
   Name = "Jugg | Premium GUI",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "by Jugg Dev",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "JuggPremium",
      FileName = "Settings"
   },
   Discord = {Enabled = false},
   KeySystem = true,
   KeySettings = {
      Title = "Jugg | Key System",
      Subtitle = "Key = JuggIsPro",
      Note = "Join Discord for key.",
      FileName = "JuggKeySave",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"JuggIsPro"}
   }
})

--// Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

--// Variables
local AimbotEnabled = false
local SilentAimEnabled = false
local FOVEnabled = false
local FOVSize = 100
local RapidFireEnabled = false

--// Create FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Transparency = 0.5
FOVCircle.Visible = false

--// Check for FOV Circle visibility
print("FOV Circle Created")

--// Aimbot Targeting Function
local function getClosestPlayer()
    local closestPlayer = nil
    local closestDistance = math.huge
    for _, player in pairs(Players:GetPlayers()) do
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

--// Silent Aim System
local function silentAim()
    local closestPlayer = getClosestPlayer()
    if closestPlayer and closestPlayer.Character then
        local predPos = closestPlayer.Character.HumanoidRootPart.Position + (closestPlayer.Character.HumanoidRootPart.Velocity * 0.15)
        print("Silent Aim targeting: " .. closestPlayer.Name)
        -- Implement silent aim logic to target predicted position
    end
end

--// Rapid Fire Implementation
local function rapidFire()
    if RapidFireEnabled then
        print("Rapid Fire is enabled")
        -- Simulate rapid fire here
        game:GetService("UserInputService").InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                while input.UserInputType == Enum.UserInputType.MouseButton1 do
                    -- Simulate firing
                    fire()
                    wait(0.1)  -- Adjust the rapid fire speed here
                end
            end
        end)
    end
end

--// GUI Controls for Combat
local CombatTab = Window:CreateTab("Combat", 4483362458)
local CombatSection = CombatTab:CreateSection("Main Combat Features")

CombatTab:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = false,
    Callback = function(Value)
        AimbotEnabled = Value
        print("Aimbot enabled:", AimbotEnabled)
    end,
})

CombatTab:CreateToggle({
    Name = "Enable Silent Aim",
    CurrentValue = false,
    Callback = function(Value)
        SilentAimEnabled = Value
        print("Silent Aim enabled:", SilentAimEnabled)
    end,
})

CombatTab:CreateToggle({
    Name = "Enable Rapid Fire",
    CurrentValue = false,
    Callback = function(Value)
        RapidFireEnabled = Value
        print("Rapid Fire enabled:", RapidFireEnabled)
    end,
})

--// FOV Settings (Miscs Tab)
local MiscsTab = Window:CreateTab("Miscs", 4483362458)
MiscsTab:CreateToggle({
    Name = "Show FOV Circle",
    CurrentValue = false,
    Callback = function(Value)
        FOVEnabled = Value
        FOVCircle.Visible = Value
        print("FOV Circle Visible:", FOVEnabled)
    end,
})

MiscsTab:CreateSlider({
    Name = "FOV Size",
    Range = {50, 500},
    Increment = 5,
    Suffix = "px",
    CurrentValue = 100,
    Callback = function(Value)
        FOVSize = Value
        print("FOV Size:", FOVSize)
    end,
})

--// Render Loop (for FOV circle, aimbot, etc.)
RunService.RenderStepped:Connect(function()
    -- Update FOV circle position and size
    if FOVEnabled then
        FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
        FOVCircle.Radius = FOVSize
    end

    -- Aimbot logic
    if AimbotEnabled then
        local closestPlayer = getClosestPlayer()
        if closestPlayer and closestPlayer.Character then
            print("Aimbot targeting: " .. closestPlayer.Name)
            -- Aim at closest player's HumanoidRootPart
            local targetPos = closestPlayer.Character.HumanoidRootPart.Position
            -- Implement aiming logic here
        end
    end

    -- Silent Aim logic
    if SilentAimEnabled then
        silentAim()
    end

    -- Handle Rapid Fire
    rapidFire()
end)

