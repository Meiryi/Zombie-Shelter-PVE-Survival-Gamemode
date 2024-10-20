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

function ZShelter.GiveMelee(player)
	if(player.Callbacks.OnGiveMelee) then
		for k,v in pairs(player.Callbacks.OnGiveMelee) do
			v(player)
			return
		end
	end
	player:Give("tfa_zsh_cso_shelteraxe")
end

function ZShelter.RS()
	for k,v in pairs(player.GetAll()) do
		ZShelter.ResetSkills(v)
	end
end

function ZShelter.ResetSkills(ply)
	net.Start("ZShelter-ResetSkills")
	net.Send(ply)
	for k,v in pairs(ZShelter.SkillList) do
		for x,y in pairs(v) do
			for index, skill in pairs(y) do
				ply:SetNWFloat("SK_"..skill.title, 0)
			end
		end
	end
	ZShelter.InitPlayerVariables(ply)
end

function ZShelter.ResetResources(ply)
	ply:SetNWInt("Woods", 0)
	ply:SetNWInt("Irons", 0)
end

function ZShelter.ResetResourcesAll()
	SetGlobalInt("Woods", 0)
	SetGlobalInt("Irons", 0)
	SetGlobalInt("Capacity", 16)
	SetGlobalInt("Powers", 0)
end

function ZShelter.InitPlayerVariables(ply)
	ply.Callbacks = {} -- Reset skill callbacks

	ply:SetNWInt("Woods", 0)
	ply:SetNWInt("Irons", 0)

	if(GetGlobalBool("GameStarted")) then
		ply:SetNWInt("SkillPoints", ZShelter.CalcStartSkillPoints(player.GetCount()) + (GetGlobalInt("Day", 1) - 1))
	end

	ply:SetNWFloat("Sanity", 100)
	ply:SetNWFloat("SanityCost", 1.5)
	ply:SetNWString("Tier4Skill", "")

	ply:SetNWFloat("DamageResistance", 1)
	ply:SetNWFloat("DamageScale", 1)
	ply:SetNWFloat("TrapDamageScale", 1)
	ply:SetNWFloat("TurretDamageScale", 1)

	ply:SetNWFloat("GatheringAmount", 1)
	ply:SetNWFloat("ResourceCapacity", 24)

	ply:SetNWFloat("ResCost", 1)
	ply:SetNWFloat("PowerCost", 1)

	ply:SetNWFloat("BuildingSpeed", 1)
	ply:SetNWFloat("RepairSpeed", 1)
	ply:SetNWFloat("BuildingHPScale", 1)

	ply:SetNWFloat("MovementSpeed", 250)
end

hook.Add("PlayerInitialSpawn", "ZShelter-InitPlayer", function(ply)
	ZShelter.InitPlayerVariables(ply)
end)

hook.Add("PlayerDeath", "ZShelter-PlayerDeath", function(ply, inflictor, attacker)
	ZShelter.CreateBackpack(ply:GetPos(), ply:GetNWInt("Woods", 0), ply:GetNWInt("Irons", 0))
	ZShelter.ResetResources(ply)
	local time = 15 + (GetGlobalInt("Day", 1) * 1.5) * (1 + (0.055 * GetConVar("zshelter_difficulty"):GetInt()))
	if(GetGlobalBool("GameStarted")) then
		ply:SetNWFloat("RespawnTime", CurTime() + time)
		timer.Simple(time, function()
			if(!IsValid(ply) || ply:Alive()) then return end
			ply:Spawn()
		end)
	else
	ply:SetNWFloat("RespawnTime", CurTime() + 3)
	timer.Simple(3, function()
		if(!IsValid(ply) || ply:Alive()) then return end
		ply:Spawn()
	end)
	end
	timer.Simple(1, function()
		ply:Spectate(6)
	end)
	if(attacker:IsPlayer() && ply != attacker) then
		attacker:SetNWInt("TKAmount", attacker:GetNWInt("TKAmount", 0) + 1)
	end
	ZShelter.BroadcastNotify(true, true, ply:Nick())
end)

hook.Add("PlayerDeathThink", "ZShelter-BlockRespawn", function(ply)
	if(ply:GetNWFloat("RespawnTime", 0) > CurTime()) then return true end
end)

hook.Add("PlayerSpawn", "ZShelter-PlayerSpawn", function(ply)
	ply:SetCustomCollisionCheck(true)
	ply:SetNWFloat("Sanity", 100)
	ZShelter.GiveMelee(ply)
	ply:GodEnable()
	if(ZShelter.SpawnPos) then
		ply:SetPos(ZShelter.SpawnPos + Vector(math.random(-128, 128), math.random(-128, 128), 0))
	end

	sound.Play("shigure/ammopickup2.wav", ply:GetPos(), 120, 100, 2)
	timer.Simple(0, function()
		ply:SetMaxArmor(ply:GetNWInt("oMaxArmor", ply:GetMaxArmor()))
		ply:SetArmor(ply:GetMaxArmor() * 0.5)
		ply:SetHealth(ply:GetNWInt("oMaxHealth", ply:GetMaxHealth()))
		ply:SetMaxHealth(ply:GetNWInt("oMaxHealth", ply:GetMaxHealth()))
	end)

	timer.Simple(5, function()
		if(!IsValid(ply)) then return end
		ply:GodDisable()
	end)
end)

hook.Add("EntityFireBullets", "ZShelter-PlayerShootBullets", function(ent, data)
	if(!ent:IsPlayer() || !ent.Callbacks || !ent.Callbacks.OnFireBullets) then return end
	if((ent.LastExecTime && ent.LastExecTime > CurTime())) then return end
	for k,v in pairs(ent.Callbacks.OnFireBullets) do
		v(ent, data)
	end
	ent.LastExecTime = CurTime() + 0.01
end)

local capacity = 240
hook.Add("PlayerAmmoChanged", "ZShelter-AmmoCheck", function(ply, ammoID, oldCount, newCount)
	local c = ply:GetNWFloat("ZShelter-AmmoCapacity", 1) * capacity
	if(newCount >= c) then
		ply:SetAmmo(c, ammoID)
	end
end)