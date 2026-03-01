--[[
    GUI para AirHub Aimbot
]]

-- Carregar o módulo do aimbot
local Aimbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/alfaezea/script-universal-1.0/main/aimbot.lua"))()

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AirHubGUI"
ScreenGui.Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 150)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
Title.Text = "🎯 AirHub Aimbot"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Fechar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Parent = Title
CloseBtn.MouseButton1Click:Connect(function()
    Aimbot.Functions:Exit()
    ScreenGui:Destroy()
end)

-- Botão Ativar
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 35)
ToggleBtn.Position = UDim2.new(0.1, 0, 0, 50)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
ToggleBtn.Text = "🔫 ATIVAR AIMBOT"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 14
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = ToggleBtn

-- Estado atual
local isActive = false

ToggleBtn.MouseButton1Click:Connect(function()
    isActive = not isActive
    Aimbot.Settings.Enabled = isActive
    
    if isActive then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
        ToggleBtn.Text = "🔫 AIMBOT ATIVO"
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        ToggleBtn.Text = "🔫 ATIVAR AIMBOT"
    end
    print("🎯 Aimbot:", isActive and "ATIVADO" or "DESATIVADO")
end)

-- Botão Team Check
local TeamBtn = Instance.new("TextButton")
TeamBtn.Size = UDim2.new(0.35, 0, 0, 25)
TeamBtn.Position = UDim2.new(0.1, 0, 0, 95)
TeamBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
TeamBtn.Text = "Team"
TeamBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TeamBtn.TextSize = 12
TeamBtn.Font = Enum.Font.GothamBold
TeamBtn.Parent = MainFrame

local TeamCorner = Instance.new("UICorner")
TeamCorner.CornerRadius = UDim.new(0, 4)
TeamCorner.Parent = TeamBtn

TeamBtn.MouseButton1Click:Connect(function()
    Aimbot.Settings.TeamCheck = not Aimbot.Settings.TeamCheck
    TeamBtn.BackgroundColor3 = Aimbot.Settings.TeamCheck and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(50, 50, 60)
end)

-- Botão Wall Check
local WallBtn = Instance.new("TextButton")
WallBtn.Size = UDim2.new(0.35, 0, 0, 25)
WallBtn.Position = UDim2.new(0.55, 0, 0, 95)
WallBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
WallBtn.Text = "Wall"
WallBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
WallBtn.TextSize = 12
WallBtn.Font = Enum.Font.GothamBold
WallBtn.Parent = MainFrame

local WallCorner = Instance.new("UICorner")
WallCorner.CornerRadius = UDim.new(0, 4)
WallCorner.Parent = WallBtn

WallBtn.MouseButton1Click:Connect(function()
    Aimbot.Settings.WallCheck = not Aimbot.Settings.WallCheck
    WallBtn.BackgroundColor3 = Aimbot.Settings.WallCheck and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(50, 50, 60)
end)

-- Info
local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, -20, 0, 20)
Info.Position = UDim2.new(0, 10, 1, -25)
Info.BackgroundTransparency = 1
Info.Text = "Mouse2: Ativar | P: Esconder"
Info.TextColor3 = Color3.fromRGB(150, 150, 150)
Info.TextSize = 10
Info.Font = Enum.Font.Gotham
Info.Parent = MainFrame

-- Tecla P
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.P then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("✅ GUI AirHub carregada!")
