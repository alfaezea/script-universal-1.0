--[[
    AIMBOT MODULE - VERSÃO FINAL FUNCIONAL
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local AimbotModule = {
    Enabled = false,
    Running = false,
    Settings = {
        FOV = 120,
        ShowFOV = true,
        FOVColor = Color3.fromRGB(0, 255, 255),
        Smoothness = 0.3
    },
    FOVCircle = Drawing.new("Circle")
}

-- Configurar FOV
AimbotModule.FOVCircle.Visible = false
AimbotModule.FOVCircle.Thickness = 1.5
AimbotModule.FOVCircle.Filled = false
AimbotModule.FOVCircle.NumSides = 32
AimbotModule.FOVCircle.Radius = AimbotModule.Settings.FOV
AimbotModule.FOVCircle.Color = AimbotModule.Settings.FOVColor
AimbotModule.FOVCircle.Transparency = 0.7

local function GetMousePos()
    return Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
end

local function GetClosestPlayer()
    local closest = nil
    local closestDist = AimbotModule.Settings.FOV
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            
            if onScreen then
                local dist = (GetMousePos() - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = player
                end
            end
        end
    end
    return closest
end

-- Loop principal
RunService.RenderStepped:Connect(function()
    -- Só executa se ativado
    if AimbotModule.Enabled then
        -- Mostrar FOV
        if AimbotModule.Settings.ShowFOV then
            AimbotModule.FOVCircle.Position = GetMousePos()
            AimbotModule.FOVCircle.Visible = true
        end
        
        -- Aimbot (só se Running = true)
        if AimbotModule.Running then
            local target = GetClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild("Head") then
                local head = target.Character.Head
                local targetPos = head.Position
                local currentPos = Camera.CFrame.Position
                Camera.CFrame = CFrame.new(currentPos, targetPos)
            end
        end
    else
        AimbotModule.FOVCircle.Visible = false
    end
end)

-- Inputs
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        AimbotModule.Running = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        AimbotModule.Running = false
    end
end)

-- Funções para GUI
AimbotModule.SetEnabled = function(state)
    AimbotModule.Enabled = state
    print("🎯 Aimbot " .. (state and "ATIVADO" or "DESATIVADO"))
end

AimbotModule.SetFOV = function(value)
    AimbotModule.Settings.FOV = value
    AimbotModule.FOVCircle.Radius = value
end

AimbotModule.SetShowFOV = function(state)
    AimbotModule.Settings.ShowFOV = state
end

print("✅ Módulo Aimbot FUNCIONAL carregado!")
return AimbotModule
