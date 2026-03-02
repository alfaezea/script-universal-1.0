-- ========== HITBOX QUE FUNCIONA COM TIROS ==========
local HitboxComTiros = {}
HitboxComTiros.__index = HitboxComTiros

-- Configurações padrão
local DEFAULTS = {
    TOGGLE_KEY = "L",
    TARGET_PART = "HumanoidRootPart",
    SIZE = 15,
    TRANSPARENCY = 0.5,  -- Meio transparente pra ver
    TEAM_CHECK = true,
    ALIVE_CHECK = true,
    ACTIVE = false
}

function HitboxComTiros.new(settings)
    local self = setmetatable({}, HitboxComTiros)
    
    self.Settings = {}
    for k,v in pairs(DEFAULTS) do self.Settings[k] = v end
    if settings then
        for k,v in pairs(settings) do self.Settings[k] = v end
    end
    
    self.HitboxParts = {}  -- Parts fantasmas que recebem os tiros
    self.OriginalParts = {} -- Parts originais escondidas
    self.Connections = {}
    self.Active = false
    
    return self
end

-- Verifica se pode modificar o jogador
function HitboxComTiros:CanModify(player)
    if player == LocalPlayer then return false end
    if not player.Character then return false end
    
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    
    if self.Settings.TEAM_CHECK and player.Team == LocalPlayer.Team then
        return false
    end
    
    return true
end

-- Cria uma hitbox fantasma para o jogador
function HitboxComTiros:CreateGhostHitbox(player)
    local character = player.Character
    if not character then return end
    
    local targetPart = character:FindFirstChild(self.Settings.TARGET_PART)
    if not targetPart then return end
    
    -- Se já existe hitbox para esse player, não criar de novo
    if self.HitboxParts[player] then return end
    
    -- Criar uma part fantasma
    local ghost = Instance.new("Part")
    ghost.Name = "GhostHitbox_" .. player.Name
    ghost.Size = Vector3.new(
        self.Settings.SIZE,
        self.Settings.SIZE,
        self.Settings.SIZE
    )
    ghost.Transparency = self.Settings.TRANSPARENCY
    ghost.CanCollide = false
    ghost.Anchored = false
    ghost.Massless = true
    ghost.CanQuery = true
    ghost.CanTouch = true
    
    -- Configurar para receber tiros
    ghost.CastShadow = false
    ghost.Material = Enum.Material.Neon
    ghost.BrickColor = BrickColor.new("Bright red")
    
    -- Posicionar exatamente onde está a parte alvo
    ghost.CFrame = targetPart.CFrame
    
    -- COLAR a parte fantasma no jogador (Weld)
    local weld = Instance.new("Weld")
    weld.Part0 = targetPart
    weld.Part1 = ghost
    weld.C0 = CFrame.new(0, 0, 0)
    weld.C1 = CFrame.new(0, 0, 0)
    weld.Parent = ghost
    
    -- Adicionar à hierarquia (colocar no Character do jogador)
    ghost.Parent = character
    
    -- Esconder a parte original (opcional - para dar feedback visual)
    -- targetPart.Transparency = 1  -- Descomente se quiser esconder a original
    
    -- Salvar referências
    self.HitboxParts[player] = ghost
    self.OriginalParts[player] = targetPart
    
    -- Conectar morte para remover
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local deathConn = humanoid.Died:Connect(function()
            self:RemoveGhostHitbox(player)
        end)
        table.insert(self.Connections, deathConn)
    end
    
    print("👻 Hitbox criada para " .. player.Name)
    return ghost
end

-- Remove a hitbox fantasma
function HitboxComTiros:RemoveGhostHitbox(player)
    if self.HitboxParts[player] then
        self.HitboxParts[player]:Destroy()
        self.HitboxParts[player] = nil
    end
    
    -- Restaurar visibilidade da parte original
    if self.OriginalParts[player] then
        -- self.OriginalParts[player].Transparency = 0  -- Se tiver escondido
        self.OriginalParts[player] = nil
    end
    
    self.OriginalParts[player] = nil
end

