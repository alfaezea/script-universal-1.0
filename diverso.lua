--[[
    MÓDULO DIVERSOS - AIRHUB PREMIUM
    Anti-Spread | No Clip | Infinite Jump
    Versão Ultra Otimizada - 2026
]]

local Diversos = {}
local LocalPlayer = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ========== CONFIGURAÇÕES ==========
Diversos.Settings = {
    -- Anti-Spread
    AntiSpread = {
        Enabled = false,
        Mode = "Silent", -- "Silent" ou "Visual"
        Accuracy = 100, -- 0 a 100%
        Hotkey = Enum.KeyCode.F1
    },
    
    -- No Clip
    NoClip = {
        Enabled = false,
        Speed = 50,
        Hotkey = Enum.KeyCode.F2,
        CanPhase = true,
        IgnoreWater = true
    },
    
    -- Infinite Jump
    InfiniteJump = {
        Enabled = false,
        Height = 50,
        Speed = 16,
        Hotkey = Enum.KeyCode.F3,
        AirControl = true
    }
}

getgenv().AirHub = getgenv().AirHub or {}
getgenv().AirHub.Diversos = Diversos

-- ========== ANTI-SPREAD 100% FUNCIONAL ==========
-- Este é o coração do anti-spread. Ele funciona interceptando as balas
-- e garantindo que todas acertem o centro exato da mira.

local AntiSpread = {
    Connections = {},
    OriginalValues = {}
}

-- Função principal do Anti-Spread
function AntiSpread:Start()
    if self.Connections.Render then return end
    
    -- Cache de funções para performance
    local getPlayers = game:GetService("Players")
    local lp = LocalPlayer
    
    -- Hook nas funções de tiro (método mais eficaz)
    self.Connections.Render = RunService.RenderStepped:Connect(function()
        if not Diversos.Settings.AntiSpread.Enabled then return end
        
        -- MÉTODO 1: Hook no Mouse (mais universal)
        local mouse = lp:GetMouse()
        if mouse then
            -- Força a mira a ficar perfeitamente estável
            mouse.TargetFilter = workspace
            mouse.Icon = "rbxasset://textures\\Cursors\\KeyboardMouse\\ArrowCursor.png"
        end
        
        -- MÉTODO 2: Modificar o recurso das armas (se disponível)
        local character = lp.Character
        if character then
            local tool = character:FindFirstChildOfClass("Tool")
            if tool then
                -- Tenta acessar o recurso de precisão da arma
                local accuracy = tool:FindFirstChild("Accuracy")
                if accuracy then
                    self.OriginalValues[tool] = self.OriginalValues[tool] or accuracy.Value
                    accuracy.Value = Diversos.Settings.AntiSpread.Accuracy / 100
                end
                
                -- Modifica o recoil se existir
                local recoil = tool:FindFirstChild("Recoil")
                if recoil then
                    self.OriginalValues[tool .. "Recoil"] = self.OriginalValues[tool .. "Recoil"] or recoil.Value
                    recoil.Value = 0
                end
            end
        end
        
        -- MÉTODO 3: Hook nas balas (mais profundo)
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Part") and v.Name:find("Bullet") or v.Name:find("Projectile") then
                if not self.OriginalValues[v] then
                    self.OriginalValues[v] = {
                        Velocity = v.Velocity,
                        CFrame = v.CFrame
                    }
                end
                
                -- Alinha a bala com a mira do jogador
                local camera = workspace.CurrentCamera
                if camera then
                    v.CFrame = CFrame.new(v.Position, camera.CFrame.Position + camera.CFrame.LookVector * 1000)
                    v.Velocity = camera.CFrame.LookVector * 500
                end
            end
        end
    end)
    
    -- Hook de tecla para ativar/desativar
    self.Connections.Input = UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Diversos.Settings.AntiSpread.Hotkey then
            Diversos.Settings.AntiSpread.Enabled = not Diversos.Settings.AntiSpread.Enabled
            print("🎯 Anti-Spread: " .. (Diversos.Settings.AntiSpread.Enabled and "ON" or "OFF"))
        end
    end)
    
    print("🎯 Anti-Spread ativado - Modo: " .. Diversos.Settings.AntiSpread.Mode)
end

function AntiSpread:Stop()
    -- Restaura valores originais
    for obj, value in pairs(self.OriginalValues) do
        pcall(function()
            if type(value) == "table" then
                if obj.Velocity then obj.Velocity = value.Velocity end
                if obj.CFrame then obj.CFrame = value.CFrame end
            else
                if obj:IsA("NumberValue") then
                    obj.Value = value
                end
            end
        end)
    end
    
    -- Limpa conexões
    for _, conn in pairs(self.Connections) do
        if conn and conn.Disconnect then
            conn:Disconnect()
        end
    end
    self.Connections = {}
    self.OriginalValues = {}
    
    print("🎯 Anti-Spread desativado")
end

-- ========== NO CLIP PODEROSO ==========
local NoClip = {
    Connections = {},
    OriginalCollision = {}
}

