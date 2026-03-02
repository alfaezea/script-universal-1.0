--[[
	AirHub by Exunys © CC0 1.0 Universal (2023)
	https://github.com/Exunys
	Modificado com Smoothness, Fly e HITBOX EXTENDER
	VERSÃO COM PROTEÇÃO DE ERROS - CORRIGIDA!
]]

--// Cache
local loadstring, getgenv, setclipboard, tablefind, UserInputService = loadstring, getgenv, setclipboard, table.find, game:GetService("UserInputService")

--// Loaded check
if AirHub or AirHubV2Loaded then return end

--// Environment
getgenv().AirHub = {}

--// Função segura para carregar módulos
local function safeLoad(url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if success then
        print("✅ Módulo carregado: " .. url)
        return result
    else
        warn("❌ Falha ao carregar: " .. url .. "\n" .. tostring(result))
        return nil
    end
end

--// Load Modules com proteção
safeLoad("https://raw.githubusercontent.com/alfaezea/script-universal-1.0/refs/heads/main/aimbot.lua")
safeLoad("https://raw.githubusercontent.com/alfaezea/script-universal-1.0/refs/heads/main/esp.lua")
safeLoad("https://raw.githubusercontent.com/alfaezea/script-universal-1.0/refs/heads/main/hitbox.lua")

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

--// Visuals Sections (WALLHACK - COMPLETO)
local WallHackChecks = VisualsTab:CreateSection({ Name = "Checks" })
local ESPSettings = VisualsTab:CreateSection({ Name = "ESP Settings" })
local BoxesSettings = VisualsTab:CreateSection({ Name = "Boxes Settings" })
local ChamsSettings = VisualsTab:CreateSection({ Name = "Chams Settings" })
local TracersSettings = VisualsTab:CreateSection({ Name = "Tracers Settings", Side = "Right" })
local HeadDotsSettings = VisualsTab:CreateSection({ Name = "Head Dots Settings", Side = "Right" })
local HealthBarSettings = VisualsTab:CreateSection({ Name = "Health Bar Settings", Side = "Right" })

--// Crosshair Sections (COMPLETO)
local CrosshairSettings = CrosshairTab:CreateSection({ Name = "Settings" })
local CrosshairSettings_CenterDot = CrosshairTab:CreateSection({ Name = "Center Dot Settings", Side = "Right" })

--// Diversos Sections (FLY + HITBOX)
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

if Aimbot then Aimbot.Settings.LockPart = Parts[1]; end
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

-- ========== WALLHACK (ESP) COMPLETO ==========
WallHackChecks:AddToggle({
	Name = "Enabled",
	Value = WallHack and WallHack.Settings.Enabled or false,
	Callback = function(New) if WallHack then WallHack.Settings.Enabled = New end end
})

WallHackChecks:AddToggle({
	Name = "Team Check",
	Value = WallHack and WallHack.Settings.TeamCheck or false,
	Callback = function(New) if WallHack then WallHack.Settings.TeamCheck = New end end
})

WallHackChecks:AddToggle({
	Name = "Alive Check",
	Value = WallHack and WallHack.Settings.AliveCheck or true,
	Callback = function(New) if WallHack then WallHack.Settings.AliveCheck = New end end
})

ESPSettings:AddToggle({
	Name = "Enabled",
	Value = WallHack and WallHack.Visuals.ESPSettings.Enabled or true,
	Callback = function(New) if WallHack then WallHack.Visuals.ESPSettings.Enabled = New end end
})

ESPSettings:AddToggle({
	Name = "Outline",
	Value = WallHack and WallHack.Visuals.ESPSettings.Outline or true,
	Callback = function(New) if WallHack then WallHack.Visuals.ESPSettings.Outline = New end end
})

ESPSettings:AddToggle({
	Name = "Display Distance",
	Value = WallHack and WallHack.Visuals.ESPSettings.DisplayDistance or true,
	Callback = function(New) if WallHack then WallHack.Visuals.ESPSettings.DisplayDistance = New end end
})

ESPSettings:AddToggle({
	Name = "Display Health",
	Value = WallHack and WallHack.Visuals.ESPSettings.DisplayHealth or true,
	Callback = function(New) if WallHack then WallHack.Visuals.ESPSettings.DisplayHealth = New end end
})

ESPSettings:AddToggle({
	Name = "Display Name",
	Value = WallHack and WallHack.Visuals.ESPSettings.DisplayName or true,
	Callback = function(New) if WallHack then WallHack.Visuals.ESPSettings.DisplayName = New end end
})

ESPSettings:AddSlider({
	Name = "Offset",
	Value = (WallHack and WallHack.Visuals.ESPSettings.Offset) or 20,
	Callback = function(New) if WallHack then WallHack.Visuals.ESPSettings.Offset = New end end,
	Min = -30, Max = 30
})

ESPSettings:AddColorpicker({
	Name = "Text Color",
	Value = (WallHack and WallHack.Visuals.ESPSettings.TextColor) or Color3.fromRGB(255,255,255),
	Callback = function(New) if WallHack then WallHack.Visuals.ESPSettings.TextColor = New end end
})

ESPSettings:AddColorpicker({
	Name = "Outline Color",
	Value = (WallHack and WallHack.Visuals.ESPSettings.OutlineColor) or Color3.fromRGB(0,0,0),
	Callback = function(New) if WallHack then WallHack.Visuals.ESPSettings.OutlineColor = New end end
})

ESPSettings:AddSlider({
	Name = "Text Transparency",
	Value = (WallHack and WallHack.Visuals.ESPSettings.TextTransparency) or 0.7,
	Callback = function(New) if WallHack then WallHack.Visuals.ESPSettings.TextTransparency = New end end,
	Min = 0, Max = 1, Decimals = 2
})

ESPSettings:AddSlider({
	Name = "Text Size",
	Value = (WallHack and WallHack.Visuals.ESPSettings.TextSize) or 14,
	Callback = function(New) if WallHack then WallHack.Visuals.ESPSettings.TextSize = New end end,
	Min = 8, Max = 24
})

ESPSettings:AddDropdown({
	Name = "Text Font",
	Value = Fonts[(WallHack and WallHack.Visuals.ESPSettings.TextFont or 0) + 1],
	Callback = function(New) if WallHack then WallHack.Visuals.ESPSettings.TextFont = Drawing.Fonts[New] end end,
	List = Fonts,
	Nothing = "UI"
})

BoxesSettings:AddToggle({
	Name = "Enabled",
	Value = WallHack and WallHack.Visuals.BoxSettings.Enabled or true,
	Callback = function(New) if WallHack then WallHack.Visuals.BoxSettings.Enabled = New end end
})

BoxesSettings:AddSlider({
	Name = "Transparency",
	Value = (WallHack and WallHack.Visuals.BoxSettings.Transparency) or 0.7,
	Callback = function(New) if WallHack then WallHack.Visuals.BoxSettings.Transparency = New end end,
	Min = 0, Max = 1, Decimals = 2
})

BoxesSettings:AddSlider({
	Name = "Thickness",
	Value = (WallHack and WallHack.Visuals.BoxSettings.Thickness) or 1,
	Callback = function(New) if WallHack then WallHack.Visuals.BoxSettings.Thickness = New end end,
	Min = 1, Max = 5
})

BoxesSettings:AddSlider({
	Name = "Scale Increase (For 3D)",
	Value = (WallHack and WallHack.Visuals.BoxSettings.Increase) or 1,
	Callback = function(New) if WallHack then WallHack.Visuals.BoxSettings.Increase = New end end,
	Min = 1, Max = 5
})

BoxesSettings:AddColorpicker({
	Name = "Color",
	Value = (WallHack and WallHack.Visuals.BoxSettings.Color) or Color3.fromRGB(255,255,255),
	Callback = function(New) if WallHack then WallHack.Visuals.BoxSettings.Color = New end end
})

BoxesSettings:AddDropdown({
	Name = "Type",
	Value = (WallHack and WallHack.Visuals.BoxSettings.Type) == 1 and "3D" or "2D",
	Callback = function(New) if WallHack then WallHack.Visuals.BoxSettings.Type = New == "3D" and 1 or 2 end,
	List = {"3D", "2D"},
	Nothing = "3D"
})

BoxesSettings:AddToggle({
	Name = "Filled (2D Square)",
	Value = WallHack and WallHack.Visuals.BoxSettings.Filled or false,
	Callback = function(New) if WallHack then WallHack.Visuals.BoxSettings.Filled = New end end
})

ChamsSettings:AddToggle({
	Name = "Enabled",
	Value = WallHack and WallHack.Visuals.ChamsSettings.Enabled or false,
	Callback = function(New) if WallHack then WallHack.Visuals.ChamsSettings.Enabled = New end end
})

ChamsSettings:AddToggle({
	Name = "Filled",
	Value = WallHack and WallHack.Visuals.ChamsSettings.Filled or true,
	Callback = function(New) if WallHack then WallHack.Visuals.ChamsSettings.Filled = New end end
})

ChamsSettings:AddToggle({
	Name = "Entire Body (For R15 Rigs)",
	Value = WallHack and WallHack.Visuals.ChamsSettings.EntireBody or false,
	Callback = function(New) if WallHack then WallHack.Visuals.ChamsSettings.EntireBody = New end end
})

ChamsSettings:AddSlider({
	Name = "Transparency",
	Value = (WallHack and WallHack.Visuals.ChamsSettings.Transparency) or 0.3,
	Callback = function(New) if WallHack then WallHack.Visuals.ChamsSettings.Transparency = New end end,
	Min = 0, Max = 1, Decimals = 2
})

ChamsSettings:AddSlider({
	Name = "Thickness",
	Value = (WallHack and WallHack.Visuals.ChamsSettings.Thickness) or 1,
	Callback = function(New) if WallHack then WallHack.Visuals.ChamsSettings.Thickness = New end end,
	Min = 0, Max = 3
})

ChamsSettings:AddColorpicker({
	Name = "Color",
	Value = (WallHack and WallHack.Visuals.ChamsSettings.Color) or Color3.fromRGB(255,255,255),
	Callback = function(New) if WallHack then WallHack.Visuals.ChamsSettings.Color = New end end
})

TracersSettings:AddToggle({
	Name = "Enabled",
	Value = WallHack and WallHack.Visuals.TracersSettings.Enabled or false,
	Callback = function(New) if WallHack then WallHack.Visuals.TracersSettings.Enabled = New end end
})

TracersSettings:AddSlider({
	Name = "Transparency",
	Value = (WallHack and WallHack.Visuals.TracersSettings.Transparency) or 0.7,
	Callback = function(New) if WallHack then WallHack.Visuals.TracersSettings.Transparency = New end end,
	Min = 0, Max = 1, Decimals = 2
})

TracersSettings:AddSlider({
	Name = "Thickness",
	Value = (WallHack and WallHack.Visuals.TracersSettings.Thickness) or 1,
	Callback = function(New) if WallHack then WallHack.Visuals.TracersSettings.Thickness = New end end,
	Min = 1, Max = 5
})

TracersSettings:AddColorpicker({
	Name = "Color",
	Value = (WallHack and WallHack.Visuals.TracersSettings.Color) or Color3.fromRGB(255,255,255),
	Callback = function(New) if WallHack then WallHack.Visuals.TracersSettings.Color = New end end
})

TracersSettings:AddDropdown({
	Name = "Start From",
	Value = TracersType[(WallHack and WallHack.Visuals.TracersSettings.Type or 1)],
	Callback = function(New) if WallHack then WallHack.Visuals.TracersSettings.Type = tablefind(TracersType, New) end end,
	List = TracersType,
	Nothing = "Bottom"
})

HeadDotsSettings:AddToggle({
	Name = "Enabled",
	Value = WallHack and WallHack.Visuals.HeadDotSettings.Enabled or false,
	Callback = function(New) if WallHack then WallHack.Visuals.HeadDotSettings.Enabled = New end end
})

HeadDotsSettings:AddToggle({
	Name = "Filled",
	Value = WallHack and WallHack.Visuals.HeadDotSettings.Filled or false,
	Callback = function(New) if WallHack then WallHack.Visuals.HeadDotSettings.Filled = New end end
})

HeadDotsSettings:AddSlider({
	Name = "Transparency",
	Value = (WallHack and WallHack.Visuals.HeadDotSettings.Transparency) or 0.5,
	Callback = function(New) if WallHack then WallHack.Visuals.HeadDotSettings.Transparency = New end end,
	Min = 0, Max = 1, Decimals = 2
})

HeadDotsSettings:AddSlider({
	Name = "Thickness",
	Value = (WallHack and WallHack.Visuals.HeadDotSettings.Thickness) or 1,
	Callback = function(New) if WallHack then WallHack.Visuals.HeadDotSettings.Thickness = New end end,
	Min = 1, Max = 5
})

HeadDotsSettings:AddSlider({
	Name = "Sides",
	Value = (WallHack and WallHack.Visuals.HeadDotSettings.Sides) or 30,
	Callback = function(New) if WallHack then WallHack.Visuals.HeadDotSettings.Sides = New end end,
	Min = 3, Max = 60
})

HeadDotsSettings:AddColorpicker({
	Name = "Color",
	Value = (WallHack and WallHack.Visuals.HeadDotSettings.Color) or Color3.fromRGB(255,255,255),
	Callback = function(New) if WallHack then WallHack.Visuals.HeadDotSettings.Color = New end end
})

HealthBarSettings:AddToggle({
	Name = "Enabled",
	Value = WallHack and WallHack.Visuals.HealthBarSettings.Enabled or false,
	Callback = function(New) if WallHack then WallHack.Visuals.HealthBarSettings.Enabled = New end end
})

HealthBarSettings:AddDropdown({
	Name = "Position",
	Value = (WallHack and WallHack.Visuals.HealthBarSettings.Type) == 1 and "Top" or (WallHack and WallHack.Visuals.HealthBarSettings.Type) == 2 and "Bottom" or (WallHack and WallHack.Visuals.HealthBarSettings.Type) == 3 and "Left" or "Right",
	Callback = function(New) if WallHack then WallHack.Visuals.HealthBarSettings.Type = New == "Top" and 1 or New == "Bottom" and 2 or New == "Left" and 3 or 4 end end,
	List = {"Top", "Bottom", "Left", "Right"},
	Nothing = "Left"
})

HealthBarSettings:AddSlider({
	Name = "Transparency",
	Value = (WallHack and WallHack.Visuals.HealthBarSettings.Transparency) or 0.8,
	Callback = function(New) if WallHack then WallHack.Visuals.HealthBarSettings.Transparency = New end end,
	Min = 0, Max = 1, Decimals = 2
})

HealthBarSettings:AddSlider({
	Name = "Size",
	Value = (WallHack and WallHack.Visuals.HealthBarSettings.Size) or 2,
	Callback = function(New) if WallHack then WallHack.Visuals.HealthBarSettings.Size = New end end,
	Min = 2, Max = 10
})

HealthBarSettings:AddSlider({
	Name = "Blue",
	Value = (WallHack and WallHack.Visuals.HealthBarSettings.Blue) or 50,
	Callback = function(New) if WallHack then WallHack.Visuals.HealthBarSettings.Blue = New end end,
	Min = 0, Max = 255
})

HealthBarSettings:AddSlider({
	Name = "Offset",
	Value = (WallHack and WallHack.Visuals.HealthBarSettings.Offset) or 10,
	Callback = function(New) if WallHack then WallHack.Visuals.HealthBarSettings.Offset = New end end,
	Min = -30, Max = 30
})

HealthBarSettings:AddColorpicker({
	Name = "Outline Color",
	Value = (WallHack and WallHack.Visuals.HealthBarSettings.OutlineColor) or Color3.fromRGB(0,0,0),
	Callback = function(New) if WallHack then WallHack.Visuals.HealthBarSettings.OutlineColor = New end end
})

-- ========== CROSSHAIR ==========
CrosshairSettings:AddToggle({
	Name = "Mouse Cursor",
	Value = UserInputService.MouseIconEnabled,
	Callback = function(New) UserInputService.MouseIconEnabled = New end
})

CrosshairSettings:AddToggle({
	Name = "Enabled",
	Value = WallHack and WallHack.Crosshair and WallHack.Crosshair.Settings.Enabled or false,
	Callback = function(New) if WallHack and WallHack.Crosshair then WallHack.Crosshair.Settings.Enabled = New end end
})

CrosshairSettings:AddColorpicker({
	Name = "Color",
	Value = (WallHack and WallHack.Crosshair and WallHack.Crosshair.Settings.Color) or Color3.fromRGB(0,255,0),
	Callback = function(New) if WallHack and WallHack.Crosshair then WallHack.Crosshair.Settings.Color = New end end
})

CrosshairSettings:AddSlider({
	Name = "Transparency",
	Value = (WallHack and WallHack.Crosshair and WallHack.Crosshair.Settings.Transparency) or 1,
	Callback = function(New) if WallHack and WallHack.Crosshair then WallHack.Crosshair.Settings.Transparency = New end end,
	Min = 0, Max = 1, Decimals = 2
})

CrosshairSettings:AddSlider({
	Name = "Size",
	Value = (WallHack and WallHack.Crosshair and WallHack.Crosshair.Settings.Size) or 12,
	Callback = function(New) if WallHack and WallHack.Crosshair then WallHack.Crosshair.Settings.Size = New end end,
	Min = 8, Max = 24
})

CrosshairSettings:AddSlider({
	Name = "Thickness",
	Value = (WallHack and WallHack.Crosshair and WallHack.Crosshair.Settings.Thickness) or 1,
	Callback = function(New) if WallHack and WallHack.Crosshair then WallHack.Crosshair.Settings.Thickness = New end end,
	Min = 1, Max = 5
})

CrosshairSettings:AddSlider({
	Name = "Gap Size",
	Value = (WallHack and WallHack.Crosshair and WallHack.Crosshair.Settings.GapSize) or 5,
	Callback = function(New) if WallHack and WallHack.Crosshair then WallHack.Crosshair.Settings.GapSize = New end end,
	Min = 0, Max = 20
})

CrosshairSettings:AddSlider({
	Name = "Rotation (Degrees)",
	Value = (WallHack and WallHack.Crosshair and WallHack.Crosshair.Settings.Rotation) or 0,
	Callback = function(New) if WallHack and WallHack.Crosshair then WallHack.Crosshair.Settings.Rotation = New end end,
	Min = -180, Max = 180
})

CrosshairSettings:AddDropdown({
	Name = "Position",
	Value = (WallHack and WallHack.Crosshair and WallHack.Crosshair.Settings.Type) == 1 and "Mouse" or "Center",
	Callback = function(New) if WallHack and WallHack.Crosshair then WallHack.Crosshair.Settings.Type = New == "Mouse" and 1 or 2 end end,
	List = {"Mouse", "Center"},
	Nothing = "Mouse"
})

CrosshairSettings_CenterDot:AddToggle({
	Name = "Center Dot",
	Value = WallHack and WallHack.Crosshair and WallHack.Crosshair.Settings.CenterDot or false,
	Callback = function(New) if WallHack and WallHack.Crosshair then WallHack.Crosshair.Settings.CenterDot = New end end
})

CrosshairSettings_CenterDot:AddColorpicker({
	Name = "Center Dot Color",
	Value = (WallHack and WallHack.Crosshair and WallHack.Crosshair.Settings.CenterDotColor) or Color3.fromRGB(0,255,0),
	Callback = function(New) if WallHack and WallHack.Crosshair then WallHack.Crosshair.Settings.CenterDotColor = New end end
})

CrosshairSettings_CenterDot:AddSlider({
	Name = "Center Dot Size",
	Value = (WallHack and WallHack.Crosshair and WallHack.Crosshair.Settings.CenterDotSize) or 1,
	Callback = function(New) if WallHack and WallHack.Crosshair then WallHack.Crosshair.Settings.CenterDotSize = New end end,
	Min = 1, Max = 6
})

CrosshairSettings_CenterDot:AddSlider({
	Name = "Center Dot Transparency",
	Value = (WallHack and WallHack.Crosshair and WallHack.Crosshair.Settings.CenterDotTransparency) or 1,
	Callback = function(New) if WallHack and WallHack.Crosshair then WallHack.Crosshair.Settings.CenterDotTransparency = New end end,
	Min = 0, Max = 1, Decimals = 2
})

CrosshairSettings_CenterDot:AddToggle({
	Name = "Center Dot Filled",
	Value = WallHack and WallHack.Crosshair and WallHack.Crosshair.Settings.CenterDotFilled or true,
	Callback = function(New) if WallHack and WallHack.Crosshair then WallHack.Crosshair.Settings.CenterDotFilled = New end end
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

print("✅ AirHub COMPLETO carregado!")
print("🎯 Aimbot | 👁️ Visuals | 🎮 Crosshair | ✈️ Fly | 💪 Hitbox")
print("✅ Todas as funcionalidades RESTAURADAS!")
print("✅ AirHub COMPLETO carregado!")
print("🎯 Aimbot | 👁️ Visuals | 🎮 Crosshair | ✈️ Fly | 💪 Hitbox")
print("✅ Todas as funcionalidades RESTAURADAS!")
