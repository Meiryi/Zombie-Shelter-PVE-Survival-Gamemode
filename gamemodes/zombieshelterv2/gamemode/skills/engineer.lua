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
		player:SetNWFloat("BuildingSpeed", player:GetNWFloat("BuildingSpeed", 1) + 0.45)
		player:SetNWFloat("oBuildingSpeed", player:GetNWFloat("BuildingSpeed", 1))
	end, 4, "bspeed", 1, "Build Speed Boost")

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
		player:Give("zsh_shelter_clawhammer")
	end,
	function(player)
		player:SetActiveWeapon(nil)
		ZShelter.ClearMelee(player)
		timer.Simple(0, function()
			local wep = ents.Create("zsh_shelter_clawhammer")
				wep:Spawn()
				player:PickupWeapon(wep)
				player:SetActiveWeapon(wep)
		end)
		end, 1, "cham", 2, "Clawhammer Upgrade", {
		"Crowbar Upgrade", "Machete Upgrade",
	})

ZShelter.AddSkills(ClassName, nil, nil,
	function(player, current)
		player:SetNWFloat("BuildingHPScale", player:GetNWFloat("BuildingHPScale", 1) + 0.1)
		player:SetNWFloat("BuildingHPScale", player:GetNWFloat("BuildingHPScale", 1))
	end, 3, "bhb", 2, "Building Health Boost")

--ZShelter.AddSkills(ClassName, nil, nil, nil, 1, "eeng", 3, "Expert Engineering", {})

ZShelter.AddSkills(ClassName, "OnRepairBuildings",
	function(player, building, buildspeed)
		local repair = 15 * player:GetNWFloat("CRepairSpeed", 1)
		for k,v in pairs(ents.FindInSphere(player:GetPos(), player:GetNWFloat("AutoRepairRadius", 0))) do
			if(!v.IsBuilding || v == building) then continue end
			ZShelter.BuildSystemNoScale(player, v, 20)
		end
	end,
	function(player)
		player:SetNWFloat("CRepairRange", player:GetNWFloat("CRepairRange", 64) + 64)
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
		if(!building.IsTurret) then return end
		local damage = math.min((building:GetMaxHealth() * 0.4), 150) * player:GetNWFloat("SDDamage", 1)
		for k,v in pairs(ents.FindInSphere(building:GetPos(), 128)) do
			if(!ZShelter.ValidateEntity(building, v)) then continue end
			v:TakeDamage(damage, building.Builder, building.Builder)
		end
		sound.Play("npc/roller/mine/rmine_explode_shock1.wav", building:GetPos())
	end,
	function(player)
		player:SetNWFloat("SDDamage", player:GetNWFloat("SDDamage", 0.5) + 0.5)
	end, 2, "sdr", 3, "Self Destruction")

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