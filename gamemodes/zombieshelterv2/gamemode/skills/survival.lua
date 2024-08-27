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

local ClassName = "Survival"

ZShelter.AddSkills(ClassName, nil, nil,
	function(player, current)
		player:SetNWFloat("MovementSpeed", player:GetNWFloat("MovementSpeed", 250) + 50)
		player:SetNWFloat("oMovementSpeed", player:GetNWFloat("MovementSpeed", 250))
	end, 2, "sboost", 1, "Speed Boost")

ZShelter.AddSkills(ClassName, nil, nil,
	function(player, current)
		player:SetNWFloat("SanityCost", player:GetNWFloat("SanityCost", 1.5) - 0.2)
	end, 3, "saboost", 1, "Sanity Boost")

local wood = Material("zsh/icon/woods_white.png", "smooth")
local iron = Material("zsh/icon/irons_white.png", "smooth")
local matTable = {
	["Woods"] = wood,
	["Irons"] = iron,
}
ZShelter.AddSkills(ClassName, "OnHUDPaint",
	function(player)
		local sx = ScreenScaleH(24)
		for k,v in pairs(ents.GetAll()) do
			if(!v:GetNWBool("IsResource", false)) then continue end
			if(!v.__alpha) then v.__alpha = 0 end
			local mat = matTable[v:GetNWString("ResourceType", "")]
			if(!mat) then continue end
			if(v:GetPos():Distance(player:GetPos()) > 1500) then
				v.__alpha = math.Clamp(v.__alpha - ZShelter.GetFixedValue(15), 0, 255)
			else
				v.__alpha = math.Clamp(v.__alpha + ZShelter.GetFixedValue(15), 0, 255)
			end
			surface.SetDrawColor(255, 255, 255, v.__alpha)
			surface.SetMaterial(mat)
			local pos = v:GetPos():ToScreen()
			surface.DrawTexturedRect(pos.x - sx * 0.5, pos.y - sx * 0.5, sx, sx)
		end
	end, nil, 1, "reswallhack", 1, "Resource Rader")

ZShelter.AddSkills(ClassName, nil, nil,
	function(player, current)
		player:SetNWFloat("TrapRepairSpeed", player:GetNWFloat("TrapRepairSpeed", 1) + 0.25)
	end, 2, "fastrepa", 1, "Fast Repair")

ZShelter.AddSkills(ClassName, nil, nil,
	function(player, current)
		player:SetNWFloat("TrapDamageScale", player:GetNWFloat("TrapDamageScale", 1) + 0.4)
	end, 2, "trapdmg", 1, "Trap Damage Boost")

ZShelter.AddSkills(ClassName, nil, nil,
	function(player, current)
		player:SetNWFloat("ResourceCapacity", player:GetNWFloat("ResourceCapacity", 24) + 7)
	end, 2, "cc", 1, "Increased Capacity")

ZShelter.AddSkills(ClassName, "OnGiveMelee",
	function(player)
		player:Give("zsh_shelter_crowbar")
	end,
	function(player)
		player:SetActiveWeapon(nil)
		ZShelter.ClearMelee(player)
		timer.Simple(0, function()
			local wep = ents.Create("zsh_shelter_crowbar")
				wep:Spawn()
				player:PickupWeapon(wep)
				player:SetActiveWeapon(wep)
		end)
	end, 1, "crowbar", 2, "Crowbar Upgrade", {
		"Clawhammer Upgrade", "Machete Upgrade",
	})

ZShelter.AddSkills(ClassName, nil, nil, nil, 1, "cm", 2, "Claymore", {})

ZShelter.AddSkills(ClassName, nil, nil, nil, 1, "cf", 2, "Campfire", {})

ZShelter.AddSkills(ClassName, "OnGatheringResources",
	function(player, resource, type, amount, full)
		local seed = math.random(1, 100)
		if(seed <= player:GetNWInt("DoubleGatheringChance", 10) || player.GatheringCount >= 5) then
			ZShelter.AddResourceToPlayer(player, type, amount)
			if(full && player:GetNWInt("SK_Resource Transporting", 0) >= 1) then
				SetGlobalInt(type, math.min(GetGlobalInt(type, 0) + amount, GetGlobalInt("Capacity", 32)))
			end
			player.GatheringCount = 0
		else
			player.GatheringCount = player.GatheringCount + 1
		end
	end,
	function(player)
		player:SetNWInt("DoubleGatheringChance", player:GetNWInt("DoubleGatheringChance", 0) + 10)
		player.GatheringCount = 0
	end, 2, "advg", 2, "Advanced Gathering")

ZShelter.AddSkills(ClassName, nil, nil,
	function(player, current)
		player:SetNWFloat("TrapHPScale", player:GetNWFloat("TrapHPScale", 1) + 0.35)
	end, 3, "reinfortrap", 2, "Reinforced Traps")

