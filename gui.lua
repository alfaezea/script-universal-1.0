--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║              AIRHUB PREMIUM - COMPLETE                    ║
    ║         ESP AVANÇADO | Aimbot | Diversos | Fly            ║
    ╚═══════════════════════════════════════════════════════════╝
]]

-- ========== CONFIGURAÇÕES INICIAIS ==========
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Criar estrutura AirHub se não existir
getgenv().AirHub = getgenv().AirHub or {}

-- ========== FUNÇÃO PARA CARREGAR MÓDULOS ==========
local function loadModule(url, name)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success and result and #result > 0 then
        local func, err = loadstring(result)
        if func then
            local success2, result2 = pcall(func)
            if success2 then
                print("✅ " .. name .. " carregado!")
                return true
            else
                warn("❌ Erro em " .. name .. ": " .. tostring(result2))
                return false
            end
        else
            warn("❌ Erro sintaxe " .. name)
            return false
        end
    else
        warn("❌ Falha download " .. name)
        return false
    end
end

-- ========== CARREGAR MÓDULOS ==========
print("🔄 Carregando AirHub Premium...")

-- Carregar ESP AVANÇADO
print("🔄 Carregando ESP Avançado...")
local espScript = game:HttpGet("https://raw.githubusercontent.com/alfaezea/script-universal-1.0/refs/heads/main/esp.lua")
local espFunc, espErr = loadstring(espScript)
if espFunc then
    pcall(espFunc)
    print("✅ ESP Avançado carregado!")
else
    warn("❌ Erro no ESP: " .. tostring(espErr))
end

-- Carregar Aimbot
loadModule("https://raw.githubusercontent.com/alfaezea/script-universal-1.0/refs/heads/main/aimbot.lua", "Aimbot")

-- Carregar Módulo Diversos (URL CORRETA)
print("🔄 Carregando Módulo Diversos...")
local diversosScript = game:HttpGet("https://raw.githubusercontent.com/alfaezea/script-universal-1.0/refs/heads/main/diversos.lua")
local diversosFunc, diversosErr = loadstring(diversosScript)
if diversosFunc then
    pcall(diversosFunc)
    print("✅ Módulo Diversos carregado!")
else
    warn("❌ Erro no Diversos: " .. tostring(diversosErr))
end

-- Aguardar carregamento
task.wait(2)

-- ========== OBTER REFERÊNCIAS ==========
local ESP = getgenv().AirHub and getgenv().AirHub.ESP_Avancado
local Aimbot = getgenv().AirHub and getgenv().AirHub.Aimbot
local Diversos = getgenv().AirHub and getgenv().AirHub.Diversos

-- ========== SISTEMA DE FLY EMBUTIDO ==========
local Fly = {
    Enabled = false,
    Speed = 50,
    BodyGyro = nil,
    BodyVelocity = nil,
    Connection = nil
}

local function ToggleFly(state)
    local character = LocalPlayer.Character
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

        Fly.Connection = RunService.RenderStepped:Connect(function()
            if not Fly.Enabled then return end

            local move = Vector3.new(0, 0, 0)
            local cam = workspace.CurrentCamera.CFrame

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move + Vector3.new(0, -1, 0) end

            if move.Magnitude > 0 then
                move = move.Unit * Fly.Speed
            end

            Fly.BodyVelocity.Velocity = move
            Fly.BodyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + cam.LookVector)
        end)

        Fly.Enabled = true
    else
        humanoid.PlatformStand = false
        if Fly.BodyGyro then Fly.BodyGyro:Destroy() end
        if Fly.BodyVelocity then Fly.BodyVelocity:Destroy() end
        if Fly.Connection then Fly.Connection:Disconnect() end
        Fly.Enabled = false
    end
end

-- ========== CRIAR GUI ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AirHubPremium"
ScreenGui.Parent = game:GetService("CoreGui")

-- Frame principal
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 700, 0, 600)
MainFrame.Position = UDim2.new(0.5, -350, 0.5, -300)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Sombra
local Shadow = Instance.new("ImageLabel")
Shadow.Size = UDim2.new(1, 10, 1, 10)
Shadow.Position = UDim2.new(0, -5, 0, -5)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
Shadow.Parent = MainFrame

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Title.BorderSizePixel = 0
Title.Text = "AIRHUB PREMIUM - ESP AVANÇADO + DIVERSOS"
Title.TextColor3 = Color3.fromRGB(255, 128, 0)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Botão fechar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame

CloseBtn.MouseButton1Click:Connect(function()
    if Fly.Enabled then ToggleFly(false) end
    if ESP and ESP.Functions and ESP.Functions.Exit then ESP.Functions:Exit() end
    if Diversos and Diversos.Destroy then Diversos:Destroy() end
    ScreenGui:Destroy()
end)

-- Status bar
local StatusBar = Instance.new("Frame")
StatusBar.Size = UDim2.new(1, -20, 0, 30)
StatusBar.Position = UDim2.new(0, 10, 0, 45)
StatusBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
StatusBar.BorderSizePixel = 0
StatusBar.Parent = MainFrame

local function createStatus(text, color, xPos)
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(0, 160, 1, 0)
    status.Position = UDim2.new(0, xPos, 0, 0)
    status.BackgroundTransparency = 1
    status.Text = text
    status.TextColor3 = color
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.TextScaled = true
    status.Font = Enum.Font.Gotham
    status.Parent = StatusBar
    return status
end

createStatus("ESP: " .. (ESP and "✅" or "❌"), ESP and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 10)
createStatus("Aimbot: " .. (Aimbot and "✅" or "❌"), Aimbot and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 180)
createStatus("Diversos: " .. (Diversos and "✅" or "❌"), Diversos and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 350)
createStatus("Fly: ✅", Color3.fromRGB(0, 255, 0), 520)

-- Abas
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -20, 0, 40)
TabContainer.Position = UDim2.new(0, 10, 0, 80)
TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

local tabs = {}

local function createTab(name, pos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 120, 1, -10)
    btn.Position = UDim2.new(0, 5 + (125 * (pos-1)), 0, 5)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.Parent = TabContainer
    table.insert(tabs, btn)
    return btn
end

-- Container de conteúdo
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -190)
ContentFrame.Position = UDim2.new(0, 10, 0, 130)
ContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

-- ========== FUNÇÕES PARA CRIAR CONTROLES ==========
local function createToggle(parent, text, yPos, getFunc, setFunc)
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, -20, 0, 35)
    bg.Position = UDim2.new(0, 10, 0, yPos)
    bg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    bg.BorderSizePixel = 0
    bg.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 250, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = bg
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 60, 0, 25)
    btn.Position = UDim2.new(1, -70, 0.5, -12.5)
    btn.BackgroundColor3 = getFunc and getFunc() and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    btn.BorderSizePixel = 0
    btn.Text = getFunc and getFunc() and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.Parent = bg
    
    btn.MouseButton1Click:Connect(function()
        if setFunc then
            local newState = not (getFunc and getFunc())
            setFunc(newState)
            btn.BackgroundColor3 = newState and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            btn.Text = newState and "ON" or "OFF"
        end
    end)
    
    return bg
