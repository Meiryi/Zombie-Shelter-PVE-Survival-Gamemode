--[[
	EN :
	Zombie Shelter v2.0 by Meiryi / Meika / Shiro / Shigure
	You SHOULD NOT edit / modify / reupload the codes, it includes editing gamemode's name
	If you have any problems, feel free to contact me on steam, thank you for reading this

	ZH-TW :
	夜襲生存戰 v2.0 by Meiryi  / Meika / Shiro / Shigure
	任何的修改是不被允許的 (包括模式的名稱)，有問題請在Steam上聯絡我, 謝謝!
	
	ZH-CN :
	昼夜求生 v2.0 by Meiryi  / Meika / Shiro / Shigure
	任何形式的编辑是不被允许的 (包括模式的名称), 若有问题请在Steam上联络我
]]

local ClassName = "Engineer"

--ZShelter.AddSkills(ClassName, nil, nil, nil, 1, "beng", 1, "Basic Engineering", {})

ZShelter.AddSkills(ClassName, nil, nil,
	function(player, current)
		player:SetNWFloat("BuildingSpeed", player:GetNWFloat("BuildingSpeed", 1) + 0.35)
		player:SetNWFloat("oBuildingSpeed", player:GetNWFloat("BuildingSpeed", 1))
	end, 3, "bspeed", 1, "Build Speed Boost")

ZShelter.AddSkills(ClassName, nil, nil,
	function(player, current)
		player:SetNWFloat("ResCost", player:GetNWFloat("ResCost", 1) - 0.1)
	end, 2, "iblue", 1, "Improved Blueprint")
--[[
	ZShelter.AddSkills(ClassName, nil, nil,
		function(player, current)
			player:SetNWFloat("PowerCost", player:GetNWFloat("PowerCost", 1) - 0.15)
		end, 2, "eing", 1, "Electrical Engineering")
]]

ZShelter.AddSkills(ClassName, "OnMeleeDamage",
	function(attacker, victim, dmginfo, melee2)
		if(!IsValid(victim) || !victim:IsPlayer() || CLIENT) then return end
		local maxArmor = victim:GetMaxArmor()
		local gain = attacker:GetNWInt("ArmorRepairAmount", 7.5)
		victim:SetArmor(math.min(victim:Armor() + math.floor(gain), maxArmor))
	end,
	function(player, current)
		player:SetNWInt("ArmorRepairAmount", current * 7.5)
	end, 2, "armor_repair", 1, "Armor Repairing")

ZShelter.AddSkills(ClassName, nil, nil,
	function(player, current)
		player:SetNWFloat("TurretDamageScale", player:GetNWFloat("TurretDamageScale", 1) + 0.1)
		player:SetNWFloat("TurretDamageScaled", player:GetNWFloat("TurretDamageScale", 1))
	end, 3, "tdmg", 1, "Turret Damage Boost")

ZShelter.AddSkills(ClassName, nil, nil, nil, 1, "adve", 2, "Advanced Engineering", {})

ZShelter.AddSkills(ClassName, nil, nil,
	function(player, current)
		player:SetNWFloat("RepairSpeed", player:GetNWFloat("RepairSpeed", 1) + 0.15)
		player:SetNWFloat("oRepairSpeed", player:GetNWFloat("RepairSpeed", 1) + 0.15)
	end, 3, "rspd", 2, "Repair Speed Boost")

ZShelter.AddSkills(ClassName, "OnSecondPassed",
	function(player)
		if(!player.APCount) then
			player.APCount = 0
		end
		player.APCount = player.APCount + 1
		if(player.APCount <= 2) then return end
		local repair = 15 * player:GetNWFloat("AutoRepairSpeed", 1)
		for k,v in pairs(ents.FindInSphere(player:GetPos(), player:GetNWFloat("AutoRepairRadius", 0))) do
			if(!v.IsBuilding) then continue end
			if(v.LastDamageTime && v.LastDamageTime > CurTime()) then continue end
			ZShelter.BuildSystemNoScale(player, v, repair)
		end
		player.APCount = 0
	end,
	function(player, current)
		player:SetNWFloat("AutoRepairSpeed", player:GetNWFloat("AutoRepairSpeed", 0.8) + 0.2)
		player:SetNWFloat("AutoRepairRadius", player:GetNWFloat("AutoRepairRadius", 0) + 256)
	end, 3, "apar", 2, "Auto Repair")


