--// Load Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "juggy | Premium v1.2",
   LoadingTitle = "juggy | Loading...",
   LoadingSubtitle = "by juggy dev",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "juggyPremium",
      FileName = "Settings"
   },
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = true
   },
   KeySystem = true,
   KeySettings = {
      Title = "juggy | Key System",
      Subtitle = "Key = jugjug",
      Note = "Join Discord for key.",
      FileName = "jugggy",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"jugjug"}
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
local VanishEnabled = false
local VanishMethod = "Float"
local AimbotEnabled = false
local FOVEnabled = false
local FOVSize = 100
local ESPEnabled = false
local SilentAimEnabled = false
local RapidFireEnabled = false
local RapidFireKey = Enum.KeyCode.Space  -- Default key for rapid fire
local Prediction = 0.165

--// FOV Circle
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
                if distance < closestDistance and distance <= FOVSize then
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

    if SilentAimEnabled and tostring(self) == "HitPart" and method == "FireServer" then
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

--// Combat Section
CombatTab:CreateToggle({
    Name = "Forcehit",
    CurrentValue = false,
    Callback = function(Value)
        ForcehitEnabled = Value
    end,
})

CombatTab:CreateToggle({
    Name = "Spinbot",
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
    CurrentValue = 50,
    Callback = function(Value)
        SpinbotSpeed = Value
    end,
})

CombatTab:CreateToggle({
    Name = "Enable Rapid Fire",
    CurrentValue = false,
    Callback = function(Value)
        RapidFireEnabled = Value
    end,
})

CombatTab:CreateKeybind({
    Name = "Choose Rapid Fire Key",
    DefaultKey = RapidFireKey,
    Callback = function(Key)
        RapidFireKey = Key
    end
})

CombatTab:CreateToggle({
    Name = "Enable Vanish",
    CurrentValue = false,
    Callback = function(Value)
        VanishEnabled = Value
    end,
})

CombatTab:CreateDropdown({
    Name = "Vanish Method",
    Options = {"Float", "Blink", "Fade"},
    CurrentOption = "Float",
    Callback = function(Option)
        VanishMethod = Option
    end,
})

--// Miscs Section
MiscsTab:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = false,
    Callback = function(Value)
        AimbotEnabled = Value
    end,
})

MiscsTab:CreateToggle({
    Name = "Show FOV Circle",
    CurrentValue = false,
    Callback = function(Value)
        FOVEnabled = Value
        FOVCircle.Visible = Value
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
    end,
})

MiscsTab:CreateToggle({
    Name = "Enable Skeleton ESP",
    CurrentValue = false,
    Callback = function(Value)
        ESPEnabled = Value
    end,
})

MiscsTab:CreateToggle({
    Name = "Enable Silent Aim",
    CurrentValue = false,
    Callback = function(Value)
        SilentAimEnabled = Value
    end,
})

--// Render Loop
RunService.RenderStepped:Connect(function()
    if FOVEnabled then
        FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
        FOVCircle.Radius = FOVSize
    end

    if SpinbotEnabled then
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(SpinbotSpeed), 0)
        end
    end

    -- ESP Skeletons
    for player, espLines in pairs(ESP) do
        local character = player.Character
        if character and ESPEnabled then
            local rootPos, onScreen = Camera:WorldToViewportPoint(character.HumanoidRootPart.Position)
            if onScreen then
                local parts = {
                    Head = character:FindFirstChild("Head"),
                    Torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso"),
                    ["Left Arm"] = character:FindFirstChild("LeftUpperArm") or character:FindFirstChild("Left Arm"),
                    ["Right Arm"] = character:FindFirstChild("RightUpperArm") or character:FindFirstChild("Right Arm"),
                    ["Left Leg"] = character:FindFirstChild("LeftUpperLeg") or character:FindFirstChild("Left Leg"),
                    ["Right Leg"] = character:FindFirstChild("RightUpperLeg") or character:FindFirstChild("Right Leg"),
                }

                -- Update ESP skeleton
                for partName, part in pairs(parts) do
                    if part then
                        espLines[partName].From = Camera:WorldToViewportPoint(part.Position)
                        espLines[partName].To = Camera:WorldToViewportPoint(parts.Torso.Position)
                        espLines[partName].Visible = true
                    end
                end
            else
                -- Hide ESP skeleton
                for _, line in pairs(espLines) do
                    line.Visible = false
                end
            end
        else
            -- Hide ESP skeleton
            for _, line in pairs(espLines) do
                line.Visible = false
            end
        end
    end
end)
