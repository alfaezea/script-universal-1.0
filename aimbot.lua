--[[
    AIMBOT ULTRA COMPLETO - AirHub Edition
    Modo Automático | Aprender Tecla | Todas as partes
]]

--// Cache
local pcall, getgenv, next, setmetatable, Vector2new, CFramenew, Color3fromRGB, Drawingnew, TweenInfonew, stringupper, mousemoverel = pcall, getgenv, next, setmetatable, Vector2.new, CFrame.new, Color3.fromRGB, Drawing.new, TweenInfo.new, string.upper, mousemoverel or (Input and Input.MouseMove)

--// Launching checks
if not getgenv().AirHub or getgenv().AirHub.Aimbot then return end

--// Services
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// Variables
local RequiredDistance, Typing, Running, ServiceConnections, Animation, OriginalSensitivity = 2000, false, false, {}

--// Environment
getgenv().AirHub.Aimbot = {
	Settings = {
		Enabled = false,
		TeamCheck = false,
		AliveCheck = true,
		WallCheck = false,
		Sensitivity = 0,
		Smoothness = 0.3,
		ThirdPerson = false,
		ThirdPersonSensitivity = 3,
		TriggerKey = "MouseButton2",
		Toggle = false,
		Auto = false, -- NOVO: Modo automático (gruda sem tecla)
		Learning = false, -- NOVO: Modo de aprendizado de tecla
		LockPart = "Head"
	},

	FOVSettings = {
		Enabled = true,
		Visible = true,
		Amount = 90,
		Color = Color3fromRGB(255, 255, 255),
		LockedColor = Color3fromRGB(255, 70, 70),
		Transparency = 0.5,
		Sides = 60,
		Thickness = 1,
		Filled = false
	},

	FOVCircle = Drawingnew("Circle")
}

local Environment = getgenv().AirHub.Aimbot

-- ========== LISTA COMPLETA DE PARTES DO CORPO ==========
Environment.ValidParts = {
	-- Cabeça
	"Head",
	
	-- Tronco
	"HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso",
	
	-- Braços (R6)
	"Left Arm", "Right Arm",
	
	-- Braços (R15)
	"LeftUpperArm", "LeftLowerArm", "LeftHand",
	"RightUpperArm", "RightLowerArm", "RightHand",
	
	-- Pernas (R6)
	"Left Leg", "Right Leg",
	
	-- Pernas (R15)
	"LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
	"RightUpperLeg", "RightLowerLeg", "RightFoot"
}

--// Core Functions
local function ConvertVector(Vector)
	return Vector2new(Vector.X, Vector.Y)
end

local function CancelLock()
	Environment.Locked = nil
	Environment.FOVCircle.Color = Environment.FOVSettings.Color
	UserInputService.MouseDeltaSensitivity = OriginalSensitivity
	if Animation then Animation:Cancel() end
end

