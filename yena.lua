 --// Load Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "plaq | Premium v1.2",
   LoadingTitle = "plaq | Loading...",
   LoadingSubtitle = "by plaq dev",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "PlaqPremium",
      FileName = "Settings"
   },
   Discord = {
      Enabled = false,
      Invite = "", -- Add Discord invite code here if you want
      RememberJoins = true
   },
   KeySystem = true,
   KeySettings = {
      Title = "plaq | Key System",
      Subtitle = "Key = plaqisgod",
      Note = "Join Discord for key.",
      FileName = "plaqKeySave",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"plaqisgod"}
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
local Prediction = 0.165

--// FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Transparency = 0.5
FOVCircle.Visible = false

--// ESP Skeletons
local Skeletons = {}

local function createSkeleton(player)
    local skeleton = {}
    for _, partName in ipairs({"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}) do
        local line = Drawing.new("Line")
        line.Color = Color3.fromRGB(255, 255, 255)
        line.Thickness = 1
        line.Transparency = 1
        skeleton[partName] = line
    end
    Skeletons[player] = skeleton
end

local function removeSkeleton(player)
    if Skeletons[player] then
        for _, line in pairs(Skeletons[player]) do
            line:Remove()
        end
        Skeletons[player] = nil
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        createSkeleton(player)
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    removeSkeleton(player)
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createSkeleton(player)
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
    for player, skeleton in pairs(Skeletons) do
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

                if parts.Head and parts.Torso then
                    skeleton.Head.From = Camera:WorldToViewportPoint(parts.Head.Position)
                    skeleton.Head.To = Camera:WorldToViewportPoint(parts.Torso.Position)
                    skeleton.Head.Visible = true
                end
                if parts.LeftArm and parts.Torso then
                    skeleton["Left Arm"].From = Camera:WorldToViewportPoint(parts.LeftArm.Position)
                    skeleton["Left Arm"].To = Camera:WorldToViewportPoint(parts.Torso.Position)
                    skeleton["Left Arm"].Visible = true
                end
                if parts.RightArm and parts.Torso then
                    skeleton["Right Arm"].From = Camera:WorldToViewportPoint(parts.RightArm.Position)
                    skeleton["Right Arm"].To = Camera:WorldToViewportPoint(parts.Torso.Position)
                    skeleton["Right Arm"].Visible = true
                end
                if parts.LeftLeg and parts.Torso then
                    skeleton["Left Leg"].From = Camera:WorldToViewportPoint(parts.LeftLeg.Position)
                    skeleton["Left Leg"].To = Camera:WorldToViewportPoint(parts.Torso.Position)
                    skeleton["Left Leg"].Visible = true
                end
                if parts.RightLeg and parts.Torso then
                    skeleton["Right Leg"].From = Camera:WorldToViewportPoint(parts.RightLeg.Position)
                    skeleton["Right Leg"].To = Camera:WorldToViewportPoint(parts.Torso.Position)
                    skeleton["Right Leg"].Visible = true
                end
            else
                for _, line in pairs(skeleton) do
                    line.Visible = false
                end
            end
        else
            for _, line in pairs(skeleton) do
                line.Visible = false
            end
        end
    end
end)
