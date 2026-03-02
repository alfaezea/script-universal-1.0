--[[
	AirHub by Exunys © CC0 1.0 Universal (2023)
	https://github.com/Exunys
	Modificado com Smoothness, Fly e HITBOX EXTENDER
	LINKS CORRIGIDOS!
]]

--// Cache
local loadstring, getgenv, setclipboard, tablefind, UserInputService = loadstring, getgenv, setclipboard, table.find, game:GetService("UserInputService")

--// Loaded check
if AirHub or AirHubV2Loaded then return end

--// Environment
getgenv().AirHub = {}

--// Load Modules (LINKS CORRIGIDOS)
loadstring(game:HttpGet("https://raw.githubusercontent.com/alfaezea/script-universal-1.0/refs/heads/main/aimbot.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/AirHub/main/Modules/Wall%20Hack.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/alfaezea/script-universal-1.0/refs/heads/main/hitbox.lua"))()

--// Variables
local Library = loadstring(game:GetObjects("rbxassetid://7657867786")[1].Source)() -- Pepsi's UI Library
local Aimbot, WallHack = getgenv().AirHub.Aimbot, getgenv().AirHub.WallHack
local Parts, Fonts, TracersType = {"Head", "HumanoidRootPart", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm", "LeftFoot", "LeftLowerLeg", "UpperTorso", "LeftUpperLeg", "RightFoot", "RightLowerLeg", "LowerTorso", "RightUpperLeg"}, {"UI", "System", "Plex", "Monospace"}, {"Bottom", "Center", "Mouse"}

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

-- ========== INSTANCIAR O EXTENDER ==========
local LimbExtender = getgenv().LimbExtender or function() return {} end
local extender = LimbExtender({
    TOGGLE = HitboxSettings.ToggleKey,
    TARGET_LIMB = HitboxSettings.TargetLimb,
    LIMB_SIZE = HitboxSettings.Size,
    LIMB_TRANSPARENCY = HitboxSettings.Transparency,
    LIMB_CAN_COLLIDE = HitboxSettings.CanCollide,
    TEAM_CHECK = HitboxSettings.TeamCheck,
    FORCEFIELD_CHECK = HitboxSettings.ForceFieldCheck,
    USE_HIGHLIGHT = HitboxSettings.UseHighlight,
    DEPTH_MODE = HitboxSettings.DepthMode,
    HIGHLIGHT_FILL_COLOR = HitboxSettings.HighlightColor,
    HIGHLIGHT_FILL_TRANSPARENCY = HitboxSettings.HighlightTransparency,
    HIGHLIGHT_OUTLINE_COLOR = HitboxSettings.OutlineColor,
    HIGHLIGHT_OUTLINE_TRANSPARENCY = HitboxSettings.OutlineTransparency,
})

-- ========== SISTEMA DE FLY ==========
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

        Fly.Connections.RenderStepped = game:GetService("RunService").RenderStepped:Connect(function()
            if not Fly.Enabled then return end

            local moveDirection = Vector3.new(0, 0, 0)
            local camera = workspace.CurrentCamera

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection = moveDirection + Vector3.new(0, -1, 0) end

            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit * Fly.Speed
            end

            if Fly.BodyVelocity then Fly.BodyVelocity.Velocity = moveDirection end
            if Fly.BodyGyro then Fly.BodyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + camera.CFrame.LookVector) end
        end)

        Fly.Enabled = true
        print("✅ Fly ATIVADO")
    else
        Fly.Enabled = false
        if Fly.Connections.RenderStepped then Fly.Connections.RenderStepped:Disconnect() end
        if Fly.BodyGyro then Fly.BodyGyro:Destroy(); Fly.BodyGyro = nil end
        if Fly.BodyVelocity then Fly.BodyVelocity:Destroy(); Fly.BodyVelocity = nil end
        if humanoid then humanoid.PlatformStand = false end
        print("❌ Fly DESATIVADO")
    end
end

--// Frame
Library.UnloadCallback = function()
    ToggleFly(false)
    if extender and extender.Destroy then extender:Destroy() end
    if Aimbot and Aimbot.Functions then Aimbot.Functions:Exit() end
    if WallHack and WallHack.Functions then WallHack.Functions:Exit() end
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

--// Tabs
local AimbotTab = MainFrame:CreateTab({ Name = "Aimbot" })
local VisualsTab = MainFrame:CreateTab({ Name = "Visuals" })
local CrosshairTab = MainFrame:CreateTab({ Name = "Crosshair" })
local MiscTab = MainFrame:CreateTab({ Name = "Diversos" })
local FunctionsTab = MainFrame:CreateTab({ Name = "Functions" })