end

local function createSlider(parent, text, yPos, min, max, getFunc, setFunc, format)
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, -20, 0, 50)
    bg.Position = UDim2.new(0, 10, 0, yPos)
    bg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    bg.BorderSizePixel = 0
    bg.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. (getFunc and getFunc() or 0)
    label.TextColor3 = Color3.fromRGB(255, 128, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = bg
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, -40, 0, 10)
    slider.Position = UDim2.new(0, 20, 0, 30)
    slider.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    slider.BorderSizePixel = 0
    slider.Parent = bg
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(getFunc and (getFunc() - min) / (max - min) or 0.5, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 128, 0)
    fill.BorderSizePixel = 0
    fill.Parent = slider
    
    local drag = Instance.new("TextButton")
    drag.Size = UDim2.new(0, 15, 0, 15)
    drag.Position = UDim2.new(fill.Size.X.Scale, -7.5, 0.5, -7.5)
    drag.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    drag.BorderSizePixel = 0
    drag.Text = ""
    drag.Parent = slider
    
    drag.MouseButton1Down:Connect(function()
        local connection
        connection = RunService.RenderStepped:Connect(function()
            local mousePos = UserInputService:GetMouseLocation()
            local sliderPos = slider.AbsolutePosition.X
            local sliderSize = slider.AbsoluteSize.X
            local relativePos = math.clamp(mousePos.X - sliderPos, 0, sliderSize)
            local percent = relativePos / sliderSize
            fill.Size = UDim2.new(percent, 0, 1, 0)
            drag.Position = UDim2.new(percent, -7.5, 0.5, -7.5)
            
            local value = min + (percent * (max - min))
            if format == "int" then
                value = math.floor(value)
            end
            label.Text = text .. ": " .. value
            if setFunc then setFunc(value) end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                connection:Disconnect()
            end
        end)
    end)
    
    return bg
end

-- ========== CRIAR ABAS ==========
local tabESP = createTab("⚡ ESP", 1)
local tabAimbot = createTab("🎯 AIMBOT", 2)
local tabDiversos = createTab("🔧 DIVERSOS", 3)
local tabFly = createTab("✈️ FLY", 4)

-- ========== CONTEÚDO ESP AVANÇADO ==========
local espContent = Instance.new("ScrollingFrame")
espContent.Size = UDim2.new(1, 0, 1, 0)
espContent.BackgroundTransparency = 1
espContent.BorderSizePixel = 0
espContent.ScrollBarThickness = 5
espContent.CanvasSize = UDim2.new(0, 0, 0, 1200)
espContent.Visible = false
espContent.Parent = ContentFrame