local function GetClosestPlayer()
	if not Environment.Locked then
		RequiredDistance = (Environment.FOVSettings.Enabled and Environment.FOVSettings.Amount or 2000)

		for _, v in next, Players:GetPlayers() do
			if v ~= LocalPlayer and v.Character then
				-- Procura a parte escolhida no character
				local targetPart = v.Character:FindFirstChild(Environment.Settings.LockPart)
				
				-- Fallback para partes alternativas
				if not targetPart then
					if Environment.Settings.LockPart == "Left Arm" then
						targetPart = v.Character:FindFirstChild("LeftUpperArm") or v.Character:FindFirstChild("LeftLowerArm")
					elseif Environment.Settings.LockPart == "Right Arm" then
						targetPart = v.Character:FindFirstChild("RightUpperArm") or v.Character:FindFirstChild("RightLowerArm")
					elseif Environment.Settings.LockPart == "Left Leg" then
						targetPart = v.Character:FindFirstChild("LeftUpperLeg") or v.Character:FindFirstChild("LeftLowerLeg")
					elseif Environment.Settings.LockPart == "Right Leg" then
						targetPart = v.Character:FindFirstChild("RightUpperLeg") or v.Character:FindFirstChild("RightLowerLeg")
					elseif Environment.Settings.LockPart == "Torso" then
						targetPart = v.Character:FindFirstChild("UpperTorso") or v.Character:FindFirstChild("LowerTorso")
					end
				end

				if targetPart and v.Character:FindFirstChildOfClass("Humanoid") then
					if Environment.Settings.TeamCheck and v.TeamColor == LocalPlayer.TeamColor then continue end
					if Environment.Settings.AliveCheck and v.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then continue end
					if Environment.Settings.WallCheck and #(Camera:GetPartsObscuringTarget({targetPart.Position}, v.Character:GetDescendants())) > 0 then continue end

					local Vector, OnScreen = Camera:WorldToViewportPoint(targetPart.Position); Vector = ConvertVector(Vector)
					local Distance = (UserInputService:GetMouseLocation() - Vector).Magnitude

					if Distance < RequiredDistance and OnScreen then
						RequiredDistance = Distance
						Environment.Locked = v
					end
				end
			end
		end
	elseif Environment.Locked.Character then
		local targetPart = Environment.Locked.Character:FindFirstChild(Environment.Settings.LockPart) or 
						  Environment.Locked.Character:FindFirstChild("HumanoidRootPart")
		if targetPart then
			if (UserInputService:GetMouseLocation() - ConvertVector(Camera:WorldToViewportPoint(targetPart.Position))).Magnitude > RequiredDistance then
				CancelLock()
			end
		else
			CancelLock()
		end
	end
end

-- Função para converter tecla pressionada em string
local function GetKeyString(Input)
	-- Botões do mouse
	if Input.UserInputType == Enum.UserInputType.MouseButton1 then return "MouseButton1" end
	if Input.UserInputType == Enum.UserInputType.MouseButton2 then return "MouseButton2" end
	if Input.UserInputType == Enum.UserInputType.MouseButton3 then return "MouseButton3" end
	
	-- Teclas do teclado
	if Input.KeyCode ~= Enum.KeyCode.Unknown then
		return tostring(Input.KeyCode):gsub("Enum.KeyCode.", "")
	end
	
	return nil
end

