--[[
    UNIVERSAL CHEAT PREMIUM
    Baseado em Exunys AirHub © CC0 1.0 Universal
    Criado por DeepSeek - Todos os direitos reservados ao estilo de código
]]

-- ========== CACHE DE FUNÇÕES (OTIMIZAÇÃO) ==========
local game, workspace = game, workspace
local pcall, getgenv, next, setmetatable, tick = pcall, getgenv, next, setmetatable, tick
local Vector2new, Vector3new, Vector3zero, CFramenew = Vector2.new, Vector3.new, Vector3.zero, CFrame.new
local Color3fromRGB, Color3fromHSV, Drawingnew, TweenInfonew = Color3.fromRGB, Color3.fromHSV, Drawing.new, TweenInfo.new
local mousemoverel = mousemoverel or (Input and Input.MouseMove)
local stringlower, stringsub, stringupper, mathfloor, mathclamp = string.lower, string.sub, string.upper, math.floor, math.clamp
local mathcos, mathsin, mathrad, mathabs = math.cos, math.sin, math.rad, math.abs

-- ========== SERVIÇOS ==========
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ========== VERIFICAÇÃO DE MÚLTIPLAS EXECUÇÕES ==========
if getgenv().UniversalCheat then
    if getgenv().UniversalCheat.Functions and getgenv().UniversalCheat.Functions.Exit then
        getgenv().UniversalCheat.Functions:Exit()
    end
end

-- ========== AMBIENTE GLOBAL ==========
getgenv().UniversalCheat = {
    Settings = {
        Enabled = true,
        TeamCheck = true,
        AliveCheck = true,
        WallCheck = true,
    },
    
    Aimbot = {
        Enabled = false,
        TeamCheck = true,
        AliveCheck = true,
        WallCheck = true,
        Sensitivity = 0.15,           -- Tempo de animação (0 = instantâneo)
        Smoothness = 0.3,              -- Suavidade do movimento
        LockMode = 1,                   -- 1 = CFrame, 2 = mousemoverel
        LockPart = "Head",              -- Parte do corpo
        TriggerKey = "MouseButton2",     -- Botão para ativar
        Toggle = false,                  -- Modo toggle ou segurar
        ThirdPersonSensitivity = 3,      -- Sensibilidade para 3ª pessoa
        FOV = 120,                        -- Raio do FOV
        ShowFOV = true,                    -- Mostrar círculo
        FOVColor = Color3fromRGB(0, 255, 255),        -- Cor normal
        FOVLockedColor = Color3fromRGB(255, 100, 100), -- Cor quando travado
        FOVTransparency = 0.7,                         -- Transparência
        FOVThickness = 1.5,                             -- Espessura
        FOVFilled = false,                               -- Preenchido
        FOVSides = 64,                                    -- Número de lados
    },
    
    ESP = {
        Enabled = false,
        TeamCheck = true,
        AliveCheck = true,
        
        -- Texto (nome, distância, vida)
        TextEnabled = true,
        TextColor = Color3fromRGB(255, 255, 255),
        TextSize = 14,
        TextOutline = true,
        OutlineColor = Color3fromRGB(0, 0, 0),
        TextTransparency = 0.3,
        TextFont = Drawing.Fonts.UI,  -- UI, System, Plex, Monospace
        TextOffset = 20,                -- Distância da cabeça
        DisplayDistance = true,
        DisplayHealth = true,
        DisplayName = true,
        
        -- Box (caixa ao redor do jogador)
        BoxEnabled = true,
        BoxType = 2,                     -- 1 = 3D, 2 = 2D
        BoxColor = Color3fromRGB(255, 255, 255),
        BoxTransparency = 0.5,
        BoxThickness = 1.5,
        BoxFilled = false,                -- Para 2D
        BoxScale = 1,                      -- Escala para 3D
        
        -- Tracers (linhas)
        TracerEnabled = true,
        TracerType = 1,                    -- 1 = Bottom, 2 = Center, 3 = Mouse
        TracerColor = Color3fromRGB(255, 255, 255),
        TracerTransparency = 0.5,
        TracerThickness = 1,
        
        -- Head Dot (ponto na cabeça)
        HeadDotEnabled = true,
        HeadDotColor = Color3fromRGB(255, 255, 255),
        HeadDotTransparency = 0.4,
        HeadDotThickness = 1,
        HeadDotFilled = false,
        HeadDotSides = 30,
        
        -- Health Bar (barra de vida)
        HealthBarEnabled = true,
        HealthBarType = 3,                  -- 1 = Top, 2 = Bottom, 3 = Left, 4 = Right
        HealthBarTransparency = 0.6,
        HealthBarSize = 3,                   -- Espessura
        HealthBarOffset = 5,                  -- Distância do corpo
        HealthBarOutlineColor = Color3fromRGB(0, 0, 0),
        HealthBarBlue = 50,                    -- Componente azul
        
        -- Chams (partes coloridas)
        ChamsEnabled = false,
        ChamsColor = Color3fromRGB(255, 255, 255),
        ChamsTransparency = 0.3,
        ChamsThickness = 1,
        ChamsFilled = true,
        ChamsEntireBody = false,               -- Para R15 (pode causar lag)
    },
    
    Crosshair = {
        Enabled = false,
        Type = 1,                           -- 1 = Mouse, 2 = Center
        Size = 12,
        Thickness = 1.5,
        Color = Color3fromRGB(0, 255, 0),
        Transparency = 1,
        GapSize = 5,
        Rotation = 0,                        -- Graus
        CenterDot = true,
        CenterDotColor = Color3fromRGB(0, 255, 0),
        CenterDotSize = 2,
        CenterDotTransparency = 1,
        CenterDotFilled = true,
    },
    
    Menu = {
        Enabled = true,
        ToggleKey = Enum.KeyCode.P,          -- Tecla para abrir/fechar
        Color = Color3fromRGB(25, 25, 35),
        AccentColor = Color3fromRGB(0, 170, 255),
        TextColor = Color3fromRGB(255, 255, 255),
        Transparency = 0.05,
    }
}

local Environment = getgenv().UniversalCheat

-- ========== VARIÁVEIS GLOBAIS ==========
local ServiceConnections = {}
local Typing = false
local Running = false
local Animation = nil
local OriginalSensitivity = nil
local WrappedPlayers = {}
local Drawings = {
    FOVCircle = Drawingnew("Circle"),
    Crosshair = {
        LeftLine = Drawingnew("Line"),
        RightLine = Drawingnew("Line"),
        TopLine = Drawingnew("Line"),
        BottomLine = Drawingnew("Line"),
        CenterDot = Drawingnew("Circle"),
    }
}

-- ========== CONFIGURAÇÕES INICIAIS DOS DRAWINGS ==========
do
    -- Configurar FOV Circle
    Drawings.FOVCircle.Visible = false
    Drawings.FOVCircle.NumSides = Environment.Aimbot.FOVSides
    
    -- Configurar Crosshair
    for _, v in next, Drawings.Crosshair do
        v.Visible = false
    end
end

-- ========== FUNÇÕES UTILITÁRIAS ==========
local function ConvertVector(Vector)
    return Vector2new(Vector.X, Vector.Y)
end

local function GetRainbowColor(Speed)
    return Color3fromHSV(tick() % Speed / Speed, 1, 1)
end

local function IsTyping()
    return Typing
end

-- ========== SISTEMA DE DETECÇÃO DE TECLADO ==========
ServiceConnections.TypingStarted = UserInputService.TextBoxFocused:Connect(function()
    Typing = true
end)