--// Aimbot Sections
local Values = AimbotTab:CreateSection({ Name = "Values" })
local Checks = AimbotTab:CreateSection({ Name = "Checks" })
local ThirdPerson = AimbotTab:CreateSection({ Name = "Third Person" })
local FOV_Values = AimbotTab:CreateSection({ Name = "Field Of View", Side = "Right" })
local FOV_Appearance = AimbotTab:CreateSection({ Name = "FOV Circle Appearance", Side = "Right" })

--// Visuals Sections
local WallHackChecks = VisualsTab:CreateSection({ Name = "Checks" })
local ESPSettings = VisualsTab:CreateSection({ Name = "ESP Settings" })
local BoxesSettings = VisualsTab:CreateSection({ Name = "Boxes Settings" })
local ChamsSettings = VisualsTab:CreateSection({ Name = "Chams Settings" })
local TracersSettings = VisualsTab:CreateSection({ Name = "Tracers Settings", Side = "Right" })
local HeadDotsSettings = VisualsTab:CreateSection({ Name = "Head Dots Settings", Side = "Right" })
local HealthBarSettings = VisualsTab:CreateSection({ Name = "Health Bar Settings", Side = "Right" })

--// Crosshair Sections
local CrosshairSettings = CrosshairTab:CreateSection({ Name = "Settings" })
local CrosshairSettings_CenterDot = CrosshairTab:CreateSection({ Name = "Center Dot Settings", Side = "Right" })

--// Diversos Sections
local FlySection = MiscTab:CreateSection({ Name = "Sistema de Voo" })
local HitboxSection = MiscTab:CreateSection({ Name = "Hitbox Extender", Side = "Right" })
local HitboxConfig = MiscTab:CreateSection({ Name = "Configurações da Hitbox", Side = "Right" })
local HighlightSection = MiscTab:CreateSection({ Name = "Configurações do Highlight", Side = "Right" })

--// Functions Sections
local FunctionsSection = FunctionsTab:CreateSection({ Name = "Functions" })

-- ========== AIMBOT ==========
Values:AddToggle({
	Name = "Enabled",
	Value = Aimbot and Aimbot.Settings.Enabled or false,
	Callback = function(New) if Aimbot then Aimbot.Settings.Enabled = New end end
})

Values:AddToggle({
	Name = "Toggle",
	Value = Aimbot and Aimbot.Settings.Toggle or false,
	Callback = function(New) if Aimbot then Aimbot.Settings.Toggle = New end end
})

Values:AddSlider({
	Name = "Smoothness",
	Value = (Aimbot and Aimbot.Settings.Smoothness) or 0.3,
	Callback = function(New) if Aimbot then Aimbot.Settings.Smoothness = New end end,
	Min = 0.1, Max = 1.0, Decimals = 2
})

Aimbot.Settings.LockPart = Parts[1]; 
Values:AddDropdown({
	Name = "Lock Part",
	Value = Parts[1],
	Callback = function(New) if Aimbot then Aimbot.Settings.LockPart = New end end,
	List = Parts,
	Nothing = "Head"
})

Values:AddTextbox({
	Name = "Hotkey",
	Value = (Aimbot and Aimbot.Settings.TriggerKey) or "MouseButton2",
	Callback = function(New) if Aimbot then Aimbot.Settings.TriggerKey = New end end
})

Values:AddSlider({
	Name = "Sensitivity",
	Value = (Aimbot and Aimbot.Settings.Sensitivity) or 0,
	Callback = function(New) if Aimbot then Aimbot.Settings.Sensitivity = New end end,
	Min = 0, Max = 1, Decimals = 2
})

Checks:AddToggle({
	Name = "Team Check",
	Value = Aimbot and Aimbot.Settings.TeamCheck or false,
	Callback = function(New) if Aimbot then Aimbot.Settings.TeamCheck = New end end
})

Checks:AddToggle({
	Name = "Wall Check",
	Value = Aimbot and Aimbot.Settings.WallCheck or false,
	Callback = function(New) if Aimbot then Aimbot.Settings.WallCheck = New end end
})

Checks:AddToggle({
	Name = "Alive Check",
	Value = Aimbot and Aimbot.Settings.AliveCheck or true,
	Callback = function(New) if Aimbot then Aimbot.Settings.AliveCheck = New end end
})

ThirdPerson:AddToggle({
	Name = "Enable Third Person",
	Value = Aimbot and Aimbot.Settings.ThirdPerson or false,
	Callback = function(New) if Aimbot then Aimbot.Settings.ThirdPerson = New end end
})

