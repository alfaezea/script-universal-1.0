--[[
	AirHub by Exunys © CC0 1.0 Universal (2023)
	https://github.com/Exunys
	Modificado com Smoothness, Fly e HITBOX EXTENDER
]]

--// Cache
local loadstring, getgenv, setclipboard, tablefind, UserInputService = loadstring, getgenv, setclipboard, table.find, game:GetService("UserInputService")

--// Loaded check
if AirHub or AirHubV2Loaded then return end

--// Environment
getgenv().AirHub = {}

--// Load Modules (use os links do seu repositório)
loadstring(game:HttpGet("https://raw.githubusercontent.com/alfaezea/script-universal-1.0/main/aimbot.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/AirHub/main/Modules/Wall%20Hack.lua"))()

--// Carregar Hitbox Extender
local LimbExtender = loadstring(game:HttpGet("https://raw.githubusercontent.com/alfaezea/script-universal-1.0/main/hitbox.lua"))()

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
    extender:Destroy()
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

--// Visuals Sections (WALLHACK)
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

--// Diversos Sections (AGORA COM FLY E HITBOX)
local FlySection = MiscTab:CreateSection({ Name = "Sistema de Voo" })
local HitboxSection = MiscTab:CreateSection({ Name = "Hitbox Extender", Side = "Right" })
local HitboxConfig = MiscTab:CreateSection({ Name = "Configurações da Hitbox", Side = "Right" })
local HighlightSection = MiscTab:CreateSection({ Name = "Configurações do Highlight", Side = "Right" })

--// Functions Sections
local FunctionsSection = FunctionsTab:CreateSection({ Name = "Functions" })

-- ========== AIMBOT (seu código existente) ==========
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

Values:AddSlider({
	Name = "Smoothness",
	Value = Aimbot.Settings.Smoothness,
	Callback = function(New) Aimbot.Settings.Smoothness = New end,
	Min = 0.1, Max = 1.0, Decimals = 2
}).Default = Aimbot.Settings.Smoothness

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

-- ========== WALLHACK (seu código existente) ==========
WallHackChecks:AddToggle({
	Name = "Enabled",
	Value = WallHack.Settings.Enabled,
	Callback = function(New) WallHack.Settings.Enabled = New end
}).Default = WallHack.Settings.Enabled

WallHackChecks:AddToggle({
	Name = "Team Check",
	Value = WallHack.Settings.TeamCheck,
	Callback = function(New) WallHack.Settings.TeamCheck = New end
}).Default = WallHack.Settings.TeamCheck

WallHackChecks:AddToggle({
	Name = "Alive Check",
	Value = WallHack.Settings.AliveCheck,
	Callback = function(New) WallHack.Settings.AliveCheck = New end
}).Default = WallHack.Settings.AliveCheck

ESPSettings:AddToggle({
	Name = "Enabled",
	Value = WallHack.Visuals.ESPSettings.Enabled,
	Callback = function(New) WallHack.Visuals.ESPSettings.Enabled = New end
}).Default = WallHack.Visuals.ESPSettings.Enabled

ESPSettings:AddToggle({
	Name = "Outline",
	Value = WallHack.Visuals.ESPSettings.Outline,
	Callback = function(New) WallHack.Visuals.ESPSettings.Outline = New end
}).Default = WallHack.Visuals.ESPSettings.Outline

ESPSettings:AddToggle({
	Name = "Display Distance",
	Value = WallHack.Visuals.ESPSettings.DisplayDistance,
	Callback = function(New) WallHack.Visuals.ESPSettings.DisplayDistance = New end
}).Default = WallHack.Visuals.ESPSettings.DisplayDistance

ESPSettings:AddToggle({
	Name = "Display Health",
	Value = WallHack.Visuals.ESPSettings.DisplayHealth,
	Callback = function(New) WallHack.Visuals.ESPSettings.DisplayHealth = New end
}).Default = WallHack.Visuals.ESPSettings.DisplayHealth

ESPSettings:AddToggle({
	Name = "Display Name",
	Value = WallHack.Visuals.ESPSettings.DisplayName,
	Callback = function(New) WallHack.Visuals.ESPSettings.DisplayName = New end
}).Default = WallHack.Visuals.ESPSettings.DisplayName