if ESP then
    local yPos = 10
    
    -- TÍTULO PRINCIPAL
    local titleESP = Instance.new("TextLabel")
    titleESP.Size = UDim2.new(1, -20, 0, 35)
    titleESP.Position = UDim2.new(0, 10, 0, yPos)
    titleESP.BackgroundColor3 = Color3.fromRGB(255, 128, 0)
    titleESP.BorderSizePixel = 0
    titleESP.Text = "⚡ ESP AVANÇADO ULTRA OTIMIZADO ⚡"
    titleESP.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleESP.TextScaled = true
    titleESP.Font = Enum.Font.GothamBold
    titleESP.Parent = espContent
    yPos = yPos + 45
    
    -- ATIVAR ESP
    createToggle(espContent, "🔘 ATIVAR ESP", yPos, 
        function() return ESP.Settings.Enabled end,
        function(v) ESP.Settings.Enabled = v end)
    yPos = yPos + 45
    
    -- SEÇÃO 1: ELEMENTOS VISUAIS
    local sec1 = Instance.new("TextLabel")
    sec1.Size = UDim2.new(1, -20, 0, 25)
    sec1.Position = UDim2.new(0, 10, 0, yPos)
    sec1.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    sec1.BorderSizePixel = 0
    sec1.Text = "   📦 ELEMENTOS VISUAIS"
    sec1.TextColor3 = Color3.fromRGB(255, 200, 100)
    sec1.TextXAlignment = Enum.TextXAlignment.Left
    sec1.TextScaled = true
    sec1.Font = Enum.Font.GothamBold
    sec1.Parent = espContent
    yPos = yPos + 30
    
    createToggle(espContent, "📦 Box ESP", yPos,
        function() return ESP.Visuals.Box.Enabled end,
        function(v) ESP.Visuals.Box.Enabled = v end)
    yPos = yPos + 45
    
    createToggle(espContent, "📏 Tracers", yPos,
        function() return ESP.Visuals.Tracer.Enabled end,
        function(v) ESP.Visuals.Tracer.Enabled = v end)
    yPos = yPos + 45
    
    -- Tipo de Tracer
    local tracerTypeLabel = Instance.new("TextLabel")
    tracerTypeLabel.Size = UDim2.new(0, 200, 0, 30)
    tracerTypeLabel.Position = UDim2.new(0, 20, 0, yPos)
    tracerTypeLabel.BackgroundTransparency = 1
    tracerTypeLabel.Text = "Tipo Tracer:"
    tracerTypeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    tracerTypeLabel.TextXAlignment = Enum.TextXAlignment.Left
    tracerTypeLabel.TextScaled = true
    tracerTypeLabel.Font = Enum.Font.Gotham
    tracerTypeLabel.Parent = espContent
    
    local tracerTypeBtn = Instance.new("TextButton")
    tracerTypeBtn.Size = UDim2.new(0, 100, 0, 25)
    tracerTypeBtn.Position = UDim2.new(0, 200, 0, yPos + 2.5)
    tracerTypeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    tracerTypeBtn.BorderSizePixel = 0
    tracerTypeBtn.Text = ESP.Visuals.Tracer.Type == 1 and "Bottom" or ESP.Visuals.Tracer.Type == 2 and "Center" or "Mouse"
    tracerTypeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tracerTypeBtn.TextScaled = true
    tracerTypeBtn.Font = Enum.Font.Gotham
    tracerTypeBtn.Parent = espContent
    
    tracerTypeBtn.MouseButton1Click:Connect(function()
        local current = ESP.Visuals.Tracer.Type
        current = current + 1
        if current > 3 then current = 1 end
        ESP.Visuals.Tracer.Type = current
        tracerTypeBtn.Text = current == 1 and "Bottom" or current == 2 and "Center" or "Mouse"
    end)
    yPos = yPos + 40
    
    createToggle(espContent, "⚫ Head Dot", yPos,
        function() return ESP.Visuals.HeadDot.Enabled end,
        function(v) ESP.Visuals.HeadDot.Enabled = v end)
    yPos = yPos + 45
    
    -- SEÇÃO 2: INFORMAÇÕES
    local sec2 = Instance.new("TextLabel")
    sec2.Size = UDim2.new(1, -20, 0, 25)
    sec2.Position = UDim2.new(0, 10, 0, yPos)
    sec2.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    sec2.BorderSizePixel = 0
    sec2.Text = "   ℹ️ INFORMAÇÕES"
    sec2.TextColor3 = Color3.fromRGB(100, 255, 100)
    sec2.TextXAlignment = Enum.TextXAlignment.Left
    sec2.TextScaled = true
    sec2.Font = Enum.Font.GothamBold
    sec2.Parent = espContent
    yPos = yPos + 30
    
    createToggle(espContent, "👤 Mostrar Nomes", yPos,
        function() return ESP.Visuals.Name.Enabled end,
        function(v) ESP.Visuals.Name.Enabled = v end)
    yPos = yPos + 45
    
    createToggle(espContent, "📏 Mostrar Distância", yPos,
        function() return ESP.Visuals.Distance.Enabled end,
        function(v) ESP.Visuals.Distance.Enabled = v end)
    yPos = yPos + 45
    
    createToggle(espContent, "❤️ Mostrar Vida (Texto)", yPos,
        function() return ESP.Visuals.Health.Text end,
        function(v) ESP.Visuals.Health.Text = v end)
    yPos = yPos + 45
    
    createToggle(espContent, "📊 Barra de Vida", yPos,
        function() return ESP.Visuals.Health.Bar end,
        function(v) ESP.Visuals.Health.Bar = v end)
    yPos = yPos + 45
    
    createToggle(espContent, "🔫 Mostrar Arma", yPos,
        function() return ESP.Visuals.Weapon.Enabled end,
        function(v) ESP.Visuals.Weapon.Enabled = v end)
    yPos = yPos + 45
    
    -- SEÇÃO 3: VERIFICAÇÕES
    local sec3 = Instance.new("TextLabel")
    sec3.Size = UDim2.new(1, -20, 0, 25)
    sec3.Position = UDim2.new(0, 10, 0, yPos)
    sec3.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    sec3.BorderSizePixel = 0
    sec3.Text = "   🔒 VERIFICAÇÕES"
    sec3.TextColor3 = Color3.fromRGB(255, 100, 100)
    sec3.TextXAlignment = Enum.TextXAlignment.Left
    sec3.TextScaled = true
    sec3.Font = Enum.Font.GothamBold
    sec3.Parent = espContent
    yPos = yPos + 30
    
    createToggle(espContent, "👥 Team Check", yPos,
        function() return ESP.Settings.TeamCheck end,
        function(v) ESP.Settings.TeamCheck = v end)
    yPos = yPos + 45
    
    createToggle(espContent, "💀 Alive Check", yPos,
        function() return ESP.Settings.AliveCheck end,
        function(v) ESP.Settings.AliveCheck = v end)
    yPos = yPos + 45
    
    -- SEÇÃO 4: OTIMIZAÇÃO
    local sec4 = Instance.new("TextLabel")
    sec4.Size = UDim2.new(1, -20, 0, 25)
    sec4.Position = UDim2.new(0, 10, 0, yPos)
    sec4.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    sec4.BorderSizePixel = 0
    sec4.Text = "   ⚡ OTIMIZAÇÃO"
    sec4.TextColor3 = Color3.fromRGB(255, 255, 0)
    sec4.TextXAlignment = Enum.TextXAlignment.Left
    sec4.TextScaled = true
    sec4.Font = Enum.Font.GothamBold
    sec4.Parent = espContent
    yPos = yPos + 30
    
    -- Distância máxima
    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(0, 200, 0, 30)
    distLabel.Position = UDim2.new(0, 20, 0, yPos)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "Distância Máxima: " .. (ESP.Settings.MaxDistance or 1000) .. "m"
    distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distLabel.TextXAlignment = Enum.TextXAlignment.Left
    distLabel.TextScaled = true
    distLabel.Font = Enum.Font.Gotham
    distLabel.Parent = espContent
    
    local distSlider = Instance.new("Frame")
    distSlider.Size = UDim2.new(0, 200, 0, 10)
    distSlider.Position = UDim2.new(0, 200, 0, yPos + 10)
    distSlider.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    distSlider.BorderSizePixel = 0
    distSlider.Parent = espContent
    
    local distFill = Instance.new("Frame")
    distFill.Size = UDim2.new((ESP.Settings.MaxDistance or 1000) / 5000, 0, 1, 0)
    distFill.BackgroundColor3 = Color3.fromRGB(255, 128, 0)
    distFill.BorderSizePixel = 0
    distFill.Parent = distSlider
    
    local distDrag = Instance.new("TextButton")
    distDrag.Size = UDim2.new(0, 15, 0, 15)
    distDrag.Position = UDim2.new(distFill.Size.X.Scale, -7.5, 0.5, -7.5)
    distDrag.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    distDrag.BorderSizePixel = 0
    distDrag.Text = ""
    distDrag.Parent = distSlider
    
    distDrag.MouseButton1Down:Connect(function()
        local connection
        connection = RunService.RenderStepped:Connect(function()
            local mousePos = UserInputService:GetMouseLocation()
            local sliderPos = distSlider.AbsolutePosition.X
            local sliderSize = distSlider.AbsoluteSize.X
            local relativePos = math.clamp(mousePos.X - sliderPos, 0, sliderSize)
            local percent = relativePos / sliderSize
            distFill.Size = UDim2.new(percent, 0, 1, 0)
            distDrag.Position = UDim2.new(percent, -7.5, 0.5, -7.5)
            
            local value = math.floor(percent * 5000)
            ESP.Settings.MaxDistance = value
            distLabel.Text = "Distância Máxima: " .. value .. "m"
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                connection:Disconnect()
            end
        end)
    end)
    yPos = yPos + 40
    
    -- Render Every
    local renderLabel = Instance.new("TextLabel")
    renderLabel.Size = UDim2.new(0, 200, 0, 30)
    renderLabel.Position = UDim2.new(0, 20, 0, yPos)
    renderLabel.BackgroundTransparency = 1
    renderLabel.Text = "Render a cada " .. (ESP.Performance.RenderEvery or 2) .. " frames"
    renderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    renderLabel.TextXAlignment = Enum.TextXAlignment.Left
    renderLabel.TextScaled = true
    renderLabel.Font = Enum.Font.Gotham
    renderLabel.Parent = espContent
    
    local renderSlider = Instance.new("Frame")
    renderSlider.Size = UDim2.new(0, 200, 0, 10)
    renderSlider.Position = UDim2.new(0, 200, 0, yPos + 10)
    renderSlider.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    renderSlider.BorderSizePixel = 0
    renderSlider.Parent = espContent
    
    local renderFill = Instance.new("Frame")
    renderFill.Size = UDim2.new(((ESP.Performance.RenderEvery or 2) - 1) / 4, 0, 1, 0)
    renderFill.BackgroundColor3 = Color3.fromRGB(255, 128, 0)
    renderFill.BorderSizePixel = 0
    renderFill.Parent = renderSlider
    
    local renderDrag = Instance.new("TextButton")
    renderDrag.Size = UDim2.new(0, 15, 0, 15)
    renderDrag.Position = UDim2.new(renderFill.Size.X.Scale, -7.5, 0.5, -7.5)
    renderDrag.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    renderDrag.BorderSizePixel = 0
    renderDrag.Text = ""
    renderDrag.Parent = renderSlider
    
    renderDrag.MouseButton1Down:Connect(function()
        local connection
        connection = RunService.RenderStepped:Connect(function()
            local mousePos = UserInputService:GetMouseLocation()
            local sliderPos = renderSlider.AbsolutePosition.X
            local sliderSize = renderSlider.AbsoluteSize.X
            local relativePos = math.clamp(mousePos.X - sliderPos, 0, sliderSize)
            local percent = relativePos / sliderSize
            renderFill.Size = UDim2.new(percent, 0, 1, 0)
            renderDrag.Position = UDim2.new(percent, -7.5, 0.5, -7.5)
            
            local value = math.floor(1 + (percent * 4))
            ESP.Performance.RenderEvery = value
            renderLabel.Text = "Render a cada " .. value .. " frames"
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                connection:Disconnect()
            end
        end)
    end)
    yPos = yPos + 45
    
    espContent.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)
