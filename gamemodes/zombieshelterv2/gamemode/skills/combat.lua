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

local ClassName = "Combat"

ZShelter.AddSkills(ClassName, nil, nil, nil, 1, "gmastery1", 1, "Beginner Gun Mastery")

ZShelter.AddSkills(ClassName, "OnDayPassed",
	function(player)
		player:SetMaxHealth(player:GetMaxHealth() + (10 * player:GetNWInt("SK_Health Boost", 0)))
	end,
	function(player, current)
		player:SetMaxHealth(player:GetMaxHealth() + (10 * GetGlobalInt("Day", 1)))
	end, 2, "hpboost", 1, "Health Boost")

ZShelter.AddSkills(ClassName, nil, nil,
	function(player, current)
		player:SetNWFloat("DamageScale", player:GetNWFloat("DamageScale", 1) + 0.1)
		player:SetNWFloat("oDamageScale", player:GetNWFloat("DamageScale", 1))
	end, 2, "dmgboost", 1, "Damage Boost")

ZShelter.AddSkills(ClassName, nil, nil,
	function(player, current)
		player:SetMaxArmor(player:GetMaxArmor() + 50)
	end, 2, "arboost", 1, "Armor Boost")

ZShelter.AddSkills(ClassName, "OnSecondPassed",
	function(player)
		if(player:GetNWFloat("Sanity", 100) <= 0) then return end
		player:SetHealth(math.min(player:Health() + player:GetNWFloat("SelfRecovering", 2), player:GetMaxHealth()))
	end,
	function(player)
		player:SetNWFloat("SelfRecovering", player:GetNWFloat("SelfRecovering", 0) + 2)
	end, 2, "sheal", 1, "Self Recovering")

ZShelter.AddSkills(ClassName, "OnGiveMelee",
	function(player)
		player:Give("zsh_shelter_machete")
	end,
	function(player)
		player:SetActiveWeapon(nil)
		ZShelter.ClearMelee(player)
		timer.Simple(0, function()
			local wep = ents.Create("zsh_shelter_machete")
				wep:Spawn()
				player:PickupWeapon(wep)
				player:SetActiveWeapon(wep)
		end)
	end, 1, "mupgrade", 2, "Machete Upgrade", {
		"Clawhammer Upgrade", "Crowbar Upgrade",
	})

ZShelter.AddSkills(ClassName, "OnSecondPassed",
	function(player)
		if(!player.NextGrenadeTime) then
			player.NextGrenadeTime = CurTime() + 10
		else
			if(player:HasWeapon("weapon_frag")) then
				player.NextGrenadeTime = CurTime() + 10
				return
			end
			if(player.NextGrenadeTime > CurTime()) then
				return
			end
		end
		player:Give("weapon_frag")
		player.NextGrenadeTime = CurTime() + 10
	end, nil, 1, "grenaderegen", 2, "Grenade Supply")

ZShelter.AddSkills(ClassName, nil, nil, nil, 1, "gmastery2", 2, "Intermediate Gun Mastery")

ZShelter.AddSkills(ClassName, nil, nil, 
	function(player, current)
		player:SetNWFloat("DamageResistance", player:GetNWFloat("DamageResistance", 1) + 0.2)
	end, 2, "dmgres", 2, "Damage Resistance")


ZShelter.AddSkills(ClassName, "OnEnemyKilled",
	function(player, npc, killedbyturrets)
		if(killedbyturrets) then return end
		local seed = math.random(1, 100)
		local chance = player:GetNWInt("LootingChance", 10)
		if(GetGlobalBool("Night", false)) then
			chance = chance * 0.25
		else
			chance = chance * 1.5
		end
		if(seed <= chance) then
			ZShelter.CreateBackpack(npc:GetPos(), math.random(1, 3), math.random(1, 3))
		end
	end,
	function(player)
		player:SetNWInt("LootingChance", player:GetNWInt("LootingChance", 0) + 10)
	end, 3, "looting_combat", 2, "Looting")

