-- ========== CONTEÚDO AIMBOT (ATUALIZADO) ==========
local aimbotContent = Instance.new("ScrollingFrame")
aimbotContent.Size = UDim2.new(1, 0, 1, 0)
aimbotContent.BackgroundTransparency = 1
aimbotContent.BorderSizePixel = 0
aimbotContent.ScrollBarThickness = 5
aimbotContent.CanvasSize = UDim2.new(0, 0, 0, 800)
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
    titleAim.Text = "🎯 AIMBOT CONFIGURÁVEL"
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
    
    -- PARTE DO CORPO (DROPDOWN)
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
    partBtn.Size = UDim2.new(0, 150, 0, 30)
    partBtn.Position = UDim2.new(0, 200, 0, yPos)
    partBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    partBtn.BorderSizePixel = 0
    partBtn.Text = Aimbot.Settings.LockPart
    partBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    partBtn.TextScaled = true
    partBtn.Font = Enum.Font.Gotham
    partBtn.Parent = aimbotContent
    
    -- Menu de partes (R6 e R15)
    local partsList = {"Head", "HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
    local partIndex = 1
    
    partBtn.MouseButton1Click:Connect(function()
        partIndex = partIndex + 1
        if partIndex > #partsList then partIndex = 1 end
        Aimbot.Settings.LockPart = partsList[partIndex]
        partBtn.Text = Aimbot.Settings.LockPart
    end)
    yPos = yPos + 40
    
    -- TECLA DE ATALHO
    local keyLabel = Instance.new("TextLabel")
    keyLabel.Size = UDim2.new(0, 200, 0, 30)
    keyLabel.Position = UDim2.new(0, 20, 0, yPos)
    keyLabel.BackgroundTransparency = 1
    keyLabel.Text = "⌨️ Tecla para grudar:"
    keyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    keyLabel.TextXAlignment = Enum.TextXAlignment.Left
    keyLabel.TextScaled = true
    keyLabel.Font = Enum.Font.Gotham
    keyLabel.Parent = aimbotContent
    
    local keyBtn = Instance.new("TextButton")
    keyBtn.Size = UDim2.new(0, 150, 0, 30)
    keyBtn.Position = UDim2.new(0, 200, 0, yPos)
    keyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    keyBtn.BorderSizePixel = 0
    keyBtn.Text = Aimbot.Settings.TriggerKey
    keyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyBtn.TextScaled = true
    keyBtn.Font = Enum.Font.Gotham
    keyBtn.Parent = aimbotContent
    
    -- Lista de teclas possíveis
    local keysList = {"MouseButton2", "MouseButton1", "V", "C", "X", "Z", "Q", "E", "R", "F", "G", "LeftShift", "LeftControl", "LeftAlt", "Space", "Tab"}
    local keyIndex = 1
    
    keyBtn.MouseButton1Click:Connect(function()
        keyIndex = keyIndex + 1
        if keyIndex > #keysList then keyIndex = 1 end
        Aimbot.Settings.TriggerKey = keysList[keyIndex]
        keyBtn.Text = Aimbot.Settings.TriggerKey
    end)
    yPos = yPos + 40
    
    -- MODO DE ATIVAÇÃO (Toggle)
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
    toggleBtn.Size = UDim2.new(0, 150, 0, 30)
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
