--// Load Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Debug: Check if Rayfield is loading
if not Rayfield then
    print("Rayfield library failed to load.")
    return
else
    print("Rayfield loaded successfully!")
end

--// Key System (Make sure it's enabled correctly)
local KeySystemEnabled = true

local Window
if Rayfield then
    -- Create Window after key system is handled
    Window = Rayfield:CreateWindow({
        Name = "Jugg | Premium GUI",
        LoadingTitle = "Loading...",
        LoadingSubtitle = "by Jugg Dev",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "JuggPremium",
            FileName = "Settings"
        },
        Discord = {
            Enabled = false,
        },
        KeySystem = KeySystemEnabled,  -- Ensure the key system is ON
        KeySettings = {
            Title = "Jugg | Key System",
            Subtitle = "Key = JuggIsPro",
            Note = "Join Discord for the key.",
            FileName = "JuggKeySave",
            SaveKey = true,
            GrabKeyFromSite = false,
            Key = {"JuggIsPro"}  -- Key needed to unlock menu
        }
    })
else
    print("Rayfield failed to load.")
end

--// Debug: Check key system validation
local function checkKeySystem()
    if KeySystemEnabled then
        print("Key system is enabled. Waiting for key input.")
    else
        print("Key system is disabled. Showing menu directly.")
        Window:Show()  -- Show the menu directly if no key system is used
    end
end

-- Call the checkKeySystem function to log the state of the key system
checkKeySystem()

-- Function to Show Menu after Key validation
local function showMenu()
    if KeySystemEnabled then
        -- Display a message for debugging to confirm the key system is awaiting input
        print("Key system is enabled. Waiting for correct key.")
    else
        -- If Key system is not enabled, show the menu directly
        print("No key system enabled. Showing menu.")
        Window:Show()  -- Show menu directly
    end
end

-- Ensure to call the showMenu function to activate the menu after validation
showMenu()

--// Example Button to test functionality
Window:CreateButton({
    Name = "Test Button",  -- A simple test button to check if the menu works
    Callback = function()
        print("Test button clicked!")  -- This should show in the console when clicked
    end
})

