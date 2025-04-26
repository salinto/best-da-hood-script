-- Load the libraries
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

AimbotOptions:AddSlider("FOVSlider", {
    Text = "Aimbot FOV",
    Default = 60,
    Min = 1,
    Max = 360,
    Rounding = 0,
    Compact = false,
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
