--[[
	AirHub by Exunys © CC0 1.0 Universal (2023)
	https://github.com/Exunys
	Modificado com aba "Diversos" e FLY FUNCIONAL
]]

--// Cache
local loadstring, getgenv, setclipboard, tablefind, UserInputService = loadstring, getgenv, setclipboard, table.find, game:GetService("UserInputService")

--// Loaded check
if AirHub or AirHubV2Loaded then
    return
end

--// Environment
getgenv().AirHub = {}

--// Load Modules
loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/AirHub/main/Modules/Aimbot.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/AirHub/main/Modules/Wall%20Hack.lua"))()

--// Variables
local Library = loadstring(game:GetObjects("rbxassetid://7657867786")[1].Source)() -- Pepsi's UI Library
local Aimbot, WallHack = getgenv().AirHub.Aimbot, getgenv().AirHub.WallHack
local Parts, Fonts, TracersType = {"Head", "HumanoidRootPart", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm", "LeftFoot", "LeftLowerLeg", "UpperTorso", "LeftUpperLeg", "RightFoot", "RightLowerLeg", "LowerTorso", "RightUpperLeg"}, {"UI", "System", "Plex", "Monospace"}, {"Bottom", "Center", "Mouse"}

-- ========== SISTEMA DE FLY FUNCIONAL ==========
local Fly = {
    Enabled = false,
    Speed = 50,
    BodyGyro = nil,
    BodyVelocity = nil,
    Connections = {}
}

local function ToggleFly(state)
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    if state then
        -- Ativar fly
        humanoid.PlatformStand = true
        
        -- Criar BodyGyro para controle de rotação
        Fly.BodyGyro = Instance.new("BodyGyro")
        Fly.BodyGyro.P = 9e4
        Fly.BodyGyro.MaxTorque = Vector3.new(9e4, 9e4, 9e4)
        Fly.BodyGyro.CFrame = rootPart.CFrame
        Fly.BodyGyro.Parent = rootPart
        
        -- Criar BodyVelocity para movimento
        Fly.BodyVelocity = Instance.new("BodyVelocity")
        Fly.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        Fly.BodyVelocity.MaxForce = Vector3.new(9e4, 9e4, 9e4)
        Fly.BodyVelocity.Parent = rootPart
        
        -- Conectar ao RenderStepped para movimento contínuo
        Fly.Connections.RenderStepped = game:GetService("RunService").RenderStepped:Connect(function()
            if not Fly.Enabled then return end
            
            local moveDirection = Vector3.new(0, 0, 0)
            local camera = workspace.CurrentCamera
            
            -- WASD para movimento
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + camera.CFrame.RightVector
            end
            -- Espaço para subir
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + Vector3.new(0, 1, 0)
            end
            -- Shift para descer
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDirection = moveDirection + Vector3.new(0, -1, 0)
            end
            
            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit * Fly.Speed
            end
            
            if Fly.BodyVelocity then
                Fly.BodyVelocity.Velocity = moveDirection
            end
            if Fly.BodyGyro then
                Fly.BodyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + camera.CFrame.LookVector)
            end
        end)
        
        Fly.Enabled = true
        print("✅ Fly ATIVADO")
    else
        -- Desativar fly
        Fly.Enabled = false
        if Fly.Connections.RenderStepped then
            Fly.Connections.RenderStepped:Disconnect()
        end
        if Fly.BodyGyro then
            Fly.BodyGyro:Destroy()
            Fly.BodyGyro = nil
        end
        if Fly.BodyVelocity then
            Fly.BodyVelocity:Destroy()
            Fly.BodyVelocity = nil
        end
        if humanoid then
            humanoid.PlatformStand = false
        end
        print("❌ Fly DESATIVADO")
    end
end

--// Frame
Library.UnloadCallback = function()
    ToggleFly(false) -- Desativa fly ao fechar
    Aimbot.Functions:Exit()
    WallHack.Functions:Exit()
    getgenv().AirHub = nil
end