ESPSettings:AddSlider({
	Name = "Offset",
	Value = WallHack.Visuals.ESPSettings.Offset,
	Callback = function(New) WallHack.Visuals.ESPSettings.Offset = New end,
	Min = -30, Max = 30
}).Default = WallHack.Visuals.ESPSettings.Offset

ESPSettings:AddColorpicker({
	Name = "Text Color",
	Value = WallHack.Visuals.ESPSettings.TextColor,
	Callback = function(New) WallHack.Visuals.ESPSettings.TextColor = New end
}).Default = WallHack.Visuals.ESPSettings.TextColor

ESPSettings:AddColorpicker({
	Name = "Outline Color",
	Value = WallHack.Visuals.ESPSettings.OutlineColor,
	Callback = function(New) WallHack.Visuals.ESPSettings.OutlineColor = New end
}).Default = WallHack.Visuals.ESPSettings.OutlineColor

ESPSettings:AddSlider({
	Name = "Text Transparency",
	Value = WallHack.Visuals.ESPSettings.TextTransparency,
	Callback = function(New) WallHack.Visuals.ESPSettings.TextTransparency = New end,
	Min = 0, Max = 1, Decimals = 2
}).Default = WallHack.Visuals.ESPSettings.TextTransparency

ESPSettings:AddSlider({
	Name = "Text Size",
	Value = WallHack.Visuals.ESPSettings.TextSize,
	Callback = function(New) WallHack.Visuals.ESPSettings.TextSize = New end,
	Min = 8, Max = 24
}).Default = WallHack.Visuals.ESPSettings.TextSize

ESPSettings:AddDropdown({
	Name = "Text Font",
	Value = Fonts[WallHack.Visuals.ESPSettings.TextFont + 1],
	Callback = function(New) WallHack.Visuals.ESPSettings.TextFont = Drawing.Fonts[New] end,
	List = Fonts,
	Nothing = "UI"
}).Default = Fonts[WallHack.Visuals.ESPSettings.TextFont + 1]

BoxesSettings:AddToggle({
	Name = "Enabled",
	Value = WallHack.Visuals.BoxSettings.Enabled,
	Callback = function(New) WallHack.Visuals.BoxSettings.Enabled = New end
}).Default = WallHack.Visuals.BoxSettings.Enabled

BoxesSettings:AddSlider({
	Name = "Transparency",
	Value = WallHack.Visuals.BoxSettings.Transparency,
	Callback = function(New) WallHack.Visuals.BoxSettings.Transparency = New end,
	Min = 0, Max = 1, Decimals = 2
}).Default = WallHack.Visuals.BoxSettings.Transparency

BoxesSettings:AddSlider({
	Name = "Thickness",
	Value = WallHack.Visuals.BoxSettings.Thickness,
	Callback = function(New) WallHack.Visuals.BoxSettings.Thickness = New end,
	Min = 1, Max = 5
}).Default = WallHack.Visuals.BoxSettings.Thickness

BoxesSettings:AddSlider({
	Name = "Scale Increase (For 3D)",
	Value = WallHack.Visuals.BoxSettings.Increase,
	Callback = function(New) WallHack.Visuals.BoxSettings.Increase = New end,
	Min = 1, Max = 5
}).Default = WallHack.Visuals.BoxSettings.Increase

BoxesSettings:AddColorpicker({
	Name = "Color",
	Value = WallHack.Visuals.BoxSettings.Color,
	Callback = function(New) WallHack.Visuals.BoxSettings.Color = New end
}).Default = WallHack.Visuals.BoxSettings.Color

BoxesSettings:AddDropdown({
	Name = "Type",
	Value = WallHack.Visuals.BoxSettings.Type == 1 and "3D" or "2D",
	Callback = function(New) WallHack.Visuals.BoxSettings.Type = New == "3D" and 1 or 2 end,
	List = {"3D", "2D"},
	Nothing = "3D"
}).Default = WallHack.Visuals.BoxSettings.Type == 1 and "3D" or "2D"

BoxesSettings:AddToggle({
	Name = "Filled (2D Square)",
	Value = WallHack.Visuals.BoxSettings.Filled,
	Callback = function(New) WallHack.Visuals.BoxSettings.Filled = New end
}).Default = WallHack.Visuals.BoxSettings.Filled

ChamsSettings:AddToggle({
	Name = "Enabled",
	Value = WallHack.Visuals.ChamsSettings.Enabled,
	Callback = function(New) WallHack.Visuals.ChamsSettings.Enabled = New end
}).Default = WallHack.Visuals.ChamsSettings.Enabled

