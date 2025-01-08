local ClassName = "Berserker"

ZShelter.AddSkills(ClassName, nil, nil,
	function(player, current)
		player:SetMaxArmor(100 + (50 * current))
		player:SetNWInt("oMaxArmor", 100 + (50 * current))
	end, 2, "armorboost", 1, "Armor Boost")

ZShelter.AddSkills(ClassName, "OnSecondPassed",
	function(player)
		if(player:GetNWFloat("Sanity", 100) <= 0) then return end
		player:SetHealth(math.min(player:Health() + player:GetNWFloat("SelfRecovering", 2), player:GetMaxHealth()))
	end,
	function(player)
		player:SetNWFloat("SelfRecovering", player:GetNWFloat("SelfRecovering", 0) + 2)
	end, 3, "hpregen", 1, "Self Recovering")

ZShelter.AddSkills(ClassName, "OnSecondPassed",
	function(player)
		player:SetArmor(math.min(player:Armor() + player:GetNWFloat("ArmorRecovering", 1), player:GetMaxArmor()))
	end,
	function(player)
		player:SetNWFloat("ArmorRecovering", player:GetNWFloat("ArmorRecovering", 0) + 1)
	end, 3, "shieldregen", 1, "Armor Regenerate")

ZShelter.AddSkills(ClassName, "OnMeleeDamage",
	function(attacker, victim, dmginfo, melee2)
		if(CLIENT) then return end
		if(!victim:IsNPC() && !victim:IsNextBot() && !victim:IsPlayer()) then return end
		if(victim.IsBoss) then return end
		local mul = attacker:GetNWFloat("MeleeDamageBoost_1")
		local oDamage = dmginfo:GetDamage()
		dmginfo:SetDamage(oDamage + (oDamage * mul))
	end,
	function(player, current)
		player:SetNWFloat("MeleeDamageBoost_1", current * 0.3)
	end, 1, "meleedmg", 1, "Melee Damage Boost1x")

ZShelter.AddSkills(ClassName, "OnGiveMelee",
	function(player)
		player:Give("tfa_zsh_cso_mastercombatknife")
	end,
	function(player)
		player:SetActiveWeapon(nil)
		ZShelter.ClearMelee(player)
		timer.Simple(0, function()
			local wep = ents.Create("tfa_zsh_cso_mastercombatknife")
				wep:Spawn()
				player:PickupWeapon(wep)
				player:SetActiveWeapon(wep)
		end)
	end, 1, "meleeupgrade", 2, "Battle Knife Upgrade", {
		"Clawhammer Upgrade", "Crowbar Upgrade",
	})

ZShelter.AddSkills(ClassName, "OnDayPassed",
	function(player)
		player:SetMaxHealth(100 + (player:GetNWInt("MaxHealthBoostCount", 0) * (15 * GetGlobalInt("Day", 1))))
		player:SetNWInt("oMaxHealth", 100 + (player:GetNWInt("MaxHealthBoostCount", 0) * (15 * GetGlobalInt("Day", 1))))
	end,
	function(player, current)
		player:SetNWInt("MaxHealthBoostCount", current)
		player:SetMaxHealth(100 + (player:GetNWInt("MaxHealthBoostCount", 0) * (15 * GetGlobalInt("Day", 1))))
		player:SetNWInt("oMaxHealth", 100 + (player:GetNWInt("MaxHealthBoostCount", 0) * (15 * GetGlobalInt("Day", 1))))
	end, 2, "hpboost_2", 2, "Health Boost")

ZShelter.AddSkills(ClassName, "OnTakingDamage",
	function(attacker, target, dmginfo)
		if(attacker == target || dmginfo:GetDamageCustom() == 8 || GetConVar("zshelter_friendly_fire"):GetInt() == 0) then return end
		ZShelter.DealNoScaleDamage(target, attacker, dmginfo:GetDamage() * target:GetNWFloat("DamageRef", 0.5))
	end,
	function(player, current)
		player:SetNWFloat("DamageRef", 4 * current)
	end, 2, "thorns_2", 2, "Damage Reflecting")

ZShelter.AddSkills(ClassName, "OnTakingDamage",
	function(attacker, target, dmginfo)
		local seed = math.random(1, 100)
		return seed <= target:GetNWInt("DodgeChance", 10)
	end,
	function(player, current)
		player:SetNWInt("DodgeChance", 10 * current)
	end, 2, "evasion", 2, "Damage Evasion")

