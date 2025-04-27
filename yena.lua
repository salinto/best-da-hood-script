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

-- Drawing FOV Box (Static)
local FOVBox = Drawing.new("Square")
FOVBox.Color = Color3.fromRGB(255, 255, 255)
FOVBox.Thickness = 2
FOVBox.Filled = false
FOVBox.Visible = true

-- Update FOV Box position and size
RunService.RenderStepped:Connect(function()
    local screenSize = workspace.CurrentCamera.ViewportSize
    local fovSize = AimbotFOV * 2

    FOVBox.Position = Vector2.new((screenSize.X - fovSize) / 2, (screenSize.Y - fovSize) / 2)
    FOVBox.Size = Vector2.new(fovSize, fovSize)
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

-- Aimbot Logic: Follow target without manually moving camera
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

-- Keybind Handling for Aimbot
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