local MainFrame = Library:CreateWindow({
	Name = "AirHub",
	Themeable = {
		Image = "7059346386",
		Info = "Made by Exunys\nPowered by Pepsi's UI Library",
		Credit = false
	},
	Background = "",
	Theme = [[{"__Designer.Colors.topGradient":"3F0C64","__Designer.Colors.section":"C259FB","__Designer.Colors.hoveredOptionBottom":"4819B4","__Designer.Background.ImageAssetID":"rbxassetid://4427304036","__Designer.Colors.selectedOption":"4E149C","__Designer.Colors.unselectedOption":"482271","__Designer.Files.WorkspaceFile":"AirHub","__Designer.Colors.unhoveredOptionTop":"310269","__Designer.Colors.outerBorder":"391D57","__Designer.Background.ImageColor":"69009C","__Designer.Colors.tabText":"B9B9B9","__Designer.Colors.elementBorder":"160B24","__Designer.Background.ImageTransparency":100,"__Designer.Colors.background":"1E1237","__Designer.Colors.innerBorder":"531E79","__Designer.Colors.bottomGradient":"361A60","__Designer.Colors.sectionBackground":"21002C","__Designer.Colors.hoveredOptionTop":"6B10F9","__Designer.Colors.otherElementText":"7B44A8","__Designer.Colors.main":"AB26FF","__Designer.Colors.elementText":"9F7DB5","__Designer.Colors.unhoveredOptionBottom":"3E0088","__Designer.Background.UseBackgroundImage":false}]]
})

--// Tabs (ADICIONADA ABA DIVERSOS)
local AimbotTab = MainFrame:CreateTab({ Name = "Aimbot" })
local VisualsTab = MainFrame:CreateTab({ Name = "Visuals" })
local CrosshairTab = MainFrame:CreateTab({ Name = "Crosshair" })
local MiscTab = MainFrame:CreateTab({ Name = "Diversos" }) -- NOVA ABA
local FunctionsTab = MainFrame:CreateTab({ Name = "Functions" })

--// Aimbot Sections (código existente...)
local Values = AimbotTab:CreateSection({ Name = "Values" })
local Checks = AimbotTab:CreateSection({ Name = "Checks" })
local ThirdPerson = AimbotTab:CreateSection({ Name = "Third Person" })
local FOV_Values = AimbotTab:CreateSection({ Name = "Field Of View", Side = "Right" })
local FOV_Appearance = AimbotTab:CreateSection({ Name = "FOV Circle Appearance", Side = "Right" })

--// Visuals Sections (código existente...)
local WallHackChecks = VisualsTab:CreateSection({ Name = "Checks" })
local ESPSettings = VisualsTab:CreateSection({ Name = "ESP Settings" })
local BoxesSettings = VisualsTab:CreateSection({ Name = "Boxes Settings" })
local ChamsSettings = VisualsTab:CreateSection({ Name = "Chams Settings" })
local TracersSettings = VisualsTab:CreateSection({ Name = "Tracers Settings", Side = "Right" })
local HeadDotsSettings = VisualsTab:CreateSection({ Name = "Head Dots Settings", Side = "Right" })
local HealthBarSettings = VisualsTab:CreateSection({ Name = "Health Bar Settings", Side = "Right" })

--// Crosshair Sections (código existente...)
local CrosshairSettings = CrosshairTab:CreateSection({ Name = "Settings" })
local CrosshairSettings_CenterDot = CrosshairTab:CreateSection({ Name = "Center Dot Settings", Side = "Right" })

--// DIVERSOS SECTION (NOVA)
local FlySection = MiscTab:CreateSection({ Name = "Sistema de Voo" })
local SpeedSection = MiscTab:CreateSection({ Name = "Configurações", Side = "Right" })

--// Functions Sections (código existente...)
local FunctionsSection = FunctionsTab:CreateSection({ Name = "Functions" })

-- ========== CÓDIGO EXISTENTE DO AIMBOT ==========
-- (todo o código que já estava aqui para Aimbot, Visuals, Crosshair)

