--// Load Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

--// Creating the main window
local Window = Rayfield:CreateWindow({
   Name = "Jugg | Premium GUI",
   LoadingTitle = "Jugg | Loading...",
   LoadingSubtitle = "by Jugg Dev",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "JuggPremium",
      FileName = "Settings"
   },
   Discord = {
      Enabled = false,
      Invite = "", -- Discord invite link
      RememberJoins = true
   },
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

--// Variables for Aimbot, Silent Aim, FOV, and Rapid Fire
local AimbotEnabled = false
local SilentAimEnabled = false
local FOVEnabled = false
local FOVSize = 100
local RapidFireEnabled = false

--// FOV Circle for Aimbot
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Transparency = 0.5
FOVCircle.Visible = false

--// Rapid Fire
local function rapidFire()
   if RapidFireEnabled then
      game:GetService("UserInputService").InputBegan:Connect(function(input)
         if input.UserInputType == Enum.UserInputType.MouseButton1 then
            while input.UserInputType == Enum.UserInputType.MouseButton1 do
               -- Perform rapid fire logic here, like simulating clicking every frame
               fire()
               wait(0.1) -- Adjust the fire speed here
            end
         end
      end)
   end
end

--// Aimbot Targeting System (Find closest player to mouse)
local function getClosestPlayer()
    local closestPlayer = nil
    local closestDistance = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                if distance < closestDistance and distance <= FOVSize then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    return closestPlayer
end

--// Silent Aim System (Predict and lock on closest player)
local function silentAim()
   local closestPlayer = getClosestPlayer()
   if closestPlayer and closestPlayer.Character then
      -- Implement silent aim, target the closest player with prediction
      local predPos = closestPlayer.Character.HumanoidRootPart.Position + (closestPlayer.Character.HumanoidRootPart.Velocity * 0.15)
      -- Add logic to simulate a shot at the predicted position
   end
end

--// GUI Setup (Combat Tab, Toggle Aimbot, Silent Aim, Rapid Fire)
local CombatTab = Window:CreateTab("Combat", 4483362458)

local CombatSection = CombatTab:CreateSection("Main Combat Features")

CombatTab:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = false,
    Callback = function(Value)
        AimbotEnabled = Value
    end,
})

CombatTab:CreateToggle({
    Name = "Enable Silent Aim",
    CurrentValue = false,
    Callback = function(Value)
        SilentAimEnabled = Value
    end,
})

CombatTab:CreateToggle({
    Name = "Enable Rapid Fire",
    CurrentValue = false,
    Callback = function(Value)
        RapidFireEnabled = Value
    end,
})

--// FOV Settings
local MiscsTab = Window:CreateTab("Miscs", 4483362458)
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

--// Render Loop (Update FOV Circle)
RunService.RenderStepped:Connect(function()
   if FOVEnabled then
      FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
      FOVCircle.Radius = FOVSize
   end

   -- Perform aimbot and silent aim checks
   if AimbotEnabled then
      local closestPlayer = getClosestPlayer()
      if closestPlayer and closestPlayer.Character then
         -- Aim at the closest player's HumanoidRootPart
         local targetPos = closestPlayer.Character.HumanoidRootPart.Position
         -- Logic to move the aim towards the target position
      end
   end

   -- Perform Silent Aim
   if SilentAimEnabled then
      silentAim()
   end

   -- Enable rapid fire
   rapidFire()
end)
