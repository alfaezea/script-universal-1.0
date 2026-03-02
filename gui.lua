--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║              PREMIUM HUB - AIRHUB EDITION                 ║
    ║                    By: DeepSeek AI                        ║
    ╚═══════════════════════════════════════════════════════════╝
]]

-- ========== FUNÇÃO SEGURA PARA CARREGAR MÓDULOS ==========
local function loadModule(url, name)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success and result and #result > 0 then
        local func, err = loadstring(result)
        if func then
            local success2, result2 = pcall(func)
            if success2 then
                print("✅ " .. name .. " carregado com sucesso!")
                return true
            else
                warn("❌ Erro ao executar " .. name .. ": " .. tostring(result2))
                return false
            end
        else
            warn("❌ Erro de sintaxe em " .. name .. ": " .. tostring(err))
            return false
        end
    else
        warn("❌ Falha ao baixar " .. name)
        return false
    end
end

-- ========== CARREGAR SEUS MÓDULOS ==========
print("🔄 Carregando módulos do AirHub...")

loadModule("https://raw.githubusercontent.com/alfaezea/script-universal-1.0/refs/heads/main/aimbot.lua", "Aimbot")
loadModule("https://raw.githubusercontent.com/alfaezea/script-universal-1.0/refs/heads/main/esp.lua", "ESP")
loadModule("https://raw.githubusercontent.com/alfaezea/script-universal-1.0/refs/heads/main/hitbox.lua", "Hitbox")

-- Aguardar carregamento
task.wait(1)

-- ========== OBTER REFERÊNCIAS DOS MÓDULOS ==========
local Aimbot = getgenv().AirHub and getgenv().AirHub.Aimbot
local ESP = getgenv().AirHub and getgenv().AirHub.WallHack
local Hitbox = getgenv().LimbExtender

-- ========== VERIFICAR MÓDULOS CARREGADOS ==========
print("🔍 Aimbot:", Aimbot and "✅" or "❌")
print("🔍 ESP:", ESP and "✅" or "❌")
print("🔍 Hitbox:", Hitbox and "✅" or "❌")

-- Se nenhum módulo carregou, mostrar erro
if not Aimbot and not ESP and not Hitbox then
    warn("❌ NENHUM MÓDULO FOI CARREGADO!")
    warn("Verifique se as URLs estão corretas e os scripts existem")
    return
end

-- ========== SISTEMA DE FLY (EMBUTIDO) ==========
local Fly = {
    Enabled = false,
    Speed = 50,
    BodyGyro = nil,
    BodyVelocity = nil,
    Connection = nil
}

local function ToggleFly(state)
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")

    if not humanoid or not rootPart then return end

    if state then
        humanoid.PlatformStand = true

        Fly.BodyGyro = Instance.new("BodyGyro")
        Fly.BodyGyro.P = 9e4
        Fly.BodyGyro.MaxTorque = Vector3.new(9e4, 9e4, 9e4)
        Fly.BodyGyro.CFrame = rootPart.CFrame
        Fly.BodyGyro.Parent = rootPart

        Fly.BodyVelocity = Instance.new("BodyVelocity")
        Fly.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        Fly.BodyVelocity.MaxForce = Vector3.new(9e4, 9e4, 9e4)
        Fly.BodyVelocity.Parent = rootPart

        Fly.Connection = game:GetService("RunService").RenderStepped:Connect(function()
            if not Fly.Enabled then return end

            local move = Vector3.new(0, 0, 0)
            local cam = workspace.CurrentCamera.CFrame

            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then move = move + cam.LookVector end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then move = move - cam.LookVector end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then move = move - cam.RightVector end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then move = move + cam.RightVector end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then move = move + Vector3.new(0, -1, 0) end

            if move.Magnitude > 0 then
                move = move.Unit * Fly.Speed
            end

            Fly.BodyVelocity.Velocity = move
            Fly.BodyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + cam.LookVector)
        end)

        Fly.Enabled = true
        print("✅ Fly ATIVADO")
    else
        humanoid.PlatformStand = false
        if Fly.BodyGyro then Fly.BodyGyro:Destroy() end
        if Fly.BodyVelocity then Fly.BodyVelocity:Destroy() end
        if Fly.Connection then Fly.Connection:Disconnect() end
        Fly.Enabled = false
        print("❌ Fly DESATIVADO")
    end
end

-- ========== SISTEMA SIMPLES DE GUI (SEM BIBLIOTECA) ==========
-- Criando uma GUI simples manualmente já que não temos a library

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AirHubPremium"
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 550)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -275)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Title.BorderSizePixel = 0
Title.Text = "AirHub Premium"
Title.TextColor3 = Color3.fromRGB(255, 117, 24)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Status dos módulos
local StatusFrame = Instance.new("Frame")
StatusFrame.Size = UDim2.new(1, -20, 0, 80)
StatusFrame.Position = UDim2.new(0, 10, 0, 50)
StatusFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
StatusFrame.BorderSizePixel = 0
StatusFrame.Parent = MainFrame

