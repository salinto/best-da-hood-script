-- Load libraries
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua'))()
local ThemeManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/SaveManager.lua'))()

-- Window Setup
local Window = Library:CreateWindow({
    Title = 'Aimbot Script | Linoria UI',
    Center = true,
    AutoShow = true,
})

local Tabs = {
    Aimbot = Window:AddTab('Aimbot')
}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Aimbot Variables
local AimbotEnabled = false
local AimbotSmoothness = 0.1
local AimbotPrediction = 0.165
local AimbotHitPart = "Head"
local AimbotShake = 0
local AimbotFOV = 100
local AimbotLockKey = Enum.KeyCode.E
local AimbotMode = "Legit" -- "Legit" or "Blatant"
local IsLocking = false

-- Draw FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 2
FOVCircle.Radius = AimbotFOV
FOVCircle.Filled = false
FOVCircle.Visible = true

-- UI Elements
local AimbotGroup = Tabs.Aimbot:AddLeftGroupbox('Main Settings')

AimbotGroup:AddToggle('AimEnabled', {
    Text = 'Enable Aimbot',
    Default = false,
    Callback = function(Value)
        AimbotEnabled = Value
    end
})

AimbotGroup:AddSlider('FOVSize', {
    Text = 'FOV Radius',
    Default = 100,
    Min = 10,
    Max = 500,
    Rounding = 0,
    Callback = function(Value)
        AimbotFOV = Value
        FOVCircle.Radius = Value
    end
})

AimbotGroup:AddDropdown('ModeSelect', {
    Values = {'Legit', 'Blatant'},
    Default = 1,
    Multi = false,
    Text = 'Aimbot Mode',
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

AimbotGroup:AddDropdown('HitPart', {
    Values = {'Head', 'HumanoidRootPart', 'UpperTorso', 'LowerTorso'},
    Default = 1,
    Multi = false,
    Text = 'HitPart',
    Callback = function(Value)
        AimbotHitPart = Value
    end
})

AimbotGroup:AddLabel('Aimbot Keybind')

AimbotGroup:AddKeyPicker('AimLockKey', {
    Default = 'E',
    SyncToggleState = false,
    Mode = 'Toggle', -- Toggle means press once = ON, press again = OFF
    Text = 'Lock Target Key',
    NoUI = false,
    Callback = function(Value)
        AimbotLockKey = Value
    end
})

-- Aimbot Functions
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

-- Main Aimbot Loop
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
    
    if AimbotEnabled and IsLocking then
        local Target = GetClosestPlayer()
        if Target and Target.Character and Target.Character:FindFirstChild(AimbotHitPart) then
            local TargetPart = Target.Character[AimbotHitPart]
            local PredictedPosition = TargetPart.Position + (TargetPart.Velocity * AimbotPrediction)
            local Camera = workspace.CurrentCamera
            local NewCFrame = CFrame.new(Camera.CFrame.Position, PredictedPosition)

            -- Optional Shake for Legit
            local ShakeOffset = Vector3.new(
                (math.random() - 0.5) * 2 * AimbotShake,
                (math.random() - 0.5) * 2 * AimbotShake,
                (math.random() - 0.5) * 2 * AimbotShake
            )

            Camera.CFrame = Camera.CFrame:Lerp(NewCFrame * CFrame.new(ShakeOffset), AimbotSmoothness)
        end
    end
end)

-- Lock Keybind
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == AimbotLockKey then
        IsLocking = not IsLocking
    end
end)

-- Theme & Save
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()

SaveManager:SetFolder('MyAimbot')
SaveManager:BuildConfigSection(Tabs.Aimbot)
