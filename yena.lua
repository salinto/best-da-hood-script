--// Key System Variables
local Key = "juggyisgod"  -- Correct key to proceed
local KeySaved = false  -- Track whether the key has been saved
local KeyInput = nil  -- Store the user input key

--// Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local SoundService = game:GetService("SoundService")
local VirtualUser = game:GetService("VirtualUser")

--// Variables
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
local Prediction = 0.165
local RapidFireEnabled = false -- <--- RAPID FIRE ADDED

local hitSound = Instance.new("Sound") -- Hit sound
hitSound.SoundId = "rbxassetid://1234567890" -- Replace with your sound ID
hitSound.Volume = 0.5
hitSound.Parent = SoundService

--// FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Transparency = 0.5
FOVCircle.Visible = false

--// Key System Setup
local function createKeyInputUI()
    -- If the key has been validated, remove the key input UI.
    if KeySaved then return end

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

-- Check if the key is saved or prompt for input
if not KeySaved then
    createKeyInputUI()
else
    print("Key system validated.")
end

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
        FOVCircle.Visible = Value
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

    if FOVEnabled then
        FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
        FOVCircle.Radius = FOVSize
    end

    if SpinbotEnabled then
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(SpinbotSpeed), 0)
        end
    end

    if RapidFireEnabled then -- <<<<< Rapid Fire active during every frame
        VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end

    -- ESP Skeletons
    for player, skeleton in pairs(Skeletons) do
        local character = player.Character
        if character and ESPEnabled then
            local rootPos, onScreen = Camera:WorldToViewportPoint(character.HumanoidRootPart.Position)
            if onScreen then
                local parts = {
                    Head = character:FindFirstChild("Head"),
                    Torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso"),
                    ["Left Arm"] = character:FindFirstChild("LeftUpperArm") or character:FindFirstChild("Left Arm"),
                    ["Right Arm"] = character:FindFirstChild("RightUpperArm") or character:FindFirstChild("Right Arm"),
                    ["Left Leg"] = character:FindFirstChild("LeftUpperLeg") or character:FindFirstChild("Left Leg"),
                    ["Right Leg"] = character:FindFirstChild("RightUpperLeg") or character:FindFirstChild("Right Leg"),
                }

                if parts.Head and parts.Torso then
                    skeleton.Head.From = Camera:WorldToViewportPoint(parts.Head.Position)
                    skeleton.Head.To = Camera:WorldToViewportPoint(parts.Torso.Position)
                    skeleton.Head.Visible = true
                end
                if parts.LeftArm and parts.Torso then
                    skeleton["Left Arm"].From = Camera:WorldToViewportPoint(parts.LeftArm.Position)
                    skeleton["Left Arm"].To = Camera:WorldToViewportPoint(parts.Torso.Position)
                    skeleton["Left Arm"].Visible = true
                end
                if parts.RightArm and parts.Torso then
                    skeleton["Right Arm"].From = Camera:WorldToViewportPoint(parts.RightArm.Position)
                    skeleton["Right Arm"].To = Camera:WorldToViewportPoint(parts.Torso.Position)
                    skeleton["Right Arm"].Visible = true
                end
                if parts.LeftLeg and parts.Torso then
                    skeleton["Left Leg"].From = Camera:WorldToViewportPoint(parts.LeftLeg.Position)
                    skeleton["Left Leg"].To = Camera:WorldToViewportPoint(parts.Torso.Position)
                    skeleton["Left Leg"].Visible = true
                end
                if parts.RightLeg and parts.Torso then
                    skeleton["Right Leg"].From = Camera:WorldToViewportPoint(parts.RightLeg.Position)
                    skeleton["Right Leg"].To = Camera:WorldToViewportPoint(parts.Torso.Position)
                    skeleton["Right Leg"].Visible = true
                end
            else
                for _, line in pairs(skeleton) do
                    line.Visible = false
                end
            end
        else
            for _, line in pairs(skeleton) do
                line.Visible = false
            end
        end
    end
end)
