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

ZShelter.OverhealList =  ZShelter.OverhealList || {}

util.AddNetworkString("ZShelter_BuildRequest")
util.AddNetworkString("ZShelter_SyncBuildingHP")

function ZShelter.SyncHP(building, player)
	net.Start("ZShelter_SyncBuildingHP")
	net.WriteInt(building:EntIndex(), 32)
	net.WriteInt(building:Health(), 32)
	net.Send(player)
end

function ZShelter.StunBuilding(building, time, bypass)
	if(!building.IsTurret || building:Health() > building:GetMaxHealth() || building:GetNWFloat("StunTime", 0) > CurTime()) then if(!bypass) then return end end
	building:NextThink(CurTime() + time)
	building:SetNWFloat("StunTime", CurTime() + time)
end

function ZShelter.ApplyDamageNerf(building, time)
	building.DamageNerfTime = CurTime() + time
	local e = EffectData()
		e:SetOrigin(building:GetPos() + Vector(0, 0, building:OBBMaxs().z + 36))
		e:SetEntity(building)
		util.Effect("zshelter_atknerf", e)
end

function ZShelter.RemoveStun(building)
	if(GetGlobalInt("Powers", 0) < 0) then return end
	building:NextThink(CurTime())
	building:SetNWFloat("StunTime", 0)
end

local gibsCollideSound = {"vj_hlr/fx/metal1.wav", "vj_hlr/fx/metal2.wav", "vj_hlr/fx/metal3.wav", "vj_hlr/fx/metal4.wav", "vj_hlr/fx/metal5.wav"}
local gibs = {
	"models/vj_hlr/gibs/metalgib_p1_g.mdl",
	"models/vj_hlr/gibs/metalgib_p2_g.mdl",
	"models/vj_hlr/gibs/metalgib_p3_g.mdl",
	"models/vj_hlr/gibs/metalgib_p4_g.mdl",
	"models/vj_hlr/gibs/metalgib_p5_g.mdl",
	"models/vj_hlr/gibs/metalgib_p6_g.mdl",
	"models/vj_hlr/gibs/metalgib_p7_g.mdl",
	"models/vj_hlr/gibs/metalgib_p8_g.mdl",
	"models/vj_hlr/gibs/metalgib_p9_g.mdl",
	"models/vj_hlr/gibs/metalgib_p10_g.mdl",
	"models/vj_hlr/gibs/metalgib_p11_g.mdl",
	}

