--// Load Yena Library
local Yena = loadstring(game:HttpGet('https://raw.githubusercontent.com/salinto/best-da-hood-script/refs/heads/main/yena.lua'))()

--// Key System (added check for valid key before proceeding)
local keySystemInitialized = false

local function initKeySystem()
    local keySettings = {
        Title = "JuggyWare | Key System",
        Subtitle = "Key = juggyisgod",
        Note = "Join Discord for key.",
        FileName = "juggyKeySave",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"juggyisgod"}
    }

    -- This function should be triggered if key matches
    local function onKeyValid()
        keySystemInitialized = true
        print("Key system initialized successfully. Proceeding to UI...")
    end

    local function onKeyInvalid()
        print("Invalid key. Please use the correct key to proceed.")
    end

    -- Check if the key is valid
    if table.find(keySettings.Key, "juggyisgod") then
        onKeyValid()
    else
        onKeyInvalid()
    end
end

initKeySystem()

-- Don't continue with the script if key system isn't valid
if not keySystemInitialized then
    return
end

--// Create Window After Key System Validation
local Window = Yena:CreateWindow({
    Name = "JuggyWare | Premium v1.2",
    LoadingTitle = "JuggyWare | Loading...",
    LoadingSubtitle = "by JuggyWare dev",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "JuggyWarePremium",
        FileName = "Settings"
    },
    Discord = {
        Enabled = false,
        Invite = "", -- Add Discord invite code here if you want
        RememberJoins = true
    },
    KeySystem = true,
    KeySettings = {
        Title = "JuggyWare | Key System",
        Subtitle = "Key = juggyisgod",
        Note = "Join Discord for key.",
        FileName = "juggyKeySave",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"juggyisgod"}
    }
})

--// Services (standard setup remains same)
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local SoundService = game:GetService("SoundService")
local VirtualUser = game:GetService("VirtualUser")

--// Variables (your existing variables for settings)
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
local RapidFireEnabled = false -- <--- RAPID FIRE ADDED

local hitSound = Instance.new("Sound")
hitSound.SoundId = "rbxassetid://1234567890" -- Replace with your sound ID
hitSound.Volume = 0.5
hitSound.Parent = SoundService

--// FOV Circle (no changes here)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Transparency = 0.5
FOVCircle.Visible = false

--// ESP Skeletons (no changes here)
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

--// Closest Player Function (unchanged)
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

--// Silent Aim Hook (unchanged)
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
            hitSound:Play() -- Play hit sound
            return self.FireServer(self, unpack(args))
        end
    end

    return __namecall(self, ...)
end)

-- Continue the rest of your setup as you had
