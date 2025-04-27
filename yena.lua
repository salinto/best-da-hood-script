-- Load Linoria
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua'))()
local ThemeManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/SaveManager.lua'))()

-- Window Setup
local Window = Library:CreateWindow({
    Title = 'GOD Aimbot | Linoria UI',
    Center = true,
    AutoShow = true,
})

-- Tabs
local Tabs = {
    Aimbot = Window:AddTab('Aimbot'),
    Visuals = Window:AddTab('Visuals') -- Visuals Tab
}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Variables
local AimbotEnabled = false
local AimbotMode = "Legit"
local AimbotFOV = 100
local BaseFOV = 100
local MaxFOV = 300
local AimbotSmoothness = 0.2
local AimbotPrediction = 0.13
local AimbotShake = 0.5
local AimbotHitPart = "Head"
local IsLocking = false
local CurrentTarget = nil
local FOVEnabled = false -- FOV checkbox

-- Drawing FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Visible = false -- Initially hidden

-- UI Setup
local AimbotGroup = Tabs.Aimbot:AddLeftGroupbox('Main')

-- Aimbot Enable
AimbotGroup:AddToggle('AimEnabled', {
    Text = 'Enable Aimbot',
    Default = false,
    Callback = function(Value)
        AimbotEnabled = Value
    end
})

-- FOV Checkbox
AimbotGroup:AddToggle('FOVEnabled', {
    Text = 'Enable FOV Circle',
    Default = false,
    Callback = function(Value)
        FOVEnabled = Value
        FOVCircle.Visible = FOVEnabled -- Toggle visibility of FOV circle
    end
})

-- FOV Size Slider
AimbotGroup:AddSlider('FOVSizeSlider', {
    Text = 'FOV Size',
    Default = 100,
    Min = 50,
    Max = 300,
    Callback = function(Value)
        AimbotFOV = Value
        BaseFOV = Value
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
            AimbotShake = 0.5
        elseif AimbotMode == "Blatant" then
            AimbotSmoothness = 1
            AimbotPrediction = 0.165
            AimbotShake = 0
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
AimbotGroup:AddLabel('Aimlock Key'):AddKeyPicker('AimLockKey', {
    Default = 'E',
    Mode = 'Toggle', 
    Text = 'Aimlock Keybind',
    NoUI = false 
})

-- Functions
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

-- Main Loop
RunService.RenderStepped:Connect(function()
    -- Update FOV Circle Position and Radius
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
    FOVCircle.Radius = AimbotFOV

    -- --- Aimbot Logic ---
    if not AimbotEnabled then
        CurrentTarget = nil
        return
    end

    if IsLocking then
        if CurrentTarget == nil or not CurrentTarget.Character or not CurrentTarget.Character:FindFirstChild(AimbotHitPart) or CurrentTarget.Character.Humanoid.Health <= 0 then
            CurrentTarget = GetClosestPlayer()
        end

        if CurrentTarget and CurrentTarget.Character and CurrentTarget.Character:FindFirstChild(AimbotHitPart) then
            local TargetPart = CurrentTarget.Character[AimbotHitPart]
            local Distance = (LocalPlayer.Character.HumanoidRootPart.Position - TargetPart.Position).Magnitude
            local AdjustedPrediction = AimbotPrediction + (Distance / 1000)

            local PredictedPosition = TargetPart.Position + (TargetPart.Velocity * AdjustedPrediction)
            local Camera = workspace.CurrentCamera
            local NewCFrame = CFrame.new(Camera.CFrame.Position, PredictedPosition)

            local ShakeOffset = Vector3.new(
                (math.random() - 0.5) * 2 * AimbotShake,
                (math.random() - 0.5) * 2 * AimbotShake,
                (math.random() - 0.5) * 2 * AimbotShake
            )

            Camera.CFrame = Camera.CFrame:Lerp(NewCFrame * CFrame.new(ShakeOffset), AimbotSmoothness)
        end
    end
end)

-- Keybind Handling for Aimbot
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Library.Flags.AimLockKey then
        IsLocking = not IsLocking
    end
end)

-- Theme / Save Setup
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder('Settings')  -- Config stored in Settings folder
SaveManager:BuildConfigSection(Tabs.Aimbot)