ZShelter.AddSkills(ClassName, nil, nil,
	function(player, current)
		player:SetNWFloat("DamageScale", player:GetNWFloat("DamageScale", 1) + 0.15)
		player:SetNWFloat("oDamageScale", player:GetNWFloat("DamageScale", 1))
	end, 2, "dmgboost", 2, "Damage Boostx1")

ZShelter.AddSkills(ClassName, "OnTakingDamage",
	function(attacker, target, dmginfo)
		ZShelter.DealNoScaleDamage(target, attacker, dmginfo:GetDamage() * target:GetNWFloat("DamageRef", 0.5))
	end,
	function(player, current)
		player:SetNWFloat("DamageRef", player:GetNWFloat("DamageRef", 0) + 0.5)
	end, 2, "thorns_combat", 2, "Damage Reflecting")

ZShelter.AddSkills(ClassName, "OnDealingDamage",
	function(attacker, victim, dmginfo)
		local seed = math.random(1, 100)
		if(seed <= attacker:GetNWFloat("DTChance", 25)) then
			ZShelter.DealNoScaleDamage(attacker, victim, dmginfo:GetDamage())
			attacker.NextDTApplyTime = CurTime() + 0.2
		end
	end,
	function(player, current)
		player:SetNWFloat("DTChance", player:GetNWFloat("DTChance", 0) + 25)
	end, 2, "dtap", 3, "Double Tap")

ZShelter.AddSkills(ClassName, "OnMeleeDamage",
	function(attacker, victim, dmginfo, melee2)
		if(!victim:IsNPC() && !victim:IsNextBot()) then return end
		if(melee2) then
			victim:NextThink(CurTime() + 0.75)
			if(SERVER) then
				victim:ClearGoal()
			end
			attacker:EmitSound("shigure/stun_impact2.wav")
		else
			victim:NextThink(CurTime() + 0.2)
			if(SERVER) then
				victim:ClearGoal()
			end
			attacker:EmitSound("shigure/stun_impact1.wav")
		end
	end, nil, 1, "mstun", 3, "Melee Stunning")

ZShelter.AddSkills(ClassName, nil, nil, nil, 1, "gmastery3", 3, "Advanced Gun Mastery")

ZShelter.AddSkills(ClassName, "OnSecondPassed",
	function(player)
		if(!player:Alive()) then return end
		local buff = player:GetNWFloat("SkillBuffDamage", 1)
		for k,v in pairs(ents.FindInSphere(player:GetPos(), 400)) do
			if(!v.IsTurret && !v:IsPlayer()) then continue end
			if(v:GetNWFloat("DamageBuffTime", 0) < CurTime()) then
				v:SetNWFloat("DamageBuff", buff)
			else
				if(v:GetNWFloat("DamageBuff", 1) < buff) then
					v:SetNWFloat("DamageBuff", buff)
				end
			end
			v:SetNWFloat("DamageBuffTime", CurTime() + 5)
		end
	end,
	function(player, current)
		player:SetNWFloat("SkillBuffDamage", player:GetNWFloat("SkillBuffDamage", 1) + 0.15)
		timer.Simple(0, function() -- This is retarded, without this util.Effect won't run
			if(player:GetNWInt("SK_Damage Amplifier", 0) > 1) then return end
			local e = EffectData()
				e:SetOrigin(player:GetPos())
				e:SetEntity(player)
				util.Effect("zshelter_ampbuff", e)
		end)
	end, 2, "groupdmg", 3, "Damage Amplifier")

ZShelter.AddSkills(ClassName, "OnEnemyKilled",
	function(player, victim, killedbyturrets)
		if(killedbyturrets) then return end
		player:SetHealth(math.min(player:Health() + (player:GetNWInt("VampireHeal", 5)), player:GetMaxHealth()))
	end,
	function(player)
		player:SetNWFloat("VampireHeal", player:GetNWFloat("VampireHeal", 0) + 5)
	end, 2, "vamp", 3, "Vampire")