ServiceConnections.TypingEnded = UserInputService.TextBoxFocusReleased:Connect(function()
    Typing = false
end)

-- ========== FUNÇÕES DO AIMBOT ==========
local Aimbot = {
    CurrentTarget = nil,
    RequiredDistance = 2000,
    
    CancelLock = function()
        Aimbot.CurrentTarget = nil
        Drawings.FOVCircle.Color = Environment.Aimbot.FOVColor
        UserInputService.MouseDeltaSensitivity = OriginalSensitivity
        if Animation then
            Animation:Cancel()
        end
    end,
    
    GetClosestPlayer = function()
        if not Aimbot.CurrentTarget then
            Aimbot.RequiredDistance = Environment.Aimbot.ShowFOV and Environment.Aimbot.FOV or 2000
            
            for _, player in next, Players:GetPlayers() do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(Environment.Aimbot.LockPart) and player.Character:FindFirstChildOfClass("Humanoid") then
                    
                    -- Team Check
                    if Environment.Aimbot.TeamCheck and player.TeamColor == LocalPlayer.TeamColor then
                        goto continue
                    end
                    
                    -- Alive Check
                    if Environment.Aimbot.AliveCheck and player.Character.Humanoid.Health <= 0 then
                        goto continue
                    end
                    
                    -- Wall Check (mais preciso)
                    if Environment.Aimbot.WallCheck then
                        local Part = player.Character[Environment.Aimbot.LockPart]
                        local Obscuring = #Camera:GetPartsObscuringTarget({Part.Position}, player.Character:GetDescendants())
                        if Obscuring > 0 then
                            goto continue
                        end
                    end
                    
                    -- Converter posição para tela
                    local Vector, OnScreen = Camera:WorldToViewportPoint(player.Character[Environment.Aimbot.LockPart].Position)
                    Vector = ConvertVector(Vector)
                    
                    -- Calcular distância do mouse
                    local Distance = (UserInputService:GetMouseLocation() - Vector).Magnitude
                    
                    if Distance < Aimbot.RequiredDistance and OnScreen then
                        Aimbot.RequiredDistance = Distance
                        Aimbot.CurrentTarget = player
                    end
                    
                    ::continue::
                end
            end
        elseif Aimbot.CurrentTarget and Aimbot.CurrentTarget.Character then
            -- Verificar se o alvo ainda está dentro do FOV
            local Vector = ConvertVector(Camera:WorldToViewportPoint(Aimbot.CurrentTarget.Character[Environment.Aimbot.LockPart].Position))
            local Distance = (UserInputService:GetMouseLocation() - Vector).Magnitude
            
            if Distance > Aimbot.RequiredDistance then
                Aimbot.CancelLock()
            end
        else
            Aimbot.CancelLock()
        end
    end,
    
    Update = function()
        if not Environment.Aimbot.Enabled then return end
        
        -- Atualizar FOV Circle
        if Environment.Aimbot.ShowFOV then
            Drawings.FOVCircle.Radius = Environment.Aimbot.FOV
            Drawings.FOVCircle.Thickness = Environment.Aimbot.FOVThickness
            Drawings.FOVCircle.Filled = Environment.Aimbot.FOVFilled
            Drawings.FOVCircle.NumSides = Environment.Aimbot.FOVSides
            Drawings.FOVCircle.Color = Aimbot.CurrentTarget and Environment.Aimbot.FOVLockedColor or Environment.Aimbot.FOVColor
            Drawings.FOVCircle.Transparency = Environment.Aimbot.FOVTransparency
            Drawings.FOVCircle.Visible = true
            Drawings.FOVCircle.Position = UserInputService:GetMouseLocation()
        else
            Drawings.FOVCircle.Visible = false
        end
        
        -- Lógica de mira
        if Running and Environment.Aimbot.Enabled then
            Aimbot.GetClosestPlayer()
            
            if Aimbot.CurrentTarget and Aimbot.CurrentTarget.Character then
                local TargetPart = Aimbot.CurrentTarget.Character[Environment.Aimbot.LockPart]
                
                if Environment.Aimbot.LockMode == 2 then
                    -- Modo mousemoverel (3ª pessoa)
                    local Vector = Camera:WorldToViewportPoint(TargetPart.Position)
                    mousemoverel(
                        (Vector.X - UserInputService:GetMouseLocation().X) * Environment.Aimbot.ThirdPersonSensitivity,
                        (Vector.Y - UserInputService:GetMouseLocation().Y) * Environment.Aimbot.ThirdPersonSensitivity
                    )
                else
                    -- Modo CFrame (1ª pessoa)
                    if Environment.Aimbot.Sensitivity > 0 then
                        Animation = TweenService:Create(Camera, 
                            TweenInfonew(Environment.Aimbot.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
                            {CFrame = CFramenew(Camera.CFrame.Position, TargetPart.Position)}
                        )
                        Animation:Play()
                    else
                        -- Interpolação suave
                        local TargetCFrame = CFramenew(Camera.CFrame.Position, TargetPart.Position)
                        Camera.CFrame = Camera.CFrame:Lerp(TargetCFrame, Environment.Aimbot.Smoothness)
                    end
                    
                    UserInputService.MouseDeltaSensitivity = 0
                end
            end
        end
    end
}

-- ========== SISTEMA DE WRAPPERS PARA ESP ==========
local ESP = {
    WrapPlayer = function(player)
        if player == LocalPlayer then return end
        
        -- Verificar se já existe
        for _, v in ipairs(WrappedPlayers) do
            if v.Player == player then return end
        end
        
        -- Criar estrutura para o jogador
        local PlayerData = {
            Player = player,
            Name = player.Name,
            Checks = {Alive = true, Team = true},
            Connections = {},
            Drawings = {
                Text = Drawingnew("Text"),
                Tracer = Drawingnew("Line"),
                HeadDot = Drawingnew("Circle"),
                Box = {
                    Square = Drawingnew("Square"),
                    TopLeft = Drawingnew("Line"),
                    TopRight = Drawingnew("Line"),
                    BottomLeft = Drawingnew("Line"),
                    BottomRight = Drawingnew("Line"),
                },
                HealthBar = {
                    Main = Drawingnew("Square"),
                    Outline = Drawingnew("Square"),
                },
                Chams = {}
            }
        }
        
        -- Configurar Chams baseado no rig type
        local function SetupChams()
            local character = player.Character
            if not character then return end
            
            -- Detectar rig type
            local RigType = "R6"
            if character:FindFirstChild("LowerTorso") then
                RigType = "R15"
            end
            
            -- Limpar Chams antigos
            for _, cham in ipairs(PlayerData.Drawings.Chams) do
                for i = 1, 6 do
                    if cham["Quad"..i] and cham["Quad"..i].Remove then
                        cham["Quad"..i]:Remove()
                    end
                end
            end
            PlayerData.Drawings.Chams = {}
            
            -- Criar Chams baseado no rig type
            local Parts = {}
            if RigType == "R6" then
                Parts = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
            else
                if Environment.ESP.ChamsEntireBody then
                    Parts = {"Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "LeftLowerArm", "LeftHand",
                             "RightUpperArm", "RightLowerArm", "RightHand", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
                             "RightUpperLeg", "RightLowerLeg", "RightFoot"}
                else
                    Parts = {"Head", "UpperTorso", "LeftUpperArm", "LeftLowerArm", "RightUpperArm", 
                             "RightLowerArm", "LeftUpperLeg", "LeftLowerLeg", "RightUpperLeg", "RightLowerLeg"}
                end
            end
            
            -- Criar objetos Drawing para cada parte
            for _, partName in ipairs(Parts) do
                local ChamData = {}
                for i = 1, 6 do
                    ChamData["Quad"..i] = Drawingnew("Quad")
                end
                PlayerData.Drawings.Chams[partName] = ChamData
            end
        end
        
        -- Configurar verificações contínuas
        PlayerData.Connections.Checks = RunService.RenderStepped:Connect(function()
            if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                PlayerData.Checks.Alive = player.Character.Humanoid.Health > 0
                if Environment.ESP.TeamCheck then
                    PlayerData.Checks.Team = player.TeamColor ~= LocalPlayer.TeamColor
                else
                    PlayerData.Checks.Team = true
                end
            else
                PlayerData.Checks.Alive = false
                PlayerData.Checks.Team = false
            end
        end)
        
        -- Configurar Chams quando o personagem carregar
        if player.Character then
            SetupChams()
        else
            player.CharacterAdded:Connect(SetupChams)
        end
        
        -- Adicionar à lista
        table.insert(WrappedPlayers, PlayerData)
        
        -- Configurar remoção automática
        player.AncestryChanged:Connect(function()
            if not player.Parent then
                ESP.UnwrapPlayer(player)
            end
        end)
    end,
    
    UnwrapPlayer = function(player)
        for i, v in ipairs(WrappedPlayers) do
            if v.Player == player then
                -- Desconectar conexões
                for _, conn in pairs(v.Connections) do
                    conn:Disconnect()
                end
                
                -- Remover drawings
                if v.Drawings.Text then v.Drawings.Text:Remove() end
                if v.Drawings.Tracer then v.Drawings.Tracer:Remove() end
                if v.Drawings.HeadDot then v.Drawings.HeadDot:Remove() end
                if v.Drawings.Box then
                    for _, drawing in pairs(v.Drawings.Box) do
                        if drawing.Remove then drawing:Remove() end
                    end
                end
                if v.Drawings.HealthBar then
                    if v.Drawings.HealthBar.Main then v.Drawings.HealthBar.Main:Remove() end
                    if v.Drawings.HealthBar.Outline then v.Drawings.HealthBar.Outline:Remove() end
                end
                for _, cham in pairs(v.Drawings.Chams) do
                    for i = 1, 6 do
                        if cham["Quad"..i] and cham["Quad"..i].Remove then
                            cham["Quad"..i]:Remove()
                        end
                    end
                end
                
                table.remove(WrappedPlayers, i)
                break
            end
        end
    end,
    
    UpdateChams = function(part, cham)
        if not part or not cham then return end
        
        local CorFrame = part.CFrame
        local PartSize = part.Size / 2
        local OnScreen = select(2, Camera:WorldToViewportPoint(CorFrame.Position))
        
        if OnScreen and Environment.ESP.ChamsEnabled then
            -- Calcular os 8 pontos do cubo
            local points = {}
            for x = -1, 1, 2 do
                for y = -1, 1, 2 do
                    for z = -1, 1, 2 do
                        local pos = Camera:WorldToViewportPoint(CorFrame * CFramenew(x * PartSize.X, y * PartSize.Y, z * PartSize.Z).Position)
                        table.insert(points, Vector2new(pos.X, pos.Y))
                    end
                end
            end
            
            -- Desenhar as 6 faces
            local faces = {
                {1,2,4,3},   -- Front
                {5,6,8,7},   -- Back
                {1,2,6,5},   -- Top
                {3,4,8,7},   -- Bottom
                {1,3,7,5},   -- Left
                {2,4,8,6},   -- Right
            }
            
            for i, face in ipairs(faces) do
                local quad = cham["Quad"..i]
                if quad then
                    quad.Visible = Environment.ESP.ChamsEnabled
                    quad.Color = Environment.ESP.ChamsColor
                    quad.Transparency = Environment.ESP.ChamsTransparency
                    quad.Thickness = Environment.ESP.ChamsThickness
                    quad.Filled = Environment.ESP.ChamsFilled
                    quad.PointA = points[face[1]]
                    quad.PointB = points[face[2]]
                    quad.PointC = points[face[3]]
                    quad.PointD = points[face[4]]
                end
            end
        else
            for i = 1, 6 do
                if cham["Quad"..i] then
                    cham["Quad"..i].Visible = false
                end
            end
        end
    end,
    
    Update = function()
        if not Environment.ESP.Enabled then
            -- Esconder todos os ESPs
            for _, playerData in ipairs(WrappedPlayers) do
                if playerData.Drawings.Text then playerData.Drawings.Text.Visible = false end
                if playerData.Drawings.Tracer then playerData.Drawings.Tracer.Visible = false end
                if playerData.Drawings.HeadDot then playerData.Drawings.HeadDot.Visible = false end
                if playerData.Drawings.Box then
                    for _, drawing in pairs(playerData.Drawings.Box) do
                        drawing.Visible = false
                    end
                end
                if playerData.Drawings.HealthBar then
                    if playerData.Drawings.HealthBar.Main then playerData.Drawings.HealthBar.Main.Visible = false end
                    if playerData.Drawings.HealthBar.Outline then playerData.Drawings.HealthBar.Outline.Visible = false end
                end
                for _, cham in pairs(playerData.Drawings.Chams) do
                    for i = 1, 6 do
                        if cham["Quad"..i] then cham["Quad"..i].Visible = false end
                    end
                end
            end
            return
        end
        
        for _, playerData in ipairs(WrappedPlayers) do
            local player = playerData.Player
            local character = player.Character
            
            if character and character:FindFirstChildOfClass("Humanoid") and character:FindFirstChild("Head") and character:FindFirstChild("HumanoidRootPart") then
                local humanoid = character.Humanoid
                local head = character.Head
                local root = character.HumanoidRootPart
                
                -- Verificar se deve mostrar
                local shouldShow = Environment.ESP.Enabled and 
                                  (not Environment.ESP.AliveCheck or playerData.Checks.Alive) and
                                  (not Environment.ESP.TeamCheck or playerData.Checks.Team)
                
                -- Posições na tela
                local headPos, onScreen = Camera:WorldToViewportPoint(head.Position + Vector3new(0, 0.5, 0))
                local rootPos = Camera:WorldToViewportPoint(root.Position - Vector3new(0, 3, 0))
                local screenHead = Vector2new(headPos.X, headPos.Y)
                local screenRoot = Vector2new(rootPos.X, rootPos.Y)
                
                if onScreen then
                    local boxHeight = mathabs(headPos.Y - rootPos.Y)
                    local boxWidth = boxHeight * 0.6
                    local boxTop = Vector2new(rootPos.X - boxWidth / 2, rootPos.Y - boxHeight)
                    
                    -- ===== TEXTO ESP =====
                    if Environment.ESP.TextEnabled and shouldShow then
                        local text = playerData.Drawings.Text
                        text.Visible = true
                        text.Center = true
                        text.Size = Environment.ESP.TextSize
                        text.Outline = Environment.ESP.TextOutline
                        text.OutlineColor = Environment.ESP.OutlineColor
                        text.Color = Environment.ESP.TextColor
                        text.Transparency = Environment.ESP.TextTransparency
                        text.Font = Environment.ESP.TextFont
                        
                        -- Construir texto
                        local content = ""
                        if Environment.ESP.DisplayName then
                            local displayName = player.DisplayName == player.Name and player.Name or player.DisplayName.." ["..player.Name.."]"
                            content = content .. displayName
                        end
                        if Environment.ESP.DisplayHealth then
                            content = content .. (content ~= "" and " " or "") .. "("..mathfloor(humanoid.Health).."HP)"
                        end
                        if Environment.ESP.DisplayDistance then
                            local dist = mathfloor((root.Position - Camera.CFrame.Position).Magnitude)
                            content = content .. (content ~= "" and " " or "") .. "["..dist.."m]"
                        end
                        
                        text.Text = content
                        text.Position = Vector2new(headPos.X, headPos.Y - Environment.ESP.TextOffset)
                    else
                        playerData.Drawings.Text.Visible = false
                    end
                    
                    -- ===== BOX =====
                    if Environment.ESP.BoxEnabled and shouldShow then
                        if Environment.ESP.BoxType == 2 then
                            -- Box 2D (Square)
                            local square = playerData.Drawings.Box.Square
                            square.Visible = true
                            square.Thickness = Environment.ESP.BoxThickness
                            square.Color = Environment.ESP.BoxColor
                            square.Transparency = Environment.ESP.BoxTransparency
                            square.Filled = Environment.ESP.BoxFilled
                            square.Size = Vector2new(boxWidth, boxHeight)
                            square.Position = boxTop
                            
                            -- Esconder linhas
                            playerData.Drawings.Box.TopLeft.Visible = false
                            playerData.Drawings.Box.TopRight.Visible = false
                            playerData.Drawings.Box.BottomLeft.Visible = false
                            playerData.Drawings.Box.BottomRight.Visible = false
                        else
                            -- Box 3D (linhas)
                            local scale = Environment.ESP.BoxScale
                            local corners = {
                                Camera:WorldToViewportPoint(root.CFrame * CFramenew( boxWidth/2 * scale,  boxHeight/2 * scale, 0).Position),
                                Camera:WorldToViewportPoint(root.CFrame * CFramenew(-boxWidth/2 * scale,  boxHeight/2 * scale, 0).Position),
                                Camera:WorldToViewportPoint(root.CFrame * CFramenew( boxWidth/2 * scale, -boxHeight/2 * scale, 0).Position),
                                Camera:WorldToViewportPoint(root.CFrame * CFramenew(-boxWidth/2 * scale, -boxHeight/2 * scale, 0).Position),
                            }
                            
                            local points = {}
                            for i = 1, 4 do
                                points[i] = Vector2new(corners[i].X, corners[i].Y)
                            end
                            
                            -- Desenhar 4 linhas do box
                            local lines = {
                                playerData.Drawings.Box.TopLeft,
                                playerData.Drawings.Box.TopRight,
                                playerData.Drawings.Box.BottomLeft,
                                playerData.Drawings.Box.BottomRight,
                            }
                            
                            local connections = {
                                {points[1], points[2]},
                                {points[2], points[4]},
                                {points[4], points[3]},
                                {points[3], points[1]},
                            }
                            
                            for i = 1, 4 do
                                lines[i].Visible = true
                                lines[i].Thickness = Environment.ESP.BoxThickness
                                lines[i].Color = Environment.ESP.BoxColor
                                lines[i].Transparency = Environment.ESP.BoxTransparency
                                lines[i].From = connections[i][1]
                                lines[i].To = connections[i][2]
                            end
                            
                            playerData.Drawings.Box.Square.Visible = false
                        end
                    else
                        -- Esconder todas as partes da box
                        for _, drawing in pairs(playerData.Drawings.Box) do
                            drawing.Visible = false
                        end
                    end
                    
                    -- ===== TRACER =====
                    if Environment.ESP.TracerEnabled and shouldShow then
                        local tracer = playerData.Drawings.Tracer
                        tracer.Visible = true
                        tracer.Thickness = Environment.ESP.TracerThickness
                        tracer.Color = Environment.ESP.TracerColor
                        tracer.Transparency = Environment.ESP.TracerTransparency
                        
                        -- Ponto de origem
                        if Environment.ESP.TracerType == 1 then
                            tracer.From = Vector2new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        elseif Environment.ESP.TracerType == 2 then
                            tracer.From = Vector2new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                        else
                            tracer.From = UserInputService:GetMouseLocation()
                        end
                        
                        -- Ponto de destino
                        tracer.To = Vector2new(rootPos.X, rootPos.Y - boxHeight * 0.75)
                    else
                        playerData.Drawings.Tracer.Visible = false
                    end
                    
                    -- ===== HEAD DOT =====
                    if Environment.ESP.HeadDotEnabled and shouldShow then
                        local dot = playerData.Drawings.HeadDot
                        dot.Visible = true
                        dot.Thickness = Environment.ESP.HeadDotThickness
                        dot.Color = Environment.ESP.HeadDotColor
                        dot.Transparency = Environment.ESP.HeadDotTransparency
                        dot.NumSides = Environment.ESP.HeadDotSides
                        dot.Filled = Environment.ESP.HeadDotFilled
                        dot.Position = screenHead
                        
                        -- Calcular tamanho baseado na distância
                        local top = Camera:WorldToViewportPoint((head.CFrame * CFramenew(0, head.Size.Y/2, 0)).Position)
                        local bottom = Camera:WorldToViewportPoint((head.CFrame * CFramenew(0, -head.Size.Y/2, 0)).Position)
                        dot.Radius = mathabs(top.Y - bottom.Y) - 3
                    else
                        playerData.Drawings.HeadDot.Visible = false
                    end
                    
                    -- ===== HEALTH BAR =====
                    if Environment.ESP.HealthBarEnabled and shouldShow then
                        local main = playerData.Drawings.HealthBar.Main
                        local outline = playerData.Drawings.HealthBar.Outline
                        
                        main.Visible = true
                        outline.Visible = true
                        
                        -- Configurações
                        main.Thickness = 1
                        main.Color = Color3fromRGB(
                            255 - mathfloor(humanoid.Health / 100 * 255),
                            mathfloor(humanoid.Health / 100 * 255),
                            Environment.ESP.HealthBarBlue
                        )
                        main.Transparency = Environment.ESP.HealthBarTransparency
                        main.Filled = true
                        
                        outline.Thickness = 2
                        outline.Color = Environment.ESP.HealthBarOutlineColor
                        outline.Transparency = Environment.ESP.HealthBarTransparency
                        outline.Filled = false
                        
                        -- Posicionamento
                        local healthPercent = humanoid.Health / 100
                        local offset = Environment.ESP.HealthBarOffset
                        local size = Environment.ESP.HealthBarSize
                        
                        if Environment.ESP.HealthBarType == 1 then  -- Top
                            outline.Size = Vector2new(2000 / rootPos.Z, size)
                            main.Size = Vector2new(outline.Size.X * healthPercent, outline.Size.Y)
                            main.Position = Vector2new(rootPos.X - outline.Size.X / 2, rootPos.Y - boxHeight - offset)
                        elseif Environment.ESP.HealthBarType == 2 then  -- Bottom
                            outline.Size = Vector2new(2000 / rootPos.Z, size)
                            main.Size = Vector2new(outline.Size.X * healthPercent, outline.Size.Y)
                            main.Position = Vector2new(rootPos.X - outline.Size.X / 2, rootPos.Y + offset)
                        elseif Environment.ESP.HealthBarType == 3 then  -- Left
                            outline.Size = Vector2new(size, 2500 / rootPos.Z)
                            main.Size = Vector2new(outline.Size.X, outline.Size.Y * healthPercent)
                            main.Position = Vector2new(boxTop.X - offset, rootPos.Y - outline.Size.Y / 2)
                        else  -- Right
                            outline.Size = Vector2new(size, 2500 / rootPos.Z)
                            main.Size = Vector2new(outline.Size.X, outline.Size.Y * healthPercent)
                            main.Position = Vector2new(boxTop.X + boxWidth + offset, rootPos.Y - outline.Size.Y / 2)
                        end
                        
                        outline.Position = main.Position
                    else
                        playerData.Drawings.HealthBar.Main.Visible = false
                        playerData.Drawings.HealthBar.Outline.Visible = false
                    end
                    
                    -- ===== CHAMS =====
                    if Environment.ESP.ChamsEnabled and shouldShow then
                        for partName, cham in pairs(playerData.Drawings.Chams) do
                            local part = character:FindFirstChild(partName)
                            if part then
                                ESP.UpdateChams(part, cham)
                            end
                        end
                    else
                        for _, cham in pairs(playerData.Drawings.Chams) do
                            for i = 1, 6 do
                                if cham["Quad"..i] then
                                    cham["Quad"..i].Visible = false
                                end
                            end
                        end
                    end
                else
                    -- Esconder tudo se não estiver na tela
                    if playerData.Drawings.Text then playerData.Drawings.Text.Visible = false end
                    if playerData.Drawings.Tracer then playerData.Drawings.Tracer.Visible = false end
                    if playerData.Drawings.HeadDot then playerData.Drawings.HeadDot.Visible = false end
                    for _, drawing in pairs(playerData.Drawings.Box) do
                        drawing.Visible = false
                    end
                    playerData.Drawings.HealthBar.Main.Visible = false
                    playerData.Drawings.HealthBar.Outline.Visible = false
                end
            else
                -- Esconder se o personagem não existir
                if playerData.Drawings.Text then playerData.Drawings.Text.Visible = false end
                if playerData.Drawings.Tracer then playerData.Drawings.Tracer.Visible = false end
                if playerData.Drawings.HeadDot then playerData.Drawings.HeadDot.Visible = false end
                for _, drawing in pairs(playerData.Drawings.Box) do
                    drawing.Visible = false
                end
                playerData.Drawings.HealthBar.Main.Visible = false
                playerData.Drawings.HealthBar.Outline.Visible = false
            end
        end
    end
}

-- ========== FUNÇÕES DO CROSSHAIR ==========
local Crosshair = {
    Update = function()
        if not Environment.Crosshair.Enabled then
            for _, v in pairs(Drawings.Crosshair) do
                v.Visible = false
            end
            return
        end
        
        local centerX, centerY
        if Environment.Crosshair.Type == 1 then
            centerX, centerY = UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y
        else
            centerX, centerY = Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2
        end
        
        local rad = mathrad(Environment.Crosshair.Rotation)
        local cos = mathcos(rad)
        local sin = mathsin(rad)
        local size = Environment.Crosshair.Size
        local gap = Environment.Crosshair.GapSize
        
        -- Linha esquerda
        local left = Drawings.Crosshair.LeftLine
        left.Visible = true
        left.Color = Environment.Crosshair.Color
        left.Thickness = Environment.Crosshair.Thickness
        left.Transparency = Environment.Crosshair.Transparency
        left.From = Vector2new(centerX - cos * gap, centerY - sin * gap)
        left.To = Vector2new(centerX - cos * (size + gap), centerY - sin * (size + gap))
        
        -- Linha direita
        local right = Drawings.Crosshair.RightLine
        right.Visible = true
        right.Color = Environment.Crosshair.Color
        right.Thickness = Environment.Crosshair.Thickness
        right.Transparency = Environment.Crosshair.Transparency
        right.From = Vector2new(centerX + cos * gap, centerY + sin * gap)
        right.To = Vector2new(centerX + cos * (size + gap), centerY + sin * (size + gap))
        
        -- Linha superior
        local top = Drawings.Crosshair.TopLine
        top.Visible = true
        top.Color = Environment.Crosshair.Color
        top.Thickness = Environment.Crosshair.Thickness
        top.Transparency = Environment.Crosshair.Transparency
        top.From = Vector2new(centerX - sin * gap, centerY - cos * gap)
        top.To = Vector2new(centerX - sin * (size + gap), centerY - cos * (size + gap))
        
        -- Linha inferior
        local bottom = Drawings.Crosshair.BottomLine
        bottom.Visible = true
        bottom.Color = Environment.Crosshair.Color
        bottom.Thickness = Environment.Crosshair.Thickness
        bottom.Transparency = Environment.Crosshair.Transparency
        bottom.From = Vector2new(centerX + sin * gap, centerY + cos * gap)
        bottom.To = Vector2new(centerX + sin * (size + gap), centerY + cos * (size + gap))
        
        -- Ponto central
        local dot = Drawings.Crosshair.CenterDot
        dot.Visible = Environment.Crosshair.CenterDot
        dot.Color = Environment.Crosshair.CenterDotColor
        dot.Radius = Environment.Crosshair.CenterDotSize
        dot.Transparency = Environment.Crosshair.CenterDotTransparency
        dot.Filled = Environment.Crosshair.CenterDotFilled
        dot.Position = Vector2new(centerX, centerY)
    end
}

-- ========== SISTEMA DE INPUT ==========
ServiceConnections.InputBegan = UserInputService.InputBegan:Connect(function(input)
    if Typing then return end
    
    -- Tecla para abrir/fechar menu (GUI será implementada depois)
    if input.KeyCode == Environment.Menu.ToggleKey then
        Environment.Menu.Enabled = not Environment.Menu.Enabled
        -- Aqui você pode adicionar lógica para mostrar/esconder GUI
    end
    
    -- Tecla do aimbot
    pcall(function()
        local triggerKey = Environment.Aimbot.TriggerKey
        if (input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode[triggerKey]) or
           (input.UserInputType == Enum.UserInputType[triggerKey]) then
            if Environment.Aimbot.Toggle then
                Running = not Running
                if not Running then
                    Aimbot.CancelLock()
                end
            else
                Running = true
            end
        end
    end)
end)

ServiceConnections.InputEnded = UserInputService.InputEnded:Connect(function(input)
    if Typing or Environment.Aimbot.Toggle then return end
    
    pcall(function()
        local triggerKey = Environment.Aimbot.TriggerKey
        if (input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode[triggerKey]) or
           (input.UserInputType == Enum.UserInputType[triggerKey]) then
            Running = false
            Aimbot.CancelLock()
        end
    end)
end)

-- ========== GERENCIAMENTO DE JOGADORES ==========
ServiceConnections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
    ESP.WrapPlayer(player)
end)

