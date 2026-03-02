--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║              PREMIUM HUB - AIRHUB EDITION                 ║
    ║                    By: DeepSeek AI                        ║
    ║                                                           ║
    ║  🎯 Aimbot | 👁️ ESP | 🎮 Crosshair | ✈️ Fly | 💪 Hitbox  ║
    ╚═══════════════════════════════════════════════════════════╝
]]

-- Carregar a biblioteca avançada (coloque aqui o código da biblioteca que você me mandou)
local Library = loadstring(game:GetObjects("rbxassetid://7657867786")[1].Source)()

-- ========== FUNÇÃO SEGURA PARA CARREGAR MÓDULOS ==========
local function loadModule(url, name)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success and result and #result > 0 then
        local func, err = loadstring(result)
        if func then
            func()
            print("✅ " .. name .. " carregado com sucesso!")
            return true
        else
            warn("❌ Erro de sintaxe em " .. name)
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

-- ========== CONFIGURAÇÕES DA HITBOX ==========
local HitboxSettings = {
    Enabled = false,
    ToggleKey = "L",
    TargetLimb = "HumanoidRootPart",
    Size = 15,
    Transparency = 0.9,
    CanCollide = false,
    TeamCheck = true,
    ForceFieldCheck = true,
    UseHighlight = true,
    DepthMode = "AlwaysOnTop",
    HighlightColor = Color3.fromRGB(255, 117, 24),
    HighlightTransparency = 0.7,
    OutlineColor = Color3.fromRGB(0, 0, 0),
    OutlineTransparency = 1,
}

-- ========== INSTANCIAR HITBOX ==========
local extender = Hitbox and Hitbox(HitboxSettings) or { Start = function() end, Stop = function() end, Set = function() end }

-- ========== CRIAR GUI PRINCIPAL ==========
local Window = Library:Load({
    name = "AirHub Premium",
    sizex = 600,
    sizey = 550,
    theme = "AirHub",
    folder = "AirHubPremium",
    extension = "cfg"
})

-- ========== CRIAR ABAS ==========
local MainTab, Signal = Window:Tab("Principal")
local AimbotTab = Window:Tab("Aimbot")
local ESPTab = Window:Tab("ESP")
local MiscTab = Window:Tab("Diversos")
local ConfigTab = Window:Tab("Configurações")

-- Ativar primeira aba
if Signal then Signal:Fire() end

-- ========== ABA PRINCIPAL ==========
local GeneralSection = MainTab:Section({ name = "Visão Geral", side = "left" })
local StatusSection = MainTab:Section({ name = "Status dos Módulos", side = "right" })

GeneralSection:Label("🎯 AirHub Premium - Versão Ultimate")
GeneralSection:Label("📌 Módulos carregados automaticamente")
GeneralSection:Separator("Informações")
GeneralSection:Label("Aimbot: " .. (Aimbot and "✅ Ativo" or "❌ Falha"))
GeneralSection:Label("ESP: " .. (ESP and "✅ Ativo" or "❌ Falha"))
GeneralSection:Label("Hitbox: " .. (Hitbox and "✅ Ativo" or "❌ Falha"))

