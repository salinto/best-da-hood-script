-- Load Libraries
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua'))()
local ThemeManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/SaveManager.lua'))()

-- Create the main window
local Window = Library:CreateWindow({
    Title = "My Aimbot GUI",
    Center = true,
    AutoShow = true,
})

-- Tabs
local Tabs = {
    Aimbot = Window:AddTab("Aimbot"),
}

-- Groups (sections inside the tab)
local AimbotOptions = Tabs.Aimbot:AddLeftGroupbox("Aimbot Settings")

-- Aimbot toggles and settings
AimbotOptions:AddToggle("AimbotEnabled", {
    Text = "Enable Aimbot",
    Default = false,
    Tooltip = "Turns the aimbot on or off.",
})

AimbotOptions:AddDropdown("AimbotTarget", {
    Values = { "Head", "Torso", "Closest" },
    Default = 1,
    Multi = false,
    Text = "Aim Target",
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
SaveManager:BuildFolder("AimbotGUI")
SaveManager:IgnoreThemeSettings()
SaveManager:BuildConfigSection(Tabs.Aimbot)

-- Theme Manager
ThemeManager:SetLibrary(Library)
ThemeManager:ApplyToTab(Tabs.Aimbot)

-------------------------------------------------------------------------------------------
-- Aimbot + FOV Circle Functionality
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

-- Update FOV Circle
RunService.RenderStepped:Connect(function()
    -- Update circle settings
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
    FOVCircle.Visible = Library.Flags.ShowFOV
    FOVCircle.Color = Library.Flags.FOVColor
end)

-- Function to get the closest enemy
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

-- Aimbot Locking
RunService.RenderStepped:Connect(function()
    if not Library.Flags.AimbotEnabled then return end

    local target = GetClosestEnemy()
    if target and target.Character then
        local aimPart = "Head"
        if Library.Flags.AimbotTarget == "Torso" then
            aimPart = "HumanoidRootPart"
        elseif Library.Flags.AimbotTarget == "Closest" then
            aimPart = "HumanoidRootPart"
        end

        local part = target.Character:FindFirstChild(aimPart)
        if part then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, part.Position)
        end
    end
end)