--// Aimbot Values
Values:AddToggle({
	Name = "Enabled",
	Value = Aimbot.Settings.Enabled,
	Callback = function(New) Aimbot.Settings.Enabled = New end
}).Default = Aimbot.Settings.Enabled

Values:AddToggle({
	Name = "Toggle",
	Value = Aimbot.Settings.Toggle,
	Callback = function(New) Aimbot.Settings.Toggle = New end
}).Default = Aimbot.Settings.Toggle

Aimbot.Settings.LockPart = Parts[1]; Values:AddDropdown({
	Name = "Lock Part",
	Value = Parts[1],
	Callback = function(New) Aimbot.Settings.LockPart = New end,
	List = Parts,
	Nothing = "Head"
}).Default = Parts[1]

Values:AddTextbox({
	Name = "Hotkey",
	Value = Aimbot.Settings.TriggerKey,
	Callback = function(New) Aimbot.Settings.TriggerKey = New end
}).Default = Aimbot.Settings.TriggerKey

Values:AddSlider({
	Name = "Sensitivity",
	Value = Aimbot.Settings.Sensitivity,
	Callback = function(New) Aimbot.Settings.Sensitivity = New end,
	Min = 0, Max = 1, Decimals = 2
}).Default = Aimbot.Settings.Sensitivity

--// Aimbot Checks
Checks:AddToggle({
	Name = "Team Check",
	Value = Aimbot.Settings.TeamCheck,
	Callback = function(New) Aimbot.Settings.TeamCheck = New end
}).Default = Aimbot.Settings.TeamCheck

Checks:AddToggle({
	Name = "Wall Check",
	Value = Aimbot.Settings.WallCheck,
	Callback = function(New) Aimbot.Settings.WallCheck = New end
}).Default = Aimbot.Settings.WallCheck

Checks:AddToggle({
	Name = "Alive Check",
	Value = Aimbot.Settings.AliveCheck,
	Callback = function(New) Aimbot.Settings.AliveCheck = New end
}).Default = Aimbot.Settings.AliveCheck

--// Aimbot ThirdPerson
ThirdPerson:AddToggle({
	Name = "Enable Third Person",
	Value = Aimbot.Settings.ThirdPerson,
	Callback = function(New) Aimbot.Settings.ThirdPerson = New end
}).Default = Aimbot.Settings.ThirdPerson

ThirdPerson:AddSlider({
	Name = "Sensitivity",
	Value = Aimbot.Settings.ThirdPersonSensitivity,
	Callback = function(New) Aimbot.Settings.ThirdPersonSensitivity = New end,
	Min = 0.1, Max = 5, Decimals = 1
}).Default = Aimbot.Settings.ThirdPersonSensitivity

--// FOV Settings Values
FOV_Values:AddToggle({
	Name = "Enabled",
	Value = Aimbot.FOVSettings.Enabled,
	Callback = function(New) Aimbot.FOVSettings.Enabled = New end
}).Default = Aimbot.FOVSettings.Enabled

FOV_Values:AddToggle({
	Name = "Visible",
	Value = Aimbot.FOVSettings.Visible,
	Callback = function(New) Aimbot.FOVSettings.Visible = New end
}).Default = Aimbot.FOVSettings.Visible

FOV_Values:AddSlider({
	Name = "Amount",
	Value = Aimbot.FOVSettings.Amount,
	Callback = function(New) Aimbot.FOVSettings.Amount = New end,
	Min = 10, Max = 300
}).Default = Aimbot.FOVSettings.Amount

--// FOV Settings Appearance
FOV_Appearance:AddToggle({
	Name = "Filled",
	Value = Aimbot.FOVSettings.Filled,
	Callback = function(New) Aimbot.FOVSettings.Filled = New end
}).Default = Aimbot.FOVSettings.Filled

FOV_Appearance:AddSlider({
	Name = "Transparency",
	Value = Aimbot.FOVSettings.Transparency,
	Callback = function(New) Aimbot.FOVSettings.Transparency = New end,
	Min = 0, Max = 1, Decimal = 1
}).Default = Aimbot.FOVSettings.Transparency

