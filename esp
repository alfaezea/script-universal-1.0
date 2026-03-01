--[[
    ESP MODULE - VERSÃO COMPLETA
    Baseado em Exunys AirHub
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

getgenv().ESPModule = {
    Settings = {
        Enabled = false,
        TeamCheck = true,
        AliveCheck = true,
        ShowBox = true,
        BoxColor = Color3.fromRGB(255, 255, 255),
        ShowName = true,
        TextColor = Color3.fromRGB(255, 255, 255),
        ShowDistance = true,
        ShowTracers = false,
        TracerColor = Color3.fromRGB(255, 255, 255),
        ShowHeadDot = false,
        HeadDotColor = Color3.fromRGB(255, 255, 255),
    },
    Drawings = {},
    Connections = {}
}

local E = getgenv().ESPModule

local function WorldToScreen(pos)
    local v, onScreen = Camera:WorldToViewportPoint(pos)
    return Vector2.new(v.X, v.Y), onScreen
end

local function GetPlayerDrawings(player)
    if not E.Drawings[player] then
        E.Drawings[player] = {
            Box = Drawing.new("Square"),
            Name = Drawing.new("Text"),
            Distance = Drawing.new("Text"),
            Tracer = Drawing.new("Line"),
            HeadDot = Drawing.new("Circle"),
        }
    end
    return E.Drawings[player]
end

E.Connections.RenderStepped = RunService.RenderStepped:Connect(function()
    if not E.Settings.Enabled then
        for _, drawings in pairs(E.Drawings) do
            for _, d in pairs(drawings) do d.Visible = false end
        end
        return
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and 
           player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("HumanoidRootPart") then
            
            local humanoid = player.Character.Humanoid
            local head = player.Character.Head
            local root = player.Character.HumanoidRootPart
            
            if E.Settings.AliveCheck and humanoid.Health <= 0 then goto skip end
            if E.Settings.TeamCheck and player.TeamColor == LocalPlayer.TeamColor then goto skip end
            
            local headPos, onScreen = WorldToScreen(head.Position + Vector3.new(0, 0.5, 0))
            local rootPos = WorldToScreen(root.Position - Vector3.new(0, 3, 0))
            
            if onScreen then
                local d = GetPlayerDrawings(player)
                local boxHeight = math.abs(headPos.Y - rootPos.Y)
                local boxWidth = boxHeight * 0.6
                local boxTop = Vector2.new(rootPos.X - boxWidth / 2, rootPos.Y - boxHeight)
                
                -- Box
                if E.Settings.ShowBox then
                    d.Box.Visible = true
                    d.Box.Size = Vector2.new(boxWidth, boxHeight)
                    d.Box.Position = boxTop
                    d.Box.Color = E.Settings.BoxColor
                    d.Box.Thickness = 1.5
                    d.Box.Filled = false
                else d.Box.Visible = false end
                
                -- Nome
                if E.Settings.ShowName then
                    d.Name.Visible = true
                    d.Name.Text = player.Name
                    d.Name.Size = 14
                    d.Name.Position = Vector2.new(headPos.X, headPos.Y - 25)
                    d.Name.Color = E.Settings.TextColor
                    d.Name.Center = true
                    d.Name.Outline = true
                else d.Name.Visible = false end
                
                -- Distância
                if E.Settings.ShowDistance then
                    local dist = math.floor((root.Position - Camera.CFrame.Position).Magnitude)
                    d.Distance.Visible = true
                    d.Distance.Text = dist.."m"
                    d.Distance.Size = 12
                    d.Distance.Position = Vector2.new(headPos.X, headPos.Y - 10)
                    d.Distance.Color = E.Settings.TextColor
                    d.Distance.Center = true
                    d.Distance.Outline = true
                else d.Distance.Visible = false end
                
                -- Tracer
                if E.Settings.ShowTracers then
                    d.Tracer.Visible = true
                    d.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    d.Tracer.To = Vector2.new(rootPos.X, rootPos.Y)
                    d.Tracer.Color = E.Settings.TracerColor
                    d.Tracer.Thickness = 1
                else d.Tracer.Visible = false end
                
                -- Head Dot
                if E.Settings.ShowHeadDot then
                    d.HeadDot.Visible = true
                    d.HeadDot.Position = headPos
                    d.HeadDot.Radius = 3
                    d.HeadDot.Color = E.Settings.HeadDotColor
                    d.HeadDot.Filled = true
                else d.HeadDot.Visible = false end
            else
                local d = E.Drawings[player]
                if d then
                    for _, drawing in pairs(d) do drawing.Visible = false end
                end
            end
            ::skip::
        end
    end
end)

-- Funções públicas
E.SetEnabled = function(state) E.Settings.Enabled = state end
E.SetTeamCheck = function(state) E.Settings.TeamCheck = state end
E.SetBox = function(state) E.Settings.ShowBox = state end
E.SetName = function(state) E.Settings.ShowName = state end
E.SetDistance = function(state) E.Settings.ShowDistance = state end
E.SetTracers = function(state) E.Settings.ShowTracers = state end
E.SetHeadDot = function(state) E.Settings.ShowHeadDot = state end
E.SetBoxColor = function(color) E.Settings.BoxColor = color end
E.SetTextColor = function(color) E.Settings.TextColor = color end

E.Exit = function()
    for _, conn in pairs(E.Connections) do conn:Disconnect() end
    for _, drawings in pairs(E.Drawings) do
        for _, d in pairs(drawings) do d:Remove() end
    end
    getgenv().ESPModule = nil
end

print("✅ Módulo ESP carregado!")