ThirdPerson:AddSlider({
	Name = "Sensitivity",
	Value = (Aimbot and Aimbot.Settings.ThirdPersonSensitivity) or 3,
	Callback = function(New) if Aimbot then Aimbot.Settings.ThirdPersonSensitivity = New end end,
	Min = 0.1, Max = 5, Decimals = 1
})

FOV_Values:AddToggle({
	Name = "Enabled",
	Value = Aimbot and Aimbot.FOVSettings.Enabled or true,
	Callback = function(New) if Aimbot then Aimbot.FOVSettings.Enabled = New end end
})

FOV_Values:AddToggle({
	Name = "Visible",
	Value = Aimbot and Aimbot.FOVSettings.Visible or true,
	Callback = function(New) if Aimbot then Aimbot.FOVSettings.Visible = New end end
})

FOV_Values:AddSlider({
	Name = "Amount",
	Value = (Aimbot and Aimbot.FOVSettings.Amount) or 90,
	Callback = function(New) if Aimbot then Aimbot.FOVSettings.Amount = New end end,
	Min = 10, Max = 300
})

FOV_Appearance:AddToggle({
	Name = "Filled",
	Value = Aimbot and Aimbot.FOVSettings.Filled or false,
	Callback = function(New) if Aimbot then Aimbot.FOVSettings.Filled = New end end
})

FOV_Appearance:AddSlider({
	Name = "Transparency",
	Value = (Aimbot and Aimbot.FOVSettings.Transparency) or 0.5,
	Callback = function(New) if Aimbot then Aimbot.FOVSettings.Transparency = New end end,
	Min = 0, Max = 1, Decimal = 1
})

FOV_Appearance:AddSlider({
	Name = "Sides",
	Value = (Aimbot and Aimbot.FOVSettings.Sides) or 60,
	Callback = function(New) if Aimbot then Aimbot.FOVSettings.Sides = New end end,
	Min = 3, Max = 60
})

FOV_Appearance:AddSlider({
	Name = "Thickness",
	Value = (Aimbot and Aimbot.FOVSettings.Thickness) or 1,
	Callback = function(New) if Aimbot then Aimbot.FOVSettings.Thickness = New end end,
	Min = 1, Max = 50
})

FOV_Appearance:AddColorpicker({
	Name = "Color",
	Value = (Aimbot and Aimbot.FOVSettings.Color) or Color3.fromRGB(255,255,255),
	Callback = function(New) if Aimbot then Aimbot.FOVSettings.Color = New end end
})

FOV_Appearance:AddColorpicker({
	Name = "Locked Color",
	Value = (Aimbot and Aimbot.FOVSettings.LockedColor) or Color3.fromRGB(255,70,70),
	Callback = function(New) if Aimbot then Aimbot.FOVSettings.LockedColor = New end end
})

-- ========== FLY ==========
FlySection:AddToggle({
	Name = "Ativar Fly",
	Value = Fly.Enabled,
	Callback = function(New) ToggleFly(New) end
})

FlySection:AddSlider({
	Name = "Velocidade",
	Value = Fly.Speed,
	Callback = function(New) Fly.Speed = New end,
	Min = 10, Max = 200, Decimals = 0
})

FlySection:AddLabel("Controles:")
FlySection:AddLabel("WASD - Andar")
FlySection:AddLabel("Espaço - Subir")
FlySection:AddLabel("Shift - Descer")

-- ========== HITBOX ==========
HitboxSection:AddToggle({
	Name = "Ativar Hitbox",
	Value = HitboxSettings.Enabled,
	Callback = function(New)
		HitboxSettings.Enabled = New
		if New and extender and extender.Start then
			extender:Start()
		elseif extender and extender.Stop then
			extender:Stop()
		end
	end
})

HitboxSection:AddDropdown({
	Name = "Tecla Atalho",
	Value = HitboxSettings.ToggleKey,
	Callback = function(New) 
		HitboxSettings.ToggleKey = New
		if extender and extender.Set then extender:Set("TOGGLE", New) end
	end,
	List = {"L", "K", "J", "H", "G", "F", "E", "Q"},
	Nothing = "L"
})

HitboxSection:AddDropdown({
	Name = "Parte do Corpo",
	Value = HitboxSettings.TargetLimb,
	Callback = function(New) 
		HitboxSettings.TargetLimb = New
		if extender and extender.Set then extender:Set("TARGET_LIMB", New) end
	end,
	List = {"Head", "HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso"},
	Nothing = "HumanoidRootPart"
})

HitboxConfig:AddSlider({
	Name = "Tamanho",
	Value = HitboxSettings.Size,
	Callback = function(New) 
		HitboxSettings.Size = New
		if extender and extender.Set then extender:Set("LIMB_SIZE", New) end
	end,
	Min = 5, Max = 30, Decimals = 1
})