else
    local err = Instance.new("TextLabel")
    err.Size = UDim2.new(1, 0, 0, 100)
    err.Position = UDim2.new(0, 0, 0, 20)
    err.BackgroundTransparency = 1
    err.Text = "❌ ESP AVANÇADO NÃO CARREGADO!"
    err.TextColor3 = Color3.fromRGB(255, 0, 0)
    err.TextWrapped = true
    err.TextScaled = true
    err.Font = Enum.Font.Gotham
    err.Parent = espContent
end

-- ========== CONTEÚDO AIMBOT ==========
local aimbotContent = Instance.new("ScrollingFrame")
aimbotContent.Size = UDim2.new(1, 0, 1, 0)
aimbotContent.BackgroundTransparency = 1
aimbotContent.BorderSizePixel = 0
aimbotContent.ScrollBarThickness = 5
aimbotContent.CanvasSize = UDim2.new(0, 0, 0, 500)
aimbotContent.Visible = false
aimbotContent.Parent = ContentFrame

if Aimbot then
    local yPos = 10
    
    createToggle(aimbotContent, "Ativar Aimbot", yPos,
        function() return Aimbot.Settings.Enabled end,
        function(v) Aimbot.Settings.Enabled = v end)
    yPos = yPos + 45
    
    createToggle(aimbotContent, "Ativar FOV", yPos,
        function() return Aimbot.FOVSettings.Enabled end,
        function(v) Aimbot.FOVSettings.Enabled = v end)
    yPos = yPos + 45
    
    createToggle(aimbotContent, "Team Check", yPos,
        function() return Aimbot.Settings.TeamCheck end,
        function(v) Aimbot.Settings.TeamCheck = v end)
    yPos = yPos + 45
    
    createToggle(aimbotContent, "Wall Check", yPos,
        function() return Aimbot.Settings.WallCheck end,
        function(v) Aimbot.Settings.WallCheck = v end)
    yPos = yPos + 45
    
    createToggle(aimbotContent, "Alive Check", yPos,
        function() return Aimbot.Settings.AliveCheck end,
        function(v) Aimbot.Settings.AliveCheck = v end)
    yPos = yPos + 45
    
    createToggle(aimbotContent, "Toggle Mode", yPos,
        function() return Aimbot.Settings.Toggle end,
        function(v) Aimbot.Settings.Toggle = v end)
    yPos = yPos + 45
    
    createSlider(aimbotContent, "Smoothness", yPos, 0.1, 1,
        function() return Aimbot.Settings.Smoothness end,
        function(v) Aimbot.Settings.Smoothness = v end, "float")
    yPos = yPos + 60
    
    createSlider(aimbotContent, "FOV Size", yPos, 10, 360,
        function() return Aimbot.FOVSettings.Amount end,
        function(v) Aimbot.FOVSettings.Amount = v end, "int")
    yPos = yPos + 60
    
    createSlider(aimbotContent, "FOV Transparency", yPos, 0, 1,
        function() return Aimbot.FOVSettings.Transparency end,
        function(v) Aimbot.FOVSettings.Transparency = v end, "float")
    yPos = yPos + 60
    
    aimbotContent.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)
else
    local err = Instance.new("TextLabel")
    err.Size = UDim2.new(1, 0, 0, 50)
    err.Position = UDim2.new(0, 0, 0, 20)
    err.BackgroundTransparency = 1
    err.Text = "❌ Aimbot não carregado!"
    err.TextColor3 = Color3.fromRGB(255, 0, 0)
    err.TextScaled = true
    err.Font = Enum.Font.Gotham
    err.Parent = aimbotContent
end

-- ========== CONTEÚDO AIMBOT (ULTRA COMPLETO) ==========
local aimbotContent = Instance.new("ScrollingFrame")
aimbotContent.Size = UDim2.new(1, 0, 1, 0)
aimbotContent.BackgroundTransparency = 1
aimbotContent.BorderSizePixel = 0
aimbotContent.ScrollBarThickness = 5
aimbotContent.CanvasSize = UDim2.new(0, 0, 0, 1000)
aimbotContent.Visible = false
aimbotContent.Parent = ContentFrame

