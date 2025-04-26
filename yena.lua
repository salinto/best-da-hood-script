-- Load the libraries
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua'))()
local ThemeManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/SaveManager.lua'))()

-- Initialize the library
local Window = Library.CreateLib("Roblox Aimbot & Visual Settings", "Dark theme")

-- Apply the theme
ThemeManager.ApplyTheme("Dark")  -- You can change this to other theme names like "Light"

-- Create a save manager to persist settings
local Settings = SaveManager.New("AimbotVisualSettings")

-- Create the tabs for the GUI
local AimbotTab = Window:NewTab("Aimbot")
local VisualTab = Window:NewTab("Visual Settings")

-- Aimbot Tab - Creating a section in the Aimbot tab
local AimbotSection = AimbotTab:NewSection("Aimbot Controls")

AimbotSection:NewToggle("Enable Aimbot", "Toggle aimbot on/off", function(state)
    if state then
        print("Aimbot enabled!")
        -- Code to activate the aimbot goes here
        Settings.AimbotEnabled = true
    else
        print("Aimbot disabled.")
        -- Code to deactivate the aimbot goes here
        Settings.AimbotEnabled = false
    end
end)

AimbotSection:NewSlider("Aimbot FOV", "Adjust the FOV for the aimbot", 180, 0, function(value)
    print("Aimbot FOV set to " .. value)
    Settings.AimbotFOV = value
end)

-- Visual Settings Tab - Creating a section in the Visual tab
local VisualSection = VisualTab:NewSection("Visual Controls")

VisualSection:NewToggle("Enable ESP", "Toggle ESP (wallhack) on/off", function(state)
    if state then
        print("ESP enabled!")
        -- Code to enable ESP goes here
        Settings.ESPEnabled = true
    else
        print("ESP disabled.")
        -- Code to disable ESP goes here
        Settings.ESPEnabled = false
    end
end)

VisualSection:NewToggle("Show FOV Circle", "Toggle FOV circle display", function(state)
    if state then
        print("FOV circle displayed!")
        -- Code to show FOV circle goes here
        Settings.ShowFOV = true
    else
        print("FOV circle hidden.")
        -- Code to hide FOV circle goes here
        Settings.ShowFOV = false
    end
end)

VisualSection:NewColorPicker("FOV Circle Color", "Pick the color for the FOV circle", Color3.fromRGB(255, 0, 0), function(color)
    print("FOV circle color set to " .. tostring(color))
    Settings.FOVColor = color
end)

-- Load saved settings if available
if Settings.AimbotEnabled then
    print("Aimbot is enabled from saved settings.")
end
if Settings.ESPEnabled then
    print("ESP is enabled from saved settings.")
end
if Settings.FOVColor then
    print("FOV circle color is " .. tostring(Settings.FOVColor))
end

-- Create a reset button
VisualSection:NewButton("Reset Settings", "Reset all visual settings to default", function()
    Settings:Reset()
    print("Settings have been reset!")
end)

-- Finalize the GUI creation
Library.SaveSettings()

-- Example function to handle the aimbot logic (just a placeholder)
function ActivateAimbot()
    -- Example: Aimbot logic for targeting enemies
    print("Aimbot activated!")
    -- Add your aimbot code here to target enemies within the FOV
end

-- Example function to handle ESP logic (just a placeholder)
function ActivateESP()
    -- Example: ESP logic to draw boxes around players
    print("ESP activated!")
    -- Add your ESP code here to render boxes or outlines on players
end