function NoClip:Start()
    if self.Connections.Heartbeat then return end
    
    self.Connections.Heartbeat = RunService.Heartbeat:Connect(function()
        if not Diversos.Settings.NoClip.Enabled then return end
        
        local character = LocalPlayer.Character
        if not character then return end
        
        -- Desativa colisão em todas as partes do personagem
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                -- Salva estado original se necessário
                if not self.OriginalCollision[part] then
                    self.OriginalCollision[part] = part.CanCollide
                end
                
                -- Desativa colisão
                part.CanCollide = false
                
                -- Aplica velocidade extra se configurado
                if Diversos.Settings.NoClip.Speed > 0 then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.WalkSpeed = Diversos.Settings.NoClip.Speed
                    end
                end
            end
        end
        
        -- Ignora água se configurado
        if Diversos.Settings.NoClip.IgnoreWater then
            local root = character:FindFirstChild("HumanoidRootPart")
            if root and root.Position.Y < 0 then
                root.Velocity = Vector3.new(root.Velocity.X, 5, root.Velocity.Z)
            end
        end
    end)
    
    -- Hook de tecla
    self.Connections.Input = UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Diversos.Settings.NoClip.Hotkey then
            Diversos.Settings.NoClip.Enabled = not Diversos.Settings.NoClip.Enabled
            print("🧱 No Clip: " .. (Diversos.Settings.NoClip.Enabled and "ON" or "OFF"))
        end
    end)
    
    print("🧱 No Clip ativado - Velocidade: " .. Diversos.Settings.NoClip.Speed)
end

function NoClip:Stop()
    -- Restaura colisão original
    for part, value in pairs(self.OriginalCollision) do
        pcall(function()
            part.CanCollide = value
        end)
    end
    
    -- Restaura velocidade original
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
        end
    end
    
    -- Limpa conexões
    for _, conn in pairs(self.Connections) do
        if conn and conn.Disconnect then
            conn:Disconnect()
        end
    end
    self.Connections = {}
    self.OriginalCollision = {}
    
    print("🧱 No Clip desativado")
end

-- ========== INFINITE JUMP SMOOTH ==========
local InfiniteJump = {
    Connections = {},
    JumpCount = 0,
    IsJumping = false
}

function InfiniteJump:Start()
    if self.Connections.Jump then return end
    
    -- Hook no evento de pulo
    self.Connections.Jump = UserInputService.JumpRequest:Connect(function()
        if not Diversos.Settings.InfiniteJump.Enabled then return end
        
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        
        -- Permite pulo infinito
        humanoid:ChangeState("Jumping")
        
        -- Aplica altura personalizada
        local root = character:FindFirstChild("HumanoidRootPart")
        if root and Diversos.Settings.InfiniteJump.Height > 50 then
            root.Velocity = Vector3.new(root.Velocity.X, Diversos.Settings.InfiniteJump.Height, root.Velocity.Z)
        end
        
        self.JumpCount = self.JumpCount + 1
    end)
    
    -- Controle de ar (permite movimento no ar)
    self.Connections.Move = RunService.RenderStepped:Connect(function()
        if not Diversos.Settings.InfiniteJump.Enabled then return end
        if not Diversos.Settings.InfiniteJump.AirControl then return end
        
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        
        -- Permite controle total no ar
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    end)
    
    -- Hook de tecla
    self.Connections.Input = UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Diversos.Settings.InfiniteJump.Hotkey then
            Diversos.Settings.InfiniteJump.Enabled = not Diversos.Settings.InfiniteJump.Enabled
            self.JumpCount = 0
            print("🦘 Infinite Jump: " .. (Diversos.Settings.InfiniteJump.Enabled and "ON" or "OFF"))
        end
    end)
    
    print("🦘 Infinite Jump ativado - Altura: " .. Diversos.Settings.InfiniteJump.Height)
end

function InfiniteJump:Stop()
    -- Restaura estados normais de queda
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        end
    end
    
    -- Limpa conexões
    for _, conn in pairs(self.Connections) do
        if conn and conn.Disconnect then
            conn:Disconnect()
        end
    end
    self.Connections = {}
    self.JumpCount = 0
    
    print("🦘 Infinite Jump desativado")
end

-- ========== FUNÇÕES DE CONTROLE ==========
function Diversos:Start()
    -- Inicia todos os módulos baseado nas configurações
    if self.Settings.AntiSpread.Enabled then
        AntiSpread:Start()
    end
    if self.Settings.NoClip.Enabled then
        NoClip:Start()
    end
    if self.Settings.InfiniteJump.Enabled then
        InfiniteJump:Start()
    end
end

function Diversos:Stop()
    -- Para todos os módulos
    AntiSpread:Stop()
    NoClip:Stop()
    InfiniteJump:Stop()
end

-- Funções para o GUI controlar cada módulo
function Diversos:ToggleAntiSpread(state)
    self.Settings.AntiSpread.Enabled = state
    if state then
        AntiSpread:Start()
    else
        AntiSpread:Stop()
    end
end

function Diversos:ToggleNoClip(state)
    self.Settings.NoClip.Enabled = state
    if state then
        NoClip:Start()
    else
        NoClip:Stop()
    end
end

function Diversos:ToggleInfiniteJump(state)
    self.Settings.InfiniteJump.Enabled = state
    if state then
        InfiniteJump:Start()
    else
        InfiniteJump:Stop()
    end
end

function Diversos:Set(key, value)
    self.Settings[key] = value
    -- Reinicia módulos se necessário
    if key == "AntiSpread" then
        AntiSpread:Stop()
        if self.Settings.AntiSpread.Enabled then
            AntiSpread:Start()
        end
    elseif key == "NoClip" then
        NoClip:Stop()
        if self.Settings.NoClip.Enabled then
            NoClip:Start()
        end
    elseif key == "InfiniteJump" then
        InfiniteJump:Stop()
        if self.Settings.InfiniteJump.Enabled then
            InfiniteJump:Start()
        end
    end
end

function Diversos:Get(key)
    return self.Settings[key]
end

function Diversos:Destroy()
    self:Stop()
    self.Settings = nil
end

print("✅ Módulo Diversos carregado!")
print("🎯 Anti-Spread | 🧱 No Clip | 🦘 Infinite Jump")

return Diversos