ZShelter.AddSkills(ClassName, "OnGiveMelee",
	function(player)
		player:Give("tfa_zsh_cso_clawhammer")
	end,
	function(player)
		player:SetActiveWeapon(nil)
		ZShelter.ClearMelee(player)
		timer.Simple(0, function()
			local wep = ents.Create("tfa_zsh_cso_clawhammer")
				wep:Spawn()
				player:PickupWeapon(wep)
				player:SetActiveWeapon(wep)
		end)
		end, 1, "cham", 2, "Clawhammer Upgrade", {
		"Battle Axe Upgrade", "Crowbar Upgrade", "Machete Upgrade",
	})

ZShelter.AddSkills(ClassName, nil, nil,
	function(player, current)
		player:SetNWFloat("BuildingHPScale", player:GetNWFloat("BuildingHPScale", 1) + 0.1)
		local scale = current * 0.1
		for k,v in ipairs(ents.GetAll()) do
			if(!v.IsBuilding || v.Builder != player) then continue end
			local boost = math.floor((v.oMaxHealth || v:GetMaxHealth()) * scale)
			if(v:Health() >= v:GetMaxHealth()) then
				v:SetHealth(v.oMaxHealth + boost)
			end
			v:SetMaxHealth(v.oMaxHealth + boost)
			v:SetNWInt("oMaxHealth", v:GetMaxHealth())
		end
	end, 3, "bhb", 2, "Building Health Boost")

--ZShelter.AddSkills(ClassName, nil, nil, nil, 1, "eeng", 3, "Expert Engineering", {})

ZShelter.AddSkills(ClassName, "OnRepairBuildings",
	function(player, building, buildspeed)
		local repair = 45 * player:GetNWFloat("CRepairSpeed", 1)
		for k,v in pairs(ents.FindInSphere(player:GetPos(), player:GetNWFloat("CRepairRange", 86))) do
			if(!v.IsBuilding || v == building) then continue end
			ZShelter.BuildSystemNoScale(player, v, 20)
		end
	end,
	function(player)
		player:SetNWFloat("CRepairRange", player:GetNWFloat("CRepairRange", 0) + 86)
		player:SetNWFloat("CRepairSpeed", player:GetNWFloat("CRepairSpeed", 0.8) + 0.2)
	end, 2, "cpar", 3, "Chain Repair")

ZShelter.AddSkills(ClassName, "OnRepairBuildings",
	function(player, building, buildspeed)
		if(building:Health() < building:GetMaxHealth()) then return end
		building:SetHealth(math.Clamp(building:Health() + buildspeed, 0, building:GetMaxHealth() * player:GetNWFloat("OverhealScale", 1)))
		ZShelter.SyncHP(building, player)
		if(!ZShelter.OverhealList[building:EntIndex()]) then
			ZShelter.OverhealList[building:EntIndex()] = building
		end
	end,
	function(player)
		player:SetNWFloat("OverhealScale", player:GetNWFloat("OverhealScale", 1) + 0.25)
	end, 2, "oheal", 3, "Overheal")

ZShelter.AddSkills(ClassName, "OnBuildingDestroyed",
	function(player, building, wood, iron, power)
		local scale = player:GetNWFloat("RecycleScale", 0.2)
		ZShelter.CreateBackpack(building:GetNWVector("NoOffsetPos", building:GetPos()), math.floor(wood * scale), math.floor(iron * scale))
	end,
	function(player)
		player:SetNWFloat("RecycleScale", player:GetNWFloat("RecycleScale", 0) + 0.2)
	end, 3, "recyc", 2, "Recycle")

