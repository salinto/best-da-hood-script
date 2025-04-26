--// Fancy UI Menu by ChatGPT (KRNL + Delta ready)

local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FancyMenu"

pcall(function()
    ScreenGui.Parent = game.CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Parent = ScreenGui

-- UICorner
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Dragging
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Tabs
local Tabs = Instance.new("Frame")
Tabs.Size = UDim2.new(0, 120, 1, 0)
Tabs.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Tabs.BorderSizePixel = 0
Tabs.Parent = MainFrame

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 10)
UICorner2.Parent = Tabs

-- Pages
local Pages = Instance.new("Frame")
Pages.Size = UDim2.new(1, -120, 1, 0)
Pages.Position = UDim2.new(0, 120, 0, 0)
Pages.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Pages.BorderSizePixel = 0
Pages.Parent = MainFrame

local UICorner3 = Instance.new("UICorner")
UICorner3.CornerRadius = UDim.new(0, 10)
UICorner3.Parent = Pages

-- UIListLayout for Tabs
local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = Tabs
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 10)

-- Functions
local function CreateTab(name)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0, 50)
    TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.Font = Enum.Font.GothamBold
    TabButton.TextSize = 14
    TabButton.Text = name
    TabButton.Parent = Tabs

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 5
    Page.Parent = Pages

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Parent = Page
    PageLayout.Padding = UDim.new(0, 10)
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder

    TabButton.MouseButton1Click:Connect(function()
        for _, page in pairs(Pages:GetChildren()) do
            if page:IsA("ScrollingFrame") then
                page.Visible = false
            end
        end
        Page.Visible = true
    end)

    return Page
end

local function CreateToggle(parent, text)
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(1, -20, 0, 40)
    Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Toggle.Font = Enum.Font.Gotham
    Toggle.TextSize = 14
    Toggle.Text = "[OFF] " .. text
    Toggle.Parent = parent

    local toggled = false
    Toggle.MouseButton1Click:Connect(function()
        toggled = not toggled
        if toggled then
            Toggle.Text = "[ON] " .. text
            Toggle.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
        else
            Toggle.Text = "[OFF] " .. text
            Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end
    end)
end

local function CreateSlider(parent, text, min, max)
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, -20, 0, 40)
    SliderLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.TextSize = 14
    SliderLabel.Text = text .. ": " .. tostring(max)
    SliderLabel.Parent = parent
end

local function CreateDropdown(parent, text, options)
    local DropButton = Instance.new("TextButton")
    DropButton.Size = UDim2.new(1, -20, 0, 40)
    DropButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    DropButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropButton.Font = Enum.Font.Gotham
    DropButton.TextSize = 14
    DropButton.Text = text .. ": " .. options[1]
    DropButton.Parent = parent

    local index = 1
    DropButton.MouseButton1Click:Connect(function()
        index = index + 1
        if index > #options then
            index = 1
        end
        DropButton.Text = text .. ": " .. options[index]
    end)
end

--// Create Tabs
local MainPage = CreateTab("Main")
local SettingsPage = CreateTab("Settings")
local FovPage = CreateTab("Fov Circle")

-- Show Main tab by default
Pages:FindFirstChildOfClass("ScrollingFrame").Visible = true

--// Add items to Main
CreateToggle(MainPage, "Silent Aim")
CreateToggle(MainPage, "Trigger Bot")

--// Add items to Settings
CreateToggle(SettingsPage, "Team Check")
CreateSlider(SettingsPage, "Hit Chance", 0, 100)
CreateDropdown(SettingsPage, "Hit Part", {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart"})

--// Add items to Fov Circle
CreateToggle(FovPage, "Show Fov Circle")
CreateSlider(FovPage, "Fov Circle Size", 0, 1000)