ChamsSettings:AddToggle({
	Name = "Filled",
	Value = WallHack.Visuals.ChamsSettings.Filled,
	Callback = function(New) WallHack.Visuals.ChamsSettings.Filled = New end
}).Default = WallHack.Visuals.ChamsSettings.Filled

ChamsSettings:AddToggle({
	Name = "Entire Body (For R15 Rigs)",
	Value = WallHack.Visuals.ChamsSettings.EntireBody,
	Callback = function(New) WallHack.Visuals.ChamsSettings.EntireBody = New end
}).Default = WallHack.Visuals.ChamsSettings.EntireBody

ChamsSettings:AddSlider({
	Name = "Transparency",
	Value = WallHack.Visuals.ChamsSettings.Transparency,
	Callback = function(New) WallHack.Visuals.ChamsSettings.Transparency = New end,
	Min = 0, Max = 1, Decimals = 2
}).Default = WallHack.Visuals.ChamsSettings.Transparency

ChamsSettings:AddSlider({
	Name = "Thickness",
	Value = WallHack.Visuals.ChamsSettings.Thickness,
	Callback = function(New) WallHack.Visuals.ChamsSettings.Thickness = New end,
	Min = 0, Max = 3
}).Default = WallHack.Visuals.ChamsSettings.Thickness

ChamsSettings:AddColorpicker({
	Name = "Color",
	Value = WallHack.Visuals.ChamsSettings.Color,
	Callback = function(New) WallHack.Visuals.ChamsSettings.Color = New end
}).Default = WallHack.Visuals.ChamsSettings.Color

TracersSettings:AddToggle({
	Name = "Enabled",
	Value = WallHack.Visuals.TracersSettings.Enabled,
	Callback = function(New) WallHack.Visuals.TracersSettings.Enabled = New end
}).Default = WallHack.Visuals.TracersSettings.Enabled

TracersSettings:AddSlider({
	Name = "Transparency",
	Value = WallHack.Visuals.TracersSettings.Transparency,
	Callback = function(New) WallHack.Visuals.TracersSettings.Transparency = New end,
	Min = 0, Max = 1, Decimals = 2
}).Default = WallHack.Visuals.TracersSettings.Transparency

TracersSettings:AddSlider({
	Name = "Thickness",
	Value = WallHack.Visuals.TracersSettings.Thickness,
	Callback = function(New) WallHack.Visuals.TracersSettings.Thickness = New end,
	Min = 1, Max = 5
}).Default = WallHack.Visuals.TracersSettings.Thickness

TracersSettings:AddColorpicker({
	Name = "Color",
	Value = WallHack.Visuals.TracersSettings.Color,
	Callback = function(New) WallHack.Visuals.TracersSettings.Color = New end
}).Default = WallHack.Visuals.TracersSettings.Color

TracersSettings:AddDropdown({
	Name = "Start From",
	Value = TracersType[WallHack.Visuals.TracersSettings.Type],
	Callback = function(New) WallHack.Visuals.TracersSettings.Type = tablefind(TracersType, New) end,
	List = TracersType,
	Nothing = "Bottom"
}).Default = Fonts[WallHack.Visuals.TracersSettings.Type + 1]

HeadDotsSettings:AddToggle({
	Name = "Enabled",
	Value = WallHack.Visuals.HeadDotSettings.Enabled,
	Callback = function(New) WallHack.Visuals.HeadDotSettings.Enabled = New end
}).Default = WallHack.Visuals.HeadDotSettings.Enabled

HeadDotsSettings:AddToggle({
	Name = "Filled",
	Value = WallHack.Visuals.HeadDotSettings.Filled,
	Callback = function(New) WallHack.Visuals.HeadDotSettings.Filled = New end
}).Default = WallHack.Visuals.HeadDotSettings.Filled

HeadDotsSettings:AddSlider({
	Name = "Transparency",
	Value = WallHack.Visuals.HeadDotSettings.Transparency,
	Callback = function(New) WallHack.Visuals.HeadDotSettings.Transparency = New end,
	Min = 0, Max = 1, Decimals = 2
}).Default = WallHack.Visuals.HeadDotSettings.Transparency

HeadDotsSettings:AddSlider({
	Name = "Thickness",
	Value = WallHack.Visuals.HeadDotSettings.Thickness,
	Callback = function(New) WallHack.Visuals.HeadDotSettings.Thickness = New end,
	Min = 1, Max = 5
}).Default = WallHack.Visuals.HeadDotSettings.Thickness

