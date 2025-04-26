--// Load Rayfield Library (Make sure you have the correct URL)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

--// Creating the main window
local Window = Rayfield:CreateWindow({
   Name = "Jugg | Premium GUI",  -- Name of the window
   LoadingTitle = "Jugg | Loading...",
   LoadingSubtitle = "by Jugg Dev",
   ConfigurationSaving = {
      Enabled = true,  -- Enable configuration saving
      FolderName = "JuggPremium",
      FileName = "Settings"
   },
   Discord = {
      Enabled = false,
      Invite = "",  -- Add Discord invite if you want
      RememberJoins = true
   },
   KeySystem = true,  -- Enable key system
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

--// GUI Tabs (Combat, Miscs, and Visuals)
local CombatTab = Window:CreateTab("Combat", 4483362458)
local MiscsTab = Window:CreateTab("Miscs", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)

--// Combat Section (Toggle Aimbot, Rapid Fire, etc.)
local CombatSection = CombatTab:CreateSection("Main Combat Features")
CombatTab:CreateToggle({
   Name = "Enable Aimbot",
   CurrentValue = false,
   Callback = function(Value)
      -- Code to enable/disable aimbot
   end,
})

CombatTab:CreateToggle({
   Name = "Enable Rapid Fire",
   CurrentValue = false,
   Callback = function(Value)
      -- Code to enable/disable rapid fire
   end,
})

CombatTab:CreateToggle({
   Name = "Enable Silent Aim",
   CurrentValue = false,
   Callback = function(Value)
      -- Code to enable/disable silent aim
   end,
})

--// Miscs Section (FOV, Skeleton ESP, etc.)
local MiscsSection = MiscsTab:CreateSection("Visuals and Aim Assists")
MiscsTab:CreateToggle({
   Name = "Show FOV Circle",
   CurrentValue = false,
   Callback = function(Value)
      -- Code to show/hide FOV circle
   end,
})

MiscsTab:CreateSlider({
   Name = "FOV Size",
   Range = {50, 500},
   Increment = 5,
   Suffix = "px",
   CurrentValue = 100,
   Callback = function(Value)
      -- Code to set FOV size
   end,
})

MiscsTab:CreateToggle({
   Name = "Enable Skeleton ESP",
   CurrentValue = false,
   Callback = function(Value)
      -- Code to enable/disable skeleton ESP
   end,
})

--// Visuals Section (Customizable)
local VisualsSection = VisualsTab:CreateSection("Custom Visuals")
VisualsTab:CreateToggle({
   Name = "Enable Player ESP",
   CurrentValue = false,
   Callback = function(Value)
      -- Code to enable/disable ESP for players
   end,
})

--// Keybind Setup (for features like Rapid Fire, Aimbot, etc.)
local KeybindSection = VisualsTab:CreateSection("Keybinds")
VisualsTab:CreateKeybind({
   Name = "Toggle Rapid Fire",
   CurrentKey = Enum.KeyCode.F,
   Callback = function(Key)
      -- Code to toggle rapid fire using the assigned key
   end,
})

VisualsTab:CreateKeybind({
   Name = "Toggle Aimbot",
   CurrentKey = Enum.KeyCode.Q,
   Callback = function(Key)
      -- Code to toggle aimbot using the assigned key
   end,
})

--// Render Loop (For FOV Circle, Aimbot, etc.)
RunService.RenderStepped:Connect(function()
   -- Update and render features
   -- Example: Update FOV Circle position and size
   if FOVEnabled then
      FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
      FOVCircle.Radius = FOVSize
   end
end)