-- ========== ABA AIMBOT ==========
if Aimbot then
    local AimbotMain = AimbotTab:Section({ name = "Configurações do Aimbot", side = "left" })
    local AimbotFOV = AimbotTab:Section({ name = "Configurações do FOV", side = "right" })
    
    -- Main settings
    AimbotMain:Toggle({
        name = "Ativar Aimbot",
        default = Aimbot.Settings.Enabled,
        flag = "AimbotEnabled",
        callback = function(v) Aimbot.Settings.Enabled = v end
    })
    
    AimbotMain:Slider({
        name = "Smoothness",
        default = Aimbot.Settings.Smoothness,
        min = 0.1,
        max = 1,
        float = 0.1,
        flag = "AimbotSmoothness",
        callback = function(v) Aimbot.Settings.Smoothness = v end
    })
    
    AimbotMain:Dropdown({
        name = "Parte do Corpo",
        content = {"Head", "HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso"},
        default = Aimbot.Settings.LockPart,
        flag = "AimbotLockPart",
        callback = function(v) Aimbot.Settings.LockPart = v end
    })
    
    AimbotMain:Toggle({
        name = "Team Check",
        default = Aimbot.Settings.TeamCheck,
        flag = "AimbotTeamCheck",
        callback = function(v) Aimbot.Settings.TeamCheck = v end
    })
    
    AimbotMain:Toggle({
        name = "Wall Check",
        default = Aimbot.Settings.WallCheck,
        flag = "AimbotWallCheck",
        callback = function(v) Aimbot.Settings.WallCheck = v end
    })
    
    AimbotMain:Toggle({
        name = "Alive Check",
        default = Aimbot.Settings.AliveCheck,
        flag = "AimbotAliveCheck",
        callback = function(v) Aimbot.Settings.AliveCheck = v end
    })
    
    AimbotMain:Keybind({
        name = "Tecla de Atalho",
        default = Enum.KeyCode[#Aimbot.Settings.TriggerKey == 1 and Aimbot.Settings.TriggerKey or "MouseButton2"],
        flag = "AimbotKey",
        callback = function(k) Aimbot.Settings.TriggerKey = k.Name end
    })
    
    -- FOV Settings
    AimbotFOV:Toggle({
        name = "Ativar FOV",
        default = Aimbot.FOVSettings.Enabled,
        flag = "AimbotFOVEnabled",
        callback = function(v) Aimbot.FOVSettings.Enabled = v end
    })
    
    AimbotFOV:Slider({
        name = "Tamanho do FOV",
        default = Aimbot.FOVSettings.Amount,
        min = 10,
        max = 360,
        flag = "AimbotFOVSize",
        callback = function(v) Aimbot.FOVSettings.Amount = v end
    })
    
    AimbotFOV:Slider({
        name = "Transparência",
        default = Aimbot.FOVSettings.Transparency * 10,
        min = 0,
        max = 10,
        float = 1,
        flag = "AimbotFOVTrans",
        callback = function(v) Aimbot.FOVSettings.Transparency = v / 10 end
    })
    
    AimbotFOV:ColorPicker({
        name = "Cor do FOV",
        default = Aimbot.FOVSettings.Color,
        flag = "AimbotFOVColor",
        callback = function(c) Aimbot.FOVSettings.Color = c end
    })
    
    AimbotFOV:ColorPicker({
        name = "Cor quando Travado",
        default = Aimbot.FOVSettings.LockedColor,
        flag = "AimbotFOVLockedColor",
        callback = function(c) Aimbot.FOVSettings.LockedColor = c end
    })
else
    AimbotTab:Section({ name = "Erro" }):Label("❌ Aimbot não carregado")
end

-- ========== ABA ESP ==========
if ESP then
    local ESPChecks = ESPTab:Section({ name = "Verificações", side = "left" })
    local ESPMain = ESPTab:Section({ name = "Configurações ESP", side = "left" })
    local ESPBoxes = ESPTab:Section({ name = "Configurações das Caixas", side = "right" })
    local ESPTracers = ESPTab:Section({ name = "Configurações dos Tracers", side = "right" })
    local ESPChams = ESPTab:Section({ name = "Configurações dos Chams", side = "right" })
    
    -- Checks
    ESPChecks:Toggle({
        name = "Ativar ESP",
        default = ESP.Settings.Enabled,
        flag = "ESPEnabled",
        callback = function(v) ESP.Settings.Enabled = v end
    })
    
    ESPChecks:Toggle({
        name = "Team Check",
        default = ESP.Settings.TeamCheck,
        flag = "ESPTeamCheck",
        callback = function(v) ESP.Settings.TeamCheck = v end
    })
    
    ESPChecks:Toggle({
        name = "Alive Check",
        default = ESP.Settings.AliveCheck,
        flag = "ESPAliveCheck",
        callback = function(v) ESP.Settings.AliveCheck = v end
    })
    
    -- ESP Settings
    ESPMain:Toggle({
        name = "Mostrar Nomes",
        default = ESP.Visuals.ESPSettings.DisplayName,
        flag = "ESPDisplayName",
        callback = function(v) ESP.Visuals.ESPSettings.DisplayName = v end
    })
    
    ESPMain:Toggle({
        name = "Mostrar Distância",
        default = ESP.Visuals.ESPSettings.DisplayDistance,
        flag = "ESPDisplayDistance",
        callback = function(v) ESP.Visuals.ESPSettings.DisplayDistance = v end
    })
    
    ESPMain:Toggle({
        name = "Mostrar Vida",
        default = ESP.Visuals.ESPSettings.DisplayHealth,
        flag = "ESPDisplayHealth",
        callback = function(v) ESP.Visuals.ESPSettings.DisplayHealth = v end
    })
    
    ESPMain:ColorPicker({
        name = "Cor do Texto",
        default = ESP.Visuals.ESPSettings.TextColor,
        flag = "ESPTextColor",
        callback = function(c) ESP.Visuals.ESPSettings.TextColor = c end
    })
    
    -- Box Settings
    ESPBoxes:Toggle({
        name = "Mostrar Caixas",
        default = ESP.Visuals.BoxSettings.Enabled,
        flag = "ESPBoxEnabled",
        callback = function(v) ESP.Visuals.BoxSettings.Enabled = v end
    })
    
    ESPBoxes:Dropdown({
        name = "Tipo de Caixa",
        content = {"3D", "2D"},
        default = ESP.Visuals.BoxSettings.Type == 1 and "3D" or "2D",
        flag = "ESPBoxType",
        callback = function(v) ESP.Visuals.BoxSettings.Type = v == "3D" and 1 or 2 end
    })
    
    ESPBoxes:ColorPicker({
        name = "Cor das Caixas",
        default = ESP.Visuals.BoxSettings.Color,
        flag = "ESPBoxColor",
        callback = function(c) ESP.Visuals.BoxSettings.Color = c end
    })
    
    ESPBoxes:Slider({
        name = "Transparência",
        default = ESP.Visuals.BoxSettings.Transparency * 10,
        min = 0,
        max = 10,
        float = 1,
        flag = "ESPBoxTrans",
        callback = function(v) ESP.Visuals.BoxSettings.Transparency = v / 10 end
    })
    
    -- Tracer Settings
    ESPTracers:Toggle({
        name = "Mostrar Tracers",
        default = ESP.Visuals.TracersSettings.Enabled,
        flag = "ESPTracersEnabled",
        callback = function(v) ESP.Visuals.TracersSettings.Enabled = v end
    })
    
    ESPTracers:Dropdown({
        name = "Origem do Tracer",
        content = {"Bottom", "Center", "Mouse"},
        default = ESP.Visuals.TracersSettings.Type == 1 and "Bottom" or ESP.Visuals.TracersSettings.Type == 2 and "Center" or "Mouse",
        flag = "ESPTracersType",
        callback = function(v) 
            ESP.Visuals.TracersSettings.Type = v == "Bottom" and 1 or v == "Center" and 2 or 3
        end
    })
    
    ESPTracers:ColorPicker({
        name = "Cor dos Tracers",
        default = ESP.Visuals.TracersSettings.Color,
        flag = "ESPTracersColor",
        callback = function(c) ESP.Visuals.TracersSettings.Color = c end
    })
    
    -- Chams Settings
    ESPChams:Toggle({
        name = "Ativar Chams",
        default = ESP.Visuals.ChamsSettings.Enabled,
        flag = "ESPChamsEnabled",
        callback = function(v) ESP.Visuals.ChamsSettings.Enabled = v end
    })
    
    ESPChams:ColorPicker({
        name = "Cor dos Chams",
        default = ESP.Visuals.ChamsSettings.Color,
        flag = "ESPChamsColor",
        callback = function(c) ESP.Visuals.ChamsSettings.Color = c end
    })
    
    ESPChams:Slider({
        name = "Transparência",
        default = ESP.Visuals.ChamsSettings.Transparency * 10,
        min = 0,
        max = 10,
        float = 1,
        flag = "ESPChamsTrans",
        callback = function(v) ESP.Visuals.ChamsSettings.Transparency = v / 10 end
    })
else
    ESPTab:Section({ name = "Erro" }):Label("❌ ESP não carregado")
end

-- ========== ABA DIVERSOS (FLY + HITBOX) ==========
local FlySection = MiscTab:Section({ name = "Sistema de Voo", side = "left" })
local HitboxSection = MiscTab:Section({ name = "Hitbox Extender", side = "right" })
local HitboxConfig = MiscTab:Section({ name = "Configurações da Hitbox", side = "right" })

-- FLY
FlySection:Toggle({
    name = "Ativar Fly",
    default = Fly.Enabled,
    flag = "FlyEnabled",
    callback = function(v) 
        Fly.Enabled = v
        ToggleFly(v)
    end
})

FlySection:Slider({
    name = "Velocidade",
    default = Fly.Speed,
    min = 10,
    max = 200,
    flag = "FlySpeed",
    callback = function(v) Fly.Speed = v end
})

FlySection:Label("Controles:")
FlySection:Label("WASD - Movimento")
FlySection:Label("Espaço - Subir")
FlySection:Label("Shift - Descer")

-- HITBOX (se carregada)
if extender then
    HitboxSection:Toggle({
        name = "Ativar Hitbox",
        default = HitboxSettings.Enabled,
        flag = "HitboxEnabled",
        callback = function(v)
            HitboxSettings.Enabled = v
            if v then extender:Start() else extender:Stop() end
        end
    })
    
    HitboxSection:Dropdown({
        name = "Parte do Corpo",
        content = {"Head", "HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso"},
        default = HitboxSettings.TargetLimb,
        flag = "HitboxTarget",
        callback = function(v)
            HitboxSettings.TargetLimb = v
            extender:Set("TARGET_LIMB", v)
        end
    })
    
    HitboxConfig:Slider({
        name = "Tamanho",
        default = HitboxSettings.Size,
        min = 5,
        max = 30,
        flag = "HitboxSize",
        callback = function(v)
            HitboxSettings.Size = v
            extender:Set("LIMB_SIZE", v)
        end
    })
    
    HitboxConfig:Slider({
        name = "Transparência",
        default = HitboxSettings.Transparency * 10,
        min = 0,
        max = 10,
        float = 1,
        flag = "HitboxTrans",
        callback = function(v)
            HitboxSettings.Transparency = v / 10
            extender:Set("LIMB_TRANSPARENCY", v / 10)
        end
    })
    
    HitboxConfig:Toggle({
        name = "Team Check",
        default = HitboxSettings.TeamCheck,
        flag = "HitboxTeamCheck",
        callback = function(v)
            HitboxSettings.TeamCheck = v
            extender:Set("TEAM_CHECK", v)
        end
    })
    
    HitboxConfig:Toggle({
        name = "Usar Highlight",
        default = HitboxSettings.UseHighlight,
        flag = "HitboxHighlight",
        callback = function(v)
            HitboxSettings.UseHighlight = v
            extender:Set("USE_HIGHLIGHT", v)
        end
    })
    
    HitboxConfig:ColorPicker({
        name = "Cor do Highlight",
        default = HitboxSettings.HighlightColor,
        flag = "HitboxHighlightColor",
        callback = function(c)
            HitboxSettings.HighlightColor = c
            extender:Set("HIGHLIGHT_FILL_COLOR", c)
        end
    })
else
    HitboxSection:Label("❌ Hitbox não carregado")
end

-- ========== ABA CONFIGURAÇÕES ==========
local ConfigSection = ConfigTab:Section({ name = "Configurações do Menu", side = "left" })
local ProfilesSection = ConfigTab:Section({ name = "Perfis de Configuração", side = "right" })

ConfigSection:Keybind({
    name = "Mostrar/Esconder GUI",
    default = Enum.KeyCode.RightShift,
    flag = "MenuToggleKey",
    callback = function(k)
        -- A biblioteca já tem sistema próprio para isso
    end
})

ConfigSection:Button({
    name = "Fechar GUI",
    callback = function()
        Window:Close()
    end
})

ConfigSection:Button({
    name = "Descarregar Script",
    callback = function()
        if Aimbot and Aimbot.Functions then Aimbot.Functions:Exit() end
        if ESP and ESP.Functions then ESP.Functions:Exit() end
        if extender and extender.Destroy then extender:Destroy() end
        Window:Unload()
    end
})

-- Sistema de perfis (se a biblioteca suportar)
ProfilesSection:Label("Sistema de perfis disponível")
ProfilesSection:Label("Use as flags para salvar configurações")

print("✅ AirHub Premium carregado com sucesso!")
print("🎯 Aimbot | 👁️ ESP | ✈️ Fly | 💪 Hitbox")
