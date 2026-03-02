--[[
    ESP AVANÇADO ULTRA OTIMIZADO
    Features: Box, Tracers, Nomes, Distância, Vida, Head Dot, Chams, Health Bar
    Otimização: Cache inteligente, Render seletivo, Anti-lag
]]

-- Cache de serviços (mais rápido)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Verificação
if not getgenv().AirHub then getgenv().AirHub = {} end
if getgenv().AirHub.ESP_Avancado then return end

-- ========== CONFIGURAÇÕES ==========
local ESP = {
    Settings = {
        Enabled = false,
        TeamCheck = false,
        AliveCheck = true,
        WallCheck = false,
        MaxDistance = 1000  -- Só renderiza até essa distância (reduz lag)
    },
    
    Visuals = {
        Box = {
            Enabled = true,
            Type = "2D",  -- "2D" ou "3D"
            Color = Color3.new(1, 1, 1),
            Transparency = 0.7,
            Thickness = 1,
            Filled = false,
            Outline = true,
            OutlineColor = Color3.new(0, 0, 0)
        },
        
        Tracer = {
            Enabled = true,
            Type = 1,  -- 1: Bottom, 2: Center, 3: Mouse
            Color = Color3.new(1, 1, 1),
            Transparency = 0.7,
            Thickness = 1
        },
        
        Name = {
            Enabled = true,
            Color = Color3.new(1, 1, 1),
            Size = 14,
            Outline = true,
            OutlineColor = Color3.new(0, 0, 0)
        },
        
        Distance = {
            Enabled = true,
            Color = Color3.new(0, 255, 255),
            Size = 12
        },
        
        Health = {
            Enabled = true,
            Bar = true,  -- Barra de vida
            Text = true, -- Texto da vida
            Position = "Left",  -- Left, Right, Top, Bottom
            Width = 3,
            Height = 30,
            ColorLow = Color3.new(1, 0, 0),    -- Vermelho (vida baixa)
            ColorHigh = Color3.new(0, 1, 0)    -- Verde (vida alta)
        },
        
        HeadDot = {
            Enabled = true,
            Color = Color3.new(1, 0, 0),
            Size = 5,
            Transparency = 0.5,
            Filled = true
        },
        
        Chams = {
            Enabled = false,
            Color = Color3.new(0, 1, 0),
            Transparency = 0.5,
            Mode = "Highlight"  -- "Highlight" ou "Fill"
        },
        
        Weapon = {
            Enabled = true,
            Color = Color3.new(1, 1, 0),
            Size = 12
        }
    },
    
    Performance = {
        RenderEvery = 2,  -- Renderiza a cada 2 frames (reduz 50% do lag)
        CullDistance = true,  -- Não renderiza muito longe
        MaxPlayers = 10,  -- Máximo de players renderizados por vez
        CacheTime = 5  -- Cache de dados por 5 segundos
    }
}

getgenv().AirHub.ESP_Avancado = ESP

-- ========== SISTEMA DE CACHE INTELIGENTE ==========
local PlayerCache = {}
local DrawingCache = {}
local FrameCounter = 0
local LastCleanup = tick()

-- Cache de funções (execução mais rápida)
local WorldToViewport = function(pos) return Camera:WorldToViewportPoint(pos) end
local GetMousePos = function() return UserInputService:GetMouseLocation() end
local Vector2 = Vector2.new
local Color3 = Color3.new
local math_floor = math.floor
local math_abs = math.abs
local math_clamp = function(v, min, max) return math.max(min, math.min(max, v)) end
local Drawing_new = Drawing.new

-- ========== GERENCIADOR DE DRAWINGS ==========
local function GetDrawing(player, type)
    if not DrawingCache[player] then
        DrawingCache[player] = {}
    end
    
    if not DrawingCache[player][type] then
        if type == "Box" then
            DrawingCache[player][type] = Drawing_new("Square")
        elseif type == "BoxOutline" then
            DrawingCache[player][type] = Drawing_new("Square")
        elseif type == "Tracer" then
            DrawingCache[player][type] = Drawing_new("Line")
        elseif type == "Name" then
            DrawingCache[player][type] = Drawing_new("Text")
        elseif type == "Distance" then
            DrawingCache[player][type] = Drawing_new("Text")
        elseif type == "HealthText" then
            DrawingCache[player][type] = Drawing_new("Text")
        elseif type == "HealthBar" then
            DrawingCache[player][type] = Drawing_new("Square")
        elseif type == "HealthBarBg" then
            DrawingCache[player][type] = Drawing_new("Square")
        elseif type == "HeadDot" then
            DrawingCache[player][type] = Drawing_new("Circle")
        elseif type == "Weapon" then
            DrawingCache[player][type] = Drawing_new("Text")
        end
    end
    
    return DrawingCache[player][type]
