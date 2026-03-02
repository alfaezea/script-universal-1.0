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
task.wait(2)

-- ========== OBTER REFERÊNCIAS DOS MÓDULOS ==========
-- Cada módulo se registra em um lugar diferente!
local Aimbot = getgenv().AirHub and getgenv().AirHub.Aimbot
local ESP = getgenv().AirHub and getgenv().AirHub.WallHack  -- ESP está como WallHack!
local Hitbox = getgenv().LimbExtender  -- Hitbox é direto no getgenv()!

-- Criar instância da Hitbox se ela existir
local HitboxInstance = Hitbox and Hitbox({})  -- Inicializa com configurações padrão

-- ========== VERIFICAR MÓDULOS CARREGADOS ==========
print("\n=== STATUS DOS MÓDULOS ===")
print("🔍 Aimbot:", Aimbot and "✅" or "❌")
print("🔍 ESP (WallHack):", ESP and "✅" or "❌") 
print("🔍 Hitbox:", Hitbox and "✅" or "❌")

if not Aimbot and not ESP and not Hitbox then
    warn("❌ NENHUM MÓDULO FOI ENCONTRADO!")
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

-- ========== CRIAR GUI SIMPLES ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AirHubPremium"
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 450)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -225)
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
    if HitboxInstance and HitboxInstance.Destroy then HitboxInstance:Destroy() end
    ScreenGui:Destroy()
end)

-- Abas
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 30)
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -100)
ContentFrame.Position = UDim2.new(0, 10, 0, 75)
ContentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

-- Função para criar abas
local function createTab(name, yPos)
    local tab = Instance.new("TextButton")
    tab.Size = UDim2.new(0, 80, 0, 25)
    tab.Position = UDim2.new(0, 5 + (85 * (yPos-1)), 0, 2)
    tab.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    tab.BorderSizePixel = 0
    tab.Text = name
    tab.TextColor3 = Color3.fromRGB(200, 200, 200)
    tab.TextScaled = true
    tab.Font = Enum.Font.Gotham
    tab.Parent = TabContainer
    return tab
end

-- Criar abas
local Tab1 = createTab("Aimbot", 1)
local Tab2 = createTab("ESP", 2)
local Tab3 = createTab("Hitbox", 3)
local Tab4 = createTab("Fly", 4)

-- Função para esconder todos os conteúdos
local function hideAll()
    for _, child in ipairs(ContentFrame:GetChildren()) do
        if child:IsA("Frame") then
            child.Visible = false
        end
    end
end

-- ========== ABA AIMBOT ==========
local AimbotFrame = Instance.new("Frame")
AimbotFrame.Size = UDim2.new(1, 0, 1, 0)
AimbotFrame.BackgroundTransparency = 1
AimbotFrame.Visible = false
AimbotFrame.Parent = ContentFrame