ServiceConnections.PlayerRemoving = Players.PlayerRemoving:Connect(function(player)
    ESP.UnwrapPlayer(player)
end)

-- Envolver jogadores existentes
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        ESP.WrapPlayer(player)
    end
end

-- ========== LOOP PRINCIPAL ==========
ServiceConnections.RenderStepped = RunService.RenderStepped:Connect(function()
    -- Atualizar Aimbot
    Aimbot.Update()
    
    -- Atualizar ESP
    ESP.Update()
    
    -- Atualizar Crosshair
    Crosshair.Update()
end)

-- ========== FUNÇÕES PÚBLICAS ==========
Environment.Functions = {
    Exit = function()
        -- Desconectar todas as conexões
        for _, conn in pairs(ServiceConnections) do
            conn:Disconnect()
        end
        
        -- Remover todos os drawings
        if Drawings.FOVCircle then Drawings.FOVCircle:Remove() end
        for _, v in pairs(Drawings.Crosshair) do
            if v.Remove then v:Remove() end
        end
        
        -- Remover todos os ESPs
        for _, playerData in ipairs(WrappedPlayers) do
            ESP.UnwrapPlayer(playerData.Player)
        end
        
        -- Limpar ambiente
        getgenv().UniversalCheat = nil
    end,
    
    Restart = function()
        Environment.Functions:Exit()
        -- O script precisará ser executado novamente
    end,
    
    ResetSettings = function()
        -- Reset Aimbot
        Environment.Aimbot = {
            Enabled = false,
            TeamCheck = true,
            AliveCheck = true,
            WallCheck = true,
            Sensitivity = 0.15,
            Smoothness = 0.3,
            LockMode = 1,
            LockPart = "Head",
            TriggerKey = "MouseButton2",
            Toggle = false,
            ThirdPersonSensitivity = 3,
            FOV = 120,
            ShowFOV = true,
            FOVColor = Color3fromRGB(0, 255, 255),
            FOVLockedColor = Color3fromRGB(255, 100, 100),
            FOVTransparency = 0.7,
            FOVThickness = 1.5,
            FOVFilled = false,
            FOVSides = 64,
        }
        
        -- Reset ESP
        Environment.ESP = {
            Enabled = false,
            TeamCheck = true,
            AliveCheck = true,
            TextEnabled = true,
            TextColor = Color3fromRGB(255, 255, 255),
            TextSize = 14,
            TextOutline = true,
            OutlineColor = Color3fromRGB(0, 0, 0),
            TextTransparency = 0.3,
            TextFont = Drawing.Fonts.UI,
            TextOffset = 20,
            DisplayDistance = true,
            DisplayHealth = true,
            DisplayName = true,
            BoxEnabled = true,
            BoxType = 2,
            BoxColor = Color3fromRGB(255, 255, 255),
            BoxTransparency = 0.5,
            BoxThickness = 1.5,
            BoxFilled = false,
            BoxScale = 1,
            TracerEnabled = true,
            TracerType = 1,
            TracerColor = Color3fromRGB(255, 255, 255),
            TracerTransparency = 0.5,
            TracerThickness = 1,
            HeadDotEnabled = true,
            HeadDotColor = Color3fromRGB(255, 255, 255),
            HeadDotTransparency = 0.4,
            HeadDotThickness = 1,
            HeadDotFilled = false,
            HeadDotSides = 30,
            HealthBarEnabled = true,
            HealthBarType = 3,
            HealthBarTransparency = 0.6,
            HealthBarSize = 3,
            HealthBarOffset = 5,
            HealthBarOutlineColor = Color3fromRGB(0, 0, 0),
            HealthBarBlue = 50,
            ChamsEnabled = false,
            ChamsColor = Color3fromRGB(255, 255, 255),
            ChamsTransparency = 0.3,
            ChamsThickness = 1,
            ChamsFilled = true,
            ChamsEntireBody = false,
        }
        
        -- Reset Crosshair
        Environment.Crosshair = {
            Enabled = false,
            Type = 1,
            Size = 12,
            Thickness = 1.5,
            Color = Color3fromRGB(0, 255, 0),
            Transparency = 1,
            GapSize = 5,
            Rotation = 0,
            CenterDot = true,
            CenterDotColor = Color3fromRGB(0, 255, 0),
            CenterDotSize = 2,
            CenterDotTransparency = 1,
            CenterDotFilled = true,
        }
    end,
    
    GetClosestPlayer = function()
        Aimbot.GetClosestPlayer()
        local target = Aimbot.CurrentTarget
        Aimbot.CancelLock()
        return target
    end,
    
    Blacklist = function(playerName)
        -- Implementar blacklist
    end,
    
    Whitelist = function(playerName)
        -- Implementar whitelist
    end,
}

