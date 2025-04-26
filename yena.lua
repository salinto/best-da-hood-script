--// Key System Variables
local Key = "juggyisgod"  -- Correct key to proceed
local KeySaved = false  -- Track whether the key has been saved
local KeyInput = ""  -- Store the user input key

--// Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local SoundService = game:GetService("SoundService")
local VirtualUser = game:GetService("VirtualUser")

--// Key System Setup
local function createKeyInputUI()
    -- If the key has been validated, remove the key input UI.
    if KeySaved then return end

    -- Create UI
    local KeyUI = Instance.new("ScreenGui")
    KeyUI.Name = "KeyUI"
    KeyUI.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(0, 300, 0, 50)
    TextBox.Position = UDim2.new(0.5, -150, 0.5, -25)
    TextBox.PlaceholderText = "Enter Key"
    TextBox.Parent = KeyUI

    local SubmitButton = Instance.new("TextButton")
    SubmitButton.Size = UDim2.new(0, 300, 0, 50)
    SubmitButton.Position = UDim2.new(0.5, -150, 0.5, 25)
    SubmitButton.Text = "Submit"
    SubmitButton.Parent = KeyUI

    -- Button Click Logic
    SubmitButton.MouseButton1Click:Connect(function()
        KeyInput = TextBox.Text
        if KeyInput == Key then
            KeySaved = true
            KeyUI:Destroy()  -- Remove the key input UI
            print("Key verified successfully!")
        else
            print("Invalid key! Please try again.")
            TextBox.Text = ""  -- Clear the input if it's wrong
        end
    end)
end

-- Show Key UI if the key isn't saved
if not KeySaved then
    createKeyInputUI()
else
    print("Key system validated.")
end

--// Combat Section (other features)
local ForcehitEnabled = false
local SpinbotEnabled = false
local SpinbotSpeed = 50
local VanishEnabled = false
local VanishMethod = "Float"
local AimbotEnabled = false
local FOVEnabled = false
local FOVSize = 100
local ESPEnabled = false
local SilentAimEnabled = false
local RapidFireEnabled = false -- <--- RAPID FIRE ADDED

--// UI Setup with Yena
local Window = Yena:CreateWindow({
    Name = "JuggyWare | Premium v1.2",
    LoadingTitle = "JuggyWare | Loading...",
    LoadingSubtitle = "by JuggyWare dev",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "JuggyWarePremium",
        FileName = "Settings"
    },
    Discord = {
        Enabled = false,
        Invite = "", -- Add Discord invite code here if you want
        RememberJoins = true
    },
    KeySystem = true,
    KeySettings = {
        Title = "JuggyWare | Key System",
        Subtitle = "Key = juggyisgod",
        Note = "Join Discord for key.",
        FileName = "juggyKeySave",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"juggyisgod"}
    }
})

--// Combat Tab UI Controls
local CombatTab = Window:CreateTab("Combat", 4483362458)
local MiscsTab = Window:CreateTab("Miscs", 4483362458)

local CombatSection = CombatTab:CreateSection("Main Combat Features")
local MiscsSection = MiscsTab:CreateSection("Visuals and Aim Assists")

--// Combat Section
CombatTab:CreateToggle({
    Name = "Forcehit",
    CurrentValue = false,
    Callback = function(Value)
        ForcehitEnabled = Value
    end,
})

CombatTab:CreateToggle({
    Name = "Spinbot",
    CurrentValue = false,
    Callback = function(Value)
        SpinbotEnabled = Value
    end,
})

CombatTab:CreateSlider({
    Name = "Spinbot Speed",
    Range = {0, 200},
    Increment = 5,
    Suffix = "°/s",
    CurrentValue = 50,
    Callback = function(Value)
        SpinbotSpeed = Value
    end,
})

CombatTab:CreateToggle({
    Name = "Rapid Fire", -- <<<<< Rapid Fire toggle
    CurrentValue = false,
    Callback = function(Value)
        RapidFireEnabled = Value
    end,
})

CombatTab:CreateToggle({
    Name = "Enable Vanish",
    CurrentValue = false,
    Callback = function(Value)
        VanishEnabled = Value
    end,
})

CombatTab:CreateDropdown({
    Name = "Vanish Method",
    Options = {"Float", "Blink", "Fade"},
    CurrentOption = "Float",
    Callback = function(Option)
        VanishMethod = Option
    end,
})

--// Miscs Section
MiscsTab:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = false,
    Callback = function(Value)
        AimbotEnabled = Value
    end,
})

MiscsTab:CreateToggle({
    Name = "Show FOV Circle",
    CurrentValue = false,
    Callback = function(Value)
        FOVEnabled = Value
    end,
})

MiscsTab:CreateSlider({
    Name = "FOV Size",
    Range = {50, 500},
    Increment = 5,
    Suffix = "px",
    CurrentValue = 100,
    Callback = function(Value)
        FOVSize = Value
    end,
})

MiscsTab:CreateToggle({
    Name = "Enable Skeleton ESP",
    CurrentValue = false,
    Callback = function(Value)
        ESPEnabled = Value
    end,
})

MiscsTab:CreateToggle({
    Name = "Enable Silent Aim",
    CurrentValue = false,
    Callback = function(Value)
        SilentAimEnabled = Value
    end,
})

--// Auto Update Check
local function checkForUpdate()
    local currentVersion = "1.2"
    local latestVersion = "1.3"
    if currentVersion ~= latestVersion then
        print("New update available!")
    end
end

checkForUpdate()

--// Render Loop
RunService.RenderStepped:Connect(function()
    -- Ensure the key system validation is handled
    if not KeySaved then return end  -- Do not run any features until key is validated

    -- Example: Implement features like Forcehit, FOV, etc. here.
end)