if Aimbot then
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -20, 0, 30)
    StatusLabel.Position = UDim2.new(0, 10, 0, 10)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "✅ Aimbot Carregado!"
    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.TextScaled = true
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Parent = AimbotFrame
    
    -- Botão Ativar
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 200, 0, 40)
    ToggleBtn.Position = UDim2.new(0.5, -100, 0, 50)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.Text = "Ativar Aimbot"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.TextScaled = true
    ToggleBtn.Font = Enum.Font.Gotham
    ToggleBtn.Parent = AimbotFrame
    
    local aimbotActive = false
    ToggleBtn.MouseButton1Click:Connect(function()
        aimbotActive = not aimbotActive
        Aimbot.Settings.Enabled = aimbotActive
        ToggleBtn.Text = aimbotActive and "Desativar Aimbot" or "Ativar Aimbot"
        ToggleBtn.BackgroundColor3 = aimbotActive and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(45, 45, 55)
    end)
    
    -- Smoothness slider
    local SmoothLabel = Instance.new("TextLabel")
    SmoothLabel.Size = UDim2.new(0, 200, 0, 30)
    SmoothLabel.Position = UDim2.new(0.5, -250, 0, 100)
    SmoothLabel.BackgroundTransparency = 1
    SmoothLabel.Text = "Smoothness: " .. Aimbot.Settings.Smoothness
    SmoothLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    SmoothLabel.TextXAlignment = Enum.TextXAlignment.Left
    SmoothLabel.TextScaled = true
    SmoothLabel.Font = Enum.Font.Gotham
    SmoothLabel.Parent = AimbotFrame
    
    local SmoothSlider = Instance.new("Frame")
    SmoothSlider.Size = UDim2.new(0, 200, 0, 20)
    SmoothSlider.Position = UDim2.new(0.5, -250, 0, 130)
    SmoothSlider.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    SmoothSlider.BorderSizePixel = 0
    SmoothSlider.Parent = AimbotFrame
    
    local SmoothSliderBtn = Instance.new("TextButton")
    SmoothSliderBtn.Size = UDim2.new(Aimbot.Settings.Smoothness * 10, 0, 1, 0)
    SmoothSliderBtn.BackgroundColor3 = Color3.fromRGB(255, 117, 24)
    SmoothSliderBtn.BorderSizePixel = 0
    SmoothSliderBtn.Text = ""
    SmoothSliderBtn.Parent = SmoothSlider
    
    SmoothSliderBtn.MouseButton1Down:Connect(function()
        local connection
        connection = game:GetService("RunService").RenderStepped:Connect(function()
            local mousePos = game:GetService("UserInputService"):GetMouseLocation()
            local sliderPos = SmoothSlider.AbsolutePosition.X
            local sliderSize = SmoothSlider.AbsoluteSize.X
            local relativePos = math.clamp(mousePos.X - sliderPos, 0, sliderSize)
            local percent = relativePos / sliderSize
            SmoothSliderBtn.Size = UDim2.new(percent, 0, 1, 0)
            local value = percent * 1  -- 0 a 1
            Aimbot.Settings.Smoothness = value
            SmoothLabel.Text = "Smoothness: " .. string.format("%.2f", value)
        end)
        
        game:GetService("UserInputService").InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                connection:Disconnect()
            end
        end)
    end)
else
    local ErrorLabel = Instance.new("TextLabel")
    ErrorLabel.Size = UDim2.new(1, -20, 0, 50)
    ErrorLabel.Position = UDim2.new(0, 10, 0, 10)
    ErrorLabel.BackgroundTransparency = 1
    ErrorLabel.Text = "❌ Aimbot não carregado!"
    ErrorLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    ErrorLabel.TextScaled = true
    ErrorLabel.Font = Enum.Font.Gotham
    ErrorLabel.Parent = AimbotFrame
end

-- ========== ABA ESP ==========
local ESPFrame = Instance.new("Frame")
ESPFrame.Size = UDim2.new(1, 0, 1, 0)
ESPFrame.BackgroundTransparency = 1
ESPFrame.Visible = false
ESPFrame.Parent = ContentFrame

