--// Load Rayfield Library
local Rayfield
local success, err = pcall(function()
    Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success then
    warn("Rayfield library failed to load! Error: " .. err)
    return
end

--// Key System Setup
local key = "JuggIsPro"  -- The key that will unlock the GUI

local function onKeyEntered(input)
    -- Check if the entered key matches the required one
    if input == key then
        -- If the key is correct, create the GUI window
        local Window = Rayfield:CreateWindow({
            Name = "Jugg Premium GUI",
            LoadingTitle = "Loading...",
            LoadingSubtitle = "by Jugg Dev",
            ConfigurationSaving = {
                Enabled = true,
                FolderName = "JuggPremium",
                FileName = "Settings"
            },
            Discord = {
                Enabled = false
            },
            KeySystem = false  -- Disable key system once it's passed
        })

        -- Add a test button to ensure GUI is created
        Window:CreateButton({
            Name = "Test Button",
            Callback = function()
                print("Test button clicked!")
            end
        })
        print("GUI Loaded Successfully!")
    else
        print("Incorrect Key! Try Again.")
    end
end

--// Create a simple key input box (GUI will be shown here if key is correct)
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer.PlayerGui

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0, 200, 0, 50)
textBox.Position = UDim2.new(0.5, -100, 0.5, -25)
textBox.Text = "Enter Key..."
textBox.Parent = screenGui

local submitButton = Instance.new("TextButton")
submitButton.Size = UDim2.new(0, 200, 0, 50)
submitButton.Position = UDim2.new(0.5, -100, 0.5, 25)
submitButton.Text = "Submit"
submitButton.Parent = screenGui

submitButton.MouseButton1Click:Connect(function()
    local input = textBox.Text
    onKeyEntered(input)
end)
