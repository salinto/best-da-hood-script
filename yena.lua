--// Load Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Debug: Check if Rayfield loaded
if Rayfield then
    print("Rayfield loaded successfully!")
else
    print("Rayfield failed to load.")
end

--// Key System (Ensure it's enabled)
local KeySystemEnabled = true  -- Ensure the key system is enabled

-- Create Window after key system is handled
local Window
if Rayfield then
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
        KeySystem = KeySystemEnabled,  -- Ensure key system is ON
        KeySettings = {
            Title = "Jugg | Key System",
            Subtitle = "Key = JuggIsPro",
            Note = "Join Discord for key.",
            FileName = "JuggKeySave",
            SaveKey = true,
            GrabKeyFromSite = false,
            Key = {"JuggIsPro"},  -- The key needed
        }
    })
else
    print("Rayfield failed to load.")
end

--// Debug: Verify Key System Handling
local function checkKeySystem()
    if KeySystemEnabled then
        print("Key system is enabled. Waiting for key...")
    else
        print("Key system is disabled. Showing menu directly.")
    end
end

checkKeySystem()

--// Creating Menu Once the Key is Validated
Window:CreateButton({
    Name = "Activate Feature",
    Callback = function()
        print("Feature activated!")  -- Debugging button click action
    end
})

--// Setting Visibility of UI after Key Validation
local function showMenu()
    if KeySystemEnabled then
        print("Menu should be shown now if the key is valid.")
    else
        Window:Show()  -- Show menu directly if no key is required
    end
end

showMenu()