if ESP then
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -20, 0, 30)
    StatusLabel.Position = UDim2.new(0, 10, 0, 10)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "✅ ESP (WallHack) Carregado!"
    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.TextScaled = true
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Parent = ESPFrame
    
    -- Botão Ativar
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 200, 0, 40)
    ToggleBtn.Position = UDim2.new(0.5, -100, 0, 50)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.Text = "Ativar ESP"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.TextScaled = true
    ToggleBtn.Font = Enum.Font.Gotham
    ToggleBtn.Parent = ESPFrame
    
    local espActive = false
    ToggleBtn.MouseButton1Click:Connect(function()
        espActive = not espActive
        ESP.Settings.Enabled = espActive
        ToggleBtn.Text = espActive and "Desativar ESP" or "Ativar ESP"
        ToggleBtn.BackgroundColor3 = espActive and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(45, 45, 55)
    end)
    
    -- Checkboxes simples
    local function createCheckbox(parent, text, yPos, setting, key)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 200, 0, 30)
        btn.Position = UDim2.new(0, 10, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        btn.BorderSizePixel = 0
        btn.Text = "🔲 " .. text
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.TextScaled = true
        btn.Font = Enum.Font.Gotham
        btn.Parent = parent
        
        local active = setting[key]
        btn.MouseButton1Click:Connect(function()
            active = not active
            setting[key] = active
            btn.Text = (active and "✅ " or "🔲 ") .. text
        end)
    end
    
    createCheckbox(ESPFrame, "Team Check", 100, ESP.Settings, "TeamCheck")
    createCheckbox(ESPFrame, "Alive Check", 140, ESP.Settings, "AliveCheck")
    createCheckbox(ESPFrame, "Box ESP", 180, ESP.Visuals.BoxSettings, "Enabled")
    createCheckbox(ESPFrame, "Tracers", 220, ESP.Visuals.TracersSettings, "Enabled")
    createCheckbox(ESPFrame, "Head Dot", 260, ESP.Visuals.HeadDotSettings, "Enabled")
else
    local ErrorLabel = Instance.new("TextLabel")
    ErrorLabel.Size = UDim2.new(1, -20, 0, 50)
    ErrorLabel.Position = UDim2.new(0, 10, 0, 10)
    ErrorLabel.BackgroundTransparency = 1
    ErrorLabel.Text = "❌ ESP não carregado!"
    ErrorLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    ErrorLabel.TextScaled = true
    ErrorLabel.Font = Enum.Font.Gotham
    ErrorLabel.Parent = ESPFrame
end

-- ========== ABA HITBOX ==========
local HitboxFrame = Instance.new("Frame")
HitboxFrame.Size = UDim2.new(1, 0, 1, 0)
HitboxFrame.BackgroundTransparency = 1
HitboxFrame.Visible = false
HitboxFrame.Parent = ContentFrame

if HitboxInstance then
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -20, 0, 30)
    StatusLabel.Position = UDim2.new(0, 10, 0, 10)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "✅ Hitbox Carregado!"
    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.TextScaled = true
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Parent = HitboxFrame
    
    -- Botão Ativar
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 200, 0, 40)
    ToggleBtn.Position = UDim2.new(0.5, -100, 0, 50)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.Text = "Ativar Hitbox"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.TextScaled = true
    ToggleBtn.Font = Enum.Font.Gotham
    ToggleBtn.Parent = HitboxFrame
    
    local hitboxActive = false
    ToggleBtn.MouseButton1Click:Connect(function()
        hitboxActive = not hitboxActive
        if hitboxActive then
            HitboxInstance:Start()
        else
            HitboxInstance:Stop()
        end
        ToggleBtn.Text = hitboxActive and "Desativar Hitbox" or "Ativar Hitbox"
        ToggleBtn.BackgroundColor3 = hitboxActive and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(45, 45, 55)
    end)
    
    -- Slider de tamanho
    local SizeLabel = Instance.new("TextLabel")
    SizeLabel.Size = UDim2.new(0, 200, 0, 30)
    SizeLabel.Position = UDim2.new(0.5, -250, 0, 100)
    SizeLabel.BackgroundTransparency = 1
    SizeLabel.Text = "Tamanho: " .. HitboxInstance:Get("LIMB_SIZE") or 15
    SizeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    SizeLabel.TextXAlignment = Enum.TextXAlignment.Left
    SizeLabel.TextScaled = true
    SizeLabel.Font = Enum.Font.Gotham
    SizeLabel.Parent = HitboxFrame
    
    local SizeSlider = Instance.new("Frame")
    SizeSlider.Size = UDim2.new(0, 200, 0, 20)
    SizeSlider.Position = UDim2.new(0.5, -250, 0, 130)
    SizeSlider.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    SizeSlider.BorderSizePixel = 0
    SizeSlider.Parent = HitboxFrame
    
    local SizeSliderBtn = Instance.new("TextButton")
    SizeSliderBtn.Size = UDim2.new(0.5, 0, 1, 0)
    SizeSliderBtn.BackgroundColor3 = Color3.fromRGB(255, 117, 24)
    SizeSliderBtn.BorderSizePixel = 0
    SizeSliderBtn.Text = ""
    SizeSliderBtn.Parent = SizeSlider
    
    SizeSliderBtn.MouseButton1Down:Connect(function()
        local connection
        connection = game:GetService("RunService").RenderStepped:Connect(function()
            local mousePos = game:GetService("UserInputService"):GetMouseLocation()
            local sliderPos = SizeSlider.AbsolutePosition.X
            local sliderSize = SizeSlider.AbsoluteSize.X
            local relativePos = math.clamp(mousePos.X - sliderPos, 0, sliderSize)
            local percent = relativePos / sliderSize
            SizeSliderBtn.Size = UDim2.new(percent, 0, 1, 0)
            local value = math.floor(5 + (percent * 25))
            HitboxInstance:Set("LIMB_SIZE", value)
            SizeLabel.Text = "Tamanho: " .. value
        end)
        
        game:GetService("UserInputService").InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                connection:Disconnect()
            end
        end)
    end)
