dm skys#9826 on discord if you need any credits
if not isfile("KavoConfig.JSON") then writefile("LunarConfig.JSON","{}")
end
local LunarWindow = loadstring(game:HttpGet("https://raw.githubusercontent.com/skyswastaken/SytroNight4ROBLOX/main/libraries/kavo.lua"))()
local window = LunarWindow.CreateLib("Lunar Client V1.0", "DarkTheme")
local entity = loadstring(game:HttpGet("https://raw.githubusercontent.com/Trix-decoder/Vape-Entity-Fix/main/Vxpe-Fix", true))() -- thanks kvng for letting me borrow this
repeat task.wait() until (entity.isAlive)

local players = game:GetService("Players")
local lplr = players.LocalPlayer
local oldchar = lplr.Character
local cam = workspace.CurrentCamera
local uis = game:GetService("UserInputService")
local KnitClient = debug.getupvalue(require(game.Players.LocalPlayer.PlayerScripts.TS.knit).setup, 6)
local Client = require(game:GetService("ReplicatedStorage").TS.remotes).default.Client
local InventoryUtil = require(game:GetService("ReplicatedStorage").TS.inventory["inventory-util"]).InventoryUtil
local itemstuff = debug.getupvalue(require(game:GetService("ReplicatedStorage").TS.item["item-meta"]).getItemMeta, 1)
local RenderStepTable = {}
local StepTable = {}
local connectioninfjump
local killauraswing = {["Enabled"] = true}
local killaurasound = {["Enabled"] = true}
local killaurahitdelay = {["Value"] = 2}
local killaurasoundval = {["Value"] = 1}
local speedval = {["Value"] = 1}
local testtogttt = {["Value"] = 20}
local ACC1
local ACC2
local antivoidtransparent = {["Value"] = 50}
local antivoidcolor = {["Hue"] = 0.93, ["Sat"] = 1, ["Value"] = 1}
local reachval = {["Value"] = 18}
local autoclick = {["Enabled"] = true}
local origC0 = game.ReplicatedStorage.Assets.Viewmodel.RightHand.RightWrist.C0
local killaurafirstpersonanim = {["Value"] = true}
local killauraanimval = {["Value"] = "Cool"}

local SprintCont = KnitClient.Controllers.SprintController
local SwordCont = KnitClient.Controllers.SwordController
local KnockbackTable = debug.getupvalue(require(game:GetService("ReplicatedStorage").TS.damage["knockback-util"]).KnockbackUtil.calculateKnockbackVelocity, 1)
local ClientHandler = Client

local function GetURL(scripturl)
	return game:HttpGet("https://raw.githubusercontent.com/skyswastaken/Juul4Roblox/main/"..scripturl, true)
end

local function isAlive(plr)
	if plr then
		return plr and plr.Character and plr.Character.Parent ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid")
	end
	return lplr and lplr.Character and lplr.Character.Parent ~= nil and lplr.Character:FindFirstChild("HumanoidRootPart") and lplr.Character:FindFirstChild("Head") and lplr.Character:FindFirstChild("Humanoid")
end

local function runcode(func)
	func()
end

local function playsound(id, volume) 
	local sound = Instance.new("Sound")
	sound.Parent = workspace
	sound.SoundId = id
	sound.PlayOnRemove = true 
	if volume then 
		sound.Volume = volume
	end
	sound:Destroy()
end

local function playanimation(id) 
	if isAlive() then 
		local animation = Instance.new("Animation")
		animation.AnimationId = id
		local animatior = lplr.Character.Humanoid.Animator
		animatior:LoadAnimation(animation):Play()
	end
end

function isNumber(str)
	if tonumber(str) ~= nil or str == 'inf' then
		return true
	end
end

function getinv(plr)
	local plr = plr or lplr
	local thingy, thingytwo = pcall(function() return InventoryUtil.getInventory(plr) end)
	return (thingy and thingytwo or {
		items = {},
		armor = {},
		hand = nil
	})
end