if Aimbot then
    local yPos = 10
    
    -- TÍTULO PRINCIPAL
    local titleAim = Instance.new("TextLabel")
    titleAim.Size = UDim2.new(1, -20, 0, 35)
    titleAim.Position = UDim2.new(0, 10, 0, yPos)
    titleAim.BackgroundColor3 = Color3.fromRGB(255, 128, 0)
    titleAim.BorderSizePixel = 0
    titleAim.Text = "🎯 AIMBOT ULTRA COMPLETO"
    titleAim.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleAim.TextScaled = true
    titleAim.Font = Enum.Font.GothamBold
    titleAim.Parent = aimbotContent
    yPos = yPos + 45
    
    -- ATIVAR AIMBOT
    createToggle(aimbotContent, "🎯 Ativar Aimbot", yPos,
        function() return Aimbot.Settings.Enabled end,
        function(v) Aimbot.Settings.Enabled = v end)
    yPos = yPos + 45
    
    -- SEÇÃO: PARTE DO CORPO
    local secPart = Instance.new("TextLabel")
    secPart.Size = UDim2.new(1, -20, 0, 25)
    secPart.Position = UDim2.new(0, 10, 0, yPos)
    secPart.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    secPart.BorderSizePixel = 0
    secPart.Text = "   🎯 PARTE DO CORPO"
    secPart.TextColor3 = Color3.fromRGB(255, 200, 100)
    secPart.TextXAlignment = Enum.TextXAlignment.Left
    secPart.TextScaled = true
    secPart.Font = Enum.Font.GothamBold
    secPart.Parent = aimbotContent
    yPos = yPos + 30
    
    -- Dropdown de partes (TODAS as partes R6 e R15)
    local partLabel = Instance.new("TextLabel")
    partLabel.Size = UDim2.new(0, 200, 0, 30)
    partLabel.Position = UDim2.new(0, 20, 0, yPos)
    partLabel.BackgroundTransparency = 1
    partLabel.Text = "Parte atual:"
    partLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    partLabel.TextXAlignment = Enum.TextXAlignment.Left
    partLabel.TextScaled = true
    partLabel.Font = Enum.Font.Gotham
    partLabel.Parent = aimbotContent
    
    local partDisplay = Instance.new("TextLabel")
    partDisplay.Size = UDim2.new(0, 200, 0, 30)
    partDisplay.Position = UDim2.new(0, 200, 0, yPos)
    partDisplay.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    partDisplay.BorderSizePixel = 0
    partDisplay.Text = Aimbot.Settings.LockPart
    partDisplay.TextColor3 = Color3.fromRGB(255, 255, 0)
    partDisplay.TextScaled = true
    partDisplay.Font = Enum.Font.GothamBold
    partDisplay.Parent = aimbotContent
    
    local partBtn = Instance.new("TextButton")
    partBtn.Size = UDim2.new(0, 100, 0, 30)
    partBtn.Position = UDim2.new(0, 410, 0, yPos)
    partBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    partBtn.BorderSizePixel = 0
    partBtn.Text = "Mudar ⬇️"
    partBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    partBtn.TextScaled = true
    partBtn.Font = Enum.Font.Gotham
    partBtn.Parent = aimbotContent
    
    -- Lista COMPLETA de partes
    local partsList = {
        "Head", "HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso",
        "Left Arm", "Right Arm", "LeftUpperArm", "LeftLowerArm", "LeftHand",
        "RightUpperArm", "RightLowerArm", "RightHand", "Left Leg", "Right Leg",
        "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg",
        "RightLowerLeg", "RightFoot"
    }
    local partIndex = 1
    for i, v in ipairs(partsList) do
        if v == Aimbot.Settings.LockPart then
            partIndex = i
            break
        end
    end
    
    partBtn.MouseButton1Click:Connect(function()
        partIndex = partIndex + 1
        if partIndex > #partsList then partIndex = 1 end
        Aimbot.Settings.LockPart = partsList[partIndex]
        partDisplay.Text = Aimbot.Settings.LockPart
    end)
    yPos = yPos + 40
    
    -- SEÇÃO: MODO DE ATIVAÇÃO
    local secMode = Instance.new("TextLabel")
    secMode.Size = UDim2.new(1, -20, 0, 25)
    secMode.Position = UDim2.new(0, 10, 0, yPos)
    secMode.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    secMode.BorderSizePixel = 0
    secMode.Text = "   ⚙️ MODO DE ATIVAÇÃO"
    secMode.TextColor3 = Color3.fromRGB(100, 200, 255)
    secMode.TextXAlignment = Enum.TextXAlignment.Left
    secMode.TextScaled = true
    secMode.Font = Enum.Font.GothamBold
    secMode.Parent = aimbotContent
    yPos = yPos + 30
    
    -- MODO AUTOMÁTICO (gruda sozinho)
    local autoToggle = createToggle(aimbotContent, "🤖 Modo Automático (gruda sozinho)", yPos,
        function() return Aimbot.Settings.Auto end,
        function(v) 
            Aimbot.Settings.Auto = v
            if v then
                Aimbot.Settings.Toggle = false
            end
        end)
    yPos = yPos + 45
    
    -- Só mostra as opções de tecla se NÃO estiver no modo automático
    if not Aimbot.Settings.Auto then
        -- TECLA ATUAL
        local keyLabel = Instance.new("TextLabel")
        keyLabel.Size = UDim2.new(0, 200, 0, 30)
        keyLabel.Position = UDim2.new(0, 20, 0, yPos)
        keyLabel.BackgroundTransparency = 1
        keyLabel.Text = "Tecla atual:"
        keyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        keyLabel.TextXAlignment = Enum.TextXAlignment.Left
        keyLabel.TextScaled = true
        keyLabel.Font = Enum.Font.Gotham
        keyLabel.Parent = aimbotContent
        
        local keyDisplay = Instance.new("TextLabel")
        keyDisplay.Size = UDim2.new(0, 150, 0, 30)
        keyDisplay.Position = UDim2.new(0, 200, 0, yPos)
        keyDisplay.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        keyDisplay.BorderSizePixel = 0
        keyDisplay.Text = Aimbot.Settings.TriggerKey
        keyDisplay.TextColor3 = Color3.fromRGB(255, 255, 0)
        keyDisplay.TextScaled = true
        keyDisplay.Font = Enum.Font.GothamBold
        keyDisplay.Parent = aimbotContent
        
        -- BOTÃO GRAVAR TECLA
        local learnBtn = Instance.new("TextButton")
        learnBtn.Size = UDim2.new(0, 150, 0, 30)
        learnBtn.Position = UDim2.new(0, 360, 0, yPos)
        learnBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        learnBtn.BorderSizePixel = 0
        learnBtn.Text = "🎤 Gravar Tecla"
        learnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        learnBtn.TextScaled = true
        learnBtn.Font = Enum.Font.Gotham
        learnBtn.Parent = aimbotContent
        
        learnBtn.MouseButton1Click:Connect(function()
            Aimbot.Settings.Learning = true
            learnBtn.Text = "⏳ Aperte uma tecla..."
            learnBtn.BackgroundColor3 = Color3.fromRGB(255, 128, 0)
            keyDisplay.Text = "?"
            
            -- Timer de 5 segundos
            task.delay(5, function()
                if Aimbot.Settings.Learning then
                    Aimbot.Settings.Learning = false
                    learnBtn.Text = "🎤 Gravar Tecla"
                    learnBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
                    keyDisplay.Text = Aimbot.Settings.TriggerKey
                end
            end)
            
            -- Atualiza quando aprender
            local conn
            conn = game:GetService("RunService").Stepped:Connect(function()
                if not Aimbot.Settings.Learning then
                    keyDisplay.Text = Aimbot.Settings.TriggerKey
                    learnBtn.Text = "🎤 Gravar Tecla"
                    learnBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
                    conn:Disconnect()
                end
            end)
        end)
        yPos = yPos + 40
        
        -- MODO TOGGLE/HOLD
        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Size = UDim2.new(0, 200, 0, 30)
        toggleLabel.Position = UDim2.new(0, 20, 0, yPos)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Text = "Modo de ativação:"
        toggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.TextScaled = true
        toggleLabel.Font = Enum.Font.Gotham
        toggleLabel.Parent = aimbotContent
        
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 200, 0, 30)
        toggleBtn.Position = UDim2.new(0, 200, 0, yPos)
        toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        toggleBtn.BorderSizePixel = 0
        toggleBtn.Text = Aimbot.Settings.Toggle and "Toggle (Apertar)" or "Hold (Segurar)"
        toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleBtn.TextScaled = true
        toggleBtn.Font = Enum.Font.Gotham
        toggleBtn.Parent = aimbotContent
        
        toggleBtn.MouseButton1Click:Connect(function()
            Aimbot.Settings.Toggle = not Aimbot.Settings.Toggle
            toggleBtn.Text = Aimbot.Settings.Toggle and "Toggle (Apertar)" or "Hold (Segurar)"
        end)
        yPos = yPos + 40
    else
        -- Mensagem quando está em modo automático
        local autoMsg = Instance.new("TextLabel")
        autoMsg.Size = UDim2.new(1, -40, 0, 30)
        autoMsg.Position = UDim2.new(0, 20, 0, yPos)
        autoMsg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        autoMsg.BorderSizePixel = 0
        autoMsg.Text = "🤖 Modo Automático ATIVO - Não precisa de tecla"
        autoMsg.TextColor3 = Color3.fromRGB(0, 255, 0)
        autoMsg.TextScaled = true
        autoMsg.Font = Enum.Font.Gotham
        autoMsg.Parent = aimbotContent
        yPos = yPos + 40
    end
    
    -- SEPARADOR
    local sep1 = Instance.new("Frame")
    sep1.Size = UDim2.new(1, -40, 0, 1)
    sep1.Position = UDim2.new(0, 20, 0, yPos)
    sep1.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    sep1.BorderSizePixel = 0
    sep1.Parent = aimbotContent
    yPos = yPos + 15
    
    -- SEÇÃO: FOV
    local secFOV = Instance.new("TextLabel")
    secFOV.Size = UDim2.new(1, -20, 0, 25)
    secFOV.Position = UDim2.new(0, 10, 0, yPos)
    secFOV.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    secFOV.BorderSizePixel = 0
    secFOV.Text = "   👁️ CONFIGURAÇÕES DO FOV"
    secFOV.TextColor3 = Color3.fromRGB(255, 100, 100)
    secFOV.TextXAlignment = Enum.TextXAlignment.Left
    secFOV.TextScaled = true
    secFOV.Font = Enum.Font.GothamBold
    secFOV.Parent = aimbotContent
    yPos = yPos + 30
    
    -- Ativar FOV
    createToggle(aimbotContent, "👁️ Ativar FOV", yPos,
        function() return Aimbot.FOVSettings.Enabled end,
        function(v) Aimbot.FOVSettings.Enabled = v end)
    yPos = yPos + 45
    
    -- Tamanho do FOV
    createSlider(aimbotContent, "Tamanho do FOV", yPos, 10, 360,
        function() return Aimbot.FOVSettings.Amount end,
        function(v) Aimbot.FOVSettings.Amount = v end, "int")
    yPos = yPos + 60
    
    -- Transparência do FOV
    createSlider(aimbotContent, "Transparência do FOV", yPos, 0, 1,
        function() return Aimbot.FOVSettings.Transparency end,
        function(v) Aimbot.FOVSettings.Transparency = v end, "float")
    yPos = yPos + 60
    
    -- SEPARADOR
    local sep2 = Instance.new("Frame")
    sep2.Size = UDim2.new(1, -40, 0, 1)
    sep2.Position = UDim2.new(0, 20, 0, yPos)
    sep2.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    sep2.BorderSizePixel = 0
    sep2.Parent = aimbotContent
    yPos = yPos + 15
    
    -- SEÇÃO: CHECKS
    local secChecks = Instance.new("TextLabel")
    secChecks.Size = UDim2.new(1, -20, 0, 25)
    secChecks.Position = UDim2.new(0, 10, 0, yPos)
    secChecks.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    secChecks.BorderSizePixel = 0
    secChecks.Text = "   🔒 VERIFICAÇÕES"
    secChecks.TextColor3 = Color3.fromRGB(100, 255, 100)
    secChecks.TextXAlignment = Enum.TextXAlignment.Left
    secChecks.TextScaled = true
    secChecks.Font = Enum.Font.GothamBold
    secChecks.Parent = aimbotContent
    yPos = yPos + 30
    
    -- Team Check
    createToggle(aimbotContent, "👥 Team Check", yPos,
        function() return Aimbot.Settings.TeamCheck end,
        function(v) Aimbot.Settings.TeamCheck = v end)
    yPos = yPos + 45
    
    -- Wall Check
    createToggle(aimbotContent, "🧱 Wall Check", yPos,
        function() return Aimbot.Settings.WallCheck end,
        function(v) Aimbot.Settings.WallCheck = v end)
    yPos = yPos + 45
    
    -- Alive Check
    createToggle(aimbotContent, "💀 Alive Check", yPos,
        function() return Aimbot.Settings.AliveCheck end,
        function(v) Aimbot.Settings.AliveCheck = v end)
    yPos = yPos + 45
    
    -- SEPARADOR
    local sep3 = Instance.new("Frame")
    sep3.Size = UDim2.new(1, -40, 0, 1)
    sep3.Position = UDim2.new(0, 20, 0, yPos)
    sep3.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    sep3.BorderSizePixel = 0
    sep3.Parent = aimbotContent
    yPos = yPos + 15
    
    -- SEÇÃO: SUAVIZAÇÃO
    local secSmooth = Instance.new("TextLabel")
    secSmooth.Size = UDim2.new(1, -20, 0, 25)
    secSmooth.Position = UDim2.new(0, 10, 0, yPos)
    secSmooth.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    secSmooth.BorderSizePixel = 0
    secSmooth.Text = "   ⚡ SUAVIZAÇÃO"
    secSmooth.TextColor3 = Color3.fromRGB(255, 255, 0)
    secSmooth.TextXAlignment = Enum.TextXAlignment.Left
    secSmooth.TextScaled = true
    secSmooth.Font = Enum.Font.GothamBold
    secSmooth.Parent = aimbotContent
    yPos = yPos + 30
    
    -- Smoothness
    createSlider(aimbotContent, "Smoothness", yPos, 0.1, 1,
        function() return Aimbot.Settings.Smoothness end,
        function(v) Aimbot.Settings.Smoothness = v end, "float")
    yPos = yPos + 60
    
    -- Dica de smoothness
    local dica = Instance.new("TextLabel")
    dica.Size = UDim2.new(1, -40, 0, 30)
    dica.Position = UDim2.new(0, 20, 0, yPos)
    dica.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    dica.BorderSizePixel = 0
    dica.Text = "💡 Dica: 0.1 = rápido | 1.0 = suave"
    dica.TextColor3 = Color3.fromRGB(200, 200, 200)
    dica.TextScaled = true
    dica.Font = Enum.Font.Gotham
    dica.Parent = aimbotContent
    yPos = yPos + 40
    
    aimbotContent.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)
