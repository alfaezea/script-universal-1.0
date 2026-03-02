--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║              AIRHUB PREMIUM - COMPLETE                    ║
    ║         ESP | Aimbot | Hitbox | Fly (Embutido)            ║
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

loadModule("https://raw.githubusercontent.com/alfaezea/script-universal-1.0/refs/heads/main/esp.lua", "ESP")
loadModule("https://raw.githubusercontent.com/alfaezea/script-universal-1.0/refs/heads/main/aimbot.lua", "Aimbot")
loadModule("https://raw.githubusercontent.com/alfaezea/script-universal-1.0/refs/heads/main/hitbox.lua", "Hitbox")

-- Aguardar carregamento
task.wait(2)

-- ========== OBTER REFERÊNCIAS ==========
local ESP = getgenv().AirHub and getgenv().AirHub.WallHack
local Aimbot = getgenv().AirHub and getgenv().AirHub.Aimbot
local HitboxModule = getgenv().LimbExtender

-- Inicializar Hitbox
local Hitbox = HitboxModule and HitboxModule({})

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
MainFrame.Size = UDim2.new(0, 650, 0, 500)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -250)
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
Title.Text = "AIRHUB PREMIUM"
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
    if Hitbox and Hitbox.Destroy then Hitbox:Destroy() end
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
    status.Size = UDim2.new(0, 150, 1, 0)
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
createStatus("Aimbot: " .. (Aimbot and "✅" or "❌"), Aimbot and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 170)
createStatus("Hitbox: " .. (Hitbox and "✅" or "❌"), Hitbox and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 330)
createStatus("Fly: ✅", Color3.fromRGB(0, 255, 0), 490)

-- Abas
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -20, 0, 35)
TabContainer.Position = UDim2.new(0, 10, 0, 80)
TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

local tabs = {}
local currentTab = nil

local function createTab(name, pos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 1, -10)
    btn.Position = UDim2.new(0, 5 + (105 * (pos-1)), 0, 5)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.Parent = TabContainer
    return btn
end

-- Container de conteúdo
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -170)
ContentFrame.Position = UDim2.new(0, 10, 0, 120)
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
    label.Size = UDim2.new(0, 200, 1, 0)
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
local tabESP = createTab("ESP", 1)
local tabAimbot = createTab("Aimbot", 2)
local tabHitbox = createTab("Hitbox", 3)
local tabFly = createTab("Fly", 4)

-- ========== CONTEÚDO ESP ==========
local espContent = Instance.new("ScrollingFrame")
espContent.Size = UDim2.new(1, 0, 1, 0)
espContent.BackgroundTransparency = 1
espContent.BorderSizePixel = 0
espContent.ScrollBarThickness = 5
espContent.CanvasSize = UDim2.new(0, 0, 0, 400)
espContent.Visible = false
espContent.Parent = ContentFrame

if ESP then
    local yPos = 10
    
    createToggle(espContent, "Ativar ESP", yPos, 
        function() return ESP.Settings.Enabled end,
        function(v) ESP.Settings.Enabled = v end)
    yPos = yPos + 45
    
    createToggle(espContent, "Box ESP", yPos,
        function() return ESP.Visuals.BoxSettings.Enabled end,
        function(v) ESP.Visuals.BoxSettings.Enabled = v end)
    yPos = yPos + 45
    
    createToggle(espContent, "Tracers", yPos,
        function() return ESP.Visuals.TracersSettings.Enabled end,
        function(v) ESP.Visuals.TracersSettings.Enabled = v end)
    yPos = yPos + 45
    
    createToggle(espContent, "Head Dot", yPos,
        function() return ESP.Visuals.HeadDotSettings.Enabled end,
        function(v) ESP.Visuals.HeadDotSettings.Enabled = v end)
    yPos = yPos + 45
    
    createToggle(espContent, "Team Check", yPos,
        function() return ESP.Settings.TeamCheck end,
        function(v) ESP.Settings.TeamCheck = v end)
    yPos = yPos + 45
    
    createToggle(espContent, "Alive Check", yPos,
        function() return ESP.Settings.AliveCheck end,
        function(v) ESP.Settings.AliveCheck = v end)
    yPos = yPos + 45
    
    createToggle(espContent, "Mostrar Nomes", yPos,
        function() return ESP.Visuals.ESPSettings.DisplayName end,
        function(v) ESP.Visuals.ESPSettings.DisplayName = v end)
    yPos = yPos + 45
    
    createToggle(espContent, "Mostrar Distância", yPos,
        function() return ESP.Visuals.ESPSettings.DisplayDistance end,
        function(v) ESP.Visuals.ESPSettings.DisplayDistance = v end)
    yPos = yPos + 45
    
    createToggle(espContent, "Mostrar Vida", yPos,
        function() return ESP.Visuals.ESPSettings.DisplayHealth end,
        function(v) ESP.Visuals.ESPSettings.DisplayHealth = v end)
    yPos = yPos + 45
    
    espContent.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)