HeadDotsSettings:AddSlider({
	Name = "Sides",
	Value = WallHack.Visuals.HeadDotSettings.Sides,
	Callback = function(New) WallHack.Visuals.HeadDotSettings.Sides = New end,
	Min = 3, Max = 60
}).Default = WallHack.Visuals.HeadDotSettings.Sides

HeadDotsSettings:AddColorpicker({
	Name = "Color",
	Value = WallHack.Visuals.HeadDotSettings.Color,
	Callback = function(New) WallHack.Visuals.HeadDotSettings.Color = New end
}).Default = WallHack.Visuals.HeadDotSettings.Color

HealthBarSettings:AddToggle({
	Name = "Enabled",
	Value = WallHack.Visuals.HealthBarSettings.Enabled,
	Callback = function(New) WallHack.Visuals.HealthBarSettings.Enabled = New end
}).Default = WallHack.Visuals.HealthBarSettings.Enabled

HealthBarSettings:AddDropdown({
	Name = "Position",
	Value = WallHack.Visuals.HealthBarSettings.Type == 1 and "Top" or WallHack.Visuals.HealthBarSettings.Type == 2 and "Bottom" or WallHack.Visuals.HealthBarSettings.Type == 3 and "Left" or "Right",
	Callback = function(New) WallHack.Visuals.HealthBarSettings.Type = New == "Top" and 1 or New == "Bottom" and 2 or New == "Left" and 3 or 4 end,
	List = {"Top", "Bottom", "Left", "Right"},
	Nothing = "Left"
}).Default = WallHack.Visuals.HealthBarSettings.Type == 1 and "Top" or WallHack.Visuals.HealthBarSettings.Type == 2 and "Bottom" or WallHack.Visuals.HealthBarSettings.Type == 3 and "Left" or "Right"

HealthBarSettings:AddSlider({
	Name = "Transparency",
	Value = WallHack.Visuals.HealthBarSettings.Transparency,
	Callback = function(New) WallHack.Visuals.HealthBarSettings.Transparency = New end,
	Min = 0, Max = 1, Decimals = 2
}).Default = WallHack.Visuals.HealthBarSettings.Transparency

HealthBarSettings:AddSlider({
	Name = "Size",
	Value = WallHack.Visuals.HealthBarSettings.Size,
	Callback = function(New) WallHack.Visuals.HealthBarSettings.Size = New end,
	Min = 2, Max = 10
}).Default = WallHack.Visuals.HealthBarSettings.Size

HealthBarSettings:AddSlider({
	Name = "Blue",
	Value = WallHack.Visuals.HealthBarSettings.Blue,
	Callback = function(New) WallHack.Visuals.HealthBarSettings.Blue = New end,
	Min = 0, Max = 255
}).Default = WallHack.Visuals.HealthBarSettings.Blue

HealthBarSettings:AddSlider({
	Name = "Offset",
	Value = WallHack.Visuals.HealthBarSettings.Offset,
	Callback = function(New) WallHack.Visuals.HealthBarSettings.Offset = New end,
	Min = -30, Max = 30
}).Default = WallHack.Visuals.HealthBarSettings.Offset

HealthBarSettings:AddColorpicker({
	Name = "Outline Color",
	Value = WallHack.Visuals.HealthBarSettings.OutlineColor,
	Callback = function(New) WallHack.Visuals.HealthBarSettings.OutlineColor = New end
}).Default = WallHack.Visuals.HealthBarSettings.OutlineColor

-- ========== DIVERSOS / FLY (Lado Esquerdo) ==========
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

-- ========== DIVERSOS / HITBOX (Lado Direito) ==========

-- Controle Principal
HitboxSection:AddToggle({
	Name = "Ativar Hitbox",
	Value = HitboxSettings.Enabled,
	Callback = function(New)
		HitboxSettings.Enabled = New
		if New then
			extender:Start()
		else
			extender:Stop()
		end
	end
})

HitboxSection:AddDropdown({
	Name = "Tecla Atalho",
	Value = HitboxSettings.ToggleKey,
	Callback = function(New) 
		HitboxSettings.ToggleKey = New
		extender:Set("TOGGLE", New)
	end,
	List = {"L", "K", "J", "H", "G", "F", "E", "Q"},
	Nothing = "L"
})

