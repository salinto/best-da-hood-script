--// Load Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

--// Check if Rayfield is loaded
if not Rayfield then
    print("Rayfield failed to load!")
    return
else
    print("Rayfield loaded successfully.")
end

--// Create Window with Key System
local Window = Rayfield:CreateWindow({
    Name = "Jugg | Premium GUI",
    LoadingTitle = "Loading Jugg GUI...",
    LoadingSubtitle = "by Jugg Dev",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "JuggPremium",
        FileName = "Settings"
    },
    Discord = {
        Enabled = false,
    },
    KeySystem = true,  -- Enable Key System
    KeySettings = {
        Title = "Jugg | Key System",
        Subtitle = "Enter key to continue...",
        Note = "Key = JuggIsPro",  -- The key users need to enter
        FileName = "JuggKeySave",  -- Save key file
        SaveKey = true,  -- Save key input for future use
        GrabKeyFromSite = false,
        Key = {"JuggIsPro"}  -- The key to unlock the menu
    }
})

--// Once the key is entered correctly, the GUI will show
Window:CreateButton({
    Name = "Test Button",  -- A simple button for testing
    Callback = function()
        print("Test button clicked!")  -- Message shown when clicked
    end
})

-- Check if the Key System works
local function checkKeySystem()
    if not Rayfield then
        return "Rayfield not loaded!"
    end

    if Window then
        -- Debugging messages based on KeySystem status
        print("Key system is enabled.")
    else
        print("Window not created.")
    end
end

-- Check if key system and window are working
checkKeySystem()