-- ========== GUI (Interface Gráfica) ==========
-- Criar ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UniversalCheatGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Tentar colocar no CoreGui (fica por cima de tudo)
pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Frame principal
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 700, 0, 500)
MainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
MainFrame.BackgroundColor3 = Environment.Menu.Color
MainFrame.BackgroundTransparency = Environment.Menu.Transparency
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Visible = Environment.Menu.Enabled
MainFrame.Parent = ScreenGui

-- Cantos arredondados
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Sombra
local Shadow = Instance.new("ImageLabel")
Shadow.Size = UDim2.new(1, 20, 1, 20)
Shadow.Position = UDim2.new(0, -10, 0, -10)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.6
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
Shadow.Parent = MainFrame

-- Barra de título
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Environment.Menu.AccentColor
TitleBar.BackgroundTransparency = 0.1
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🎯 UNIVERSAL CHEAT PREMIUM"
Title.TextColor3 = Environment.Menu.TextColor
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.Parent = TitleBar

-- Botão Fechar
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0, 7.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    Environment.Functions:Exit()
end)

-- Botão Minimizar
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -75, 0, 7.5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "🗕"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 18
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = TitleBar

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 6)
MinimizeCorner.Parent = MinimizeButton

MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Container de Abas
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -20, 0, 45)
TabContainer.Position = UDim2.new(0, 10, 0, 55)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