FOV_Appearance:AddSlider({
	Name = "Sides",
	Value = Aimbot.FOVSettings.Sides,
	Callback = function(New) Aimbot.FOVSettings.Sides = New end,
	Min = 3, Max = 60
}).Default = Aimbot.FOVSettings.Sides

FOV_Appearance:AddSlider({
	Name = "Thickness",
	Value = Aimbot.FOVSettings.Thickness,
	Callback = function(New) Aimbot.FOVSettings.Thickness = New end,
	Min = 1, Max = 50
}).Default = Aimbot.FOVSettings.Thickness

FOV_Appearance:AddColorpicker({
	Name = "Color",
	Value = Aimbot.FOVSettings.Color,
	Callback = function(New) Aimbot.FOVSettings.Color = New end
}).Default = Aimbot.FOVSettings.Color

FOV_Appearance:AddColorpicker({
	Name = "Locked Color",
	Value = Aimbot.FOVSettings.LockedColor,
	Callback = function(New) Aimbot.FOVSettings.LockedColor = New end
}).Default = Aimbot.FOVSettings.LockedColor

-- ========== NOVA SEÇÃO: DIVERSOS / FLY ==========

--// Toggle do Fly
FlySection:AddToggle({
	Name = "Ativar Fly",
	Value = Fly.Enabled,
	Callback = function(New)
		ToggleFly(New)
	end
})

--// Slider de Velocidade
SpeedSection:AddSlider({
	Name = "Velocidade do Fly",
	Value = Fly.Speed,
	Callback = function(New)
		Fly.Speed = New
	end,
	Min = 10,
	Max = 200,
	Decimals = 0
})

--// Informações de controle
SpeedSection:AddLabel("Controles:")
SpeedSection:AddLabel("WASD - Movimento")
SpeedSection:AddLabel("Espaço - Subir")
SpeedSection:AddLabel("Shift - Descer")

-- ========== CÓDIGO EXISTENTE DO WALLHACK ==========
-- (todo o código que já estava para WallHack, omitido por brevidade mas deve ser mantido)

--// Wall Hack Settings (mantenha todo o código original aqui)
WallHackChecks:AddToggle({
	Name = "Enabled",
	Value = WallHack.Settings.Enabled,
	Callback = function(New) WallHack.Settings.Enabled = New end
}).Default = WallHack.Settings.Enabled

-- ... (continue com todas as configurações originais do WallHack)

-- ========== FUNÇÕES EXISTENTES ==========
FunctionsSection:AddButton({
	Name = "Reset Settings",
	Callback = function()
		Aimbot.Functions:ResetSettings()
		WallHack.Functions:ResetSettings()
		Library.ResetAll()
	end
})

FunctionsSection:AddButton({
	Name = "Restart",
	Callback = function()
		Aimbot.Functions:Restart()
		WallHack.Functions:Restart()
	end
})

FunctionsSection:AddButton({
	Name = "Exit",
	Callback = Library.Unload,
})

FunctionsSection:AddButton({
	Name = "Copy Script Page",
	Callback = function()
		setclipboard("https://github.com/Exunys/AirHub")
	end
})

--// AirHub V2 Prompt (opcional, pode remover se quiser)
do
	local Aux = Instance.new("BindableFunction")
	Aux.OnInvoke = function(Answer)
		if Answer == "No" then return end
		Library.Unload()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/AirHub-V2/main/src/Main.lua"))()
	end
	game.StarterGui:SetCore("SendNotification", {
		Title = "🎆 AirHub V2 🎆",
		Text = "Would you like to use the new AirHub V2 script?",
		Button1 = "Yes",
		Button2 = "No",
		Duration = 1 / 0,
		Icon = "rbxassetid://6238537240",
		Callback = Aux
	})
end

print("✅ AirHub carregado com aba DIVERSOS e FLY FUNCIONAL!")
print("🦅 Use WASD + Espaço/Shift para voar!")
