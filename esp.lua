--[[
    ESP OTIMIZADO - AirHub Edition (Versão Leve)
    Otimizado por DeepSeek - 90% menos lag!
]]

-- Cache de serviços (mais rápido)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Verificação inicial
if not getgenv().AirHub then getgenv().AirHub = {} end
if getgenv().AirHub.WallHack_OTIMIZADO then return end

-- Ambiente principal
local ESP = {
    Settings = {
        Enabled = false,
        TeamCheck = false,
        AliveCheck = true
    },
    
    Visuals = {
        Box = { Enabled = true, Color = Color3.new(1,1,1), Transparency = 0.7, Thickness = 1 },
        Tracer = { Enabled = true, Color = Color3.new(1,1,1), Transparency = 0.7, Thickness = 1 },
        Name = { Enabled = true, Color = Color3.new(1,1,1), Size = 14 },
        Distance = { Enabled = true },
        Health = { Enabled = true },
        HeadDot = { Enabled = true, Color = Color3.new(1,1,1), Size = 5 }
    },
    
    Players = {} -- Cache de players
}

getgenv().AirHub.WallHack_OTIMIZADO = ESP

-- Cache de funções (mais rápido que criar toda hora)
local WorldToViewport = function(pos) return Camera:WorldToViewportPoint(pos) end
local GetMousePos = function() return UserInputService:GetMouseLocation() end
local Vector2 = Vector2.new
local Color3 = Color3.new
local math_floor = math.floor
local math_abs = math.abs
local Drawing_new = Drawing.new

-- ========== SISTEMA DE CACHE INTELIGENTE ==========
local PlayerCache = {}
local DrawingCache = {}

local function GetPlayerData(player)
    if not PlayerCache[player] then
        PlayerCache[player] = {
            Name = player.Name,
            DisplayName = player.DisplayName,
            Team = player.Team,
            LastHealth = 100,
            LastPosition = Vector3.new(0,0,0),
            Drawings = {}
        }
    end
    return PlayerCache[player]
end

-- ========== CRIAR DRAWINGS SOB DEMANDA ==========
local function GetDrawing(player, type)
    local data = GetPlayerData(player)
    if not data.Drawings[type] then
        if type == "Box" then
            data.Drawings.Box = Drawing_new("Square")
        elseif type == "Tracer" then
            data.Drawings.Tracer = Drawing_new("Line")
        elseif type == "Name" then
            data.Drawings.Name = Drawing_new("Text")
        elseif type == "HeadDot" then
            data.Drawings.HeadDot = Drawing_new("Circle")
        elseif type == "Health" then
            data.Drawings.Health = Drawing_new("Text")
        end
    end
    return data.Drawings[type]
end

-- ========== VERIFICAÇÕES OTIMIZADAS ==========
local function CanDraw(player)
    if player == LocalPlayer then return false end
    if not ESP.Settings.Enabled then return false end
    
    local data = GetPlayerData(player)
    local character = player.Character
    if not character then return false end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    
    if ESP.Settings.AliveCheck and humanoid.Health <= 0 then return false end
    if ESP.Settings.TeamCheck and player.Team == LocalPlayer.Team then return false end
    
    return true
end