-- Container de Conteúdo
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -30, 1, -130)
ContentContainer.Position = UDim2.new(0, 15, 0, 110)
ContentContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
ContentContainer.BackgroundTransparency = 0.2
ContentContainer.BorderSizePixel = 0
ContentContainer.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 8)
ContentCorner.Parent = ContentContainer

-- Função para criar abas
local tabs = {}
local currentTab = "Aimbot"
local tabButtons = {}

local function createTab(name, icon, position)
    local tab = Instance.new("TextButton")
    tab.Size = UDim2.new(0, 100, 1, 0)
    tab.Position = UDim2.new(0, position, 0, 0)
    tab.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    tab.BackgroundTransparency = 0.3
    tab.BorderSizePixel = 0
    tab.Text = icon .. " " .. name
    tab.TextColor3 = Color3.fromRGB(200, 200, 200)
    tab.TextSize = 14
    tab.Font = Enum.Font.GothamBold
    tab.Parent = TabContainer
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tab
    
    tab.MouseButton1Click:Connect(function()
        currentTab = name
        for _, btn in ipairs(tabButtons) do
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        tab.BackgroundColor3 = Environment.Menu.AccentColor
        tab.TextColor3 = Color3.fromRGB(255, 255, 255)
        updateContent(name)
    end)
    
    table.insert(tabButtons, tab)
    tabs[name] = tab