function getsword()
	local sd
	local higherdamage
	local swordslots
	local swords = getinv().items
	for i, v in pairs(swords) do
		if v.itemType:lower():find("sword") or v.itemType:lower():find("blade") then
			if higherdamage == nil or itemstuff[v.itemType].sword.damage > higherdamage then
				sd = v
				higherdamage = itemstuff[v.itemType].sword.damage
				swordslots = i
			end
		end
	end
	return sd, swordslots
end

local itemtab = debug.getupvalue(require(game:GetService("ReplicatedStorage").TS.item["item-meta"]).getItemMeta, 1)
local function getEquipped()
	local typetext = ""
	local obj = (entity.isAlive and lplr.Character:FindFirstChild("HandInvItem") and lplr.Character.HandInvItem.Value or nil)
	if obj then
		if obj.Name:find("sword") or obj.Name:find("blade") or obj.Name:find("baguette") or obj.Name:find("scythe") or obj.Name:find("dao") then
			typetext = "sword"
		end
		if obj.Name:find("wool") or itemtab[obj.Name]["block"] then
			typetext = "block"
		end
		if obj.Name:find("bow") then
			typetext = "bow"
		end
	end
	return {["Object"] = obj, ["Type"] = typetext}
end

local function getremote(tab)
	for i,v in pairs(tab) do
		if v == "Client" then
			return tab[i + 1]
		end
	end
	return ""
end

local function hvFunc(cock)
	return {hashedval = cock}
end

local function targetCheck(plr, check)
	return (check and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("ForceField") == nil or check == false)
end

local function isPlayerTargetable(plr, target)
	return plr ~= lplr and plr and isAlive(plr) and targetCheck(plr, target)
end

local function GetAllNearestHumanoidToPosition(distance, amount)
	local returnedplayer = {}
	local currentamount = 0
	if entity.isAlive then -- alive check
		for i, v in pairs(game.Players:GetChildren()) do -- loop through players
			if isPlayerTargetable((v), true, true, v.Character ~= nil) and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") and currentamount < amount then -- checks
				local mag = (lplr.Character.HumanoidRootPart.Position - v.Character:FindFirstChild("HumanoidRootPart").Position).magnitude
				if mag <= distance then -- mag check
					table.insert(returnedplayer, v)
					currentamount = currentamount + 1
				end
			end
		end
		for i2,v2 in pairs(game:GetService("CollectionService"):GetTagged("Monster")) do -- monsters
			if v2:FindFirstChild("HumanoidRootPart") and currentamount < amount and v2.Name ~= "Duck" then -- no duck
				local mag = (lplr.Character.HumanoidRootPart.Position - v2.HumanoidRootPart.Position).magnitude
				if mag <= distance then -- magcheck
					table.insert(returnedplayer, {Name = (v2 and v2.Name or "Monster"), UserId = 1443379645, Character = v2}) -- monsters are npcs so I have to create a fake player for target info
					currentamount = currentamount + 1
				end
			end
		end
	end
	return returnedplayer -- table of attackable entities
end

local function BindToRenderStep(name, num, func)
	if RenderStepTable[name] == nil then
		RenderStepTable[name] = game:GetService("RunService").RenderStepped:connect(func)
	end
end
local function UnbindFromRenderStep(name)
	if RenderStepTable[name] then
		RenderStepTable[name]:Disconnect()
		RenderStepTable[name] = nil
	end
end

local function BindToStepped(name, num, func)
	if StepTable[name] == nil then
		StepTable[name] = game:GetService("RunService").Stepped:connect(func)
	end
end
local function UnbindFromStepped(name)
	if StepTable[name] then
		StepTable[name]:Disconnect()
		StepTable[name] = nil
	end
end

