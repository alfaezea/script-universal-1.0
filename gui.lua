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

-- ========== CARREGAR MÓDULOS ==========
print("🔄 Carregando módulos do AirHub...")

loadModule("https://raw.githubusercontent.com/alfaezea/script-universal-1.0/refs/heads/main/aimbot.lua", "Aimbot")
loadModule("https://raw.githubusercontent.com/alfaezea/script-universal-1.0/refs/heads/main/esp.lua", "ESP")
loadModule("https://raw.githubusercontent.com/alfaezea/script-universal-1.0/refs/heads/main/hitbox.lua", "Hitbox")

-- Aguardar carregamento
task.wait(1)

-- ========== ACESSAR MÓDULOS CORRETAMENTE ==========
-- Em vez de procurar em getgenv().AirHub, vamos verificar diretamente
local Aimbot = getgenv().AirHub and getgenv().AirHub.Aimbot
local ESP = getgenv().AirHub and getgenv().AirHub.WallHack or getgenv().AirHub and getgenv().AirHub.ESP
local Hitbox = getgenv().LimbExtender

-- DEBUG: Mostrar o que tem no getgenv()
print("🔍 Conteúdo do getgenv().AirHub:", getgenv().AirHub and "existe" or "não existe")
if getgenv().AirHub then
    for k,v in pairs(getgenv().AirHub) do
        print("  - " .. tostring(k) .. ": " .. tostring(v))
    end
end

-- ========== VERIFICAR MÓDULOS CARREGADOS ==========
print("🔍 Aimbot:", Aimbot and "✅" or "❌")
print("🔍 ESP:", ESP and "✅" or "❌")
print("🔍 Hitbox:", Hitbox and "✅" or "❌")

-- Se nenhum módulo carregou, mostrar erro
if not Aimbot and not ESP and not Hitbox then
    warn("❌ NENHUM MÓDULO FOI ENCONTRADO!")
    warn("Verificando alternativas...")
    
    -- Tentar encontrar os módulos em outros locais
    for k,v in pairs(getgenv()) do
        if type(v) == "table" and (k == "AirHub" or k == "Aimbot" or k == "ESP" or k == "LimbExtender") then
            print("✅ Encontrado: " .. tostring(k))
        end
    end
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

-- ========== CRIAR GUI SIMPLES ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AirHubPremium"
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
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
    if Fly.Enabled then ToggleFly(false) end
    ScreenGui:Destroy()
end)

-- Status dos módulos
local StatusFrame = Instance.new("Frame")
StatusFrame.Size = UDim2.new(1, -20, 0, 100)
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

local function createStatusLabel(name, module, yPos)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 10, 0, yPos)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. (module and "✅ ATIVO" or "❌ FALHA")
    label.TextColor3 = module and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = StatusFrame
    return label
end

createStatusLabel("Aimbot", Aimbot, 30)
createStatusLabel("ESP", ESP, 50)
createStatusLabel("Hitbox", Hitbox, 70)

-- Botão Fly
local FlyButton = Instance.new("TextButton")
FlyButton.Size = UDim2.new(0, 150, 0, 40)
FlyButton.Position = UDim2.new(0, 10, 0, 160)
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
SpeedLabel.Position = UDim2.new(0, 170, 0, 165)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Velocidade: 50"
SpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.TextScaled = true
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.Parent = MainFrame

-- Slider de velocidade
local SpeedSlider = Instance.new("Frame")
SpeedSlider.Size = UDim2.new(0, 200, 0, 20)
SpeedSlider.Position = UDim2.new(0, 170, 0, 195)
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

-- Slider de velocidade
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
Instructions.Size = UDim2.new(1, -20, 0, 80)
Instructions.Position = UDim2.new(0, 10, 0, 230)
Instructions.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Instructions.BorderSizePixel = 0
Instructions.Text = "Controles Fly:\nWASD - Movimento\nEspaço - Subir\nShift - Descer"
Instructions.TextColor3 = Color3.fromRGB(200, 200, 200)
Instructions.TextWrapped = true
Instructions.TextScaled = true
Instructions.Font = Enum.Font.Gotham
Instructions.Parent = MainFrame

print("✅ AirHub Premium carregado com sucesso!")
