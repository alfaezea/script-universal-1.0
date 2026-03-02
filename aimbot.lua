-- ========== CONTEÚDO AIMBOT (ATUALIZADO) ==========
local aimbotContent = Instance.new("ScrollingFrame")
aimbotContent.Size = UDim2.new(1, 0, 1, 0)
aimbotContent.BackgroundTransparency = 1
aimbotContent.BorderSizePixel = 0
aimbotContent.ScrollBarThickness = 5
aimbotContent.CanvasSize = UDim2.new(0, 0, 0, 900)
aimbotContent.Visible = false
aimbotContent.Parent = ContentFrame

if Aimbot then
    local yPos = 10
    
    -- TÍTULO
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
    
    -- PARTE DO CORPO (TODAS AS PARTES)
    local partLabel = Instance.new("TextLabel")
    partLabel.Size = UDim2.new(0, 200, 0, 30)
    partLabel.Position = UDim2.new(0, 20, 0, yPos)
    partLabel.BackgroundTransparency = 1
    partLabel.Text = "🎯 Parte do corpo:"
    partLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    partLabel.TextXAlignment = Enum.TextXAlignment.Left
    partLabel.TextScaled = true
    partLabel.Font = Enum.Font.Gotham
    partLabel.Parent = aimbotContent
    
    local partBtn = Instance.new("TextButton")
    partBtn.Size = UDim2.new(0, 200, 0, 30)
    partBtn.Position = UDim2.new(0, 200, 0, yPos)
    partBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    partBtn.BorderSizePixel = 0
    partBtn.Text = Aimbot.Settings.LockPart
    partBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    partBtn.TextScaled = true
    partBtn.Font = Enum.Font.Gotham
    partBtn.Parent = aimbotContent
    
    -- Lista de TODAS as partes do corpo
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
        partBtn.Text = Aimbot.Settings.LockPart
    end)
    yPos = yPos + 40
    
    -- MODO AUTOMÁTICO (gruda sem tecla)
    createToggle(aimbotContent, "🤖 Modo Automático (gruda sozinho)", yPos,
        function() return Aimbot.Settings.Auto end,
        function(v) 
            Aimbot.Settings.Auto = v
            if v then
                Aimbot.Settings.Toggle = false
            end
        end)
    yPos = yPos + 45
    
    -- SISTEMA DE APRENDER TECLA
    local keyLabel = Instance.new("TextLabel")
    keyLabel.Size = UDim2.new(0, 200, 0, 30)
    keyLabel.Position = UDim2.new(0, 20, 0, yPos)
    keyLabel.BackgroundTransparency = 1
    keyLabel.Text = "⌨️ Tecla atual:"
    keyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    keyLabel.TextXAlignment = Enum.TextXAlignment.Left
    keyLabel.TextScaled = true
    keyLabel.Font = Enum.Font.Gotham
    keyLabel.Parent = aimbotContent
    
    local keyDisplay = Instance.new("TextLabel")
    keyDisplay.Size = UDim2.new(0, 100, 0, 30)
    keyDisplay.Position = UDim2.new(0, 200, 0, yPos)
    keyDisplay.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    keyDisplay.BorderSizePixel = 0
    keyDisplay.Text = Aimbot.Settings.TriggerKey
    keyDisplay.TextColor3 = Color3.fromRGB(255, 255, 0)
    keyDisplay.TextScaled = true
    keyDisplay.Font = Enum.Font.GothamBold
    keyDisplay.Parent = aimbotContent
    
    local learnBtn = Instance.new("TextButton")
    learnBtn.Size = UDim2.new(0, 100, 0, 30)
    learnBtn.Position = UDim2.new(0, 310, 0, yPos)
    learnBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    learnBtn.BorderSizePixel = 0
    learnBtn.Text = "Gravar"
    learnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    learnBtn.TextScaled = true
    learnBtn.Font = Enum.Font.Gotham
    learnBtn.Parent = aimbotContent
    
    learnBtn.MouseButton1Click:Connect(function()
        Aimbot.Settings.Learning = true
        learnBtn.Text = "Aperte uma tecla..."
        learnBtn.BackgroundColor3 = Color3.fromRGB(255, 128, 0)
        
        -- Timer para sair do modo aprendizado após 5 segundos
        task.delay(5, function()
            if Aimbot.Settings.Learning then
                Aimbot.Settings.Learning = false
                learnBtn.Text = "Gravar"
                learnBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            end
        end)
        
        -- Atualiza o display quando a tecla for escolhida
        local conn
        conn = game:GetService("RunService").Stepped:Connect(function()
            if not Aimbot.Settings.Learning then
                keyDisplay.Text = Aimbot.Settings.TriggerKey
                learnBtn.Text = "Gravar"
                learnBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
                conn:Disconnect()
            end
        end)
    end)
    yPos = yPos + 40
    
    -- MODO DE ATIVAÇÃO (Toggle/Hold) - só aparece se não for Auto
    if not Aimbot.Settings.Auto then
        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Size = UDim2.new(0, 200, 0, 30)
        toggleLabel.Position = UDim2.new(0, 20, 0, yPos)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Text = "🔄 Modo de ativação:"
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
    end
    
    -- SEPARADOR
    local sep1 = Instance.new("Frame")
    sep1.Size = UDim2.new(1, -40, 0, 1)
    sep1.Position = UDim2.new(0, 20, 0, yPos)
    sep1.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    sep1.BorderSizePixel = 0
    sep1.Parent = aimbotContent
    yPos = yPos + 15
    
    -- FOV
    createToggle(aimbotContent, "👁️ Ativar FOV", yPos,
        function() return Aimbot.FOVSettings.Enabled end,
        function(v) Aimbot.FOVSettings.Enabled = v end)
    yPos = yPos + 45
    
    createSlider(aimbotContent, "FOV Size", yPos, 10, 360,
        function() return Aimbot.FOVSettings.Amount end,
        function(v) Aimbot.FOVSettings.Amount = v end, "int")
    yPos = yPos + 60
    
    createSlider(aimbotContent, "FOV Transparency", yPos, 0, 1,
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
    
    -- CHECKS
    createToggle(aimbotContent, "👥 Team Check", yPos,
        function() return Aimbot.Settings.TeamCheck end,
        function(v) Aimbot.Settings.TeamCheck = v end)
    yPos = yPos + 45
    
    createToggle(aimbotContent, "🧱 Wall Check", yPos,
        function() return Aimbot.Settings.WallCheck end,
        function(v) Aimbot.Settings.WallCheck = v end)
    yPos = yPos + 45
    
    createToggle(aimbotContent, "💀 Alive Check", yPos,
        function() return Aimbot.Settings.AliveCheck end,
        function(v) Aimbot.Settings.AliveCheck = v end)
    yPos = yPos + 45
    
    -- SMOOTHNESS
    createSlider(aimbotContent, "Smoothness", yPos, 0.1, 1,
        function() return Aimbot.Settings.Smoothness end,
        function(v) Aimbot.Settings.Smoothness = v end, "float")
    yPos = yPos + 60
    
    aimbotContent.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)
else
    local err = Instance.new("TextLabel")
    err.Size = UDim2.new(1, 0, 0, 100)
    err.Position = UDim2.new(0, 0, 0, 20)
    err.BackgroundTransparency = 1
    err.Text = "❌ AIMBOT NÃO CARREGADO!\n\nVerifique o script"
    err.TextColor3 = Color3.fromRGB(255, 0, 0)
    err.TextWrapped = true
    err.TextScaled = true
    err.Font = Enum.Font.Gotham
    err.Parent = aimbotContent
end