else
    local err = Instance.new("TextLabel")
    err.Size = UDim2.new(1, 0, 0, 100)
    err.Position = UDim2.new(0, 0, 0, 20)
    err.BackgroundTransparency = 1
    err.Text = "❌ AIMBOT NÃO CARREGADO!\n\nVerifique se o script do aimbot está correto"
    err.TextColor3 = Color3.fromRGB(255, 0, 0)
    err.TextWrapped = true
    err.TextScaled = true
    err.Font = Enum.Font.Gotham
    err.Parent = aimbotContent
end
    
    -- ===== SEÇÃO: ANTI-SPREAD =====
    local secAS = Instance.new("TextLabel")
    secAS.Size = UDim2.new(1, -20, 0, 25)
    secAS.Position = UDim2.new(0, 10, 0, yPos)
    secAS.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    secAS.BorderSizePixel = 0
    secAS.Text = "   🎯 ANTI-SPREAD"
    secAS.TextColor3 = Color3.fromRGB(255, 200, 100)
    secAS.TextXAlignment = Enum.TextXAlignment.Left
    secAS.TextScaled = true
    secAS.Font = Enum.Font.GothamBold
    secAS.Parent = diversosContent
    yPos = yPos + 30
    
    -- Toggle Anti-Spread
    createToggle(diversosContent, "🎯 Ativar Anti-Spread", yPos,
        function() return Diversos.Settings.AntiSpread.Enabled end,
        function(v) Diversos:ToggleAntiSpread(v) end)
    yPos = yPos + 45
    
    -- Precisão (Accuracy)
    createSlider(diversosContent, "Precisão", yPos, 0, 100,
        function() return Diversos.Settings.AntiSpread.Accuracy end,
        function(v) 
            Diversos.Settings.AntiSpread.Accuracy = v
            if Diversos.Settings.AntiSpread.Enabled then
                Diversos:ToggleAntiSpread(false)
                Diversos:ToggleAntiSpread(true)
            end
        end, "int")
    yPos = yPos + 60
    
    -- Modo do Anti-Spread
    local modeLabel = Instance.new("TextLabel")
    modeLabel.Size = UDim2.new(0, 200, 0, 30)
    modeLabel.Position = UDim2.new(0, 20, 0, yPos)
    modeLabel.BackgroundTransparency = 1
    modeLabel.Text = "Modo:"
    modeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    modeLabel.TextXAlignment = Enum.TextXAlignment.Left
    modeLabel.TextScaled = true
    modeLabel.Font = Enum.Font.Gotham
    modeLabel.Parent = diversosContent
    
    local modeBtn = Instance.new("TextButton")
    modeBtn.Size = UDim2.new(0, 100, 0, 25)
    modeBtn.Position = UDim2.new(0, 200, 0, yPos + 2.5)
    modeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    modeBtn.BorderSizePixel = 0
    modeBtn.Text = Diversos.Settings.AntiSpread.Mode
    modeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    modeBtn.TextScaled = true
    modeBtn.Font = Enum.Font.Gotham
    modeBtn.Parent = diversosContent
    
    modeBtn.MouseButton1Click:Connect(function()
        if Diversos.Settings.AntiSpread.Mode == "Silent" then
            Diversos.Settings.AntiSpread.Mode = "Visual"
        else
            Diversos.Settings.AntiSpread.Mode = "Silent"
        end
        modeBtn.Text = Diversos.Settings.AntiSpread.Mode
        if Diversos.Settings.AntiSpread.Enabled then
            Diversos:ToggleAntiSpread(false)
            Diversos:ToggleAntiSpread(true)
        end
    end)
    yPos = yPos + 40
    
    -- Hotkey Anti-Spread
    local hotkeyLabel = Instance.new("TextLabel")
    hotkeyLabel.Size = UDim2.new(0, 200, 0, 30)
    hotkeyLabel.Position = UDim2.new(0, 20, 0, yPos)
    hotkeyLabel.BackgroundTransparency = 1
    hotkeyLabel.Text = "Hotkey: F1"
    hotkeyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    hotkeyLabel.TextXAlignment = Enum.TextXAlignment.Left
    hotkeyLabel.TextScaled = true
    hotkeyLabel.Font = Enum.Font.Gotham
    hotkeyLabel.Parent = diversosContent
    yPos = yPos + 35
    
    -- Separador
    local sep1 = Instance.new("Frame")
    sep1.Size = UDim2.new(1, -40, 0, 1)
    sep1.Position = UDim2.new(0, 20, 0, yPos)
    sep1.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    sep1.BorderSizePixel = 0
    sep1.Parent = diversosContent
    yPos = yPos + 15
    
    -- ===== SEÇÃO: NO CLIP =====
    local secNC = Instance.new("TextLabel")
    secNC.Size = UDim2.new(1, -20, 0, 25)
    secNC.Position = UDim2.new(0, 10, 0, yPos)
    secNC.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    secNC.BorderSizePixel = 0
    secNC.Text = "   🧱 NO CLIP"
    secNC.TextColor3 = Color3.fromRGB(100, 200, 255)
    secNC.TextXAlignment = Enum.TextXAlignment.Left
    secNC.TextScaled = true
    secNC.Font = Enum.Font.GothamBold
    secNC.Parent = diversosContent
    yPos = yPos + 30
    
    -- Toggle No Clip
    createToggle(diversosContent, "🧱 Ativar No Clip", yPos,
        function() return Diversos.Settings.NoClip.Enabled end,
        function(v) Diversos:ToggleNoClip(v) end)
    yPos = yPos + 45
    
    -- Velocidade No Clip
    createSlider(diversosContent, "Velocidade", yPos, 16, 200,
        function() return Diversos.Settings.NoClip.Speed end,
        function(v) 
            Diversos.Settings.NoClip.Speed = v
            if Diversos.Settings.NoClip.Enabled then
                Diversos:ToggleNoClip(false)
                Diversos:ToggleNoClip(true)
            end
        end, "int")
    yPos = yPos + 60
    
    -- Toggle Ignorar Água
    createToggle(diversosContent, "💧 Ignorar Água", yPos,
        function() return Diversos.Settings.NoClip.IgnoreWater end,
        function(v) 
            Diversos.Settings.NoClip.IgnoreWater = v
            if Diversos.Settings.NoClip.Enabled then
                Diversos:ToggleNoClip(false)
                Diversos:ToggleNoClip(true)
            end
        end)
    yPos = yPos + 45
    
    -- Hotkey No Clip
    local hotkeyNC = Instance.new("TextLabel")
    hotkeyNC.Size = UDim2.new(0, 200, 0, 30)
    hotkeyNC.Position = UDim2.new(0, 20, 0, yPos)
    hotkeyNC.BackgroundTransparency = 1
    hotkeyNC.Text = "Hotkey: F2"
    hotkeyNC.TextColor3 = Color3.fromRGB(200, 200, 200)
    hotkeyNC.TextXAlignment = Enum.TextXAlignment.Left
    hotkeyNC.TextScaled = true
    hotkeyNC.Font = Enum.Font.Gotham
    hotkeyNC.Parent = diversosContent
    yPos = yPos + 35
    
    -- Separador
    local sep2 = Instance.new("Frame")
    sep2.Size = UDim2.new(1, -40, 0, 1)
    sep2.Position = UDim2.new(0, 20, 0, yPos)
    sep2.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    sep2.BorderSizePixel = 0
    sep2.Parent = diversosContent
    yPos = yPos + 15
    
    -- ===== SEÇÃO: INFINITE JUMP =====
    local secIJ = Instance.new("TextLabel")
    secIJ.Size = UDim2.new(1, -20, 0, 25)
    secIJ.Position = UDim2.new(0, 10, 0, yPos)
    secIJ.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    secIJ.BorderSizePixel = 0
    secIJ.Text = "   🦘 INFINITE JUMP"
    secIJ.TextColor3 = Color3.fromRGB(100, 255, 100)
    secIJ.TextXAlignment = Enum.TextXAlignment.Left
    secIJ.TextScaled = true
    secIJ.Font = Enum.Font.GothamBold
    secIJ.Parent = diversosContent
    yPos = yPos + 30
    
    -- Toggle Infinite Jump
    createToggle(diversosContent, "🦘 Ativar Infinite Jump", yPos,
        function() return Diversos.Settings.InfiniteJump.Enabled end,
        function(v) Diversos:ToggleInfiniteJump(v) end)
    yPos = yPos + 45
    
    -- Altura do Pulo
    createSlider(diversosContent, "Altura do Pulo", yPos, 20, 200,
        function() return Diversos.Settings.InfiniteJump.Height end,
        function(v) 
            Diversos.Settings.InfiniteJump.Height = v
            if Diversos.Settings.InfiniteJump.Enabled then
                Diversos:ToggleInfiniteJump(false)
                Diversos:ToggleInfiniteJump(true)
            end
        end, "int")
    yPos = yPos + 60
    
    -- Controle Aéreo
    createToggle(diversosContent, "🎮 Controle Aéreo", yPos,
        function() return Diversos.Settings.InfiniteJump.AirControl end,
        function(v) 
            Diversos.Settings.InfiniteJump.AirControl = v
            if Diversos.Settings.InfiniteJump.Enabled then
                Diversos:ToggleInfiniteJump(false)
                Diversos:ToggleInfiniteJump(true)
            end
        end)
    yPos = yPos + 45
    
    -- Hotkey Infinite Jump
    local hotkeyIJ = Instance.new("TextLabel")
    hotkeyIJ.Size = UDim2.new(0, 200, 0, 30)
    hotkeyIJ.Position = UDim2.new(0, 20, 0, yPos)
    hotkeyIJ.BackgroundTransparency = 1
    hotkeyIJ.Text = "Hotkey: F3"
    hotkeyIJ.TextColor3 = Color3.fromRGB(200, 200, 200)
    hotkeyIJ.TextXAlignment = Enum.TextXAlignment.Left
    hotkeyIJ.TextScaled = true
    hotkeyIJ.Font = Enum.Font.Gotham
    hotkeyIJ.Parent = diversosContent
    yPos = yPos + 35
    
    -- INFO RODAPÉ
    local infoFooter = Instance.new("TextLabel")
    infoFooter.Size = UDim2.new(1, -20, 0, 40)
    infoFooter.Position = UDim2.new(0, 10, 0, yPos + 10)
    infoFooter.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    infoFooter.BorderSizePixel = 0
    infoFooter.Text = "⚡ Hotkeys:\nF1 = Anti-Spread | F2 = No Clip | F3 = Infinite Jump"
    infoFooter.TextColor3 = Color3.fromRGB(255, 255, 0)
    infoFooter.TextWrapped = true
    infoFooter.TextScaled = true
    infoFooter.Font = Enum.Font.Gotham
    infoFooter.Parent = diversosContent
    yPos = yPos + 55
    
    diversosContent.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)