end

-- ========== VERIFICAÇÕES OTIMIZADAS ==========
local function CanRender(player)
    if player == LocalPlayer then return false end
    if not ESP.Settings.Enabled then return false end
    
    local character = player.Character
    if not character then return false end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    
    if ESP.Settings.AliveCheck and humanoid.Health <= 0 then return false end
    if ESP.Settings.TeamCheck and player.Team == LocalPlayer.Team then return false end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end
    
    -- Verificar distância
    if ESP.Performance.CullDistance then
        local dist = (Camera.CFrame.Position - rootPart.Position).Magnitude
        if dist > ESP.Settings.MaxDistance then return false end
    end
    
    -- Verificar se está na tela (otimizado)
    local pos, onScreen = WorldToViewport(rootPart.Position)
    if not onScreen then return false end
    
    return true
end

-- ========== SISTEMA DE CORES PARA VIDA ==========
local function GetHealthColor(health, maxHealth)
    local percent = health / maxHealth
    return Color3.new(1 - percent, percent, 0)
end

-- ========== ATUALIZAR BOX 2D ==========
local function UpdateBox2D(player, character, rootPart, dist)
    local box = GetDrawing(player, "Box")
    if not box then return end
    
    local pos, onScreen = WorldToViewport(rootPart.Position)
    if not onScreen then 
        box.Visible = false 
        return
    end
    
    -- Calcular tamanho baseado na distância
    local size = math_clamp(2500 / dist, 30, 150)
    
    box.Visible = true
    box.Color = ESP.Visuals.Box.Color
    box.Transparency = ESP.Visuals.Box.Transparency
    box.Thickness = ESP.Visuals.Box.Thickness
    box.Filled = ESP.Visuals.Box.Filled
    box.Size = Vector2(size, size * 1.8)
    box.Position = Vector2(pos.X - size/2, pos.Y - size)
end