HitboxConfig:AddSlider({
	Name = "Transparência",
	Value = HitboxSettings.Transparency,
	Callback = function(New) 
		HitboxSettings.Transparency = New
		if extender and extender.Set then extender:Set("LIMB_TRANSPARENCY", New) end
	end,
	Min = 0, Max = 1, Decimals = 2
})

HitboxConfig:AddToggle({
	Name = "Pode Colidir",
	Value = HitboxSettings.CanCollide,
	Callback = function(New) 
		HitboxSettings.CanCollide = New
		if extender and extender.Set then extender:Set("LIMB_CAN_COLLIDE", New) end
	end
})

HitboxConfig:AddToggle({
	Name = "Team Check",
	Value = HitboxSettings.TeamCheck,
	Callback = function(New) 
		HitboxSettings.TeamCheck = New
		if extender and extender.Set then extender:Set("TEAM_CHECK", New) end
	end
})

HitboxConfig:AddToggle({
	Name = "ForceField Check",
	Value = HitboxSettings.ForceFieldCheck,
	Callback = function(New) 
		HitboxSettings.ForceFieldCheck = New
		if extender and extender.Set then extender:Set("FORCEFIELD_CHECK", New) end
	end
})

HighlightSection:AddToggle({
	Name = "Usar Highlight",
	Value = HitboxSettings.UseHighlight,
	Callback = function(New) 
		HitboxSettings.UseHighlight = New
		if extender and extender.Set then extender:Set("USE_HIGHLIGHT", New) end
	end
})

HighlightSection:AddDropdown({
	Name = "Modo Profundidade",
	Value = HitboxSettings.DepthMode,
	Callback = function(New) 
		HitboxSettings.DepthMode = New
		if extender and extender.Set then extender:Set("DEPTH_MODE", New) end
	end,
	List = {"AlwaysOnTop", "Occluded", "AlwaysOnBottom"},
	Nothing = "AlwaysOnTop"
})

HighlightSection:AddColorpicker({
	Name = "Cor do Fill",
	Value = HitboxSettings.HighlightColor,
	Callback = function(New) 
		HitboxSettings.HighlightColor = New
		if extender and extender.Set then extender:Set("HIGHLIGHT_FILL_COLOR", New) end
	end
})

HighlightSection:AddSlider({
	Name = "Transparência Fill",
	Value = HitboxSettings.HighlightTransparency,
	Callback = function(New) 
		HitboxSettings.HighlightTransparency = New
		if extender and extender.Set then extender:Set("HIGHLIGHT_FILL_TRANSPARENCY", New) end
	end,
	Min = 0, Max = 1, Decimals = 2
})

HighlightSection:AddColorpicker({
	Name = "Cor do Outline",
	Value = HitboxSettings.OutlineColor,
	Callback = function(New) 
		HitboxSettings.OutlineColor = New
		if extender and extender.Set then extender:Set("HIGHLIGHT_OUTLINE_COLOR", New) end
	end
})

HighlightSection:AddSlider({
	Name = "Transparência Outline",
	Value = HitboxSettings.OutlineTransparency,
	Callback = function(New) 
		HitboxSettings.OutlineTransparency = New
		if extender and extender.Set then extender:Set("HIGHLIGHT_OUTLINE_TRANSPARENCY", New) end
	end,
	Min = 0, Max = 1, Decimals = 2
})

-- ========== FUNCTIONS ==========
FunctionsSection:AddButton({
	Name = "Reset Settings",
	Callback = function()
		if Aimbot and Aimbot.Functions then Aimbot.Functions:ResetSettings() end
		if WallHack and WallHack.Functions then WallHack.Functions:ResetSettings() end
		Library.ResetAll()
	end
})

FunctionsSection:AddButton({
	Name = "Restart",
	Callback = function()
		if Aimbot and Aimbot.Functions then Aimbot.Functions:Restart() end
		if WallHack and WallHack.Functions then WallHack.Functions:Restart() end
	end
})

FunctionsSection:AddButton({
	Name = "Exit",
	Callback = Library.Unload,
})

FunctionsSection:AddButton({
	Name = "Copy Script Page",
	Callback = function() setclipboard("https://github.com/Exunys/AirHub") end
})

print("✅ AirHub carregado com SMOOTHNESS, FLY e HITBOX!")
print("🎯 Smoothness controla a velocidade da mira (0.1 = rápido, 1.0 = suave)")
print("💪 Hitbox Extender adicionado na aba Diversos!")
