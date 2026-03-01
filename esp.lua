--[[
    GUI - VERSÃO CORRIGIDA
]]

local Aimbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/alfaezea/script-universal-1.0/main/aimbot.lua"))()
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/alfaezea/script-universal-1.0/main/esp.lua"))()

print("🔍 DEBUG - Aimbot:", Aimbot)
print("🔍 DEBUG - ESP:", ESP)

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GoldGUI"
ScreenGui.Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 200)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BackgroundTransparency = 0.1
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
Title.Text = "🎯 GOLD CHEAT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
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
    ScreenGui:Destroy()
end)

-- Botão Aimbot
local AimbotBtn = Instance.new("TextButton")
AimbotBtn.Size = UDim2.new(0.8, 0, 0, 35)
AimbotBtn.Position = UDim2.new(0.1, 0, 0, 50)
AimbotBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
AimbotBtn.Text = "🔫 AIMBOT: OFF"
AimbotBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotBtn.TextSize = 14
AimbotBtn.Font = Enum.Font.GothamBold
AimbotBtn.Parent = MainFrame

local AimbotCorner = Instance.new("UICorner")
AimbotCorner.CornerRadius = UDim.new(0, 6)
AimbotCorner.Parent = AimbotBtn

AimbotBtn.MouseButton1Click:Connect(function()
    if Aimbot and Aimbot.SetEnabled then
        local newState = not Aimbot.Enabled
        Aimbot.SetEnabled(newState)
        
        if newState then
            AimbotBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
            AimbotBtn.Text = "🔫 AIMBOT: ON"
        else
            AimbotBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            AimbotBtn.Text = "🔫 AIMBOT: OFF"
        end
        print("🎯 Aimbot alternado para:", newState)
    else
        warn("⚠️ Aimbot não responde!")
    end
end)

-- Botão ESP
local ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(0.8, 0, 0, 35)
ESPBtn.Position = UDim2.new(0.1, 0, 0, 95)
ESPBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
ESPBtn.Text = "👁️ ESP: OFF"
ESPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPBtn.TextSize = 14
ESPBtn.Font = Enum.Font.GothamBold
ESPBtn.Parent = MainFrame

local ESPCorner = Instance.new("UICorner")
ESPCorner.CornerRadius = UDim.new(0, 6)
ESPCorner.Parent = ESPBtn

ESPBtn.MouseButton1Click:Connect(function()
    if ESP and ESP.SetEnabled then
        local newState = not ESP.Enabled
        ESP.SetEnabled(newState)
        
        if newState then
            ESPBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
            ESPBtn.Text = "👁️ ESP: ON"
        else
            ESPBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            ESPBtn.Text = "👁️ ESP: OFF"
        end
        print("👁️ ESP alternado para:", newState)
    else
        warn("⚠️ ESP não responde!")
    end
end)

-- Info
local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, -20, 0, 20)
Info.Position = UDim2.new(0, 10, 1, -25)
Info.BackgroundTransparency = 1
Info.Text = "Mouse2: Ativar mira | P: Esconder GUI"
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

print("✅ GUI CARREGADA! Tudo pronto!")