-- ========== ATUALIZAR TRACER ==========
local function UpdateTracer(player, character, rootPart)
    local tracer = GetDrawing(player, "Tracer")
    if not tracer then return end
    
    local pos, onScreen = WorldToViewport(rootPart.Position)
    if not onScreen then 
        tracer.Visible = false 
        return
    end
    
    tracer.Visible = true
    tracer.Color = ESP.Visuals.Tracer.Color
    tracer.Transparency = ESP.Visuals.Tracer.Transparency
    tracer.Thickness = ESP.Visuals.Tracer.Thickness
    
    tracer.To = Vector2(pos.X, pos.Y)
    
    -- Tipo do tracer
    if ESP.Visuals.Tracer.Type == 1 then
        tracer.From = Vector2(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
    elseif ESP.Visuals.Tracer.Type == 2 then
        tracer.From = Vector2(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    elseif ESP.Visuals.Tracer.Type == 3 then
        tracer.From = GetMousePos()
    end
end

-- ========== ATUALIZAR NOME E DISTÂNCIA ==========
local function UpdateNameAndDistance(player, character, head, dist)
    local nameText = GetDrawing(player, "Name")
    local distText = GetDrawing(player, "Distance")
    
    local pos, onScreen = WorldToViewport(head.Position)
    if not onScreen then 
        if nameText then nameText.Visible = false end
        if distText then distText.Visible = false end
        return
    end
    
    -- Nome
    if ESP.Visuals.Name.Enabled and nameText then
        nameText.Visible = true
        nameText.Color = ESP.Visuals.Name.Color
        nameText.Size = ESP.Visuals.Name.Size
        nameText.Center = true
        nameText.Outline = ESP.Visuals.Name.Outline
        nameText.OutlineColor = ESP.Visuals.Name.OutlineColor
        nameText.Text = player.DisplayName
        nameText.Position = Vector2(pos.X, pos.Y - 60)
    end
    
    -- Distância
    if ESP.Visuals.Distance.Enabled and distText then
        distText.Visible = true
        distText.Color = ESP.Visuals.Distance.Color
        distText.Size = ESP.Visuals.Distance.Size
        distText.Center = true
        distText.Text = math_floor(dist) .. "m"
        distText.Position = Vector2(pos.X, pos.Y - 45)
    end
end

-- ========== ATUALIZAR HEAD DOT ==========
local function UpdateHeadDot(player, character, head)
    local dot = GetDrawing(player, "HeadDot")
    if not dot then return end
    
    local pos, onScreen = WorldToViewport(head.Position)
    if not onScreen then 
        dot.Visible = false 
        return
    end
    
    dot.Visible = true
    dot.Color = ESP.Visuals.HeadDot.Color
    dot.NumSides = 8
    dot.Filled = ESP.Visuals.HeadDot.Filled
    dot.Thickness = 1
    dot.Transparency = ESP.Visuals.HeadDot.Transparency
    dot.Radius = ESP.Visuals.HeadDot.Size
    dot.Position = Vector2(pos.X, pos.Y)
end

-- ========== ATUALIZAR BARRA DE VIDA ==========
local function UpdateHealth(player, character, rootPart, dist)
    local healthBar = GetDrawing(player, "HealthBar")
    local healthBg = GetDrawing(player, "HealthBarBg")
    local healthText = GetDrawing(player, "HealthText")
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    local pos, onScreen = WorldToViewport(rootPart.Position)
    if not onScreen then 
        if healthBar then healthBar.Visible = false end
        if healthBg then healthBg.Visible = false end
        if healthText then healthText.Visible = false end
        return
    end
    
    local health = humanoid.Health
    local maxHealth = humanoid.MaxHealth
    local percent = math_clamp(health / maxHealth, 0, 1)
    
    -- Barra de vida
    if ESP.Visuals.Health.Bar then
        local barWidth = 3
        local barHeight = 40
        local barX = pos.X + 25
        local barY = pos.Y - 20
        
        -- Fundo da barra
        healthBg.Visible = true
        healthBg.Size = Vector2(barWidth + 2, barHeight + 2)
        healthBg.Position = Vector2(barX - 1, barY - 1)
        healthBg.Color = Color3.new(0, 0, 0)
        healthBg.Transparency = 0.3
        healthBg.Filled = true
        healthBg.Thickness = 0
        
        -- Barra de vida
        healthBar.Visible = true
        healthBar.Size = Vector2(barWidth, barHeight * percent)
        healthBar.Position = Vector2(barX, barY + (barHeight * (1 - percent)))
        healthBar.Color = GetHealthColor(health, maxHealth)
        healthBar.Transparency = 0
        healthBar.Filled = true
        healthBar.Thickness = 0
    end
    
    -- Texto da vida
    if ESP.Visuals.Health.Text and healthText then
        healthText.Visible = true
        healthText.Text = math_floor(health)
        healthText.Size = 12
        healthText.Color = GetHealthColor(health, maxHealth)
        healthText.Position = Vector2(pos.X + 35, pos.Y - 10)
        healthText.Center = false
    end
end

-- ========== ATUALIZAR ARMA ==========
local function UpdateWeapon(player, character, head)
    local weaponText = GetDrawing(player, "Weapon")
    if not weaponText then return end
    
    local tool = character:FindFirstChildOfClass("Tool")
    if not tool then 
        weaponText.Visible = false 
        return
    end
    
    local pos, onScreen = WorldToViewport(head.Position)
    if not onScreen then 
        weaponText.Visible = false 
        return
    end
    
    weaponText.Visible = true
    weaponText.Text = "[" .. tool.Name .. "]"
    weaponText.Color = ESP.Visuals.Weapon.Color
    weaponText.Size = ESP.Visuals.Weapon.Size
    weaponText.Center = true
    weaponText.Position = Vector2(pos.X, pos.Y - 75)
end

-- ========== LIMPEZA DE CACHE ==========
local function CleanupCache()
    for player in pairs(DrawingCache) do
        if not player or not player.Parent then
            for _, drawing in pairs(DrawingCache[player]) do
                pcall(function() drawing:Remove() end)
            end
            DrawingCache[player] = nil
        end
    end
end

-- ========== LOOP PRINCIPAL ULTRA OTIMIZADO ==========
local connection
connection = RunService.RenderStepped:Connect(function()
    -- Limpeza periódica (a cada 5 segundos)
    if tick() - LastCleanup > 5 then
        CleanupCache()
        LastCleanup = tick()
    end
    
    -- Controle de frames (reduz lag)
    FrameCounter = FrameCounter + 1
    if FrameCounter % ESP.Performance.RenderEvery ~= 0 then return end
    
    -- Se ESP desligado, esconder tudo
    if not ESP.Settings.Enabled then
        for player, drawings in pairs(DrawingCache) do
            for _, drawing in pairs(drawings) do
                if drawing then drawing.Visible = false end
            end
        end
        return
    end
    
    -- Renderizar players
    local rendered = 0
    for _, player in ipairs(Players:GetPlayers()) do
        if rendered >= ESP.Performance.MaxPlayers then break end
        
        if CanRender(player) then
            local character = player.Character
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            local head = character:FindFirstChild("Head")
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            
            if rootPart and head and humanoid then
                local dist = (Camera.CFrame.Position - rootPart.Position).Magnitude
                
                -- Renderizar cada elemento
                if ESP.Visuals.Box.Enabled then UpdateBox2D(player, character, rootPart, dist) end
                if ESP.Visuals.Tracer.Enabled then UpdateTracer(player, character, rootPart) end
                if ESP.Visuals.Name.Enabled or ESP.Visuals.Distance.Enabled then 
                    UpdateNameAndDistance(player, character, head, dist) 
                end
                if ESP.Visuals.HeadDot.Enabled then UpdateHeadDot(player, character, head) end
                if ESP.Visuals.Health.Bar or ESP.Visuals.Health.Text then 
                    UpdateHealth(player, character, rootPart, dist) 
                end
                if ESP.Visuals.Weapon.Enabled then UpdateWeapon(player, character, head) end
                
                rendered = rendered + 1
            end
        else
            -- Esconder drawings de players não renderizáveis
            local drawings = DrawingCache[player]
            if drawings then
                for _, drawing in pairs(drawings) do
                    if drawing then drawing.Visible = false end
                end
            end
        end
    end
end)

-- ========== INICIALIZAÇÃO ==========
-- Adicionar jogadores existentes
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        -- Pré-criar drawings
        GetDrawing(player, "Box")
        GetDrawing(player, "Tracer")
        GetDrawing(player, "Name")
        GetDrawing(player, "Distance")
        GetDrawing(player, "HealthBar")
        GetDrawing(player, "HealthBarBg")
        GetDrawing(player, "HealthText")
        GetDrawing(player, "HeadDot")
        GetDrawing(player, "Weapon")
    end
end

-- Detectar novos jogadores
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        -- Criar drawings para o novo jogador
        GetDrawing(player, "Box")
        GetDrawing(player, "Tracer")
        GetDrawing(player, "Name")
        GetDrawing(player, "Distance")
        GetDrawing(player, "HealthBar")
        GetDrawing(player, "HealthBarBg")
        GetDrawing(player, "HealthText")
        GetDrawing(player, "HeadDot")
        GetDrawing(player, "Weapon")
    end
end)

-- Remover jogadores
Players.PlayerRemoving:Connect(function(player)
    local drawings = DrawingCache[player]
    if drawings then
        for _, drawing in pairs(drawings) do
            pcall(function() drawing:Remove() end)
        end
        DrawingCache[player] = nil
    end
end)

-- ========== FUNÇÕES DE CONTROLE ==========
ESP.Functions = {
    Exit = function()
        if connection then connection:Disconnect() end
        for player, drawings in pairs(DrawingCache) do
            for _, drawing in pairs(drawings) do
                pcall(function() drawing:Remove() end)
            end
        end
        DrawingCache = {}
        getgenv().AirHub.ESP_Avancado = nil
    end,
    
    Reset = function()
        ESP.Settings.Enabled = false
        ESP.Settings.TeamCheck = false
        ESP.Settings.AliveCheck = true
    end
}

print("✅ ESP AVANÇADO ULTRA OTIMIZADO carregado!")
print("📊 Features: Box | Tracer | Nome | Distância | Vida | HeadDot | Arma")
print("⚡ Otimização: Render seletivo | Cache inteligente | Anti-lag")

return ESP