ZShelter.AddSkills(ClassName, nil, nil, 
	function(player, current)
		player:SetNWFloat("DamageResistance", 1 + (0.15 * current))
	end, 2, "dmgres_3", 2, "Damage Resistance")

ZShelter.AddSkills(ClassName, "OnMeleeDamage",
	function(attacker, victim, dmginfo, melee2)
		if(CLIENT) then return end
		if(!victim:IsPlayer() && !victim:IsNPC() && !victim:IsNextBot()) then return end
		local time = attacker:GetNWInt("SilenceDuration", 3)
		ZShelter.ApplyDamageMul(victim, "silence"..attacker:EntIndex(), 0.75, time)
		victim:SetNWFloat("SilencedTime", CurTime() + time)
		timer.Simple(0, function()
		local e = EffectData()
			e:SetEntity(victim)
			e:SetScale(time)
		util.Effect("zshelter_silenced", e)
		end)
	end,
	function(player, current)
		player:SetNWInt("SilenceDuration", 3 + current)
	end, 3, "silence", 2, "Silence")

ZShelter.AddSkills(ClassName, "OnMeleeDamage",
	function(attacker, victim, dmginfo, melee2)
		if(CLIENT) then return end
		if(!victim:IsNPC() && !victim:IsNextBot() && !victim:IsPlayer()) then return end
		if(victim.IsBoss) then return end
		local mul = attacker:GetNWFloat("MeleeDamageBoost_2")
		local oDamage = dmginfo:GetDamage()
		dmginfo:SetDamage(oDamage + (oDamage * mul))
	end,
	function(player, current)
		player:SetNWFloat("MeleeDamageBoost_2", current * 0.5)
	end, 1, "meleedmg", 2, "Melee Damage Boost2x")

ZShelter.AddSkills(ClassName, "OnMeleeDamage",
	function(attacker, victim, dmginfo, melee2)
		if(!victim:IsNPC() && !victim:IsNextBot()) then return end
		local wep = attacker:GetActiveWeapon()
		if(!IsValid(wep) || wep:GetClass() != "tfa_zsh_cso_skull9") then return end
		local t = 0.75
		if(melee2) then
			if(victim.IsBoss) then
				t = t * 0.8
			end
			attacker:EmitSound("shigure/stun_impact2.wav")
		else
			t = t * 0.5
			if(victim.IsBoss) then
				t = t * 0.5
			end
			attacker:EmitSound("shigure/stun_impact1.wav")
		end
		if(CLIENT) then return end
		ZShelter.StunEntity(victim, t)
	end, nil, 1, "stunning", 3, "Melee Stunning")

ZShelter.AddSkills(ClassName, "OnMeleeDamage",
	function(attacker, victim, dmginfo, melee2)
		if(!victim:IsNPC() && !victim:IsNextBot() && !victim:IsPlayer()) then return end
		attacker:SetHealth(math.min(attacker:GetMaxHealth(), attacker:Health() + attacker:GetNWFloat("VampireHeal", 10)))
	end,
	function(player, current)
		player:SetNWFloat("VampireHeal", current * 10)
	end, 2, "vampire_2", 3, "Vampire")

ZShelter.AddSkills(ClassName, "OnGiveMelee",
	function(player)
		player:Give("tfa_zsh_cso_skull9")
	end,
	function(player)
		player:SetActiveWeapon(nil)
		ZShelter.ClearMelee(player)
		timer.Simple(0, function()
			local wep = ents.Create("tfa_zsh_cso_skull9")
				wep:Spawn()
				player:PickupWeapon(wep)
				player:SetActiveWeapon(wep)
		end)
	end, 1, "meleeupgrade", 3, "Battle Axe Upgrade", {
		"Clawhammer Upgrade", "Crowbar Upgrade",
	})