end

createTab("Aimbot", "🎯", 0)
createTab("ESP", "👁️", 100)
createTab("Crosshair", "🎮", 200)
createTab("Settings", "⚙️", 300)

-- Ativar primeira aba
tabs["Aimbot"].BackgroundColor3 = Environment.Menu.AccentColor
tabs["Aimbot"].TextColor3 = Color3.fromRGB(255, 255, 255)

-- Funções auxiliares para criar elementos na GUI
local function createSectionTitle(text, y)
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 30)
    title.Position = UDim2.new(0, 10, 0, y)
    title.BackgroundTransparency = 1
    title.Text = text
    title.TextColor3 = Environment.Menu.AccentColor
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    return title
end

local function createToggle(parent, x, y, text, category, setting)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 280, 0, 30)
    frame.Position = UDim2.new(0, x, 0, y)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 200, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Environment.Menu.TextColor
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 50, 0, 25)
    toggle.Position = UDim2.new(0, 210, 0, 2.5)
    toggle.BackgroundColor3 = Environment[category][setting] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    toggle.BorderSizePixel = 0
    toggle.Text = Environment[category][setting] and "ON" or "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextSize = 12
    toggle.Font = Enum.Font.GothamBold
    toggle.Parent = frame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 4)
    toggleCorner.Parent = toggle
    
    toggle.MouseButton1Click:Connect(function()
        Environment[category][setting] = not Environment[category][setting]
        toggle.BackgroundColor3 = Environment[category][setting] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        toggle.Text = Environment[category][setting] and "ON" or "OFF"
    end)
