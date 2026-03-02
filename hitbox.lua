--[[
    HITBOX EXTENDER - VERSÃO SIMPLIFICADA
    Sem dependências externas, 100% funcional
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local HitboxSimple = {}
HitboxSimple.__index = HitboxSimple

-- Configurações padrão
local DEFAULTS = {
    TOGGLE_KEY = "L",
    TARGET_PART = "HumanoidRootPart",
    SIZE = 15,
    TRANSPARENCY = 0.9,
    CAN_COLLIDE = false,
    TEAM_CHECK = true,
    ALIVE_CHECK = true,
    USE_HIGHLIGHT = true,
    HIGHLIGHT_COLOR = Color3.fromRGB(255, 117, 24),
    HIGHLIGHT_TRANSPARENCY = 0.7,
    ACTIVE = false
}

function HitboxSimple.new(settings)
    local self = setmetatable({}, HitboxSimple)
    
    -- Merge settings
    self.Settings = {}
    for k,v in pairs(DEFAULTS) do self.Settings[k] = v end
    if settings then
        for k,v in pairs(settings) do self.Settings[k] = v end
    end
    
    self.Players = {}
    self.Connections = {}
    self.Highlights = {}
    self.OriginalSizes = {}  -- Guarda tamanhos originais
    
    -- Iniciar se ativo
    if self.Settings.ACTIVE then
        self:Start()
    end
    
    return self
end

-- Verifica se pode modificar o jogador
function HitboxSimple:CanModify(player)
    if player == LocalPlayer then return false end
    if not player.Character then return false end
    
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    
    if self.Settings.TEAM_CHECK and player.Team == LocalPlayer.Team then
        return false
    end
    
    return true
end

-- Salva tamanho original e modifica
function HitboxSimple:ModifyPart(part)
    if not part or not part.Parent then return end
    
    -- Salva tamanho original se ainda não salvou
    if not self.OriginalSizes[part] then
        self.OriginalSizes[part] = {
            Size = part.Size,
            Transparency = part.Transparency,
            CanCollide = part.CanCollide
        }
    end
    
    -- Aplica novo tamanho
    local newSize = Vector3.new(
        self.Settings.SIZE,
        self.Settings.SIZE,
        self.Settings.SIZE
    )
    
    part.Size = newSize
    part.Transparency = self.Settings.TRANSPARENCY
    part.CanCollide = self.Settings.CAN_COLLIDE
    part.Massless = true
    
    -- Criar highlight se necessário
    if self.Settings.USE_HIGHLIGHT and not self.Highlights[part] then
        local highlight = Instance.new("Highlight")
        highlight.Adornee = part
        highlight.FillColor = self.Settings.HIGHLIGHT_COLOR
        highlight.FillTransparency = self.Settings.HIGHLIGHT_TRANSPARENCY
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = game:GetService("CoreGui")
        self.Highlights[part] = highlight
    end
end

-- Restaura tamanho original
function HitboxSimple:RestorePart(part)
    if not part then return end
    
    if self.OriginalSizes[part] then
        local original = self.OriginalSizes[part]
        part.Size = original.Size
        part.Transparency = original.Transparency
        part.CanCollide = original.CanCollide
        part.Massless = false
        self.OriginalSizes[part] = nil
    end
    
    if self.Highlights[part] then
        self.Highlights[part]:Destroy()
        self.Highlights[part] = nil
    end
end

-- Processa um jogador
function HitboxSimple:ProcessPlayer(player)
    if not self:CanModify(player) then return end
    
    local character = player.Character
    local targetPart = character:FindFirstChild(self.Settings.TARGET_PART)
    
    if targetPart then
        self:ModifyPart(targetPart)
    end
    
    -- Monitorar morte/resspawn
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        -- Quando morrer, restaurar
        local deathConn
        deathConn = humanoid.Died:Connect(function()
            self:RestorePart(targetPart)
            if deathConn then deathConn:Disconnect() end
        end)
        table.insert(self.Connections, deathConn)
        
        -- Quando reviver, modificar de novo
        local respawnConn
        respawnConn = player.CharacterAdded:Connect(function(newChar)
            -- Aguardar carregar
            task.wait(0.5)
            local newPart = newChar:FindFirstChild(self.Settings.TARGET_PART)
            if newPart then
                self:ModifyPart(newPart)
            end
            if respawnConn then respawnConn:Disconnect() end
        end)
        table.insert(self.Connections, respawnConn)
    end
end

-- Iniciar hitbox
function HitboxSimple:Start()
    if self.Active then return end
    self.Active = true
    
    -- Processar jogadores atuais
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            self:ProcessPlayer(player)
        end
    end
    
    -- Detectar novos jogadores
    local playerAddedConn
    playerAddedConn = Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer then
            -- Aguardar character carregar
            local charConn
            charConn = player.CharacterAdded:Connect(function()
                task.wait(0.5)
                self:ProcessPlayer(player)
                if charConn then charConn:Disconnect() end
            end)
            table.insert(self.Connections, charConn)
            
            -- Se já tem character
            if player.Character then
                task.wait(0.5)
                self:ProcessPlayer(player)
            end
        end
    end)
    table.insert(self.Connections, playerAddedConn)
    
    -- Loop de manutenção (garantir que continua funcionando)
    local loopConn
    loopConn = RunService.Heartbeat:Connect(function()
        if not self.Active then
            if loopConn then loopConn:Disconnect() end
            return
        end
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local part = player.Character:FindFirstChild(self.Settings.TARGET_PART)
                if part and not self.OriginalSizes[part] and self:CanModify(player) then
                    self:ModifyPart(part)
                end
            end
        end
    end)
    table.insert(self.Connections, loopConn)
    
    print("✅ Hitbox Ativada - Tamanho: " .. self.Settings.SIZE)
end

-- Parar hitbox
function HitboxSimple:Stop()
    self.Active = false
    
    -- Restaurar todas as partes
    for part in pairs(self.OriginalSizes) do
        self:RestorePart(part)
    end
    
    -- Desconectar tudo
    for _, conn in ipairs(self.Connections) do
        if conn and conn.Disconnect then
            conn:Disconnect()
        end
    end
    self.Connections = {}
    
    -- Destruir highlights
    for _, highlight in pairs(self.Highlights) do
        if highlight and highlight.Destroy then
            highlight:Destroy()
        end
    end
    self.Highlights = {}
    
    print("❌ Hitbox Desativada")
end

-- Toggle
function HitboxSimple:Toggle()
    if self.Active then
        self:Stop()
    else
        self:Start()
    end
    return self.Active
end

-- Atualizar configuração
function HitboxSimple:Set(key, value)
    local oldValue = self.Settings[key]
    self.Settings[key] = value
    
    -- Se ativo, reiniciar para aplicar
    if self.Active and oldValue ~= value then
        self:Stop()
        self:Start()
    end
end

-- Pegar configuração
function HitboxSimple:Get(key)
    return self.Settings[key]
end

-- Destruir
function HitboxSimple:Destroy()
    self:Stop()
    self.Settings = nil
    self.Players = nil
    self.Connections = nil
    self.Highlights = nil
    self.OriginalSizes = nil
end

return setmetatable({}, { 
    __call = function(_, settings) 
        return HitboxSimple.new(settings) 
    end 
})

function LimbExtender:Get(key) return self._settings[key] end

return setmetatable({}, { __call = function(_, userSettings) return LimbExtender.new(userSettings) end, __index = LimbExtender, })