local ShieldMat1 = Material("zsh/buffs/shield_1.png")
local ShieldMat2 = Material("zsh/buffs/shield_2.png")
local ShieldMat3 = Material("zsh/buffs/shield_3.png")
ZShelter.AddSkills(ClassName, "MultipleHook",
	{
		OnSecondPassed = function(player)
			if((player.NextShieldTime || 0) > CurTime()) then return end
			if(!IsValid(player.ShieldEntity)) then
				player:SetNWInt("ZShelter_ShieldState", 1)
				player.ShieldEntity = ents.Create("obj_combat_shield")
				player.ShieldEntity:SetOwner(player)
				player.ShieldEntity:Spawn()
				player.NextShieldTime = CurTime() + 8
				sound.Play("npc/scanner/combat_scan5.wav", player:GetPos(), 100, 100, 1)
				return
			else
				if(!player:Alive()) then
					player.ShieldEntity:Remove()
					player.ShieldEntity = nil
					player:SetNWInt("ZShelter_ShieldState", 0)
					return
				end
			end
			if(player:GetNWInt("ZShelter_ShieldState", 0) < player:GetNWInt("MaximumShieldCount", 0)) then
				sound.Play("npc/scanner/combat_scan5.wav", player:GetPos(), 100, 100, 1)
				player:SetNWInt("ZShelter_ShieldState", math.min(player:GetNWInt("ZShelter_ShieldState", 0) + 1, player:GetNWInt("MaximumShieldCount", 0)))
			end
			player.NextShieldTime = CurTime() + 8
		end,
		OnTakingDamage = function(attacker, victim, dmginfo, skip)
			local state = victim:GetNWInt("ZShelter_ShieldState", 0)
			local block = false
			local parry = victim:GetNWFloat("ParryDuration") > CurTime()
			if(parry) then return end
			if(state > 0) then
				local mul = 0.07 + math.max((state - 1) * 0.03, 0)
				victim:SetHealth(math.min(victim:GetMaxHealth(), victim:Health() + (victim:GetMaxHealth() * mul)))
				sound.Play("weapons/airboat/airboat_gun_energy"..math.random(1, 2)..".wav", victim:GetPos(), 100, 100, 1)
				block = true
			end
			state = math.max(state - 1, 0)
			victim:SetNWInt("ZShelter_ShieldState", state)
			if(state <= 0 && IsValid(victim.ShieldEntity)) then
				sound.Play("weapons/physcannon/energy_disintegrate4.wav", victim:GetPos(), 100, 100, 1)
				victim.ShieldEntity:Remove()
			end
			return block
		end,
		OnEnemyKilled = function(attacker, npc, AttackedByTurrets)
			if(AttackedByTurrets) then return end
			if(!ZShelter.IsHoldingMelee(attacker)) then return end
			attacker.NextShieldTime = attacker.NextShieldTime - 1
		end,
		OnHUDPaint = function()
			local ply = LocalPlayer()
			if(!ply:Alive()) then return end
			local state = ply:GetNWInt("ZShelter_ShieldState", 0)
			if(state <= 0) then return end
			if(state == 1) then
				surface.SetMaterial(ShieldMat1)
			elseif(state == 2) then
				surface.SetMaterial(ShieldMat2)
			else
				surface.SetMaterial(ShieldMat3)
			end
			local x, y = ScrW() * 0.5, ScrH() * 0.6
			local size = ScreenScaleH(32)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRect(x - size * 0.5, y - size * 0.5, size, size)
		end,
	},
	function(player, current)
		player:SetNWInt("MaximumShieldCount", current)
	end, 3, "shield_2", 3, "Layered Defense")

ZShelter.AddSkills(ClassName, "OnMeleeDamage",
	function(attacker, victim, dmginfo, melee2)
		if(CLIENT) then return end
		if(!victim:IsNPC() && !victim:IsNextBot() && !victim:IsPlayer()) then return end
		if(victim.IsBoss) then return end
		local mul = attacker:GetNWFloat("MeleeDamageBoost_3")
		local oDamage = dmginfo:GetDamage()
		dmginfo:SetDamage(oDamage + (oDamage * mul))
	end,
	function(player, current)
		player:SetNWFloat("MeleeDamageBoost_3", current * 0.4)
	end, 2, "meleedmg", 3, "Melee Damage Boost3x")

