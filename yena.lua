-- Load Linoria Library
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua'))()

if not Library then
    warn("Failed to load the Linoria UI library.")
    return
end

-- Create Window
local Window = Library:CreateWindow({
    Title = 'GOD Aimbot | Linoria UI',
    Center = true,
    AutoShow = true,
})

-- Tabs
local Tabs = {
    Aimbot = Window:AddTab('Aimbot'),
    Visuals = Window:AddTab('Visuals'),
    Movement = Window:AddTab('Movement')
}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Variables
local AimbotEnabled, IsLocking = false, false
local AimbotFOV, AimbotSmoothness, AimbotPrediction = 100, 0.2, 0.13
local AimbotHitPart, AimbotKey = "Head", Enum.KeyCode.E
local RapidFire, RainbowESPEnabled = false, false
local SpeedWalkEnabled, SuperJumpEnabled = false, false
local WalkSpeedAmount, JumpPowerAmount = 50, 100
local TargetPlayer = nil
local SilentAimEnabled = false

-- FOV Circle (Fixed Position)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Visible = true

-- Aimbot Tab Setup
local AimbotGroup = Tabs.Aimbot:AddLeftGroupbox('Main')

-- Enable Aimbot Toggle
AimbotGroup:AddToggle('AimEnabled', {
    Text = 'Enable Aimbot',
    Default = false,
    Callback = function(Value)
        AimbotEnabled = Value
    end
})

-- Aimbot Keybind (placed right under Enable Aimbot)
AimbotGroup:AddLabel('Aimlock Keybind'):AddKeyPicker('AimLockKey', {
    Default = 'E',
    Mode = 'Toggle',
    Text = 'Aimlock Key',
    NoUI = false,
    Callback = function(Key)
        AimbotKey = Enum.KeyCode[Key] or Enum.KeyCode.E
    end
})

-- FOV Slider
AimbotGroup:AddInput('FOVInput', {
    Default = '100',
    Numeric = true,
    Finished = true,
    Text = 'FOV Size',
    Placeholder = '100',
    Callback = function(Value)
        AimbotFOV = tonumber(Value) or 100
    end
})

-- Mode Dropdown
AimbotGroup:AddDropdown('ModeSelect', {
    Values = {'Legit', 'Blatant'},
    Default = 1,
    Text = 'Mode',
    Callback = function(Value)
        if Value == "Legit" then
            AimbotSmoothness = 0.2
            AimbotPrediction = 0.13
        else
            AimbotSmoothness = 1
            AimbotPrediction = 0.165
        end
    end
})

-- Hit Part Dropdown
AimbotGroup:AddDropdown('HitPartSelect', {
    Values = {'Head', 'HumanoidRootPart', 'UpperTorso', 'LowerTorso'},
    Default = 1,
    Text = 'HitPart',
    Callback = function(Value) AimbotHitPart = Value end
})

-- Rapid Fire Toggle
AimbotGroup:AddToggle('RapidFire', {
    Text = 'Enable Rapid Fire',
    Default = false,
    Callback = function(Value) RapidFire = Value end
})

-- Silent Aim Toggle
AimbotGroup:AddToggle('SilentAim', {
    Text = 'Enable Silent Aim',
    Default = false,
    Callback = function(Value) SilentAimEnabled = Value end
})

-- Visuals Setup
local ESPGroup = Tabs.Visuals:AddLeftGroupbox('ESP Features')

-- Box ESP Toggle
ESPGroup:AddToggle('BoxESP', { Text = 'Box ESP', Default = false })

-- Skeleton ESP Toggle
ESPGroup:AddToggle('SkeletonESP', { Text = 'Skeleton ESP', Default = false })

-- Tracers ESP Toggle
ESPGroup:AddToggle('TracersESP', { Text = 'Tracers ESP', Default = false })

-- Rainbow ESP Toggle
local RainbowESPGroup = Tabs.Visuals:AddRightGroupbox('Rainbow ESP')

RainbowESPGroup:AddToggle('RainbowESP', {
    Text = 'Enable Rainbow ESP',
    Default = false,
    Callback = function(Value) RainbowESPEnabled = Value end
})

-- Movement Cheats Setup
local MovementGroup = Tabs.Movement:AddLeftGroupbox('Movement Cheats')

-- Walk Speed Slider
MovementGroup:AddSlider('WalkSpeedSlider', {
    Text = 'Walk Speed',
    Default = 50,
    Min = 16,
    Max = 200,
    Callback = function(Value) WalkSpeedAmount = Value end
})

-- Jump Power Slider
MovementGroup:AddSlider('JumpPowerSlider', {
    Text = 'Jump Power',
    Default = 50,
    Min = 50,
    Max = 200,
    Callback = function(Value) JumpPowerAmount = Value end
})

-- Speed Walk Toggle
MovementGroup:AddToggle('SpeedWalk', {
    Text = 'Speed Walk',
    Default = false,
    Callback = function(Value) SpeedWalkEnabled = Value end
})

-- Super Jump Toggle
MovementGroup:AddToggle('SuperJump', {
    Text = 'Super Jump',
    Default = false,
    Callback = function(Value) SuperJumpEnabled = Value end
})