end

local function createSlider(parent, x, y, text, min, max, category, setting, decimals)
    decimals = decimals or 0
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 280, 0, 50)
    frame.Position = UDim2.new(0, x, 0, y)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 200, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Environment.Menu.TextColor
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(0, 210, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(Environment[category][setting])
    valueLabel.TextColor3 = Environment.Menu.AccentColor
    valueLabel.TextSize = 14
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Parent = frame
    
    local slider = Instance.new("TextButton")
    slider.Size = UDim2.new(1, 0, 0, 20)
    slider.Position = UDim2.new(0, 0, 0, 25)
    slider.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    slider.BorderSizePixel = 0
    slider.Text = ""
    slider.Parent = frame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 4)
    sliderCorner.Parent = slider
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((Environment[category][setting] - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Environment.Menu.AccentColor
    fill.BorderSizePixel = 0
    fill.Parent = slider
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = fill
    
    local dragging = false
    
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local mousePos = UserInputService:GetMouseLocation()
            local sliderPos = slider.AbsolutePosition.X
            local sliderSize = slider.AbsoluteSize.X
            local relativePos = mathclamp(mousePos - sliderPos, 0, sliderSize)
            local value = min + (relativePos / sliderSize) * (max - min)
            
            if decimals > 0 then
                value = mathfloor(value * (10^decimals)) / (10^decimals)
            else
                value = mathfloor(value)
            end
            
            fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            valueLabel.Text = tostring(value)
            Environment[category][setting] = value
        end
    end)
end

local function createDropdown(parent, x, y, text, options, category, setting)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 280, 0, 45)
    frame.Position = UDim2.new(0, x, 0, y)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 200, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Environment.Menu.TextColor
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local dropdown = Instance.new("TextButton")
    dropdown.Size = UDim2.new(0, 100, 0, 25)
    dropdown.Position = UDim2.new(0, 160, 0, 0)
    dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    dropdown.BorderSizePixel = 0
    dropdown.Text = tostring(Environment[category][setting])
    dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdown.TextSize = 12
    dropdown.Font = Enum.Font.Gotham
    dropdown.Parent = frame
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 4)
    dropdownCorner.Parent = dropdown
    
    dropdown.MouseButton1Click:Connect(function()
        local currentIndex = 1
        for i, opt in ipairs(options) do
            if opt == tostring(Environment[category][setting]) then
                currentIndex = i % #options + 1
                break
            end
        end
        Environment[category][setting] = options[currentIndex]
        dropdown.Text = tostring(Environment[category][setting])
    end)
end

local function createColorPicker(parent, x, y, text, category, setting)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 280, 0, 35)
    frame.Position = UDim2.new(0, x, 0, y)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 200, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Environment.Menu.TextColor
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local colorBtn = Instance.new("TextButton")
    colorBtn.Size = UDim2.new(0, 30, 0, 25)
    colorBtn.Position = UDim2.new(0, 210, 0, 5)
    colorBtn.BackgroundColor3 = Environment[category][setting]
    colorBtn.BorderSizePixel = 0
    colorBtn.Text = ""
    colorBtn.Parent = frame
    
    local colorCorner = Instance.new("UICorner")
    colorCorner.CornerRadius = UDim.new(0, 4)
    colorCorner.Parent = colorBtn
    
    local colors = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(255, 0, 255),
        Color3.fromRGB(0, 255, 255),
        Color3.fromRGB(255, 255, 255),
        Environment.Menu.AccentColor
    }
    
    colorBtn.MouseButton1Click:Connect(function()
        local currentIndex = 1
        for i, c in ipairs(colors) do
            if c == Environment[category][setting] then
                currentIndex = i % #colors + 1
                break
            end
        end
        Environment[category][setting] = colors[currentIndex]
        colorBtn.BackgroundColor3 = colors[currentIndex]
    end)
end