local mat = Material("zsh/icon/parry.png", "smooth")
local alpha = 0
ZShelter.AddSkills(ClassName, "MultipleHook", {
	OnMeleeStrike = function(player, melee2)
		if(player:GetNWFloat("ParryCD", 0) > CurTime()) then return end
		player:SetNWFloat("ParryDuration", CurTime() + player:GetNWFloat("ParryTime", 0.15))
		player:SetNWInt("ParryCD", CurTime() + player:GetNWFloat("ParryCoolDownTime", 3.5))
	end,
	OnTakingDamage = function(attacker, target, dmginfo)
		if(target:GetNWFloat("ParryDuration") < CurTime()) then return end
		sound.Play("shigure/parry.wav", target:GetPos(), 100, 100, 1)
		target:SetNWFloat("ParryDuration", 0)
		return true
	end,
	OnHUDPaint = function()
		local ply = LocalPlayer()
		local totalcd = ply:GetNWFloat("ParryCoolDownTime", 3.5)
		local time = ply:GetNWFloat("ParryCD", 0)
		if(time > CurTime()) then
			alpha = math.Clamp(alpha + ZShelter.GetFixedValue(15), 0, 255)
		else
			alpha = math.Clamp(alpha - ZShelter.GetFixedValue(15), 0, 255)
		end
		local x, y = ScrW() * 0.5, ScrH() * 0.5
		local s, t = ScreenScaleH(16), ScreenScaleH(1)
		if(alpha > 0) then
			local fraction = math.Clamp(1 - (time - CurTime()) / totalcd, 0, 1)
			ZShelter:CircleTimerAnimation(x, y, s, t, 1, Color(0, 0, 0, alpha * 0.5))
			ZShelter:CircleTimerAnimation(x, y, s, t, fraction, Color(255, 255, 255, alpha))
		end
	end,
	},
	function(player, current)
		player:SetNWFloat("ParryCoolDownTime", 3.5 - (0.25 * current))
		player:SetNWFloat("ParryTime", 0.2 + (0.05 * current))
	end, 2, "parry", 3, "Parry")

ZShelter.AddSkills(ClassName, "MultipleHook", {
		OnEnemyKilled = function(attacker, npc, AttackedByTurrets)
			if(AttackedByTurrets) then return end
			if(!ZShelter.IsHoldingMelee(attacker)) then return end
			attacker:SetNWFloat("Sanity", math.min(attacker:GetNWFloat("Sanity", 0) + attacker:GetNWFloat("SanityRegenAmount", 1.5), 100))
		end,
	},
	function(player, current)
		player:SetNWFloat("SanityRegenAmount", 1.5 * current)
	end, 2, "sanityonkill", 3, "SanityRegen")

ZShelter.AddSkills(ClassName, "OnSkillCalled",
	function(player)
		local ang = player:EyeAngles()
		ang.x = 0
		local pos =  player:GetPos() + Vector(0, 0, 5)
		local fwd = ang:Forward() * 800
		local offset = (pos + fwd) - pos
		local dst = pos:Distance(pos + fwd)
		local gap = 128
		local entHit = {}
		local step = math.max(math.floor(dst / gap), 1)
		for i = 1, step do
			local fraction = i / step
			local tr = {
				start = pos,
				endpos = pos + (offset * fraction),
				filter = player,
				mask = MASK_PLAYERSOLID_BRUSHONLY,
				collisiongroup = COLLISION_GROUP_NPC_SCRIPTED,
			}
			for k,v in ipairs(ents.FindInSphere(tr.endpos, gap)) do
				if(v == player) then continue end
				if(!v:IsPlayer() && !v:IsNPC() && !v:IsNextBot()) then continue end
				entHit[v:EntIndex()] = true
			end
			local ret = util.TraceEntity(tr, player)
			if(!ret.HitWorld) then
				player:SetPos(ret.HitPos)
			end
		end
		player:GodEnable()
		timer.Simple(3, function()
			if(!IsValid(player)) then return end
			player:GodDisable()
		end)
		for k,v in pairs(entHit) do
			local ent = Entity(k)
			ent:TakeDamage(1000, player, player)
		end

		sound.Play("weapons/physcannon/energy_sing_explosion2.wav", player:GetPos(), 100, 100, 1)
	end,
	function()

	end, 1, "dash", 4, "Flash Slash", nil, 20)

ZShelter.AddSkills(ClassName, "OnSkillCalled",
	 function(player)
		if(!player.Callbacks.OnTakingDamage) then
			player.Callbacks.OnTakingDamage = {}
		end
		player.Callbacks.OnTakingDamage["GodmodeSkill"] = function(attacker, target, dmginfo)
			if(attacker == target) then return end
			ZShelter.DealNoScaleDamage(target, attacker, dmginfo:GetDamage() * 10)
			return true
		end
		timer.Simple(15, function()
			if(!IsValid(player)) then return end
			player.Callbacks.OnTakingDamage["GodmodeSkill"] = nil
		end)
	end,
	function(player, current)
		return
	end, 1, "godmode", 4, "Godmode", nil, 50)