local function Load()
	OriginalSensitivity = UserInputService.MouseDeltaSensitivity

	ServiceConnections.RenderSteppedConnection = RunService.RenderStepped:Connect(function()
		if Environment.FOVSettings.Enabled and Environment.Settings.Enabled then
			Environment.FOVCircle.Radius = Environment.FOVSettings.Amount
			Environment.FOVCircle.Thickness = Environment.FOVSettings.Thickness
			Environment.FOVCircle.Filled = Environment.FOVSettings.Filled
			Environment.FOVCircle.NumSides = Environment.FOVSettings.Sides
			Environment.FOVCircle.Color = Environment.FOVSettings.Color
			Environment.FOVCircle.Transparency = Environment.FOVSettings.Transparency
			Environment.FOVCircle.Visible = Environment.FOVSettings.Visible
			Environment.FOVCircle.Position = Vector2new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
		else
			Environment.FOVCircle.Visible = false
		end

		-- MODO AUTOMÁTICO: Gruda sem precisar apertar nada
		if Environment.Settings.Auto and Environment.Settings.Enabled then
			Running = true
		end

		if Running and Environment.Settings.Enabled then
			GetClosestPlayer()

			if Environment.Locked and Environment.Locked.Character then
				local targetPart = Environment.Locked.Character:FindFirstChild(Environment.Settings.LockPart) or 
								  Environment.Locked.Character:FindFirstChild("HumanoidRootPart")

				if targetPart then
					if Environment.Settings.ThirdPerson then
						local Vector = Camera:WorldToViewportPoint(targetPart.Position)
						mousemoverel(
							(Vector.X - UserInputService:GetMouseLocation().X) * Environment.Settings.ThirdPersonSensitivity,
							(Vector.Y - UserInputService:GetMouseLocation().Y) * Environment.Settings.ThirdPersonSensitivity
						)
					else
						if Environment.Settings.Sensitivity > 0 then
							Animation = TweenService:Create(Camera, 
								TweenInfonew(Environment.Settings.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), 
								{CFrame = CFramenew(Camera.CFrame.Position, targetPart.Position)}
							)
							Animation:Play()
						else
							local TargetCFrame = CFramenew(Camera.CFrame.Position, targetPart.Position)
							Camera.CFrame = Camera.CFrame:Lerp(TargetCFrame, Environment.Settings.Smoothness)
						end

						UserInputService.MouseDeltaSensitivity = 0
					end

					Environment.FOVCircle.Color = Environment.FOVSettings.LockedColor
				end
			end
		end
	end)

	-- Sistema de aprendizado de teclas
	ServiceConnections.InputBeganConnection = UserInputService.InputBegan:Connect(function(Input)
		if not Typing then
			-- Se estiver em modo de aprendizado
			if Environment.Settings.Learning then
				local keyString = GetKeyString(Input)
				if keyString then
					Environment.Settings.TriggerKey = keyString
					Environment.Settings.Learning = false
					print("✅ Nova tecla do aimbot: " .. keyString)
				end
				return
			end

			-- Modo normal (sem aprendizado)
			if Environment.Settings.Auto then return end -- Modo automático ignora teclas

			local keyString = GetKeyString(Input)
			if keyString == Environment.Settings.TriggerKey then
				if Environment.Settings.Toggle then
					Running = not Running
					if not Running then CancelLock() end
				else
					Running = true
				end
			end
		end
	end)

	ServiceConnections.InputEndedConnection = UserInputService.InputEnded:Connect(function(Input)
		if not Typing and not Environment.Settings.Toggle and not Environment.Settings.Auto then
			local keyString = GetKeyString(Input)
			if keyString == Environment.Settings.TriggerKey then
				Running = false
				CancelLock()
			end
		end
	end)

	ServiceConnections.TypingStartedConnection = UserInputService.TextBoxFocused:Connect(function() Typing = true end)
	ServiceConnections.TypingEndedConnection = UserInputService.TextBoxFocusReleased:Connect(function() Typing = false end)
end

--// Functions
Environment.Functions = {}

function Environment.Functions:Exit()
	for _, v in next, ServiceConnections do v:Disconnect() end
	Environment.FOVCircle:Remove()
	getgenv().AirHub.Aimbot.Functions = nil
	getgenv().AirHub.Aimbot = nil
	Load = nil; ConvertVector = nil; CancelLock = nil; GetClosestPlayer = nil;
end

function Environment.Functions:Restart()
	for _, v in next, ServiceConnections do v:Disconnect() end
	Load()
end

function Environment.Functions:ResetSettings()
	Environment.Settings = {
		Enabled = false,
		TeamCheck = false,
		AliveCheck = true,
		WallCheck = false,
		Sensitivity = 0,
		Smoothness = 0.3,
		ThirdPerson = false,
		ThirdPersonSensitivity = 3,
		TriggerKey = "MouseButton2",
		Toggle = false,
		Auto = false,
		Learning = false,
		LockPart = "Head"
	}

	Environment.FOVSettings = {
		Enabled = true,
		Visible = true,
		Amount = 90,
		Color = Color3fromRGB(255, 255, 255),
		LockedColor = Color3fromRGB(255, 70, 70),
		Transparency = 0.5,
		Sides = 60,
		Thickness = 1,
		Filled = false
	}
end

setmetatable(Environment.Functions, { __newindex = warn })

--// Load
Load()

print("✅ Aimbot Ultra Completo carregado!")
print("🎯 Modo Automático | Aprender Tecla | Todas as partes")

return Environment
