--// Load Rayfield Library
local Rayfield
local success, err = pcall(function()
    Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success then
    warn("Rayfield library failed to load! Error: " .. err)
    return
end

--// Key system setup
local correctKey = "JuggIsPro"  -- Set your key here
local keyEntered = false  -- Flag to track if the key was entered

--// Create the Key Input GUI (Before Rayfield GUI is visible)
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer.PlayerGui

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0, 300, 0, 50)
textBox.Position = UDim2.new(0.5, -150, 0.5, -100)
textBox.Text = "Enter Key..."
textBox.Parent = screenGui

local submitButton = Instance.new("TextButton")
submitButton.Size = UDim2.new(0, 300, 0, 50)
submitButton.Position = UDim2.new(0.5, -150, 0.5, 50)
submitButton.Text = "Submit"
submitButton.Parent = screenGui

--// Key input callback function
submitButton.MouseButton1Click:Connect(function()
    local input = textBox.Text
    if input == correctKey then
        keyEntered = true
        screenGui:Destroy()  -- Remove the key input screen
        -- Create the Rayfield GUI after correct key
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
                Enabled = false,
                Invite = "",
            },
            KeySystem = false  -- Disable key system after key is entered
        })

        -- Create a basic button as an example of working GUI
        Window:CreateButton({
            Name = "Test Button",
            Callback = function()
                print("Test Button Clicked!")
            end
        })

        -- Optional: Add more UI components here as needed
        print("GUI Loaded Successfully!")
    else
        textBox.Text = "Incorrect Key! Try Again."
    end
end)