ZShelter.AddSkills(ClassName, nil, nil,
	function(player, current)
		player:SetNWFloat("DamageScale", player:GetNWFloat("DamageScale", 1) + 0.25)
		player:SetNWFloat("oDamageScale", player:GetNWFloat("DamageScale", 1))
	end, 1, "dmgboost", 3, "Damage Boostx2")

ZShelter.AddSkills(ClassName, "OnFireBullets",
	function(player, bulletdata)
		if(player.LastTriggerTime && player.LastTriggerTime > CurTime()) then return end
		player.LastTriggerTime = CurTime() + 1

		local eyepos = player:EyePos()
		local wep = player:GetActiveWeapon()

		if(!IsValid(wep)) then return end

		local targets = {}
		for k,v in pairs(ents.FindInCone(player:GetPos(), player:GetAngles():Forward(), 1024, 0.707)) do
			if(v.IsBuilding || v.IsPathTester) then continue end
			if(v:Health() <= 0) then continue end
			if(!v:IsNPC() && !v:IsNextBot()) then continue end
			if(!ZShelterVisible_Vec(player, eyepos, v)) then continue end
			local dist = v:GetPos():Distance(player:GetPos())
			table.insert(targets, {
				dst = dist,
				ent = v,
			})
		end

		if(#targets == 0) then return end

		table.sort(targets, function(a, b) return a.dst < b.dst end)
		local damage = 15 + player:GetNWInt("DTDamage")
		local max = player:GetNWInt("DTAmount", 0)
		local count = 0

		for k,v in pairs(targets) do
			if(count >= max) then return end
			local ent = v.ent
			local ef = EffectData()
				ef:SetOrigin(eyepos)
				ef:SetStart(ent:GetPos() + Vector(0, 0, ent:OBBMaxs().z * 0.5))
				
				util.Effect("zshelter_double_trigger", ef, true, true)
			ent:TakeDamage(damage, player, wep)

			count = count + 1
		end
	end,
	function(player, current)
		player:SetNWInt("DTDamage", player:GetNWInt("DTDamage", 0) + 10)
		player:SetNWInt("DTAmount", player:GetNWInt("DTAmount", 0) + 1)
	end, 2, "dt", 3, "Double Trigger")

ZShelter.AddSkills(ClassName, "OnDealingDamage",
	function(attacker, victim, dmginfo)
		local inflictor = dmginfo:GetInflictor()
		if(!IsValid(inflictor) || inflictor:GetClass() != "npc_grenade_frag") then return end
		if(!victim:IsNPC() && !victim:IsNextBot()) then return end
		local time = attacker.StunTime || 2.5
		victim:NextThink(CurTime() + time)
		victim:ClearGoal()
	end,
	function(player, current)
		player.StunTime = current * 2.5
	end, 2, "grns", 3, "Grenade Stunning")

ZShelter.AddSkills(ClassName, "OnSkillCalled",
	function(player)
		local airstrike = ents.Create("sk_zshelter_airstrike")
			airstrike:SetPos(player:EyePos())
			airstrike:Spawn()
			airstrike:SetOwner(player)
			airstrike.TargetVec = player:GetEyeTrace().HitPos
	end,
	function()
	end, 1, "astrike", 4, "Airstrike", nil, 60)

ZShelter.AddSkills(ClassName, "OnSkillCalled",
	function(player)
		player:SetNWFloat("DamageScale", player:GetNWFloat("oDamageScale", 1) * 5)
		timer.Simple(15, function()
			player:SetNWFloat("DamageScale", player:GetNWFloat("oDamageScale", 1))
		end)
	end,
	function()
	end, 1, "cstim", 4, "Combat Stimpack", nil, 40)
