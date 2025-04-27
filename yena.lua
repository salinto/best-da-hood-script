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
    AutoShow = true,  -- Ensure the window is auto-shown when the script is run
})

-- Tabs for Aimbot and Visuals
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
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Variables for Aimbot and Visuals
local AimbotEnabled = false
local IsLocking = false
local AimbotFOV = 100
local AimbotMode = "Legit"
local AimbotSmoothness = 0.2
local AimbotPrediction = 0.13
local AimbotHitPart = "Head"
local TargetPlayer = nil
local RapidFire = false
local VoidWalkEnabled = false
local AimbotKey = Enum.KeyCode.E -- Default key for aimbot
local VoidWalkKey = Enum.KeyCode.C -- Default key for void walk
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Visible = true

-- Aimbot UI Setup
local AimbotGroup = Tabs.Aimbot:AddLeftGroupbox('Main')

-- Aimbot Enable Toggle
AimbotGroup:AddToggle('AimEnabled', {
    Text = 'Enable Aimbot',
    Default = false,
    Callback = function(Value)
        AimbotEnabled = Value
    end
})

-- FOV Size Input Box
AimbotGroup:AddInput('FOVInput', {
    Default = '100',
    Numeric = true,
    Finished = true,
    Text = 'FOV Size',
    Tooltip = 'Type your FOV manually',
    Placeholder = '100',
    Callback = function(Value)
        local Number = tonumber(Value)
        if Number then
            AimbotFOV = Number
        end
    end
})

-- Mode Selector
AimbotGroup:AddDropdown('ModeSelect', {
    Values = {'Legit', 'Blatant'},
    Default = 1,
    Multi = false,
    Text = 'Mode',
    Callback = function(Value)
        AimbotMode = Value
        if AimbotMode == "Legit" then
            AimbotSmoothness = 0.2
            AimbotPrediction = 0.13
        elseif AimbotMode == "Blatant" then
            AimbotSmoothness = 1
            AimbotPrediction = 0.165
        end
    end
})

-- HitPart Selector
AimbotGroup:AddDropdown('HitPartSelect', {
    Values = {'Head', 'HumanoidRootPart', 'UpperTorso', 'LowerTorso'},
    Default = 1,
    Multi = false,
    Text = 'HitPart',
    Callback = function(Value)
        AimbotHitPart = Value
    end
})

-- Keybind for Aimbot
AimbotGroup:AddLabel('Aimlock Keybind'):AddKeyPicker('AimLockKey', {
    Default = 'E',
    Mode = 'Toggle', 
    Text = 'Aimlock Keybind',
    NoUI = false,
    Callback = function(Value)
        AimbotKey = Enum.KeyCode[Value] or Enum.KeyCode.E  -- Update keybind dynamically
    end
})

-- Rapid Fire Toggle
AimbotGroup:AddToggle('RapidFire', {
    Text = 'Enable Rapid Fire',
    Default = false,
    Callback = function(Value)
        RapidFire = Value
    end
})

-- Visuals Tab (ESP Features)
local VisualsGroup = Tabs.Visuals:AddLeftGroupbox('ESP Features')

VisualsGroup:AddToggle('SkeletonESP', {
    Text = 'Skeleton ESP',
    Default = false,
    Tooltip = 'Draw skeleton on players'
})

VisualsGroup:AddToggle('TracersESP', {
    Text = 'Tracers',
    Default = false,
    Tooltip = 'Draw tracers from your screen to players'
})

VisualsGroup:AddToggle('BoxESP', {
    Text = 'Box ESP',
    Default = false,
    Tooltip = 'Draw boxes around players'
})

VisualsGroup:AddToggle('VoidWalk', {
    Text = 'Enable Void Walk',
    Default = false,
    Tooltip = 'Enable void walk (walk through floors/ground)',
    Callback = function(Value)
        VoidWalkEnabled = Value
    end
})

-- Function to Get Closest Player for Aimbot
local function GetClosestPlayer()
    local ClosestPlayer = nil
    local ClosestDistance = math.huge
    for _, Player in pairs(Players:GetPlayers()) do
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

-- Main Loop for Aimbot
RunService.RenderStepped:Connect(function()
    -- Update FOV Circle Position and Radius
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
    FOVCircle.Radius = AimbotFOV

    -- --- Aimbot Logic ---
    if AimbotEnabled and IsLocking and TargetPlayer then
        local CurrentTarget = TargetPlayer
        if CurrentTarget and CurrentTarget.Character and CurrentTarget.Character:FindFirstChild(AimbotHitPart) then
            local TargetPart = CurrentTarget.Character[AimbotHitPart]
            local PredictedPosition = TargetPart.Position + (TargetPart.Velocity * AimbotPrediction)
            local Camera = workspace.CurrentCamera
            local NewCFrame = CFrame.new(Camera.CFrame.Position, PredictedPosition)

            Camera.CFrame = Camera.CFrame:Lerp(NewCFrame, AimbotSmoothness)
        end
    end

    -- --- Rapid Fire Logic ---
    if RapidFire and AimbotEnabled then
        -- Rapid Fire - Simulate firing quickly
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.MouseButton1) then
            -- Trigger Fire Event here if applicable (like for Roblox shooting)
            -- Make sure to call the fire action frequently
            -- For example:
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
            end
        end
    end
end)

-- Keybind Handling for Aimbot
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == AimbotKey then
        if AimbotEnabled then
            IsLocking = not IsLocking
            if IsLocking then
                TargetPlayer = GetClosestPlayer()
            else
                TargetPlayer = nil
            end
        end
    end
end)

-- Keybind Handling for Void Walk
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == VoidWalkKey then
        -- Toggle Void Walk (makes player walk through ground or float)
        VoidWalkEnabled = not VoidWalkEnabled
        local humanoid = Character:FindFirstChild("Humanoid")
        if VoidWalkEnabled then
            humanoid.PlatformStand = true
            humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            humanoid.WalkSpeed = 100 -- You can set any speed here (adjust as needed)
        else
            humanoid.PlatformStand = false
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            humanoid.WalkSpeed = 16 -- Reset the speed to default
        end
    end
end)

-- Visuals ESP Logic
RunService.RenderStepped:Connect(function()
    -- --- Visuals Logic ---
    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local RootPart = Player.Character.HumanoidRootPart
            local Pos, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(RootPart.Position)

            if OnScreen then
                -- Skeleton ESP
                if Library.Flags.SkeletonESP then
                    -- Example logic to connect Humanoid parts for skeleton ESP
                    local humanoid = Player.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        -- Draw bones here, you can use `drawing` library or `Drawing` API for it
                    end
                end

                -- Tracers
                if Library.Flags.TracersESP then
                    local Tracer = Drawing.new("Line")
                    Tracer.Color = Color3.fromRGB(255, 255, 255)
                    Tracer.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
                    Tracer.To = Vector2.new(Pos.X, Pos.Y)
                    Tracer.Thickness = 1
                    Tracer.Visible = true
                end

                -- Box ESP
                if Library.Flags.BoxESP then
                    local Box = Drawing.new("Square")
                    Box.Position = Vector2.new(Pos.X - 15, Pos.Y - 15)
                    Box.Size = Vector2.new(30, 30)
                    Box.Color = Color3.fromRGB(255, 255, 255)
                    Box.Thickness = 1
                    Box.Filled = false
                    Box.Visible = true
                end
            end
        end
    end
end)

-- Debugging message to ensure everything runs smoothly
print("Script Initialized and UI Loaded!")