else
    local err = Instance.new("TextLabel")
    err.Size = UDim2.new(1, 0, 0, 100)
    err.Position = UDim2.new(0, 0, 0, 20)
    err.BackgroundTransparency = 1
    err.Text = "❌ MÓDULO DIVERSOS NÃO CARREGADO!\n\nVerifique a URL do módulo"
    err.TextColor3 = Color3.fromRGB(255, 0, 0)
    err.TextWrapped = true
    err.TextScaled = true
    err.Font = Enum.Font.Gotham
    err.Parent = diversosContent
end

-- ========== CONTEÚDO FLY ==========
local flyContent = Instance.new("Frame")
flyContent.Size = UDim2.new(1, 0, 1, 0)
flyContent.BackgroundTransparency = 1
flyContent.Visible = false
flyContent.Parent = ContentFrame

local yPosFly = 20
local flyActive = false

local flyToggle = createToggle(flyContent, "Ativar Fly", yPosFly,
    function() return flyActive end,
    function(v) 
        flyActive = v
        ToggleFly(v)
    end)
yPosFly = yPosFly + 45

createSlider(flyContent, "Velocidade", yPosFly, 10, 200,
    function() return Fly.Speed end,
    function(v) Fly.Speed = v end, "int")
yPosFly = yPosFly + 60