--[[
ZShelter.AddSkills(ClassName, nil, nil,
	function(player, current)
		player:SetNWFloat("DamageResistance_Trap", player:GetNWFloat("DamageResistance_Trap", 1) - 0.1)
	end, 4, "", 2, "Reinforced Traps")
]]

--[[
ZShelter.AddSkills(ClassName, "OnBuildingPlaced",
	function(player, building)
		if(building.Cate != "Trap") then return end
		local scl = player.TrapPrebuildAmount || 0
		ZShelter.BuildSystemNoScale(player, building, (building:GetMaxHealth() * scl) + 1)
	end,
	function(player, current)
		player.TrapPrebuildAmount = current * 0.5
	end, 2, "fastdepl", 3, "Fast Deploy")
]]

ZShelter.AddSkills(ClassName, "OnGatheringResources",
	function(player, resource, type, amount, full, nocallback)
		if(nocallback) then return end
		local dst = player:GetNWFloat("GatheringRadius", 80)
		for k,v in pairs(ZShelter.ResourceList) do
			if(!IsValid(v) || v == resource) then continue end
			if(v:GetPos():Distance(player:GetPos()) > dst) then continue end
			ZShelter.GatheringSystem(player, v, true)
		end
	end,
	function(player)
		player:SetNWFloat("GatheringRadius", player:GetNWFloat("GatheringRadius", 0) + 85)
	end, 2, "cgth", 3, "Chain Gathering")

ZShelter.AddSkills(ClassName, "OnGatheringResources",
	function(player, resource, type, amount, full, nocallback)
		if(nocallback) then return end
		ZShelter.GatheringSystem(player, resource, true)
	end, nil, 1, "haste", 3, "Haste")

ZShelter.AddSkills(ClassName, "OnGatheringResources",
	function(player, resource, type, amount, full, nocallback)
		if(!full) then return end
		local current = GetGlobalInt(type, 0)
		local capacity = GetGlobalInt("Capacity", 16)
		if(current >= capacity) then return end
		player:AddFrags(amount * 3)
		SetGlobalInt(type, math.min(current + amount, capacity))

		resource.Amount = resource.Amount - 1
		if(resource.Amount <= 0) then
			resource:Remove()
		end
	end, nil, 1, "restrans", 3, "Resource Transporting")

ZShelter.AddSkills(ClassName, "OnTrapDetonate",
	function(player, trapent)
		local count = trapent.ExplodeCount || 1
		local max = player.MineExplodeCount || 0
		trapent:NextThink(CurTime() + 0.5)
		trapent.ExplodeCount = count + 1
		if(count <= max) then
			return true
		end
	end,
	function(player, current)
		player.MineExplodeCount = current
	end, 2, "demoexpert", 3, "Demolitions Specialist")

ZShelter.AddSkills(ClassName, "OnRepairingTraps",
	function(player, trapent)
		local repair = player:GetNWFloat("TrapRepairSpeed", 1) * 5
		for k,v in pairs(ents.FindInSphere(player:GetPos(), player.TrapRepairRadius || 86)) do
			if(!v.IsTrap) then continue end
			v:SetHealth(math.min(v:Health() + repair, v:GetMaxHealth()))
		end
	end,
	function(player, current)
		player.TrapRepairRadius = current * 86
	end, 2, "cr_survival", 3, "Slick Repairing")

ZShelter.AddSkills(ClassName, "OnSkillCalled",
	function(player)
		local e = EffectData()
			e:SetOrigin(player:GetPos() + Vector(0, 0, 1))
		util.Effect("VortDispel", e)
		sound.Play("shigure/stunwave.wav", e:GetOrigin(), 120, 100, 3)
		sound.Play("shigure/stunwave.wav", e:GetOrigin(), 120, 100, 3)
		for k,v in pairs(ents.FindInSphere(player:GetPos(), 400)) do
			if(!ZShelter.ValidateEntity(player, v)) then continue end
			v:NextThink(CurTime() + 10)
			local e = EffectData()
				e:SetEntity(v)
				e:SetMagnitude(5)
				util.Effect("TeslaHitboxes", e)
		end
	end, nil, 1, "stunw", 4, "Stunwave", nil, 25)

ZShelter.AddSkills(ClassName, "OnSkillCalled",
	function(player)
		local turret = ents.Create("npc_vj_zshelter_mini_turret")
			turret:Spawn()
			turret:SetPos(util.QuickTrace(player:GetPos(), Vector(0, 0, -1024), {turret, player}).HitPos)
			turret:SetOwner(player)
			turret:SetMaxHealth(2000)
			turret:SetHealth(2000)
	end, nil, 1, "tturret", 4, "Temporary Turret", nil, 35)