local StatusTitle = Instance.new("TextLabel")
StatusTitle.Size = UDim2.new(1, 0, 0, 25)
StatusTitle.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
StatusTitle.BorderSizePixel = 0
StatusTitle.Text = "Status dos Módulos"
StatusTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusTitle.TextScaled = true
StatusTitle.Font = Enum.Font.Gotham
StatusTitle.Parent = StatusFrame

local AimbotStatus = Instance.new("TextLabel")
AimbotStatus.Size = UDim2.new(1, 0, 0, 20)
AimbotStatus.Position = UDim2.new(0, 10, 0, 30)
AimbotStatus.BackgroundTransparency = 1
AimbotStatus.Text = "Aimbot: " .. (Aimbot and "✅ ATIVO" or "❌ FALHA")
AimbotStatus.TextColor3 = Aimbot and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
AimbotStatus.TextXAlignment = Enum.TextXAlignment.Left
AimbotStatus.TextScaled = true
AimbotStatus.Font = Enum.Font.Gotham
AimbotStatus.Parent = StatusFrame

local ESPStatus = Instance.new("TextLabel")
ESPStatus.Size = UDim2.new(1, 0, 0, 20)
ESPStatus.Position = UDim2.new(0, 10, 0, 50)
ESPStatus.BackgroundTransparency = 1
ESPStatus.Text = "ESP: " .. (ESP and "✅ ATIVO" or "❌ FALHA")
ESPStatus.TextColor3 = ESP and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
ESPStatus.TextXAlignment = Enum.TextXAlignment.Left
ESPStatus.TextScaled = true
ESPStatus.Font = Enum.Font.Gotham
ESPStatus.Parent = StatusFrame

-- Botão Fly
local FlyButton = Instance.new("TextButton")
FlyButton.Size = UDim2.new(0, 150, 0, 40)
FlyButton.Position = UDim2.new(0, 10, 0, 140)
FlyButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
FlyButton.BorderSizePixel = 0
FlyButton.Text = "Ativar Fly"
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.TextScaled = true
FlyButton.Font = Enum.Font.Gotham
FlyButton.Parent = MainFrame

-- Velocidade Fly
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0, 100, 0, 30)
SpeedLabel.Position = UDim2.new(0, 170, 0, 145)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Velocidade: 50"
SpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.TextScaled = true
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.Parent = MainFrame

local SpeedSlider = Instance.new("Frame")
SpeedSlider.Size = UDim2.new(0, 200, 0, 20)
SpeedSlider.Position = UDim2.new(0, 170, 0, 175)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
SpeedSlider.BorderSizePixel = 0
SpeedSlider.Parent = MainFrame

local SpeedSliderButton = Instance.new("TextButton")
SpeedSliderButton.Size = UDim2.new(0.5, 0, 1, 0)
SpeedSliderButton.BackgroundColor3 = Color3.fromRGB(255, 117, 24)
SpeedSliderButton.BorderSizePixel = 0
SpeedSliderButton.Text = ""
SpeedSliderButton.Parent = SpeedSlider

-- Função do Fly
local flyActive = false
FlyButton.MouseButton1Click:Connect(function()
    flyActive = not flyActive
    FlyButton.Text = flyActive and "Desativar Fly" or "Ativar Fly"
    FlyButton.BackgroundColor3 = flyActive and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(45, 45, 55)
    ToggleFly(flyActive)
end)

-- Slider de velocidade (simplificado)
SpeedSliderButton.MouseButton1Down:Connect(function()
    local connection
    connection = game:GetService("RunService").RenderStepped:Connect(function()
        local mousePos = game:GetService("UserInputService"):GetMouseLocation()
        local sliderPos = SpeedSlider.AbsolutePosition.X
        local sliderSize = SpeedSlider.AbsoluteSize.X
        local relativePos = math.clamp(mousePos.X - sliderPos, 0, sliderSize)
        local percent = relativePos / sliderSize
        SpeedSliderButton.Size = UDim2.new(percent, 0, 1, 0)
        Fly.Speed = math.floor(10 + (percent * 190))
        SpeedLabel.Text = "Velocidade: " .. Fly.Speed
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            connection:Disconnect()
        end
    end)
end)

-- Instruções
local Instructions = Instance.new("TextLabel")
Instructions.Size = UDim2.new(1, -20, 0, 100)
Instructions.Position = UDim2.new(0, 10, 0, 200)
Instructions.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Instructions.BorderSizePixel = 0
Instructions.Text = "Controles Fly:\nWASD - Movimento\nEspaço - Subir\nShift - Descer"
Instructions.TextColor3 = Color3.fromRGB(200, 200, 200)
Instructions.TextWrapped = true
Instructions.TextScaled = true
Instructions.Font = Enum.Font.Gotham
Instructions.Parent = MainFrame

-- Botão Fechar
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextScaled = true
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = MainFrame

CloseButton.MouseButton1Click:Connect(function()
    if flyActive then ToggleFly(false) end
    ScreenGui:Destroy()
end)

print("✅ AirHub Premium carregado com sucesso!")
print("🎯 Aimbot | 👁️ ESP | ✈️ Fly | 💪 Hitbox")
