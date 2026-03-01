--[[
    ESP MODULE - VERSÃO FUNCIONAL
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ESPModule = {
    Enabled = false,
    Settings = {
        TeamCheck = true,
        ShowName = true,
        TextColor = Color3.fromRGB(255, 255, 255)
    },
    Drawings = {}
}

local function WorldToScreen(pos)
    local v, onScreen = Camera:WorldToViewportPoint(pos)
    return Vector2.new(v.X, v.Y), onScreen
end

-- Loop principal
RunService.RenderStepped:Connect(function()
    -- Só executa se ativado
    if not ESPModule.Enabled then
        -- Esconde todos os drawings
        for _, drawings in pairs(ESPModule.Drawings) do
            for _, d in pairs(drawings) do
                d.Visible = false
            end
        end
        return
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local headPos, onScreen = WorldToScreen(head.Position + Vector3.new(0, 0.5, 0))
            
            if onScreen then
                -- Criar drawing se não existir
                if not ESPModule.Drawings[player] then
                    ESPModule.Drawings[player] = {
                        Name = Drawing.new("Text")
                    }
                    local nameText = ESPModule.Drawings[player].Name
                    nameText.Size = 14
                    nameText.Center = true
                    nameText.Outline = true
                    nameText.OutlineColor = Color3.fromRGB(0, 0, 0)
                end
                
                -- Atualizar e mostrar
                local nameText = ESPModule.Drawings[player].Name
                nameText.Visible = true
                nameText.Text = player.Name
                nameText.Position = Vector2.new(headPos.X, headPos.Y - 20)
                nameText.Color = ESPModule.Settings.TextColor
            else
                -- Esconder se não estiver na tela
                if ESPModule.Drawings[player] then
                    ESPModule.Drawings[player].Name.Visible = false
                end
            end
        end
    end
end)

-- Funções para GUI
ESPModule.SetEnabled = function(state)
    ESPModule.Enabled = state
    print("👁️ ESP SetEnabled:", state)
end

print("✅ Módulo ESP FUNCIONAL carregado!")
return ESPModule