local controls = Instance.new("TextLabel")
controls.Size = UDim2.new(1, -40, 0, 100)
controls.Position = UDim2.new(0, 20, 0, yPosFly)
controls.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
controls.BorderSizePixel = 0
controls.Text = "Controles:\nWASD - Movimento\nEspaço - Subir\nShift - Descer"
controls.TextColor3 = Color3.fromRGB(200, 200, 200)
controls.TextWrapped = true
controls.TextScaled = true
controls.Font = Enum.Font.Gotham
controls.Parent = flyContent

-- ========== SISTEMA DE ABAS ==========
local function hideAllTabs()
    espContent.Visible = false
    aimbotContent.Visible = false
    diversosContent.Visible = false
    flyContent.Visible = false
    for _, btn in pairs(tabs) do
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    end
end

tabESP.MouseButton1Click:Connect(function()
    hideAllTabs()
    espContent.Visible = true
    tabESP.BackgroundColor3 = Color3.fromRGB(255, 128, 0)
end)

tabAimbot.MouseButton1Click:Connect(function()
    hideAllTabs()
    aimbotContent.Visible = true
    tabAimbot.BackgroundColor3 = Color3.fromRGB(255, 128, 0)
end)

tabDiversos.MouseButton1Click:Connect(function()
    hideAllTabs()
    diversosContent.Visible = true
    tabDiversos.BackgroundColor3 = Color3.fromRGB(255, 128, 0)
end)

tabFly.MouseButton1Click:Connect(function()
    hideAllTabs()
    flyContent.Visible = true
    tabFly.BackgroundColor3 = Color3.fromRGB(255, 128, 0)
end)

-- Mostrar primeira aba
espContent.Visible = true
tabESP.BackgroundColor3 = Color3.fromRGB(255, 128, 0)

print("✅ AirHub Premium carregado com sucesso!")
print("📌 ESP AVANÇADO + DIVERSOS (Anti-Spread, No Clip, Infinite Jump)")
print("⚡ Hotkeys: F1=AntiSpread | F2=NoClip | F3=InfiniteJump")