-- Atualizar posição das hitboxes (garantir que acompanham)
function HitboxComTiros:UpdateHitboxes()
    for player, ghost in pairs(self.HitboxParts) do
        if player and player.Character and ghost and ghost.Parent then
            local targetPart = player.Character:FindFirstChild(self.Settings.TARGET_PART)
            if targetPart then
                -- O weld já mantém a posição, mas garantimos que o weld existe
                local weld = ghost:FindFirstChildOfClass("Weld")
                if not weld then
                    -- Recriar weld se perdeu
                    weld = Instance.new("Weld")
                    weld.Part0 = targetPart
                    weld.Part1 = ghost
                    weld.C0 = CFrame.new(0, 0, 0)
                    weld.C1 = CFrame.new(0, 0, 0)
                    weld.Parent = ghost
                end
            else
                -- Se perdeu a parte alvo, remover hitbox
                self:RemoveGhostHitbox(player)
            end
        else
            -- Se player morreu ou ghost foi destruído, limpar
            self:RemoveGhostHitbox(player)
        end
    end
end

-- Processar jogador
function HitboxComTiros:ProcessPlayer(player)
    if not self:CanModify(player) then return end
    
    -- Criar hitbox fantasma
    self:CreateGhostHitbox(player)
    
    -- Monitorar respawn
    local respawnConn = player.CharacterAdded:Connect(function()
        task.wait(0.5)
        if self.Active and self:CanModify(player) then
            self:CreateGhostHitbox(player)
        end
    end)
    table.insert(self.Connections, respawnConn)
end

-- Iniciar
function HitboxComTiros:Start()
    if self.Active then return end
    self.Active = true
    
    print("🔄 Iniciando Hitbox (compatível com tiros)...")
    
    -- Processar jogadores existentes
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            self:ProcessPlayer(player)
        end
    end
    
    -- Detectar novos jogadores
    local playerAddedConn = Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer then
            local function onCharacterAdded()
                task.wait(0.5)
                self:ProcessPlayer(player)
            end
            
            if player.Character then
                onCharacterAdded()
            end
            
            local charConn = player.CharacterAdded:Connect(onCharacterAdded)
            table.insert(self.Connections, charConn)
        end
    end)
    table.insert(self.Connections, playerAddedConn)
    
    -- Loop de atualização
    local loopConn = RunService.Heartbeat:Connect(function()
        if not self.Active then
            if loopConn then loopConn:Disconnect() end
            return
        end
        self:UpdateHitboxes()
    end)
    table.insert(self.Connections, loopConn)
    
    print("✅ Hitbox Ativada - Tamanho: " .. self.Settings.SIZE)
end

-- Parar
function HitboxComTiros:Stop()
    self.Active = false
    
    -- Remover todas as hitboxes fantasmas
    for player in pairs(self.HitboxParts) do
        self:RemoveGhostHitbox(player)
    end
    
    -- Limpar conexões
    for _, conn in ipairs(self.Connections) do
        if conn and conn.Disconnect then
            conn:Disconnect()
        end
    end
    self.Connections = {}
    
    print("❌ Hitbox Desativada")
end

-- Toggle
function HitboxComTiros:Toggle()
    if self.Active then
        self:Stop()
    else
        self:Start()
    end
    return self.Active
end

-- Atualizar tamanho em tempo real
function HitboxComTiros:Set(key, value)
    local oldValue = self.Settings[key]
    self.Settings[key] = value
    
    if self.Active and key == "SIZE" and oldValue ~= value then
        for _, ghost in pairs(self.HitboxParts) do
            if ghost and ghost.Parent then
                ghost.Size = Vector3.new(value, value, value)
            end
        end
        print("📏 Tamanho alterado para: " .. value)
    elseif self.Active and key == "TRANSPARENCY" and oldValue ~= value then
        for _, ghost in pairs(self.HitboxParts) do
            if ghost and ghost.Parent then
                ghost.Transparency = value
            end
        end
    elseif self.Active and key == "TEAM_CHECK" and oldValue ~= value then
        self:Stop()
        self:Start()
    end
end

function HitboxComTiros:Get(key)
    return self.Settings[key]
end

function HitboxComTiros:Destroy()
    self:Stop()
    self.Settings = nil
    self.HitboxParts = nil
    self.OriginalParts = nil
    self.Connections = nil
end
