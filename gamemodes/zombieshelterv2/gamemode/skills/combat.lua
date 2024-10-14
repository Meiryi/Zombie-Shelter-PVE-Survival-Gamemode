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
		player:SetMaxHealth(100 + (player:GetNWInt("MaxHealthBoostCount", 0) * (10 * GetGlobalInt("Day", 1))))
		player:SetNWInt("oMaxHealth", 100 + (player:GetNWInt("MaxHealthBoostCount", 0) * (10 * GetGlobalInt("Day", 1))))
	end,
	function(player, current)
		player:SetNWInt("MaxHealthBoostCount", player:GetNWInt("MaxHealthBoostCount", 0) + 1)
		player:SetMaxHealth(100 + (player:GetNWInt("MaxHealthBoostCount", 0) * (10 * GetGlobalInt("Day", 1))))
		player:SetNWInt("oMaxHealth", 100 + (player:GetNWInt("MaxHealthBoostCount", 0) * (10 * GetGlobalInt("Day", 1))))
	end, 2, "hpboost", 1, "Health Boost")

ZShelter.AddSkills(ClassName, nil, nil,
	function(player, current)
		player:SetNWFloat("DamageScale", player:GetNWFloat("DamageScale", 1) + 0.1)
		player:SetNWFloat("oDamageScale", player:GetNWFloat("DamageScale", 1))
	end, 2, "dmgboost", 1, "Damage Boost")

ZShelter.AddSkills(ClassName, nil, nil,
	function(player, current)
		player:SetMaxArmor(100 + (50 * current))
		player:SetNWInt("oMaxArmor", 100 + (50 * current))
	end, 2, "arboost", 1, "Armor Boost")

ZShelter.AddSkills(ClassName, "OnSecondPassed",
	function(player)
		if(player:GetNWFloat("Sanity", 100) <= 0) then return end
		player:SetHealth(math.min(player:Health() + player:GetNWFloat("SelfRecovering", 2), player:GetMaxHealth()))
	end,
	function(player)
		player:SetNWFloat("SelfRecovering", player:GetNWFloat("SelfRecovering", 0) + 2)
	end, 3, "sheal", 1, "Self Recovering")

ZShelter.AddSkills(ClassName, "OnSecondPassed",
	function(player)
		player:SetArmor(math.min(player:Armor() + player:GetNWFloat("ArmorRecovering", 1), player:GetMaxArmor()))
	end,
	function(player)
		player:SetNWFloat("ArmorRecovering", player:GetNWFloat("ArmorRecovering", 0) + 1)
	end, 3, "armorregen", 1, "Armor Regenerate")

ZShelter.AddSkills(ClassName, "OnGiveMelee",
	function(player)
		player:Give("tfa_zsh_cso_machete")
	end,
	function(player)
		player:SetActiveWeapon(nil)
		ZShelter.ClearMelee(player)
		timer.Simple(0, function()
			local wep = ents.Create("tfa_zsh_cso_machete")
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
	end, 3, "dmgres", 2, "Damage Resistance")


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

ZShelter.AddSkills(ClassName, "OnFireBullets",
	function(ply, bulletdata)
		local wep = ply:GetActiveWeapon()
		if(IsValid(wep)) then
			local firerate = wep:GetNextPrimaryFire() - CurTime()
			wep:SetNextPrimaryFire(CurTime() + (firerate * ply:GetNWFloat("FRate", 1)))
		end
	end,
	function(player, current)
		player:SetNWFloat("FRate", player:GetNWFloat("FRate", 1) - 0.1)
	end, 3, "firerate", 2, "Firerate Boost")

ZShelter.AddSkills(ClassName, nil, nil,
	function(player, current)
		player:SetNWFloat("NoiseScale", player:GetNWFloat("NoiseScale", 1) - 0.1)
	end, 3, "silencer", 2, "Silencer")

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
	end, 1, "mupgrade", 3, "Battle Axe Upgrade", {
		"Machete Upgrade", "Clawhammer Upgrade", "Crowbar Upgrade",
	})

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

local function vvec(self, vec, target)
	local tr = {
		start = vec,
		endpos = target:GetPos() + Vector(0, 0, target:OBBMaxs().z / 2),
		filter = {self, target},
		mask = MASK_SHOT,
	}
	local ret = util.TraceLine(tr)
	local ent = ret.Entity
	if(IsValid(ent)) then
		local mins, maxs = ent:GetCollisionBounds()
		mins.z = 0
		maxs.z = 0
		local dst = mins:Distance(maxs) * 1.5
		if(ent.IsPlayerBarricade || ent.IsBarricade) then return false end
		return ent:GetPos():Distance(tr.endpos) <= dst
	else
		return ret.Fraction == 1
	end
end

local whitelist = {
	logic_zshelter_path_tester = true,

}
local validTarget = function(ply, target)
	if(ZShelter.TurretClassesForCheck[target:GetClass()] || target:GetNWBool("IsBuilding")) then return false end
	if(!target:IsNPC() && !target:IsNextBot()) then return false end
	return true
end
local traceToFOV = function(pos)
	local x, y = ScrW() * 0.5, ScrH() * 0.5
	return math.Distance(pos.x, pos.y, x, y)
