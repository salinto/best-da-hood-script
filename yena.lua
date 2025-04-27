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
    Visuals = Window:AddTab('Visuals')
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

-- FOV Circle Variables
local FOVEnabled = false
local FOVRadius = 100  -- Default FOV size

-- Create UI elements for FOV controls
local VisualsTab = Tabs.Visuals
VisualsTab:AddToggle({
    Name = "Enable FOV Circle",
    Default = false,
    Callback = function(state)
        FOVEnabled = state
    end
})

VisualsTab:AddSlider({
    Name = "FOV Circle Size",
    Min = 50,
    Max = 300,
    Default = 100,
    Callback = function(value)
        FOVRadius = value
    end
})

-- Drawing FOV Circle based on toggle and size
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Visible = FOVEnabled

-- Update FOV Circle position and size
RunService.RenderStepped:Connect(function()
    if not FOVEnabled then
        FOVCircle.Visible = false
        return
    else
        FOVCircle.Visible = true
    end

    local screenSize = workspace.CurrentCamera.ViewportSize
    local fovSize = FOVRadius  -- FOV size is based on the slider value

    FOVCircle.Position = Vector2.new(screenSize.X / 2, screenSize.Y / 2)  -- Center the circle
    FOVCircle.Radius = fovSize  -- Set radius of circle based on FOV slider
end)

-- Aimbot Follow Logic
RunService.RenderStepped:Connect(function()
    if not AimbotEnabled then return end

    local ClosestPlayer = GetClosestPlayer()
    if not ClosestPlayer or not ClosestPlayer.Character then return end

    local TargetPart = ClosestPlayer.Character:FindFirstChild(AimbotHitPart)
    if not TargetPart then return end

    local TargetPosition = TargetPart.Position
    local Camera = workspace.CurrentCamera
    local CurrentCFrame = Camera.CFrame
    local TargetCFrame = CFrame.new(CurrentCFrame.Position, TargetPosition)

    Camera.CFrame = Camera.CFrame:Lerp(TargetCFrame, AimbotSmoothness)
end)

-- Functions for Getting Closest Player
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

-- Keybind Handling for Aimbot (Lock on the closest target)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.E then
        AimbotEnabled = not AimbotEnabled
    end
end)

-- Theme / Save Setup
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder('Settings')  -- Config stored in Settings folder
SaveManager:BuildConfigSection(Tabs.Aimbot)