local attackentitycont = Client:Get(getremote(debug.getconstants(getmetatable(KnitClient.Controllers.SwordController)["attackEntity"])))
local rgfejd = false
local DistVal = {["Value"] = 18}
local equipped = getEquipped()
function KillauraRemote()
	for i,v in pairs(game.Players:GetChildren()) do
		if v.Character and v.Name ~= game.Players.LocalPlayer.Name and v.Character:FindFirstChild("HumanoidRootPart") then
			local mag = (v.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
			if mag <= DistVal["Value"] and v.Team ~= game.Players.LocalPlayer.Team and v.Character:FindFirstChild("Humanoid") then
				if v.Character.Humanoid.Health > 0 then
					rgfejd = true
					local sword = (equipped.Object and (equipped.Object.Name == "frying_pan" or equipped.Object.Name == "baguette") and {tool = equipped.Object} or getsword())
					local selfPosition = lplr.Character.HumanoidRootPart.Position + (DistVal["Value"] > 14 and (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude > 14 and (CFrame.lookAt(lplr.Character.HumanoidRootPart.Position, v.Character.HumanoidRootPart.Position).lookVector * 4) or Vector3.new(0, 0, 0))
					local Entity = v.Character
					local target = v.Character:GetPrimaryPartCFrame().Position
					local attacksuccess = attackentitycont:CallServer({
						["chargedAttack"] = {["chargeRatio"] = 1},
						["weapon"] = sword["tool"],
						["entityInstance"] = Entity,
						["validate"] = {["targetPosition"] = {["value"] = target,
							["hash"] = hvFunc(target)},
						["raycast"] = {
							["cameraPosition"] = hvFunc(cam.CFrame.Position), 
							["cursorDirection"] = hvFunc(Ray.new(cam.CFrame.Position, v.Character:GetPrimaryPartCFrame().Position).Unit.Direction)
						},
						["selfPosition"] = {["value"] = selfPosition,
							["hash"] = hvFunc(selfPosition)
						}
						}
					})
					if attacksuccess and itemtab[sword["tool"].Name].sword.respectAttackSpeedOnServer then 
						killaurahitdelay = tick() + itemtab[sword["tool"].Name].sword.attackSpeed
					end
					if killaurahitdelay > tick() then 
						return nil
					end
					if killaurasound["Enabled"] then
						playsound("rbxassetid://6760544639", killaurasoundval["Value"])
					end
					if killauraswing["Enabled"] then
						playanimation("rbxassetid://4947108314")
					end
				end
			else
				rgfejd = false
			end
		end
	end
end

local CombatConstant = require(game:GetService("ReplicatedStorage").TS.combat["combat-constant"]).CombatConstant
local Credits = window:NewTab("Credits")
local Combat = window:NewTab("Combat")
local Blatant = window:NewTab("Blatant")
local Render = window:NewTab("Render")
local Utility = window:NewTab("Utility")
local World = window:NewTab("World")
local GUI = window:NewTab("GUI")
local Reach = Combat:NewSection("Reach")
Reach:NewToggle("Reach", "Extend your attack range", function(state)
	if state then
		CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE = (reachval["Value"] - 0.0001)
	else
		CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE = 14.4
	end
end)
local Sprint = Combat:NewSection("Sprint")
Sprint:NewToggle("Sprint", "idk", function(state)
	if state then
		BindToStepped("Sprint", 1, function()
			if SprintCont.sprinting == false then
				SprintCont:startSprinting()
			end
		end)
	else
		UnbindFromStepped("Sprint")
		SprintCont:stopSprinting()
	end
end)
local NoFall = Combat:NewSection("NoFallDamage")
NoFall:NewToggle("NoFall", "Prevents taking fall damage", function(state)
	if state then
		local NoFall = {["Enabled"] = true}
		local oldfall

		spawn(function()
			repeat task.wait(0.5)
				ClientHandler:Get("GroundHit"):SendToServer()
			until NoFall["Enabled"] == false
		end)
	end
end)
local Velocity = Combat:NewSection("Velocity")
Velocity:NewToggle("Velocity", "Prevents taking kb", function(state)
	if state then
		KnockbackTable["kbDirectionStrength"] = 0
		KnockbackTable["kbUpwardStrength"] = 0
	else
		KnockbackTable["kbDirectionStrength"] = 100
		KnockbackTable["kbUpwardStrength"] = 100
	end
end)
local Aura = Blatant:NewSection("KillAura")
Aura:NewToggle("Aura", "yes", function(state)
	if state then
		while wait(1/16) do
if state == false then break end
			if entity.isAlive then
				KillauraRemote()
			end
		end
	end
end)
Aura:NewSlider("Distance ", "Increase killaura distance", 100, 1, function(val)
	DistVal["Value"] = val
end)
Aura:NewToggle("No Swing", "Disable killaura swing", function(state)
	if state then
		if killauraswing["Enabled"] == true then
			killauraswing["Enabled"] = false
		end
	else
		if killauraswing["Enabled"] == false then
			killauraswing["Enabled"] = true
		end
	end
end)
Aura:NewSlider("Sound 1-0", "Adjust killaura sound", 1, 0, function(val)
	killaurasoundval["Value"] = val
end)
local Infjump = Blatant:NewSection("InfJump")
Infjump:NewToggle("Infjump", "Allows you to hold space to fly up", function(state)
	if state then
		local InfJump = {["Enabled"] = true}
		connectioninfjump = uis.JumpRequest:connect(function(jump)
			if InfJump["Enabled"] then
				lplr.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
			end
		end)
	else
		connectioninfjump:Disconnect()
	end
end)

runcode(function()
	local wall = nil
	local spiderspeed = {["Value"] = 0}
	local Spider = Blatant:NewSection("Spider")
	Spider:NewToggle("Spider", "Allows you to climb up walls", function(state)
		if state then
			BindToStepped("Spider", 1, function()
				local raycastparameters = RaycastParams.new()
				raycastparameters.FilterDescendantsInstances = {lplr.Character}
				local ray = workspace:Raycast(lplr.Character.Humanoid.LeftLeg.Position, lplr.Character.HumanoidRootPart.CFrame.LookVector * 1.3, raycastparameters)

				wall = ray and ray.Instance or nil
				if wall then
					lplr.Character.HumanoidRootPart.Velocity = Vector3.new(lplr.Character.HumanoidRootPart.Velocity.X or 0, spiderspeed["Value"], lplr.Character.HumanoidRootPart.Velocity.Z or 0)

					if lplr.Character.Humanoid:GetState() ~= Enum.HumanoidStateType.Climbing then
						lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
					end
				end
			end)
		else
			UnbindFromStepped("Spider")
		end
	end)
	Spider:NewSlider("Speed", "Adjust spider speed", 100, 0, function(val) -- 500 (MaxValue) | 0 (MinValue)
		spiderspeed["Value"] = val
	end)
end)
local FixCam = Utility:NewSection("FixCam/RestoreCam")
FixCam:NewButton("FixCam", "fix cam bug on mobile", function()
	cam.CameraType = Enum.CameraType.Fixed
	cam.CameraType = Enum.CameraType.Custom
end)
local AntiVoid = World:NewSection("AntiVoid")
AntiVoid:NewToggle("AntiVoid", "no void", function(state)
	if state then
		antivoidp = Instance.new("Part", workspace)
		antivoidp.Name = "AntiVoid"
		antivoidp.CanCollide = true
		antivoidp.Size = Vector3.new(2048, 1, 2048)
		antivoidp.Anchored = true
		antivoidp.Transparency = 1 - (antivoidtransparent["Value"] / 100)
		antivoidp.Material = Enum.Material.Neon
		antivoidp.Color = Color3.fromHSV(antivoidcolor["Hue"], antivoidcolor["Sat"], antivoidcolor["Value"])
		antivoidp.Position = Vector3.new(0, 23.5, 0)
		antivoidp.Touched:connect(function(touchedvoid)
			if touchedvoid.Parent:FindFirstChild("Humanoid") and touchedvoid.Parent.Name == lplr.Name then
				lplr.Character.Humanoid.Jump = true
				lplr.Character.Humanoid:ChangeState("Jumping")
				wait(0.2)
				lplr.Character.Humanoid:ChangeState("Jumping")
				wait(0.2)
				lplr.Character.Humanoid:ChangeState("Jumping")
			end
		end)
	else
		if antivoidp then
			antivoidp:Remove()
		end
	end
end)
local UI = UI:NewSection("Colors")
for theme, color in pairs(colors) do
	UI:NewColorPicker(theme, "Change your "..theme, color, function(color3)
		kavoUi:ChangeColor(theme, color3)
	end)
end

