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
local SpinbotKey = Enum.KeyCode.Q  -- Default key for Spinbot
local RapidFireEnabled = false
local RapidFireKey = Enum.KeyCode.Space  -- Default key for Rapid Fire
local Prediction = 0.165
local GodModeEnabled = false
local GodFistEnabled = false
local SilentAimEnabled = false
local ESPEnabled = false

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

CombatTab:CreateKeybind({
    Name = "Spinbot Key",
    DefaultKey = SpinbotKey,
    Callback = function(Key)
        SpinbotKey = Key
    end
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
    Name = "Rapid Fire Key",
    DefaultKey = RapidFireKey,
    Callback = function(Key)
        RapidFireKey = Key
    end
})

CombatTab:CreateToggle({
    Name = "God Mode",
    CurrentValue = false,
    Callback = function(Value)
        GodModeEnabled = Value
    end,
})

CombatTab:CreateToggle({
    Name = "God Fist",
    CurrentValue = false,
    Callback = function(Value)
        GodFistEnabled = Value
    end,
})

--// Miscs Section (Visuals, Silent Aim, etc.)
MiscsTab:CreateToggle({
    Name = "Enable Silent Aim",
    CurrentValue = false,
    Callback = function(Value)
        SilentAimEnabled = Value
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
    CurrentValue = 100,
    Callback = function(Value)
        FOVSize = Value
    end,
})

--// Render Loop
RunService.RenderStepped:Connect(function()
    if FOVCircle.Visible then
        FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
        FOVCircle.Radius = FOVSize
    end

    if SpinbotEnabled and UserInputService:IsKeyDown(SpinbotKey) then
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(SpinbotSpeed), 0)
        end
    end

    if RapidFireEnabled and UserInputService:IsKeyDown(RapidFireKey) then
        -- Your rapid fire logic goes here
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

    -- God Mode & God Fist Logic (Example implementation)
    if GodModeEnabled then
        LocalPlayer.Character:FindFirstChild("Humanoid").Health = math.huge
    end
    if GodFistEnabled then
        -- Implement God Fist logic (could involve instant KO or increased damage)
    end
end)