end
local servertime = 0
if(CLIENT) then
	hook.Add("Move", "ZShelter_ServerTime", function()
		if(!IsFirstTimePredicted()) then return end
		servertime = CurTime()
	end)
end

ZShelter.AimAssistStrength = 0.08
local switch = false
local nextreloadTime = 0
local maxFOV = 10
local finalTarget = nil
ZShelter.AddSkills(ClassName, "CreateMove",
	function(ply, cmd)
		ply = LocalPlayer()
		local keydown = input.IsMouseDown(MOUSE_4)
		if(!keydown) then return end
		local eyepos = ply:EyePos()
		local eyeangles = ply:EyeAngles()
		local _dst = -1
		local targetset = false
		for k,v in ipairs(ents.GetAll()) do
			if(v:Health() <= 0 || whitelist[v:GetClass()] || !validTarget(ply, v)) then continue end
			if(!vvec(ply, eyepos, v)) then continue end
			local pos = v:GetPos() + v:OBBCenter()
			if(pos:Distance(v:GetPos()) <= 1) then continue end
			local ang = (pos - eyepos):Angle()
			local p = math.abs(math.NormalizeAngle(eyeangles.p - ang.p))
			local y = math.abs(math.NormalizeAngle(eyeangles.y - ang.y))
			local dst = p + y
			if(p > maxFOV || y > maxFOV) then continue end
			if(_dst == -1) then
				finalTarget = v
				_dst = dst
				targetset = true
			else
				if(dst < _dst) then
					finalTarget = v
					_dst = dst
					targetset = true
				end
			end
		end
		if(!targetset) then
			finalTarget = false
		end
		if(IsValid(finalTarget)) then
			local wep = ply:GetActiveWeapon()
			if(IsValid(wep) && wep:Clip1() <= 0) then
				return
			end
			local viewpunchAngle = ply:GetViewPunchAngles()
			local eyeangle = ply:EyeAngles()
			local pos = finalTarget:GetPos() + finalTarget:OBBCenter()
			if(pos == finalTarget:GetPos()) then
				pos.z = pos.z + 35
			end
			local ang = ((pos + (finalTarget:GetVelocity() * FrameTime())) - eyepos):Angle()
			local lerpangle = LerpAngle(ZShelter.AimAssistStrength, eyeangle, ang - viewpunchAngle)
			cmd:SetViewAngles(lerpangle)
			local eyetrace = {
				start = eyepos,
				endpos = eyepos + lerpangle:Forward() * 32767,
				mask = MASK_SHOT,
				filter = ply,
			}
			local trace = util.TraceLine(eyetrace)
			if(IsValid(trace.Entity) && validTarget(ply, trace.Entity)) then
				if(!switch) then
					cmd:AddKey(IN_ATTACK)
					switch = true
				else
					switch = false
				end
			end
		end
	end,
nil, 1, "aimbot", 3, "Aim Assist")

if(CLIENT) then
	local alpha = 0
	local entsAlpha = {}
	hook.Add("HUDPaint", "ZShelter_DrawAimbotFOV", function()
		if(LocalPlayer():GetNWInt("SK_Aim Assist", 0) == 0) then return end
		local keydown = input.IsMouseDown(MOUSE_4)
		if(keydown) then
			alpha = math.Clamp(alpha + ZShelter.GetFixedValue(25), 0, 255)
		else
			alpha = math.Clamp(alpha - ZShelter.GetFixedValue(25), 0, 255)
		end
		if(alpha <= 0) then return end
		local f = math.tan(math.rad(maxFOV))
		local radius = f * (ScrW() / 2.637)
		local centerX, centerY = ScrW() / 2, ScrH() / 2
		surface.DrawCircle(centerX, centerY, radius, Color(255, 255, 255, alpha))
		if(IsValid(finalTarget)) then
			local pos = finalTarget:GetPos() + finalTarget:OBBCenter() + (finalTarget:GetVelocity() * FrameTime())
			pos = pos:ToScreen()
			surface.DrawLine(centerX, centerY, pos.x, pos.y)
			local wide = ScreenScaleH(2)
			local pos = finalTarget:GetPos()
			pos = pos:ToScreen()
			local p1 = (finalTarget:GetPos() + finalTarget:OBBMaxs()):ToScreen()
			local tall = math.abs(p1.y - pos.y)
			local offset = math.abs(p1.x - pos.x)
			local widehalf = wide * 0.5
			local fraction = math.Clamp(finalTarget:Health() / finalTarget:GetMaxHealth(), 0, 1)
			draw.RoundedBox(0, pos.x + offset, pos.y - tall, wide, tall, Color(0, 0, 0, alpha * 0.5))
			draw.RoundedBox(0, pos.x + offset, pos.y - tall * fraction, wide, tall * fraction, Color(255 * (1 - fraction), 255 * fraction, 0, alpha))
		end
	end)
end

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
		OnTakingDamage = function(attacker, victim, dmginfo)
			local state = victim:GetNWInt("ZShelter_ShieldState", 0)
			local block = false
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
				victim.NextShieldTime = CurTime() + 5
			end
			return block
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
	end, 3, "shieldabs", 3, "Layered Defense")

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
	end, 1, "cstim", 4, "Combat Stimpack", nil, 90)