-- Helper Functions
local function GetClosestPlayer()
    local ClosestPlayer, ClosestDistance = nil, math.huge
    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local Pos, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(Player.Character.HumanoidRootPart.Position)
            if OnScreen then
                local Distance = (Vector2.new(Pos.X, Pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if Distance < ClosestDistance and Distance < AimbotFOV then
                    ClosestDistance = Distance
                    ClosestPlayer = Player
                end
            end
        end
    end
    return ClosestPlayer
end

-- Rainbow Color Generator
local function GetRainbowColor()
    local t = tick() * 2
    return Color3.fromHSV(t % 1, 1, 1)
end

-- Main RenderStepped
RunService.RenderStepped:Connect(function()
    -- FOV Update (Correct position and following mouse)
    FOVCircle.Position = Vector2.new(Mouse.X - AimbotFOV / 2, Mouse.Y - AimbotFOV / 2)  -- Center FOV around cursor
    FOVCircle.Radius = AimbotFOV

    -- Movement Cheats
    if Character and Character:FindFirstChild("Humanoid") then
        if SpeedWalkEnabled then
            Character.Humanoid.WalkSpeed = WalkSpeedAmount
        else
            Character.Humanoid.WalkSpeed = 16
        end

        if SuperJumpEnabled then
            Character.Humanoid.JumpPower = JumpPowerAmount
        else
            Character.Humanoid.JumpPower = 50
        end
    end

    -- Aimbot
    if AimbotEnabled and IsLocking and TargetPlayer then
        local TargetPart = TargetPlayer.Character and TargetPlayer.Character:FindFirstChild(AimbotHitPart)
        if TargetPart then
            local PredictedPosition = TargetPart.Position + (TargetPart.Velocity * AimbotPrediction)
            local Camera = workspace.CurrentCamera
            local NewCFrame = CFrame.new(Camera.CFrame.Position, PredictedPosition)
            Camera.CFrame = Camera.CFrame:Lerp(NewCFrame, AimbotSmoothness)
        end
    end

    -- Silent Aim
    if SilentAimEnabled and AimbotEnabled and TargetPlayer then
        local TargetPart = TargetPlayer.Character and TargetPlayer.Character:FindFirstChild(AimbotHitPart)
        if TargetPart then
            local PredictedPosition = TargetPart.Position + (TargetPart.Velocity * AimbotPrediction)
            local Camera = workspace.CurrentCamera
            local Direction = (PredictedPosition - Camera.CFrame.Position).unit
            local Ray = Ray.new(Camera.CFrame.Position, Direction * 999)
            local Hit, HitPosition = workspace:FindPartOnRay(Ray, LocalPlayer.Character)
            if Hit then
                Mouse.Hit = CFrame.new(HitPosition)
            end
        end
    end

    -- Rapid Fire
    if RapidFire and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
            task.wait(0.01) -- faster firing rate
        end
    end
end)

-- ESP Logic
RunService.RenderStepped:Connect(function()
    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local RootPart = Player.Character.HumanoidRootPart
            local Pos, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(RootPart.Position)
            if OnScreen then
                local color = RainbowESPEnabled and GetRainbowColor() or Color3.fromRGB(255, 255, 255)

                -- Box ESP
                if Library.Flags.BoxESP then
                    local Box = Drawing.new("Square")
                    Box.Size = Vector2.new(50, 100)
                    Box.Position = Vector2.new(Pos.X - 25, Pos.Y - 50)
                    Box.Color = color
                    Box.Filled = false
                    Box.Thickness = 2
                    Box.Visible = true
                    task.delay(0.01, function() Box:Remove() end)
                end

                -- Skeleton ESP
                if Library.Flags.SkeletonESP then
                    local Head = Player.Character:FindFirstChild("Head")
                    local Torso = Player.Character:FindFirstChild("UpperTorso") or Player.Character:FindFirstChild("Torso")
                    if Head and Torso then
                        local HeadPos, _ = workspace.CurrentCamera:WorldToViewportPoint(Head.Position)
                        local TorsoPos, _ = workspace.CurrentCamera:WorldToViewportPoint(Torso.Position)

                        local NeckLine = Drawing.new("Line")
                        NeckLine.From = Vector2.new(HeadPos.X, HeadPos.Y)
                        NeckLine.To = Vector2.new(TorsoPos.X, TorsoPos.Y)
                        NeckLine.Color = color
                        NeckLine.Thickness = 2
                        NeckLine.Visible = true
                        task.delay(0.01, function() NeckLine:Remove() end)
                    end
                end

                -- Tracers ESP
                if Library.Flags.TracersESP then
                    local Tracer = Drawing.new("Line")
                    Tracer.Color = color
                    Tracer.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
                    Tracer.To = Vector2.new(Pos.X, Pos.Y)
                    Tracer.Thickness = 1
                    Tracer.Visible = true
                    task.delay(0.01, function() Tracer:Remove() end)
                end
            end
        end
    end
end)

-- Input Handling
UserInputService.InputBegan:Connect(function(Input, Processed)
    if Processed then return end
    if Input.KeyCode == AimbotKey then
        if AimbotEnabled then
            IsLocking = not IsLocking
            TargetPlayer = IsLocking and GetClosestPlayer() or nil
        end
    end
end)

print("✅ Script Loaded Successfully!")