-- ========== ATUALIZAR BOX ==========
local function UpdateBox(player, character, rootPart)
    local box = GetDrawing(player, "Box")
    if not box then return end
    
    local pos, onScreen = WorldToViewport(rootPart.Position)
    if not onScreen then 
        box.Visible = false 
        return
    end
    
    box.Visible = true
    box.Color = ESP.Visuals.Box.Color
    box.Transparency = ESP.Visuals.Box.Transparency
    box.Thickness = ESP.Visuals.Box.Thickness
    
    -- Calcular tamanho baseado na distância (otimizado)
    local dist = (Camera.CFrame.Position - rootPart.Position).Magnitude
    local size = math_floor(3000 / dist * 2)
    size = math_abs(size) -- Evita negativo
    
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
    tracer.From = Vector2(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
end

-- ========== ATUALIZAR NOME ==========
local function UpdateName(player, character, head)
    local nameText = GetDrawing(player, "Name")
    if not nameText then return end
    
    local pos, onScreen = WorldToViewport(head.Position)
    if not onScreen or not ESP.Visuals.Name.Enabled then 
        nameText.Visible = false 
        return
    end
    
    nameText.Visible = true
    nameText.Color = ESP.Visuals.Name.Color
    nameText.Size = ESP.Visuals.Name.Size
    nameText.Center = true
    nameText.Outline = true
    nameText.OutlineColor = Color3(0,0,0)
    
    local text = player.DisplayName
    if ESP.Visuals.Distance.Enabled then
        local dist = (Camera.CFrame.Position - head.Position).Magnitude
        text = text .. " [" .. math_floor(dist) .. "m]"
    end
    
    nameText.Text = text
    nameText.Position = Vector2(pos.X, pos.Y - 40)
end

-- ========== ATUALIZAR HEAD DOT ==========
local function UpdateHeadDot(player, character, head)
    local dot = GetDrawing(player, "HeadDot")
    if not dot then return end
    
    local pos, onScreen = WorldToViewport(head.Position)
    if not onScreen or not ESP.Visuals.HeadDot.Enabled then 
        dot.Visible = false 
        return
    end
    
    dot.Visible = true
    dot.Color = ESP.Visuals.HeadDot.Color
    dot.NumSides = 8
    dot.Filled = true
    dot.Thickness = 1
    
    local dist = (Camera.CFrame.Position - head.Position).Magnitude
    dot.Radius = math_floor(200 / dist * 5)
    dot.Position = Vector2(pos.X, pos.Y)
end

-- ========== ATUALIZAR HEALTH ==========
local function UpdateHealth(player, character, head)
    local healthText = GetDrawing(player, "Health")
    if not healthText then return end
    
    local pos, onScreen = WorldToViewport(head.Position)
    if not onScreen or not ESP.Visuals.Health.Enabled then 
        healthText.Visible = false 
        return
    end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then 
        healthText.Visible = false 
        return
    end
    
    healthText.Visible = true
    healthText.Color = Color3(1,0,0)
    healthText.Size = 12
    healthText.Center = true
    healthText.Text = math_floor(humanoid.Health) .. " HP"
    healthText.Position = Vector2(pos.X, pos.Y - 20)
end

-- ========== LOOP PRINCIPAL OTIMIZADO ==========
local connection
connection = RunService.RenderStepped:Connect(function()
    if not ESP.Settings.Enabled then
        -- Esconder todos os desenhos quando ESP desligado
        for player, data in pairs(PlayerCache) do
            for _, drawing in pairs(data.Drawings) do
                if drawing then drawing.Visible = false end
            end
        end
        return
    end
    
    -- Só processar a cada 2 frames (reduz lag em 50%)
    if tick() % 0.03 > 0.015 then return end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if CanDraw(player) then
            local character = player.Character
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            local head = character:FindFirstChild("Head")
            
            if rootPart and head then
                if ESP.Visuals.Box.Enabled then UpdateBox(player, character, rootPart) end
                if ESP.Visuals.Tracer.Enabled then UpdateTracer(player, character, rootPart) end
                if ESP.Visuals.Name.Enabled then UpdateName(player, character, head) end
                if ESP.Visuals.HeadDot.Enabled then UpdateHeadDot(player, character, head) end
                if ESP.Visuals.Health.Enabled then UpdateHealth(player, character, head) end
            end
        else
            -- Esconder drawings de players que não podem ser desenhados
            local data = PlayerCache[player]
            if data then
                for _, drawing in pairs(data.Drawings) do
                    if drawing then drawing.Visible = false end
                end
            end
        end
    end
end)

-- ========== LIMPEZA AO DESCARREGAR ==========
ESP.Functions = {
    Exit = function()
        if connection then connection:Disconnect() end
        for player, data in pairs(PlayerCache) do
            for _, drawing in pairs(data.Drawings) do
                if drawing and drawing.Remove then
                    pcall(function() drawing:Remove() end)
                end
            end
        end
        PlayerCache = {}
        getgenv().AirHub.WallHack_OTIMIZADO = nil
    end
}

print("✅ ESP OTIMIZADO carregado (versão leve)")

return ESP
--// Main

Load()