ZShelter.AddSkills(ClassName, "OnBuildingPlaced",
	function(player, building)
		if(building.Cate == "Trap") then return end
		local scl = player:GetNWFloat("QuickDeplayScale", 0.175)
		ZShelter.BuildSystemNoScale(player, building, (building:GetMaxHealth() * scl) + 1)
	end,
	function(player, current)
		player:SetNWFloat("QuickDeplayScale", current * 0.175)
	end, 2, "fastdeploy_eng", 2, "Quick Deploy")

ZShelter.AddSkills(ClassName, "OnBuildingDealDamage",
	function(building, dmginfo, victim)
		local ply = building:GetOwner()
		if(!building.IsTurret || !IsValid(victim) || !IsValid(ply) || !ply:IsPlayer()) then return end
		if(!building.SuppressionEnemies || !building.SuppressionEnemieTimings) then
			building.SuppressionEnemies = {}
			building.SuppressionEnemieTimings = {}
		end
		local index = victim:EntIndex()
		local time = building.SuppressionEnemieTimings[index] || 0
		if(time > CurTime()) then
			return
		end
		if(math.abs(time - CurTime()) > 2.5) then
			building.SuppressionEnemies[index] = 0
		end
		local scale = building.SuppressionEnemies[index] || 0
		if(scale > 0) then
			ZShelter.DealNoScaleDamage(ply, victim, dmginfo:GetDamage() * scale)
		end
		building.SuppressionEnemies[index] = math.min(scale + 0.04, ply:GetNWInt("SuppressionDamageScale", 0.25))
		building.SuppressionEnemieTimings[index] = CurTime() + 0.2
	end,
	function(player, current)
		player:SetNWFloat("SuppressionDamageScale", current * 0.25)
	end, 2, "targetfire", 2, "Precision Suppression")

ZShelter.AddSkills(ClassName, "ShouldUseStorage",
	function(player, buildingdata)
		local woods = player:GetNWInt("Woods", 0)
		local irons = player:GetNWInt("Irons", 0)

		if(woods < buildingdata.woods || irons < buildingdata.irons) then
			return true
		end
	end, nil, 1, "drone", 3, "Transporting Drone")

ZShelter.AddSkills(ClassName, "OnBuildingDestroyed",
	function(player, building, wood, iron, power)
		if(!building.IsTurret || !building:GetNWBool("Completed")) then return end
		local damage = math.min((building:GetMaxHealth() * 0.5), 300) * player:GetNWFloat("SDDamage", 1)
		for k,v in pairs(ents.FindInSphere(building:GetPos(), 128)) do
			if(!ZShelter.ValidateEntity(building, v)) then continue end
			ZShelter.DealNoScaleDamage(player, v, damage)
		end
		local e = EffectData()
			e:SetOrigin(building:GetPos())
		util.Effect("Explosion", e)
		sound.Play("npc/roller/mine/rmine_explode_shock1.wav", building:GetPos())
	end,
	function(player)
		player:SetNWFloat("SDDamage", player:GetNWFloat("SDDamage", 0.5) + 0.5)
	end, 2, "sdr", 3, "Self Destruction")

ZShelter.AddSkills(ClassName, "OnBuildingTakeDamage",
	function(player, building, attacker, damage)
		if(!IsValid(attacker) || !building.IsTurret || attacker:IsPlayer()) then return end
		local dmg = player:GetNWFloat("DRDamage", 5)
		local dmgscale = player:GetNWInt("DRDamageScale", 0.25) * damage
		ZShelter.DealNoScaleDamage(player, attacker, dmgscale)
		if(building.LastAOEDamageTime && building.LastAOEDamageTime > CurTime()) then return end
		for k,v in ipairs(ents.FindInSphere(building:GetPos(), 64)) do
			if(!ZShelter.ValidateTarget(v) || v == attacker || v.IsBuilding) then continue end
			ZShelter.DealNoScaleDamage(player, v, dmg)
		end
		building.LastAOEDamageTime = CurTime() + 1
	end,
	function(player)
		player:SetNWFloat("DRDamage", player:GetNWFloat("DRDamage", 0) + 5)
		player:SetNWFloat("DRDamageScale", player:GetNWFloat("DRDamageScale", 0) + 0.25)
	end, 4, "thorns", 3, "Damage Reflection")

