--[[
    AIMBOT MODULE - VERSÃO COMPLETA
    Baseado em Exunys AirHub
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local AimbotModule = {
    Settings = {
        Enabled = false,
        TeamCheck = true,
        AliveCheck = true,
        WallCheck = true,
        Sensitivity = 0.15,
        Smoothness = 0.3,
        LockPart = "Head",
        FOV = 120,
        ShowFOV = true,
        FOVColor = Color3.fromRGB(0, 255, 255),
        FOVLockedColor = Color3.fromRGB(255, 100, 100),
    },
    Running = false,
    CurrentTarget = nil,
    Connections = {},
    FOVCircle = Drawing.new("Circle")
}

local A = AimbotModule

-- Configurar FOV
A.FOVCircle.Visible = false
A.FOVCircle.Thickness = 1.5
A.FOVCircle.Filled = false
A.FOVCircle.NumSides = 64
A.FOVCircle.Radius = A.Settings.FOV
A.FOVCircle.Transparency = 0.7

local function GetMousePos()
    return Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
end

local function WorldToScreen(pos)
    local v, onScreen = Camera:WorldToViewportPoint(pos)
    return Vector2.new(v.X, v.Y), onScreen
end

local function IsVisible(targetPart)
    if not A.Settings.WallCheck then return true end
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin).Unit
    local ray = Ray.new(origin, direction * 1000)
    local hit = workspace:FindPartOnRay(ray, LocalPlayer.Character)
    if hit then return hit:IsDescendantOf(targetPart.Parent) end
    return false
end

local function GetClosestPlayer()
    local closest, closestDist = nil, A.Settings.FOV
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(A.Settings.LockPart) and player.Character:FindFirstChildOfClass("Humanoid") then
            local humanoid = player.Character.Humanoid
            local targetPart = player.Character[A.Settings.LockPart]
            
            if A.Settings.TeamCheck and player.TeamColor == LocalPlayer.TeamColor then goto continue end
            if A.Settings.AliveCheck and humanoid.Health <= 0 then goto continue end
            if A.Settings.WallCheck and not IsVisible(targetPart) then goto continue end
            
            local screenPos, onScreen = WorldToScreen(targetPart.Position)
            if onScreen then
                local dist = (GetMousePos() - screenPos).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = player
                end
            end
            ::continue::
        end
    end
    return closest
end

A.Connections.RenderStepped = RunService.RenderStepped:Connect(function()
    if A.Settings.Enabled and A.Settings.ShowFOV then
        A.FOVCircle.Position = GetMousePos()
        A.FOVCircle.Radius = A.Settings.FOV
        A.FOVCircle.Color = A.CurrentTarget and A.Settings.FOVLockedColor or A.Settings.FOVColor
        A.FOVCircle.Visible = true
    else
        A.FOVCircle.Visible = false
    end
    
    if A.Settings.Enabled and A.Running then
        A.CurrentTarget = GetClosestPlayer()
        if A.CurrentTarget and A.CurrentTarget.Character then
            local targetPart = A.CurrentTarget.Character[A.Settings.LockPart]
            local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, A.Settings.Smoothness)
        end
    end
end)

A.Connections.InputBegan = UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        A.Running = true
    end
end)

A.Connections.InputEnded = UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        A.Running = false
        A.CurrentTarget = nil
    end
end)

-- Funções públicas
A.SetEnabled = function(state) A.Settings.Enabled = state end
A.SetTeamCheck = function(state) A.Settings.TeamCheck = state end
A.SetWallCheck = function(state) A.Settings.WallCheck = state end
A.SetFOV = function(value) A.Settings.FOV = value end
A.SetSmoothness = function(value) A.Settings.Smoothness = value end
A.SetLockPart = function(part) A.Settings.LockPart = part end
A.SetShowFOV = function(state) A.Settings.ShowFOV = state end

A.Exit = function()
    for _, conn in pairs(A.Connections) do conn:Disconnect() end
    A.FOVCircle:Remove()
end

print("✅ Módulo Aimbot carregado!")

-- 🔥 LINHA MÁGICA: RETORNA O MÓDULO
return AimbotModule