else
    local err = Instance.new("TextLabel")
    err.Size = UDim2.new(1, 0, 0, 50)
    err.Position = UDim2.new(0, 0, 0, 20)
    err.BackgroundTransparency = 1
    err.Text = "❌ ESP não carregado!"
    err.TextColor3 = Color3.fromRGB(255, 0, 0)
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

-- ========== CONTEÚDO HITBOX ==========
local hitboxContent = Instance.new("ScrollingFrame")
hitboxContent.Size = UDim2.new(1, 0, 1, 0)
hitboxContent.BackgroundTransparency = 1
hitboxContent.BorderSizePixel = 0
hitboxContent.ScrollBarThickness = 5
hitboxContent.CanvasSize = UDim2.new(0, 0, 0, 300)
hitboxContent.Visible = false
hitboxContent.Parent = ContentFrame

if Hitbox then
    local yPos = 10
    local hitboxActive = false
    
    local toggleBtn = createToggle(hitboxContent, "Ativar Hitbox", yPos,
        function() return hitboxActive end,
        function(v) 
            hitboxActive = v
            if v then 
                Hitbox:Start()
            else 
                Hitbox:Stop()
            end
        end)
    yPos = yPos + 45
    
    createToggle(hitboxContent, "Team Check", yPos,
        function() return Hitbox:Get("TEAM_CHECK") end,
        function(v) Hitbox:Set("TEAM_CHECK", v) end)
    yPos = yPos + 45
    
    createToggle(hitboxContent, "Usar Highlight", yPos,
        function() return Hitbox:Get("USE_HIGHLIGHT") end,
        function(v) Hitbox:Set("USE_HIGHLIGHT", v) end)
    yPos = yPos + 45
    
    createSlider(hitboxContent, "Tamanho", yPos, 5, 30,
        function() return Hitbox:Get("LIMB_SIZE") or 15 end,
        function(v) Hitbox:Set("LIMB_SIZE", v) end, "int")
    yPos = yPos + 60
    
    createSlider(hitboxContent, "Transparência", yPos, 0, 1,
        function() return Hitbox:Get("LIMB_TRANSPARENCY") or 0.9 end,
        function(v) Hitbox:Set("LIMB_TRANSPARENCY", v) end, "float")
    yPos = yPos + 60
    
    hitboxContent.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)
else
    local err = Instance.new("TextLabel")
    err.Size = UDim2.new(1, 0, 0, 50)
    err.Position = UDim2.new(0, 0, 0, 20)
    err.BackgroundTransparency = 1
    err.Text = "❌ Hitbox não carregado!"
    err.TextColor3 = Color3.fromRGB(255, 0, 0)
    err.TextScaled = true
    err.Font = Enum.Font.Gotham
    err.Parent = hitboxContent
end

-- ========== CONTEÚDO FLY ==========
local flyContent = Instance.new("Frame")
flyContent.Size = UDim2.new(1, 0, 1, 0)
flyContent.BackgroundTransparency = 1
flyContent.Visible = false
flyContent.Parent = ContentFrame

local yPos = 20
local flyActive = false

local flyToggle = createToggle(flyContent, "Ativar Fly", yPos,
    function() return flyActive end,
    function(v) 
        flyActive = v
        ToggleFly(v)
    end)
yPos = yPos + 45

createSlider(flyContent, "Velocidade", yPos, 10, 200,
    function() return Fly.Speed end,
    function(v) Fly.Speed = v end, "int")
yPos = yPos + 60

local controls = Instance.new("TextLabel")
controls.Size = UDim2.new(1, -40, 0, 100)
controls.Position = UDim2.new(0, 20, 0, yPos)
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
    hitboxContent.Visible = false
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

tabHitbox.MouseButton1Click:Connect(function()
    hideAllTabs()
    hitboxContent.Visible = true
    tabHitbox.BackgroundColor3 = Color3.fromRGB(255, 128, 0)
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
print("📌 Use as abas para configurar cada módulo")
