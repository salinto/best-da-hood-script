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

--// Variables
local ForcehitEnabled = false
local SpinbotEnabled = false
local SpinbotSpeed = 50
local SpinbotKey = Enum.KeyCode.Q
local RapidFireEnabled = false
local RapidFireKey = Enum.KeyCode.Space
local Prediction = 0.165
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

--// ESP Skeletons (Renamed to just ESP)
local ESP = {}

local function createESP(player)
    local espLines = {}
    for _, partName in ipairs({"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}) do
        local line = Drawing.new("Line")
        line.Color = Color3.fromRGB(255, 255, 255)
        line.Thickness = 1
        line.Transparency = 1
        espLines[partName] = line
    end
    ESP[player] = espLines
end

local function removeESP(player)
    if ESP[player] then
        for _, line in pairs(ESP[player]) do
            line:Remove()
        end
        ESP[player] = nil
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        createESP(player)
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end

--// Closest Player Function
local function getClosestPlayer()
    local closestPlayer = nil
    local closestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end

    return closestPlayer
end

--// Silent Aim Hook
local __namecall
__namecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if tostring(self) == "HitPart" and method == "FireServer" then
        local closest = getClosestPlayer()
        if closest and closest.Character and closest.Character:FindFirstChild("HumanoidRootPart") then
            local predPos = closest.Character.HumanoidRootPart.Position + (closest.Character.HumanoidRootPart.Velocity * Prediction)
            args[1] = closest.Character.HumanoidRootPart
            args[2] = predPos
            return self.FireServer(self, unpack(args))
        end
    end

    return __namecall(self, ...)
end)

--// UI Tabs and Sections
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

--// Render Loop
RunService.RenderStepped:Connect(function()
    if FOVCircle.Visible then
        FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
        FOVCircle.Radius = FOVSize
    end

    -- Implement Spinbot (Spinning around the target in the air)
    if SpinbotEnabled then
        local character = LocalPlayer.Character
        local closest = getClosestPlayer()
        if character and closest then
            local targetPosition = closest.Character.HumanoidRootPart.Position
            local characterPosition = character.HumanoidRootPart.Position
            local direction = (targetPosition - characterPosition).unit

            -- Make the character spin around the target
            character.HumanoidRootPart.CFrame = CFrame.new(characterPosition) * CFrame.Angles(0, math.rad(SpinbotSpeed), 0)
        end
    end

    -- God Mode & God Fist Logic
    if GodModeEnabled then
        LocalPlayer.Character:FindFirstChild("Humanoid").Health = math.huge
    end
    if GodFistEnabled then
        -- Implement God Fist logic here
    end
end)