-- Função para atualizar conteúdo das abas
function updateContent(tabName)
    for _, child in ipairs(ContentContainer:GetChildren()) do
        child:Destroy()
    end
    
    if tabName == "Aimbot" then
        local y = 10
        
        local title = createSectionTitle("CONFIGURAÇÕES DO AIMBOT", y)
        title.Parent = ContentContainer
        
        y = 45
        createToggle(ContentContainer, 10, y, "Ativar Aimbot", "Aimbot", "Enabled")
        createToggle(ContentContainer, 10, y+35, "Team Check", "Aimbot", "TeamCheck")
        createToggle(ContentContainer, 10, y+70, "Wall Check", "Aimbot", "WallCheck")
        createToggle(ContentContainer, 10, y+105, "Alive Check", "Aimbot", "AliveCheck")
        createToggle(ContentContainer, 10, y+140, "Mostrar FOV", "Aimbot", "ShowFOV")
        createToggle(ContentContainer, 10, y+175, "Modo Toggle", "Aimbot", "Toggle")
        
        createDropdown(ContentContainer, 10, y+210, "Parte do Corpo", 
            {"Head", "HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso"}, "Aimbot", "LockPart")
        
        createDropdown(ContentContainer, 10, y+260, "Modo de Mira", 
            {"1 - CFrame", "2 - MouseMoveRel"}, "Aimbot", "LockMode", function(val)
                Environment.Aimbot.LockMode = tonumber(val:sub(1,1))
            end)
        
        createSlider(ContentContainer, 10, y+310, "Suavidade", 0.1, 1, "Aimbot", "Smoothness", 1)
        createSlider(ContentContainer, 10, y+365, "Sensibilidade Animação", 0, 1, "Aimbot", "Sensitivity", 2)
        
        -- Segunda coluna
        createSlider(ContentContainer, 300, y, "Raio do FOV", 30, 360, "Aimbot", "FOV", 0)
        createSlider(ContentContainer, 300, y+55, "Espessura do FOV", 1, 5, "Aimbot", "FOVThickness", 1)
        createSlider(ContentContainer, 300, y+110, "Transparência FOV", 0, 1, "Aimbot", "FOVTransparency", 1)
        createSlider(ContentContainer, 300, y+165, "Número de Lados", 3, 100, "Aimbot", "FOVSides", 0)
        
        createColorPicker(ContentContainer, 300, y+220, "Cor do FOV", "Aimbot", "FOVColor")
        createColorPicker(ContentContainer, 300, y+260, "Cor Travado", "Aimbot", "FOVLockedColor")
        
    elseif tabName == "ESP" then
        local y = 10
        
        local title = createSectionTitle("WALLHACK ESP", y)
        title.Parent = ContentContainer
        
        y = 45
        createToggle(ContentContainer, 10, y, "Ativar ESP", "ESP", "Enabled")
        createToggle(ContentContainer, 10, y+35, "Team Check", "ESP", "TeamCheck")
        createToggle(ContentContainer, 10, y+70, "Alive Check", "ESP", "AliveCheck")
        
        createToggle(ContentContainer, 10, y+105, "Mostrar Texto", "ESP", "TextEnabled")
        createToggle(ContentContainer, 10, y+140, "Mostrar Box", "ESP", "BoxEnabled")
        createToggle(ContentContainer, 10, y+175, "Mostrar Tracer", "ESP", "TracerEnabled")
        createToggle(ContentContainer, 10, y+210, "Mostrar Head Dot", "ESP", "HeadDotEnabled")
        createToggle(ContentContainer, 10, y+245, "Mostrar Health Bar", "ESP", "HealthBarEnabled")
        createToggle(ContentContainer, 10, y+280, "Mostrar Chams", "ESP", "ChamsEnabled")
        
        -- Configurações de Texto
        local title2 = createSectionTitle("CONFIGURAÇÕES DE TEXTO", y+320)
        title2.Parent = ContentContainer
        
        createSlider(ContentContainer, 10, y+355, "Tamanho do Texto", 8, 24, "ESP", "TextSize", 0)
        createSlider(ContentContainer, 10, y+410, "Transparência", 0, 1, "ESP", "TextTransparency", 1)
        createSlider(ContentContainer, 10, y+465, "Offset Vertical", 0, 50, "ESP", "TextOffset", 0)
        
        createColorPicker(ContentContainer, 10, y+520, "Cor do Texto", "ESP", "TextColor")
        createColorPicker(ContentContainer, 10, y+560, "Cor do Outline", "ESP", "OutlineColor")
        
        -- Segunda coluna - Configurações de Box
        createSlider(ContentContainer, 300, y, "Espessura da Box", 1, 5, "ESP", "BoxThickness", 1)
        createSlider(ContentContainer, 300, y+55, "Transparência Box", 0, 1, "ESP", "BoxTransparency", 1)
        createSlider(ContentContainer, 300, y+110, "Escala 3D", 1, 3, "ESP", "BoxScale", 1)
        
        createDropdown(ContentContainer, 300, y+165, "Tipo de Box", 
            {"1 - 3D", "2 - 2D"}, "ESP", "BoxType", function(val)
                Environment.ESP.BoxType = tonumber(val:sub(1,1))
            end)
        
        createColorPicker(ContentContainer, 300, y+215, "Cor da Box", "ESP", "BoxColor")
        
        -- Configurações de Tracer
        local title3 = createSectionTitle("TRACER", y+265)
        title3.Parent = ContentContainer
        
        createSlider(ContentContainer, 300, y+300, "Espessura Tracer", 1, 5, "ESP", "TracerThickness", 1)
        createSlider(ContentContainer, 300, y+355, "Transparência", 0, 1, "ESP", "TracerTransparency", 1)
        
        createDropdown(ContentContainer, 300, y+410, "Origem do Tracer", 
            {"1 - Bottom", "2 - Center", "3 - Mouse"}, "ESP", "TracerType", function(val)
                Environment.ESP.TracerType = tonumber(val:sub(1,1))
            end)
        
        createColorPicker(ContentContainer, 300, y+460, "Cor do Tracer", "ESP", "TracerColor")
        
    elseif tabName == "Crosshair" then
        local y = 10
        
        local title = createSectionTitle("CROSSHAIR CUSTOMIZÁVEL", y)
        title.Parent = ContentContainer
        
        y = 45
        createToggle(ContentContainer, 10, y, "Ativar Crosshair", "Crosshair", "Enabled")
        createToggle(ContentContainer, 10, y+35, "Ponto Central", "Crosshair", "CenterDot")
        
        createDropdown(ContentContainer, 10, y+70, "Posição", 
            {"1 - Mouse", "2 - Centro"}, "Crosshair", "Type", function(val)
                Environment.Crosshair.Type = tonumber(val:sub(1,1))
            end)
        
        createSlider(ContentContainer, 10, y+120, "Tamanho", 4, 30, "Crosshair", "Size", 0)
        createSlider(ContentContainer, 10, y+175, "Espessura", 1, 5, "Crosshair", "Thickness", 1)
        createSlider(ContentContainer, 10, y+230, "Gap (Espaço)", 0, 20, "Crosshair", "GapSize", 0)
        createSlider(ContentContainer, 10, y+285, "Rotação", -180, 180, "Crosshair", "Rotation", 0)
        createSlider(ContentContainer, 10, y+340, "Transparência", 0, 1, "Crosshair", "Transparency", 1)
        
        -- Segunda coluna
        createColorPicker(ContentContainer, 300, y, "Cor do Crosshair", "Crosshair", "Color")
        createColorPicker(ContentContainer, 300, y+40, "Cor do Ponto", "Crosshair", "CenterDotColor")
        
        createSlider(ContentContainer, 300, y+80, "Tamanho do Ponto", 1, 10, "Crosshair", "CenterDotSize", 0)
        createSlider(ContentContainer, 300, y+135, "Transparência Ponto", 0, 1, "Crosshair", "CenterDotTransparency", 1)
        
    elseif tabName == "Settings" then
        local y = 10
        
        local title = createSectionTitle("CONFIGURAÇÕES GLOBAIS", y)
        title.Parent = ContentContainer
        
        y = 45
        createToggle(ContentContainer, 10, y, "Team Check Global", "Settings", "TeamCheck")
        createToggle(ContentContainer, 10, y+35, "Alive Check Global", "Settings", "AliveCheck")
        createToggle(ContentContainer, 10, y+70, "Wall Check Global", "Settings", "WallCheck")
        
        -- Botões de função
        local function createButton(parent, x, y, text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 150, 0, 40)
            btn.Position = UDim2.new(0, x, 0, y)
            btn.BackgroundColor3 = Environment.Menu.AccentColor
            btn.BorderSizePixel = 0
            btn.Text = text
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = 14
            btn.Font = Enum.Font.GothamBold
            btn.Parent = parent
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(callback)
        end
        
        createButton(ContentContainer, 10, y+120, "Resetar Configurações", function()
            Environment.Functions:ResetSettings()
            -- Atualizar GUI (simplificado)
            for _, child in ipairs(ContentContainer:GetChildren()) do
                child:Destroy()
            end
            updateContent(currentTab)
        end)
        
        createButton(ContentContainer, 180, y+120, "Restart Script", function()
            Environment.Functions:Restart()
        end)
        
        createButton(ContentContainer, 350, y+120, "Exit", function()
            CloseButton.MouseButton1Click:Fire()
        end)
        
        local info = Instance.new("TextLabel")
        info.Size = UDim2.new(1, -20, 0, 100)
        info.Position = UDim2.new(0, 10, 0, y+180)
        info.BackgroundTransparency = 1
        info.Text = "⚡ UNIVERSAL CHEAT PREMIUM ⚡\n\nBaseado em Exunys AirHub\nTecla P: Abrir/Fechar Menu\nMouse2: Ativar Aimbot (segurar)\n\nTodas as configurações são aplicadas em tempo real!"
        info.TextColor3 = Environment.Menu.TextColor
        info.TextSize = 14
        info.TextWrapped = true
        info.Font = Enum.Font.Gotham
        info.Parent = ContentContainer
    end
end

-- Inicializar primeira aba
updateContent("Aimbot")

-- ========== INICIALIZAÇÃO ==========
OriginalSensitivity = UserInputService.MouseDeltaSensitivity

print("✅ UNIVERSAL CHEAT PREMIUM CARREGADO!")
print("✅ Aimbot | ESP | Crosshair | GUI Moderna")
print("✅ Tecla P para abrir/fechar o menu")
print("✅ Mouse2 para ativar o aimbot (padrão)")
print("✅ Baseado em Exunys AirHub - Todos os direitos reservados")
