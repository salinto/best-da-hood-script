-- Load OrionLib
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

local Window = OrionLib:MakeWindow({
    Name = "Isabelle2025",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "Isabelle2025Config"
})

-- MAIN TAB
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- VISUALS TAB
local VisualsTab = Window:MakeTab({
    Name = "Visuals",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- MISC TAB
local MiscTab = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- SETTINGS TAB
local SettingsTab = Window:MakeTab({
    Name = "Settings",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Aimbot Misc Section
MainTab:AddSection({Name = "Aimbot Misc"})

local AimbotEnabled = false
MainTab:AddToggle({
    Name = "Enabled",
    Default = false,
    Callback = function(Value)
        AimbotEnabled = Value
    end
})

MainTab:AddSlider({
    Name = "Aimbot FOV",
    Min = 0,
    Max = 300,
    Default = 100,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    Callback = function(Value)
        -- Set FOV
    end
})

MainTab:AddSlider({
    Name = "Smoothing Factor",
    Min = 0,
    Max = 5,
    Default = 1,
    Color = Color3.fromRGB(255,255,255),
    Increment = 0.01,
    Callback = function(Value)
        -- Set smoothing
    end
})

MainTab:AddSlider({
    Name = "Prediction X",
    Min = 0,
    Max = 5,
    Default = 1,
    Color = Color3.fromRGB(255,255,255),
    Increment = 0.01,
    Callback = function(Value)
        -- Prediction X
    end
})

MainTab:AddSlider({
    Name = "Prediction Y",
    Min = 0,
    Max = 5,
    Default = 1,
    Color = Color3.fromRGB(255,255,255),
    Increment = 0.01,
    Callback = function(Value)
        -- Prediction Y
    end
})

MainTab:AddDropdown({
    Name = "Prediction Method",
    Default = "Division",
    Options = {"Division", "Addition", "Subtraction", "Multiplication"},
    Callback = function(Value)
        -- Method chosen
    end
})

MainTab:AddDropdown({
    Name = "Hitbox Priority",
    Default = "Head",
    Options = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"},
    Callback = function(Value)
        -- Hitbox part
    end
})

MainTab:AddDropdown({
    Name = "Method",
    Default = "Mouse",
    Options = {"Mouse", "Camera"},
    Callback = function(Value)
        -- Mouse/camera lock
    end
})

MainTab:AddSection({Name = "Flags"})

MainTab:AddToggle({
    Name = "Teamcheck",
    Default = false,
    Callback = function(Value)
        -- Teamcheck on/off
    end
})

MainTab:AddToggle({
    Name = "Healthcheck",
    Default = false,
    Callback = function(Value)
        -- Healthcheck on/off
    end
})

MainTab:AddToggle({
    Name = "Invisible check",
    Default = false,
    Callback = function(Value)
        -- Invisible check
    end
})

-- Silent Aim Section
MiscTab:AddSection({Name = "Silent Aim Misc"})

local SilentAimEnabled = false
MiscTab:AddToggle({
    Name = "Enabled",
    Default = false,
    Callback = function(Value)
        SilentAimEnabled = Value
    end
})

MiscTab:AddSlider({
    Name = "Silent FOV",
    Min = 0,
    Max = 300,
    Default = 50,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    Callback = function(Value)
        -- Silent FOV set
    end
})

MiscTab:AddSlider({
    Name = "Hitchance (%)",
    Min = 0,
    Max = 100,
    Default = 100,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    Callback = function(Value)
        -- Hitchance
    end
})

MiscTab:AddSlider({
    Name = "Prediction X",
    Min = 0,
    Max = 5,
    Default = 1,
    Color = Color3.fromRGB(255,255,255),
    Increment = 0.01,
    Callback = function(Value)
        -- Silent Prediction X
    end
})

MiscTab:AddSlider({
    Name = "Prediction Y",
    Min = 0,
    Max = 5,
    Default = 1,
    Color = Color3.fromRGB(255,255,255),
    Increment = 0.01,
    Callback = function(Value)
        -- Silent Prediction Y
    end
})

MiscTab:AddDropdown({
    Name = "Prediction Method",
    Default = "Division",
    Options = {"Division", "Addition", "Subtraction", "Multiplication"},
    Callback = function(Value)
        -- Prediction Method
    end
})

MiscTab:AddToggle({
    Name = "Closest Part To Mouse",
    Default = false,
    Callback = function(Value)
        -- Closest Part
    end
})

-- Triggerbot Section
MiscTab:AddSection({Name = "Triggerbot"})

local TriggerbotEnabled = false
MiscTab:AddToggle({
    Name = "Enabled",
    Default = false,
    Callback = function(Value)
        TriggerbotEnabled = Value
    end
})

MiscTab:AddSlider({
    Name = "Delay (ms)",
    Min = 0,
    Max = 500,
    Default = 0,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    Callback = function(Value)
        -- Delay
    end
})

MiscTab:AddSlider({
    Name = "Release Delay (s)",
    Min = 0,
    Max = 1,
    Default = 0,
    Color = Color3.fromRGB(255,255,255),
    Increment = 0.01,
    Callback = function(Value)
        -- Release Delay
    end
})

MiscTab:AddSlider({
    Name = "Scale",
    Min = 0,
    Max = 1,
    Default = 0.1,
    Color = Color3.fromRGB(255,255,255),
    Increment = 0.01,
    Callback = function(Value)
        -- Scale
    end
})

-- Init
OrionLib:Init()