else
    local ErrorLabel = Instance.new("TextLabel")
    ErrorLabel.Size = UDim2.new(1, -20, 0, 50)
    ErrorLabel.Position = UDim2.new(0, 10, 0, 10)
    ErrorLabel.BackgroundTransparency = 1
    ErrorLabel.Text = "❌ Hitbox não carregado!"
    ErrorLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    ErrorLabel.TextScaled = true
    ErrorLabel.Font = Enum.Font.Gotham
    ErrorLabel.Parent = HitboxFrame
end

-- ========== ABA FLY ==========
local FlyFrame = Instance.new("Frame")
FlyFrame.Size = UDim2.new(1, 0, 1, 0)
FlyFrame.BackgroundTransparency = 1
FlyFrame.Visible = false
FlyFrame.Parent = ContentFrame

-- Botão Fly
local FlyBtn = Instance.new("TextButton")
FlyBtn.Size = UDim2.new(0, 200, 0, 40)
FlyBtn.Position = UDim2.new(0.5, -100, 0, 20)
FlyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
FlyBtn.BorderSizePixel = 0
FlyBtn.Text = "Ativar Fly"
FlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyBtn.TextScaled = true
FlyBtn.Font = Enum.Font.Gotham
FlyBtn.Parent = FlyFrame

local flyActive = false
FlyBtn.MouseButton1Click:Connect(function()
    flyActive = not flyActive
    FlyBtn.Text = flyActive and "Desativar Fly" or "Ativar Fly"
    FlyBtn.BackgroundColor3 = flyActive and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(45, 45, 55)
    ToggleFly(flyActive)
end)

-- Velocidade Fly
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0, 200, 0, 30)
SpeedLabel.Position = UDim2.new(0.5, -250, 0, 70)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Velocidade: 50"
SpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.TextScaled = true
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.Parent = FlyFrame

local SpeedSlider = Instance.new("Frame")
SpeedSlider.Size = UDim2.new(0, 200, 0, 20)
SpeedSlider.Position = UDim2.new(0.5, -250, 0, 100)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
SpeedSlider.BorderSizePixel = 0
SpeedSlider.Parent = FlyFrame

local SpeedSliderBtn = Instance.new("TextButton")
SpeedSliderBtn.Size = UDim2.new(0.25, 0, 1, 0)
SpeedSliderBtn.BackgroundColor3 = Color3.fromRGB(255, 117, 24)
SpeedSliderBtn.BorderSizePixel = 0
SpeedSliderBtn.Text = ""
SpeedSliderBtn.Parent = SpeedSlider

SpeedSliderBtn.MouseButton1Down:Connect(function()
    local connection
    connection = game:GetService("RunService").RenderStepped:Connect(function()
        local mousePos = game:GetService("UserInputService"):GetMouseLocation()
        local sliderPos = SpeedSlider.AbsolutePosition.X
        local sliderSize = SpeedSlider.AbsoluteSize.X
        local relativePos = math.clamp(mousePos.X - sliderPos, 0, sliderSize)
        local percent = relativePos / sliderSize
        SpeedSliderBtn.Size = UDim2.new(percent, 0, 1, 0)
        Fly.Speed = math.floor(10 + (percent * 190))
        SpeedLabel.Text = "Velocidade: " .. Fly.Speed
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            connection:Disconnect()
        end
    end)
end)

local Instructions = Instance.new("TextLabel")
Instructions.Size = UDim2.new(1, -20, 0, 100)
Instructions.Position = UDim2.new(0, 10, 0, 150)
Instructions.BackgroundTransparency = 1
Instructions.Text = "Controles:\nWASD - Movimento\nEspaço - Subir\nShift - Descer"
Instructions.TextColor3 = Color3.fromRGB(200, 200, 200)
Instructions.TextWrapped = true
Instructions.TextScaled = true
Instructions.Font = Enum.Font.Gotham
Instructions.Parent = FlyFrame

-- Configurar abas
Tab1.MouseButton1Click:Connect(function()
    hideAll()
    AimbotFrame.Visible = true
end)

Tab2.MouseButton1Click:Connect(function()
    hideAll()
    ESPFrame.Visible = true
end)

Tab3.MouseButton1Click:Connect(function()
    hideAll()
    HitboxFrame.Visible = true
end)

Tab4.MouseButton1Click:Connect(function()
    hideAll()
    FlyFrame.Visible = true
end)

-- Mostrar primeira aba
AimbotFrame.Visible = true

print("\n✅ AirHub Premium carregado com sucesso!")
print("📌 Use as abas para configurar cada módulo")