function ZShelter.CreateGib(ent, model, sounds, pos, mins, maxs)
	if(!mins || !maxs) then
		mins = Vector(0, 0, 0)
		maxs = Vector(0, 0, 0)
	end
	local vecRand = Vector(math.random(mins.x, maxs.x), math.random(mins.y, maxs.y), math.random(mins.z, maxs.z))
	local gib = ents.Create("obj_vj_gib")
	gib:SetModel(model)
	gib:SetPos(pos + vecRand)
	gib:SetAngles(AngleRand())
	gib.CollideSound = sounds[math.random(#sounds)]
	gib.BloodType = nil
	gib:Spawn()
	gib:Activate()
	gib:SetColor(Color(255, 255, 255, 255))
	gib:SetRenderMode(RENDERMODE_TRANSCOLOR)
	gib:SetCollisionGroup(1)

	gib.KillTime = CurTime() + 1
	gib.Alpha = 255
	gib.Think = function()
		if(gib.KillTime < CurTime()) then
			gib.Alpha = math.max(gib.Alpha - 30, 0)
			if(gib.Alpha <= 0) then
				gib:Remove()
				return
			end
		end
		gib:SetColor(Color(255, 255, 255, gib.Alpha))
		gib:NextThink(CurTime() + 0.1)
		return true
	end

	local phys = gib:GetPhysicsObject()
	if(IsValid(phys)) then
		phys:SetVelocity(VectorRand(-200, 200))
	end
end

function ZShelter.HandleBarricade(barricade, player, damage)
	if(!GetGlobalBool("GameStarted")) then return end
	barricade:SetHealth(barricade:Health() - damage)
	ZShelter.SyncHP(barricade, player)
	if(barricade:Health() <= 0) then
		local mins, maxs = barricade:GetModelBounds()
		for i = 1, 20 do
			ZShelter.CreateGib(barricade, gibs[math.random(1, #gibs)], gibsCollideSound, barricade:GetNWVector("NoOffsetPos", barricade:GetPos()), mins, maxs)
		end
		barricade:Remove()
		sound.Play("shigure/break.mp3", barricade:GetNWVector("NoOffsetPos", barricade:GetPos(), 100, 100, 2))
	end
end

local damageSD = {
	"vj_hlr/fx/metal1.wav",
	"vj_hlr/fx/metal3.wav",
}

function ZShelter.ApplyDamageFast(building, damage, sd, bypass_durability)
	local phys = building:GetPhysicsObject()
	if(IsValid(phys)) then
		phys:EnableMotion(false)
	end 
	if(GetConVar("zshelter_debug_disable_building_damage"):GetInt() == 1) then return end
	if(building:GetNWBool("DurabilitySystem", false) && !bypass_durability) then return end
	building.LastDamagedTime = CurTime()
	building:SetHealth(building:Health() - damage)
	if(game.SinglePlayer()) then
		local owner = building:GetOwner()
		if(IsValid(owner) && owner:IsPlayer()) then
			ZShelter.SyncHP(building, building:GetOwner())
		end
	end
	if(building:Health() <= 0) then
		local mins, maxs = building:GetModelBounds()
		for i = 1, 8 do
			ZShelter.CreateGib(building, gibs[math.random(1, #gibs)], gibsCollideSound, building:GetNWVector("NoOffsetPos", building:GetPos()), mins, maxs)
		end
		local owner = building.Builder
		if(IsValid(owner) && owner:IsPlayer()) then
			if(owner.Callbacks.OnBuildingDestroyed) then
				for k,v in pairs(owner.Callbacks.OnBuildingDestroyed) do
					v(owner, building, building:GetNWInt("Woods", 0), building:GetNWInt("Irons", 0), building:GetNWInt("Powers", 0))
				end
			end
			SetGlobalInt("Powers", GetGlobalInt("Powers", 0) + building:GetNWInt("Powers", 0))
			if(building.nvar) then
				SetGlobalInt(building.nvar, math.max(GetGlobalInt(building.nvar, 0) - 1, 0))
				building.counted = true
			end
		end
		if(building.__od) then
			building.__od(building)
			building.ODCalled = true
		end
		if(building:GetNWString("Name", "none") != "none") then
			ZShelter.BroadcastNotify(true, false, building:GetNWString("Name", "none"))
		end
		building:Remove()
		sound.Play("shigure/break.mp3", building:GetNWVector("NoOffsetPos", building:GetPos(), 100, 100, 2))
	end
end

function ZShelter.ApplyDamage(attacker, building, dmginfo)
	local phys = building:GetPhysicsObject()
	if(IsValid(phys)) then
		phys:EnableMotion(false)
	end 
	if(IsValid(attacker) && !attacker:IsPlayer()) then
		ZShelter.Director_AddDamage(building, dmginfo:GetDamage())
	end
	if(building:GetNWBool("DurabilitySystem", false)) then
		if(!IsValid(attacker) || (IsValid(attacker) && !attacker:IsPlayer())) then return end
	end
	if(building:GetNWBool("NoBuildSystem", false)) then return end
	building.LastDamagedTime = CurTime()
	local damage = dmginfo:GetDamage()
	local owner = building.Builder
	if(IsValid(owner) && owner:IsPlayer()) then
		local category = building.Cate || "NULL"
		damage = damage * owner:GetNWFloat("DamageResistance_"..category, 1)
		if(owner.Callbacks.OnBuildingTakeDamage) then
			for k,v in pairs(owner.Callbacks.OnBuildingTakeDamage) do
				v(owner, building, attacker, damage)
			end
		end
	end
	if(GetConVar("zshelter_debug_disable_building_damage"):GetInt() == 1) then return end
	if(IsValid(attacker)) then
		if(attacker:IsPlayer() && building:GetNWBool("NoPlayerDamage", false)) then return end
		if(attacker:IsPlayer()) then
			damage = damage * attacker:GetNWFloat("BuildingSpeed", 1)
		end
		building:SetHealth(building:Health() - damage)
		if(attacker:IsPlayer()) then
			ZShelter.SyncHP(building, attacker)
			building.LastDamageTime = CurTime() + 2
			hook.Run("OnPlayerDamageBuilding", attacker, building)
		end
	else
		building:SetHealth(building:Health() - damage)
	end

	if(!building.LastSDTime) then
		building.LastSDTime = 0
	else
		if(building.LastSDTime < CurTime()) then
			sound.Play(damageSD[math.random(1, #damageSD)], building:GetPos(), 100, 100, 1)
			building.LastSDTime = CurTime() + 0.15
		end
	end
	if(building:Health() <= 0) then
		local mins, maxs = building:GetModelBounds()
		for i = 1, 8 do
			ZShelter.CreateGib(building, gibs[math.random(1, #gibs)], gibsCollideSound, building:GetNWVector("NoOffsetPos", building:GetPos()), mins, maxs)
		end
		local owner = building.Builder
		if(IsValid(owner) && owner:IsPlayer()) then
			if(owner.Callbacks.OnBuildingDestroyed) then
				for k,v in pairs(owner.Callbacks.OnBuildingDestroyed) do
					v(owner, building, building:GetNWInt("Woods", 0), building:GetNWInt("Irons", 0), building:GetNWInt("Powers", 0))
				end
			end
			SetGlobalInt("Powers", GetGlobalInt("Powers", 0) + building:GetNWInt("Powers", 0))
			if(building.nvar) then
				SetGlobalInt(building.nvar, math.max(GetGlobalInt(building.nvar, 0) - 1, 0))
				building.counted = true
			end
		end
		if(building.__od) then
			building.__od(building)
			building.ODCalled = true
		end
		if(building:GetNWString("Name", "none") != "none") then
			ZShelter.BroadcastNotify(true, false, building:GetNWString("Name", "none"))
		end
		building:Remove()
		sound.Play("shigure/break.mp3", building:GetNWVector("NoOffsetPos", building:GetPos(), 100, 100, 2))
	end
	if(game.SinglePlayer()) then
		local owner = building:GetOwner()
		if(IsValid(owner) && owner:IsPlayer()) then
			ZShelter.SyncHP(building, building:GetOwner())
		end
	end
end

function ZShelter.BuildSystemNoScale(player, building, buildspeed) -- Do not use this on your SWEP for repairing!, use ZShelter.BuildSystem() instead
	if(building:GetNWBool("NoBuildSystem", false) || (building:GetNWBool("Completed", false) && building:GetNWBool("DurabilitySystem", false)) || building:Health() >= building:GetMaxHealth()) then return end
	local bspeed = buildspeed
	building:SetHealth(math.Clamp(building:Health() + bspeed, 0, building:GetMaxHealth()))
	if(IsValid(player)) then
		ZShelter.SyncHP(building, player)
	end
	if(!building:GetNWBool("Completed", false) && building:Health() >= building:GetMaxHealth()) then
		building:NextThink(CurTime())
		building:SetNWBool("Completed", true)
		building:SetColor(Color(255, 255, 255, 255))
		if(building.__oc) then
			building.__oc(building)
		end
		sound.Play("shigure/buildC.mp3", building:GetNWVector("NoOffsetPos", building:GetPos(), 100, 100, 2))
	end
end

function ZShelter.TrapRepairSystem(player, building)
	if(player.Callbacks && player.Callbacks.OnRepairingTraps) then
		for k,v in pairs(player.Callbacks.OnRepairingTraps) do
			v(player, building)
		end
	end
	local restore = (building.DurabilityRepair || 1) * player:GetNWFloat("TrapRepairSpeed", 1)
	building:SetHealth(math.min(building:Health() + restore, building:GetMaxHealth()))
	ZShelter.SyncHP(building, player)
end

function ZShelter.BuildSystem(player, building, buildspeed)
	if(building:GetNWBool("NoBuildSystem", false)) then return end
	if(building:GetNWBool("Completed", false) && building:GetNWBool("DurabilitySystem", false)) then
		ZShelter.TrapRepairSystem(player, building)
		return
	end
	local baseScale = player:GetNWFloat("BuildingSpeed", 1)
	if(building.bspeed && !building:GetNWBool("Completed", false)) then
		if(!building.boostremaining) then
			building.boostremaining = building:GetMaxHealth()
		end
		if(building.boostremaining > 0) then
			baseScale = baseScale + building.bspeed
		end
	end
	if(building:GetNWBool("Completed", false) && building.LastDamagedTime) then
		if(CurTime() - building.LastDamagedTime > 10) then
			baseScale = baseScale + 0.15
		end
	end
	local bspeed = baseScale * buildspeed
	if(building:GetNWBool("Completed", false)) then
		bspeed = player:GetNWFloat("RepairSpeed", 1) * bspeed
	end
	if(player.Callbacks.OnRepairBuildings) then
		for k,v in pairs(player.Callbacks.OnRepairBuildings) do
			v(player, building, bspeed)
		end
	end
	if(building:GetNWFloat("StunTime", 0) > CurTime() && GetGlobalInt("Powers", 0) >= 0) then
		ZShelter.RemoveStun(building)
	end
	if(building:Health() >= building:GetMaxHealth()) then return end
	building:SetHealth(math.Clamp(building:Health() + bspeed, 0, building:GetMaxHealth()))
	if(building.boostremaining) then
		building.boostremaining = math.max(building.boostremaining - bspeed, 0)
	end
	ZShelter.SyncHP(building, player)
	if(!building:GetNWBool("Completed", false) && building:Health() >= building:GetMaxHealth()) then
		building:NextThink(CurTime())
		building:SetNWBool("Completed", true)
		building:SetColor(Color(255, 255, 255, 255))
		if(building.__oc) then
			building.__oc(building)
		end
		sound.Play("shigure/buildC.mp3", building:GetNWVector("NoOffsetPos", building:GetPos(), 100, 100, 2))
	end
	hook.Run("OnPlayerRepairBuilding", player, building)
end

function ZShelter.AddBait(building)
	local bait = ents.Create("npc_vj_zshelter_shelter_hitbox")
		bait:SetPos(building:GetPos())
		bait:Spawn()
		bait:SetCollisionGroup(1)
		bait:SetNWBool("IsBuilding", true)
		bait:SetNWBool("NoPlayerDamage", true)
		bait:SetNWBool("Completed", true)
		bait:SetNoDraw(true)

		bait:SetCollisionBounds(Vector(-1, -1, 0), Vector(1, 1, 1))

		bait.Think = function()
			if(!IsValid(building)) then
				bait:Remove()
				return
			end
			bait:SetPos(building:GetPos())
			bait:NextThink(CurTime() + 1)
			return true
		end
end

function ZShelter.CreateRemovelThinker(owner, func, interval)
	local thinker = ents.Create("obj_internal_thinker")
		thinker:SetOwner(owner)
		thinker:Spawn()
		thinker.Think = function()
			if(!IsValid(owner)) then
				thinker:Remove()
				return
			end
			if(!owner:GetNWBool("Completed", false)) then return end
			thinker:SetPos(owner:GetPos())
			func(owner)
			thinker:NextThink(CurTime() + interval)
			return true
		end
end

net.Receive("ZShelter_BuildRequest", function(len, ply)
	local index1 = net.ReadString()
	local index2 = net.ReadInt(32)
	local vec = net.ReadVector()
	local yaw = net.ReadInt(32)

	local data = ZShelter.BuildingConfig[index1][index2]
	if(!data) then return end
	local woods, irons, powers = math.max(math.floor(data.woods * ply:GetNWFloat("ResCost", 1)), 1), math.max(math.floor(data.irons * ply:GetNWFloat("ResCost", 1)), 1), math.max(math.floor(data.powers * ply:GetNWFloat("PowerCost", 1)), 0)
	if(data.powers <= 0) then
		powers = 0
	end
	local meet, storage = ZShelter.IsRequirementMeet(ply, data)
	if(!meet) then return end

	SetGlobalInt("TBuilds", GetGlobalInt("TBuilds", 0) + 1)
	ply:SetNWInt("TBuilds", ply:GetNWInt("TBuilds", 0) + 1)

	ply:AddFrags(math.floor((woods + irons + powers) * 0.65))

	if(storage) then
		SetGlobalInt("Woods", math.max(GetGlobalInt("Woods", 0) - data.woods, 0))
		SetGlobalInt("Irons", math.max(GetGlobalInt("Irons", 0) - data.irons, 0))
	else
		ply:SetNWInt("Woods", math.max(ply:GetNWInt("Woods", 1) - data.woods, 0))
		ply:SetNWInt("Irons", math.max(ply:GetNWInt("Irons", 1) - data.irons, 0))
	end

	local tdata = data.tdata
	local ent = ents.Create(data.class)
		ent:SetPos(vec + data.offset)
		ent:SetAngles(Angle(0, yaw, 0))
		if(!ent:IsNPC()) then
			ent:SetModel(data.model)
		else
			if(!tdata.noowner) then
				ent:SetOwner(ply)
			end
			if(!tdata.forcecollide) then
				ent:SetCustomCollisionCheck(true)
			end
			ent:SetNWBool("IsTurret", true)
		end

		if(tdata.forceowner) then
			ent:SetOwner(ply)
		end

		if(tdata.notarget) then
			ent.NoTarget = true
		end

		if(tdata.forcemodel) then
			ent:SetModel(data.model)
		end

		ent:Spawn()

		ent.oSetCollisionGroup = ent.SetCollisionGroup
		local func = function(self, group)
			debug.Trace()
			ent.oSetCollisionGroup(self, group)
		end
		ent.SetCollisionGroup = func

		if(data.category == "Turret") then
			ent.IsTurret = true
		end

		if(!tdata.dothink) then
			ent:NextThink(CurTime() + 10240000)
		end
		ent:SetRenderMode(RENDERMODE_TRANSCOLOR)

		local scale = 1
		if(data.category != "Trap") then
			scale = ply:GetNWFloat("BuildingHPScale", 1)
		else
			scale = ply:GetNWFloat("TrapHPScale", 1)
		end

		ent.Cate = data.category

		ent:SetMaxHealth(data.health * ply:GetNWFloat("BuildingHPScale", 1))
		ent:SetHealth(1)

		ent:SetColor(Color(255, 255, 255, 180))
		ent:SetNWBool("IsBuilding", true)
		ent:SetNWBool("Completed", false)
		ent:SetNWString("Name", data.title)
		ent:SetNWVector("NoOffsetPos", vec + Vector(0, 0, 1))

		ent:SetNWInt("Woods", woods)
		ent:SetNWInt("Irons", irons)
		ent:SetNWInt("Powers", powers)
		ent:SetNWInt("oPowers", powers)

		ent.Builder = ply
		ent.IsBuilding = true

		if(tdata.damage) then
			ent.AttackDamage = tdata.damage
			ent:SetNWInt("AttackDamage", ent.AttackDamage)
			ent:SetNWInt("oAttackDamage", ent.AttackDamage)
		end

		ent:SetNWInt("oMaxHealth", ent:GetMaxHealth())
		ent.oMaxHealth = data.health

		if(index1 == "Trap") then
			ent.IsTrap = true
		end

		if(tdata.bait) then
			ZShelter.AddBait(ent)
		end

		if(tdata.yawoffset) then
			ent:SetAngles(ent:GetAngles() + Angle(0, tdata.yawoffset, 0))
		end

		if(tdata.physcollide) then
			ZShelter.AddCollisionEntity(ent)
		end
		
		if(tdata.manual) then
			ent:SetNWBool("HasManualControl", true)
		end

		if(tdata.thinkfunc) then
			local interval = 1
			if(tdata.thinkinterval) then
				interval = tdata.thinkinterval
			end
			ZShelter.CreateRemovelThinker(ent, tdata.thinkfunc, interval)
		end

		if(tdata.highlight_day) then
			ent.HasHL = true
			ent.HLDay = tdata.highlight_day
			ent.HLColor = tdata.highlight_color || Color(255, 255, 255, 255)
		end

		if(tdata.oncomplete) then
			ent.__oc = tdata.oncomplete
		end

		if(tdata.ondestroy) then
			ent.__od = tdata.ondestroy
			ent.ODCalled = false
		end

		if(tdata.onshelterupgrade) then
			ent.__ou = tdata.onshelterupgrade
		end

		if(tdata.ondamaged) then
			ent.__oda = tdata.ondamaged
		end

		if(tdata.onuse) then
			ZShelter.AddFunc(ent, tdata.onuse)
		end

		if(tdata.buildspeed) then
			ent.bspeed = tdata.buildspeed
		end

		if(tdata.durability) then
			ent:SetNWBool("DurabilitySystem", true)
			ent:SetNWInt("DurabilityRepairTarget", tdata.durability_repair_hits || 3)
			ent.DurabilityCost = tdata.durability_cost || 1
			ent.DurabilityInv = tdata.durability_cost_interval || 0
			ent.DurabilityRepair = tdata.repair_amount || 5
		end

		if(tdata.upgradable) then
			ent:SetNWBool("Upgradable", true)
			ent:SetNWInt("MaxUpgrade", tdata.upgradecount || 2)
			ent:SetNWFloat("AttackScale", tdata.upgrade_attackscale || 0.25)
			ent:SetNWFloat("HealthScale", tdata.upgrade_healthscale || 0.1)
		end

		local phys = ent:GetPhysicsObject()
		if(IsValid(phys)) then
			phys:EnableMotion(false)
		end

		ent.nvar = "Build_"..data.title
		SetGlobalInt(ent.nvar, GetGlobalInt(ent.nvar, 0) + 1)

		local type = data.category
		if(type == "Barricade") then
			ent.IsPlayerBarricade = true
			ent.PathIndex = bit.tohex(math.random(1, 65536), 4)
			ent.RemovePathCheck = true

			local phys = ent:GetPhysicsObject()
			if(IsValid(phys)) then
				phys:SetMass(50000)
			end

			--ZShelter.ValidPath(ent:GetNWVector("NoOffsetPos", ent:GetPos()), ent.PathIndex)
		end
		if(ply.Callbacks.OnBuildingPlaced) then
			for k,v in pairs(ply.Callbacks.OnBuildingPlaced) do
				v(ply, ent)
			end
		end

		 ZShelter.BroadcastNotify(false, false, data.title)

		 if(GetConVar("zshelter_debug_instant_build"):GetInt() == 1) then
		 	ZShelter.BuildSystemNoScale(ply, ent, 999999)
		 end

		timer.Simple(0.33, function()
			if(!IsValid(ent)) then return end
			ZShelter.SyncVariables(ent, ent:GetNWBool("Upgradable", false), ent:GetNWInt("MaxUpgrade", 2), 0, ent:GetNWFloat("AttackScale", 0.25), ent:GetNWFloat("HealthScale", 0.1))
		end)
		SetGlobalInt("Powers", GetGlobalInt("Powers", 0) - powers)
		sound.Play("shigure/build.mp3", ent:GetNWVector("NoOffsetPos", ent:GetPos(), 100, 100, 2))
end)

local count = 0
hook.Add("ZShelter-SecondPassed", "ZShelter-SecondTicker", function()
	count = count + 1
	if(count < 3) then return end
	for k,v in pairs(ZShelter.OverhealList) do
		if(!IsValid(v) || v:Health() <= v:GetMaxHealth()) then
			ZShelter.OverhealList[k] = nil
			continue
		end
		local decrease = math.max(1, (v:Health() - v:GetMaxHealth()) / 100)
		v:SetHealth(math.max(v:Health() - decrease, v:GetMaxHealth()))
	end
	count = 0
end)

hook.Add("EntityRemoved", "ZShelter-CheckAmount", function(ent, fullUpdate)
	if(!ent.counted && ent.nvar) then
		SetGlobalInt(ent.nvar, math.max(GetGlobalInt(ent.nvar, 0) - 1, 0))
	end
	if(ent.__od && !ent.ODCalled) then
		ent.__od(ent)
	end
end)