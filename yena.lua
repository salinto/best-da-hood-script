--// Load Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

--// Check if Rayfield is loaded
if not Rayfield then
    print("Rayfield failed to load!")
else
    print("Rayfield loaded successfully!")
end

--// Create Window
local Window = Rayfield:CreateWindow({
   Name = "Jugg | Premium GUI",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "by Jugg Dev",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "JuggPremium",
      FileName = "Settings"
   },
   Discord = {Enabled = false},
   KeySystem = true,
   KeySettings = {
      Title = "Jugg | Key System",
      Subtitle = "Key = JuggIsPro",
      Note = "Join Discord for key.",
      FileName = "JuggKeySave",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"JuggIsPro"}
   }
})

--// Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

--// Variables
local FOVEnabled = false
local FOVSize = 100
local RapidFireEnabled = false
local isFiring = false

--// Create FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Transparency = 0.5
FOVCircle.Visible = false

--// FOV Circle Update (Position and Size)
local function updateFOVCircle()
    if FOVEnabled then
        FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36) -- Position of the circle near the mouse
        FOVCircle.Radius = FOVSize
    end
end

--// Rapid Fire Implementation
local function rapidFire()
    if RapidFireEnabled then
        if isFiring then
            -- Simulate shooting every 0.1 second when rapid fire is enabled
            fire()
            wait(0.1)
        end
    end
end

--// Key Handling for Rapid Fire (Hold MouseButton1 to activate)
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isFiring = true
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isFiring = false
    end
end)

--// GUI Controls for FOV and Rapid Fire
local CombatTab = Window:CreateTab("Combat", 4483362458)
local CombatSection = CombatTab:CreateSection("Main Combat Features")

-- Toggle for FOV Circle
CombatTab:CreateToggle({
    Name = "Enable FOV Circle",
    CurrentValue = false,
    Callback = function(Value)
        FOVEnabled = Value
        FOVCircle.Visible = Value
        print("FOV Circle Visible:", FOVEnabled)
    end,
})

-- Slider for FOV Size
CombatTab:CreateSlider({
    Name = "FOV Size",
    Range = {50, 500},
    Increment = 5,
    Suffix = "px",
    CurrentValue = 100,
    Callback = function(Value)
        FOVSize = Value
        print("FOV Size:", FOVSize)
    end,
})

-- Toggle for Rapid Fire
CombatTab:CreateToggle({
    Name = "Enable Rapid Fire",
    CurrentValue = false,
    Callback = function(Value)
        RapidFireEnabled = Value
        print("Rapid Fire enabled:", RapidFireEnabled)
    end,
})

--// Main Loop for Updates
RunService.RenderStepped:Connect(function()
    -- Update FOV Circle
    updateFOVCircle()

    -- Handle Rapid Fire
    rapidFire()
end)
