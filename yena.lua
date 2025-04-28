-- Load Linoria Library
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua'))()

if not Library then
    warn("Failed to load Linoria UI library.")
    return
end

-- Create Window
local Window = Library:CreateWindow({
    Title = 'GOD Aimbot | Linoria UI',
    Center = true,
    AutoShow = true,
})

local Tabs = {
    Aimbot = Window:AddTab('Aimbot'),
    Visuals = Window:AddTab('Visuals')
}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- Variables
local AimbotEnabled = false
local IsLocking = false
local AimbotFOV = 100
local AimbotSmoothness = 0.2
local AimbotPrediction = 0.13
local AimbotHitPart = "Head"
local TargetPlayer = nil
local AimbotKey = Enum.KeyCode.E
local WalkSpeedEnabled = false
local JumpPowerEnabled = false
local DefaultWalkSpeed = 16
local DefaultJumpPower = 50

-- Draw FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Visible = true

-- ESP Storage
local ESPObjects = {}

-- Aimbot Tab
local AimbotGroup = Tabs.Aimbot:AddLeftGroupbox('Aimbot Settings')

AimbotGroup:AddToggle('AimEnabled', {
    Text = 'Enable Aimbot',
    Default = false,
    Callback = function(Value) AimbotEnabled = Value end
})

AimbotGroup:AddInput('FOVInput', {
    Default = '100',
    Numeric = true,
    Finished = true,
    Text = 'FOV Size',
    Callback = function(Value)
        local Number = tonumber(Value)
        if Number then AimbotFOV = Number end
    end
})

AimbotGroup:AddDropdown('HitPartSelect', {
    Values = {'Head', 'HumanoidRootPart', 'UpperTorso'},
    Default = 1,
    Multi = false,
    Text = 'HitPart',
    Callback = function(Value) AimbotHitPart = Value end
})

AimbotGroup:AddLabel('Aimlock Key'):AddKeyPicker('AimLockKey', {
    Default = 'E',
    Mode = 'Toggle',
    Text = 'Aimlock Key',
    NoUI = false,
    Callback = function(Value)
        AimbotKey = Enum.KeyCode[Value] or Enum.KeyCode.E
    end
})

-- Visuals Tab
local VisualsGroup = Tabs.Visuals:AddLeftGroupbox('ESP Options')

VisualsGroup:AddToggle('BoxESP', {
    Text = 'Box ESP',
    Default = false
})

VisualsGroup:AddToggle('TracersESP', {
    Text = 'Tracers ESP',
    Default = false
})

VisualsGroup:AddToggle('SkeletonESP', {
    Text = 'Skeleton ESP',
    Default = false
})

VisualsGroup:AddToggle('WalkSpeedEnabled', {
    Text = 'Enable WalkSpeed',
    Default = false,
    Callback = function(Value)
        WalkSpeedEnabled = Value
        LocalPlayer.Character.Humanoid.WalkSpeed = Value and 50 or DefaultWalkSpeed
    end
})

VisualsGroup:AddToggle('JumpPowerEnabled', {
    Text = 'Enable High Jump',
    Default = false,
    Callback = function(Value)
        JumpPowerEnabled = Value
        LocalPlayer.Character.Humanoid.JumpPower = Value and 120 or DefaultJumpPower
    end
})

-- Functions
local function GetClosestPlayer()
    local Closest, Distance = nil, math.huge
    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild(AimbotHitPart) then
            local Pos, OnScreen = Camera:WorldToViewportPoint(Player.Character[AimbotHitPart].Position)
            if OnScreen then
                local Magnitude = (Vector2.new(Pos.X, Pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if Magnitude < Distance and Magnitude < AimbotFOV then
                    Distance = Magnitude
                    Closest = Player
                end
            end
        end
    end
    return Closest
end

-- Update ESP Function
local function UpdateESP()
    for _, v in pairs(ESPObjects) do
        if v then v:Remove() end
    end
    ESPObjects = {}

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local RootPart = Player.Character.HumanoidRootPart
            local Pos, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)

            if OnScreen then
                if Library.Flags.BoxESP then
                    local Box = Drawing.new("Square")
                    Box.Position = Vector2.new(Pos.X - 15, Pos.Y - 15)
                    Box.Size = Vector2.new(30, 30)
                    Box.Color = Color3.fromRGB(255, 255, 255)
                    Box.Thickness = 1
                    Box.Filled = false
                    Box.Visible = true
                    table.insert(ESPObjects, Box)
                end

                if Library.Flags.TracersESP then
                    local Tracer = Drawing.new("Line")
                    Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    Tracer.To = Vector2.new(Pos.X, Pos.Y)
                    Tracer.Color = Color3.fromRGB(255, 255, 255)
                    Tracer.Thickness = 1
                    Tracer.Visible = true
                    table.insert(ESPObjects, Tracer)
                end

                if Library.Flags.SkeletonESP then
                    -- Skeleton ESP (basic connection torso to limbs if you want here)
                    -- Example: you could draw lines manually, needs more advanced bone positions
                end
            end
        end
    end
end

-- Main Loop
RunService.RenderStepped:Connect(function()
    -- Update FOV
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
    FOVCircle.Radius = AimbotFOV

    -- Update Aimbot
    if AimbotEnabled and IsLocking and TargetPlayer then
        if TargetPlayer.Character and TargetPlayer.Character:FindFirstChild(AimbotHitPart) then
            local TargetPart = TargetPlayer.Character[AimbotHitPart]
            local Predicted = TargetPart.Position + (TargetPart.Velocity * AimbotPrediction)
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Predicted), AimbotSmoothness)
        end
    end

    -- Update ESP
    UpdateESP()
end)

-- Keybind Handling
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == AimbotKey and AimbotEnabled then
        IsLocking = not IsLocking
        if IsLocking then
            TargetPlayer = GetClosestPlayer()
        else
            TargetPlayer = nil
        end
    end
end)

print("Script Loaded Successfully!")