local material = Material("zsh/icon/armor.png")
ZShelter.AddSkills(ClassName, "MultipleHook",
	{
		OnTurretsChanged = function(player)
			local st = SysTime()
			local max = player:GetNWFloat("DefenseMul", 0.2)
			for _, v in pairs(ZShelter.TrackedTurrets) do
				if(!v.Builder == player) then continue end
				v.DefenseMul = 0
				local pos = v:GetPos()
				for _, ent in pairs(ZShelter.TrackedTurrets) do
					if(v.DefenseMul >= max || ent.Builder != player || ent == v) then continue end
					if(ent:GetPos():Distance(pos) < 200) then
						v.DefenseMul = v.DefenseMul + 0.05
					end
				end
				v.DefenseMul = math.min(v.DefenseMul, max)
				v:SetNWFloat("DefenseMul", v.DefenseMul)
			end
		end,
		OnBuildingTakeDamage = function(player, building, attacker, damage)
			local mul = building.DefenseMul || 0
			if(mul == 0) then return end
			local regen = damage * mul
			if(building:Health() > building:GetMaxHealth()) then return end
			building:SetHealth(building:Health() + regen)
		end,
		OnHUDPaint = function()
			local turret = LocalPlayer():GetEyeTrace().Entity
			if(!turret:GetNWBool("IsTurret") || turret:GetPos():Distance(LocalPlayer():GetPos()) > 768) then return end
			local pos = (turret:GetPos() + turret:OBBCenter()):ToScreen()
			local x, y = pos.x, pos.y
			local size = ScreenScaleH(14)
			surface.SetMaterial(material)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRect(x - size * 0.5, y - size * 0.5, size, size)
			local def = math.Round(turret:GetNWFloat("DefenseMul", 0) * 100, 2)
			draw.DrawText(def.."%", "ZShelter-HUDElemFont", x, y + size * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			for k,v in ipairs(ents.FindInSphere(turret:GetPos(), 200)) do
				if(!v:GetNWBool("IsBuilding") || !v:GetNWBool("IsTurret")) then continue end
				local pos = (v:GetPos() + v:OBBCenter()):ToScreen()
				local _x, _y = pos.x, pos.y
				surface.DrawLine(x, y, _x, _y)
				surface.DrawTexturedRect(_x - size * 0.5, _y - size * 0.5, size, size)
			end
			cam.Start3D()
				local bounds = Vector(200, 200, 1)
				render.SetColorMaterial()
				render.DrawBox(turret:GetPos(), angle_zero, -bounds, bounds, Color(235, 120, 50, 10), true)
			cam.End3D()
		end,
	},
	function(player, current)
		player:SetNWFloat("DefenseMul", current * 0.25)
	end, 2, "matrix", 3, "Defense Matrix")

ZShelter.AddSkills(ClassName, "OnSkillCalled",
	function(player)
		player:Give("zsh_shelter_c4")
	end, nil, 1, "c4", 4, "C4", nil, 45)

ZShelter.AddSkills(ClassName, "OnSkillCalled",
	function(player)
		local index = bit.tohex(math.random(1, 10240), 4)
		local ktime = CurTime() + 10
		local fixinterval = 0
		if(!player.Callbacks.OnSecondPassed) then
			player.Callbacks.OnSecondPassed = {}
		end
		player.Callbacks.OnSecondPassed[index] = function()
			if(ktime < CurTime() || !player:Alive()) then
				player.Callbacks.OnSecondPassed[index] = nil
				return
			end
			for k,v in pairs(ents.FindInSphere(player:GetPos(), 380)) do
				if(!v.IsBuilding) then continue end
				ZShelter.BuildSystemNoScale(player, v, 250)
				ZShelter.SyncHP(v, player)
			end
		end
	end, nil, 1, "raura", 4, "Repair Aura", nil, 60)