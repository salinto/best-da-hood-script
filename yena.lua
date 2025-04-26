-- Load Libraries
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua'))()
local ThemeManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/SaveManager.lua'))()

-- Create the main window
local Window = Library:CreateWindow({
    Title = "Advanced Aimbot GUI",
    Center = true,
    AutoShow = true,
})

-- Tabs
local Tabs = {
    Aimbot = Window:AddTab("Aimbot"),
}

-- Groups (sections inside the tab)
local AimbotOptions = Tabs.Aimbot:AddLeftGroupbox("Aimbot Settings")

AimbotOptions:AddToggle("AimbotEnabled", {
    Text = "Enable Aimbot",
    Default = false,
})

AimbotOptions:AddDropdown("AimbotHitPart", {
    Values = { "Head", "HumanoidRootPart", "UpperTorso", "LowerTorso" },
    Default = 1,
    Multi = false,
    Text = "Hit Part",
})

AimbotOptions:AddSlider("PredictionAmount", {
    Text = "Prediction Amount",
    Default = 0.165,
    Min = 0,
    Max = 1,
    Rounding = 3,
})

AimbotOptions:AddSlider("Smoothness", {
    Text = "Aimbot Smoothness",
    Default = 5,
    Min = 1,
    Max = 50,
    Rounding = 0,
})

AimbotOptions:AddSlider("ShakeAmount", {
    Text = "Shake Amount",
    Default = 0,
    Min = 0,
    Max = 2,
    Rounding = 2,
})

AimbotOptions:AddToggle("ShowFOV", {
    Text = "Show FOV Circle",
    Default = true,
})

AimbotOptions:AddColorPicker("FOVColor", {
    Default = Color3.fromRGB(255, 0, 0),
    Title = "FOV Circle Color",
})

-- Save Manager
SaveManager:SetLibrary(Library)
SaveManager:BuildFolder("AdvancedAimbot")
SaveManager:IgnoreThemeSettings()
SaveManager:BuildConfigSection(Tabs.Aimbot)

-- Theme Manager
ThemeManager:SetLibrary(Library)
ThemeManager:ApplyToTab(Tabs.Aimbot)

-------------------------------------------------------------------------------------------
-- Aimbot Code
-------------------------------------------------------------------------------------------

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Create FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Thickness = 2
FOVCircle.NumSides = 100
FOVCircle.Radius = 100
FOVCircle.Filled = false
FOVCircle.Color = Color3.fromRGB(255, 0, 0)

RunService.RenderStepped:Connect(function()
    -- Update FOV Circle
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
    FOVCircle.Visible = Library.Flags.ShowFOV
    FOVCircle.Color = Library.Flags.FOVColor
end)

-- Get closest enemy function
local function GetClosestEnemy()
    local closestEnemy = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local screenPoint, onScreen = workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPoint.X, screenPoint.Y)).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestEnemy = player
                end
            end
        end
    end
    return closestEnemy
end

-- Aimbot Logic
RunService.RenderStepped:Connect(function()
    if not Library.Flags.AimbotEnabled then return end

    local target = GetClosestEnemy()
    if target and target.Character then
        local aimPart = target.Character:FindFirstChild(Library.Flags.AimbotHitPart)
        if aimPart then
            -- Prediction
            local predictVelocity = aimPart.Velocity * Library.Flags.PredictionAmount
            local predictedPosition = aimPart.Position + predictVelocity

            -- Smoothness calculation
            local camera = workspace.CurrentCamera
            local direction = (predictedPosition - camera.CFrame.Position).Unit
            local targetCFrame = CFrame.lookAt(camera.CFrame.Position, predictedPosition)

            local smoothness = Library.Flags.Smoothness or 5
            local shake = (Vector3.new(
                (math.random() - 0.5) * Library.Flags.ShakeAmount,
                (math.random() - 0.5) * Library.Flags.ShakeAmount,
                (math.random() - 0.5) * Library.Flags.ShakeAmount
            ))

            camera.CFrame = camera.CFrame:Lerp(targetCFrame * CFrame.new(shake), 1 / smoothness)
        end
    end
end)
