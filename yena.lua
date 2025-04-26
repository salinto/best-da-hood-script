local TweenService = game:GetService('TweenService')
local UserInputService = game:GetService('UserInputService')

-- Ensure that the Library is available
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua'))()
local ThemeManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/SaveManager.lua'))()

-- Toggle for Mouse Cursor Visibility
local mouseCursorEnabled = true -- Start with the cursor enabled

-- Function to toggle the mouse cursor
local function toggleMouseCursor()
    mouseCursorEnabled = not mouseCursorEnabled
    UserInputService.MouseIconEnabled = mouseCursorEnabled
end

-- Basic GUI Setup
local Window = Library:CreateWindow({
    Title = 'Etiquette Internal',
    Center = true,
    AutoShow = true,
    Size = Vector2.new(320, 240),  -- Window size for mobile and PC
})

-- Add a button to toggle the cursor visibility
Window:AddButton('Toggle Cursor', function()
    toggleMouseCursor()
end)

-- Create Tabs
local MainTab = Window:AddTab('Main')
local WeaponsTab = Window:AddTab('Weapons')
local ModificationsTab = Window:AddTab('Mods')
local SettingsTab = Window:AddTab('Settings')

-- Aimbot Settings
local AimbotGroup = MainTab:AddLeftGroupbox('Aimbot')

AimbotGroup:AddToggle('Enable', { Text = 'Enable', Default = false })
AimbotGroup:AddToggle('ClosestPart', { Text = 'Closest Part', Default = true })
AimbotGroup:AddToggle('StickyAim', { Text = 'Sticky Aim', Default = false })

AimbotGroup:AddDivider()

AimbotGroup:AddSlider('PredictionX', {
    Text = 'Prediction X',
    Default = 5,
    Min = 0,
    Max = 10,
    Rounding = 1,
})

AimbotGroup:AddSlider('PredictionY', {
    Text = 'Prediction Y',
    Default = 5,
    Min = 0,
    Max = 10,
    Rounding = 1,
})

AimbotGroup:AddDivider()

AimbotGroup:AddSlider('FOV', {
    Text = 'Aimbot FOV',
    Default = 100,
    Min = 10,
    Max = 300,
    Rounding = 0,
})

AimbotGroup:AddDropdown('HitPart', {
    Values = { 'Head', 'Torso', 'Legs' },
    Default = 1,
    Multi = false,
    Text = 'Hit Part',
})

-- Minimize Button
local Minimized = false
local FullSize = Window._window.Size
local MinimizedSize = Vector2.new(320, 50)

local function SmoothResize(sizeGoal)
    local tween = TweenService:Create(Window._window, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = sizeGoal})
    tween:Play()
end

local TitleBar = Window._window:FindFirstChild('Topbar')
if TitleBar then
    local MinimizeButton = Instance.new('TextButton')
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -50, 0, 5)
    MinimizeButton.BackgroundTransparency = 0.5
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    MinimizeButton.Text = "-"
    MinimizeButton.Font = Enum.Font.SourceSansBold
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.TextSize = 24
    MinimizeButton.Parent = TitleBar

    MinimizeButton.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        if Minimized then
            SmoothResize(MinimizedSize)
        else
            SmoothResize(FullSize)
        end
    end)
end

-- Theme and Save Manager
ThemeManager:SetLibrary(Library)
ThemeManager:LoadDefault()

SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder('EtiquetteInternal')
SaveManager:BuildConfigSection(SettingsTab)

-- Make the window draggable
local dragging = false
local dragInput, dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Window._window.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Window._window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