HitboxSection:AddDropdown({
	Name = "Parte do Corpo",
	Value = HitboxSettings.TargetLimb,
	Callback = function(New) 
		HitboxSettings.TargetLimb = New
		extender:Set("TARGET_LIMB", New)
	end,
	List = {"Head", "HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso"},
	Nothing = "HumanoidRootPart"
})

-- Configurações da Hitbox
HitboxConfig:AddSlider({
	Name = "Tamanho",
	Value = HitboxSettings.Size,
	Callback = function(New) 
		HitboxSettings.Size = New
		extender:Set("LIMB_SIZE", New)
	end,
	Min = 5, Max = 30, Decimals = 1
})

HitboxConfig:AddSlider({
	Name = "Transparência",
	Value = HitboxSettings.Transparency,
	Callback = function(New) 
		HitboxSettings.Transparency = New
		extender:Set("LIMB_TRANSPARENCY", New)
	end,
	Min = 0, Max = 1, Decimals = 2
})

HitboxConfig:AddToggle({
	Name = "Pode Colidir",
	Value = HitboxSettings.CanCollide,
	Callback = function(New) 
		HitboxSettings.CanCollide = New
		extender:Set("LIMB_CAN_COLLIDE", New)
	end
})

HitboxConfig:AddToggle({
	Name = "Team Check",
	Value = HitboxSettings.TeamCheck,
	Callback = function(New) 
		HitboxSettings.TeamCheck = New
		extender:Set("TEAM_CHECK", New)
	end
})

HitboxConfig:AddToggle({
	Name = "ForceField Check",
	Value = HitboxSettings.ForceFieldCheck,
	Callback = function(New) 
		HitboxSettings.ForceFieldCheck = New
		extender:Set("FORCEFIELD_CHECK", New)
	end
})

-- Configurações do Highlight
HighlightSection:AddToggle({
	Name = "Usar Highlight",
	Value = HitboxSettings.UseHighlight,
	Callback = function(New) 
		HitboxSettings.UseHighlight = New
		extender:Set("USE_HIGHLIGHT", New)
	end
})

HighlightSection:AddDropdown({
	Name = "Modo Profundidade",
	Value = HitboxSettings.DepthMode,
	Callback = function(New) 
		HitboxSettings.DepthMode = New
		extender:Set("DEPTH_MODE", New)
	end,
	List = {"AlwaysOnTop", "Occluded", "AlwaysOnBottom"},
	Nothing = "AlwaysOnTop"
})

HighlightSection:AddColorpicker({
	Name = "Cor do Fill",
	Value = HitboxSettings.HighlightColor,
	Callback = function(New) 
		HitboxSettings.HighlightColor = New
		extender:Set("HIGHLIGHT_FILL_COLOR", New)
	end
})

HighlightSection:AddSlider({
	Name = "Transparência Fill",
	Value = HitboxSettings.HighlightTransparency,
	Callback = function(New) 
		HitboxSettings.HighlightTransparency = New
		extender:Set("HIGHLIGHT_FILL_TRANSPARENCY", New)
	end,
	Min = 0, Max = 1, Decimals = 2
})

HighlightSection:AddColorpicker({
	Name = "Cor do Outline",
	Value = HitboxSettings.OutlineColor,
	Callback = function(New) 
		HitboxSettings.OutlineColor = New
		extender:Set("HIGHLIGHT_OUTLINE_COLOR", New)
	end
})

HighlightSection:AddSlider({
	Name = "Transparência Outline",
	Value = HitboxSettings.OutlineTransparency,
	Callback = function(New) 
		HitboxSettings.OutlineTransparency = New
		extender:Set("HIGHLIGHT_OUTLINE_TRANSPARENCY", New)
	end,
	Min = 0, Max = 1, Decimals = 2
})

-- ========== FUNCTIONS ==========
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
	Callback = function() setclipboard("https://github.com/Exunys/AirHub") end
})

print("✅ AirHub carregado com SMOOTHNESS, FLY e HITBOX!")
print("🎯 Smoothness controla a velocidade da mira (0.1 = rápido, 1.0 = suave)")
print("💪 Hitbox Extender adicionado na aba Diversos!")
})

print("✅ AirHub carregado com SMOOTHNESS e FLY!")
print("🎯 Smoothness controla a velocidade da mira (0.1 = rápido, 1.0 = suave)")
