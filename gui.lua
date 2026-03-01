-- GUI Mínima para Teste
local Aimbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/alfaezea/script-universal-1.0/main/aimbot.lua"))()
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/alfaezea/script-universal-1.0/main/esp.lua"))()

print("✅ Aimbot carregado: ", Aimbot)
print("✅ ESP carregado: ", ESP)

-- GUI simples
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.5, -100, 0.5, -50)
Frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
Frame.Parent = ScreenGui

local Texto = Instance.new("TextLabel")
Texto.Size = UDim2.new(1, 0, 0, 30)
Texto.Text = "TESTE FUNCIONOU!"
Texto.TextColor3 = Color3.fromRGB(255, 255, 255)
Texto.BackgroundTransparency = 1
Texto.Parent = Frame

print("✅ GUI de teste carregada!")
