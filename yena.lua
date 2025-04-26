-- Load OrionLib
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

-- Window setup
local Window = OrionLib:MakeWindow({
    Name = "Isabelle2025",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "Isabelle2025Config"
})

-- Tabs
local Main = Window:MakeTab({Name = "Main", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local Visuals = Window:MakeTab({Name = "Visuals", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local Misc = Window:MakeTab({Name = "Misc", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local Settings = Window:MakeTab({Name = "Settings", Icon = "rbxassetid://4483345998", PremiumOnly = false})

-- === AIMBOT SECTION ===
Main:AddSection({Name = "Aimbot Misc"})

Main:AddToggle({
    Name = "Enabled",
    Default = false,
    Callback = function(v) print("Aimbot:", v) end
})

Main:AddSlider({
    Name = "Aimbot FOV",
    Min = 0,
    Max = 300,
    Default = 100,
    Increment = 1,
    Callback = function(v) print("FOV:", v) end
})

Main:AddSlider({
    Name = "Smoothing Factor",
    Min = 0,
    Max = 5,
    Default = 1,
    Increment = 0.01,
    Callback = function(v) print("Smoothing:", v) end
})

Main:AddSlider({
    Name = "Prediction X",
    Min = 0,
    Max = 5,
    Default = 1,
    Increment = 0.01,
    Callback = function(v) print("Prediction X:", v) end
})

Main:AddSlider({
    Name = "Prediction Y",
    Min = 0,
    Max = 5,
    Default = 1,
    Increment = 0.01,
    Callback = function(v) print("Prediction Y:", v) end
})

Main:AddDropdown({
    Name = "Prediction Method",
    Default = "Division",
    Options = {"Division", "Addition", "Subtraction", "Multiplication"},
    Callback = function(v) print("Method:", v) end
})

Main:AddDropdown({
    Name = "Hitbox Priority",
    Default = "Head",
    Options = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"},
    Callback = function(v) print("Hitbox:", v) end
})

Main:AddDropdown({
    Name = "Method",
    Default = "Mouse",
    Options = {"Mouse", "Camera"},
    Callback = function(v) print("Method:", v) end
})

Main:AddSection({Name = "Flags"})

Main:AddToggle({Name = "Teamcheck", Default = false, Callback = function(v) print("Teamcheck:", v) end})
Main:AddToggle({Name = "Healthcheck", Default = false, Callback = function(v) print("Healthcheck:", v) end})
Main:AddToggle({Name = "Invisible check", Default = false, Callback = function(v) print("Invis Check:", v) end})

-- === SILENT AIM SECTION ===
Misc:AddSection({Name = "Silent Aim Misc"})

Misc:AddToggle({
    Name = "Enabled",
    Default = false,
    Callback = function(v) print("Silent Aim:", v) end
})

Misc:AddSlider({
    Name = "Silent FOV",
    Min = 0,
    Max = 300,
    Default = 50,
    Increment = 1,
    Callback = function(v) print("Silent FOV:", v) end
})

Misc:AddSlider({
    Name = "Hitchance (%)",
    Min = 0,
    Max = 100,
    Default = 100,
    Increment = 1,
    Callback = function(v) print("Hitchance:", v) end
})

Misc:AddSlider({
    Name = "Prediction X",
    Min = 0,
    Max = 5,
    Default = 1,
    Increment = 0.01,
    Callback = function(v) print("Silent X:", v) end
})

Misc:AddSlider({
    Name = "Prediction Y",
    Min = 0,
    Max = 5,
    Default = 1,
    Increment = 0.01,
    Callback = function(v) print("Silent Y:", v) end
})

Misc:AddDropdown({
    Name = "Prediction Method",
    Default = "Division",
    Options = {"Division", "Addition", "Subtraction", "Multiplication"},
    Callback = function(v) print("Silent Method:", v) end
})

Misc:AddToggle({
    Name = "Closest Part To Mouse",
    Default = false,
    Callback = function(v) print("Closest Part:", v) end
})

-- === TRIGGERBOT SECTION ===
Misc:AddSection({Name = "Triggerbot"})

Misc:AddToggle({
    Name = "Enabled",
    Default = false,
    Callback = function(v) print("Triggerbot:", v) end
})

Misc:AddSlider({
    Name = "Delay (ms)",
    Min = 0,
    Max = 500,
    Default = 0,
    Increment = 1,
    Callback = function(v) print("Delay:", v) end
})

Misc:AddSlider({
    Name = "Release Delay (s)",
    Min = 0,
    Max = 1,
    Default = 0,
    Increment = 0.01,
    Callback = function(v) print("Release Delay:", v) end
})

Misc:AddSlider({
    Name = "Scale",
    Min = 0,
    Max = 1,
    Default = 0.1,
    Increment = 0.01,
    Callback = function(v) print("Scale:", v) end
})

-- === INIT ===
OrionLib:Init()
