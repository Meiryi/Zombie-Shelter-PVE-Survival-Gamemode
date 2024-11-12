ZShelter.Enhancements = {}
ZShelter.Enhancements.Buffs = {

}

--[[
	Callbacks :
		OnHit(attacker, victim, dmginfo)
		OnKill(attacker, victim)
		OnFireWeapon(attacker, wep)
		OnCreateMove(player, cmd)
]]
function ZShelter.Enhancements.Register(data)
	table.insert(ZShelter.Enhancements.Buffs, data)
end

function ZShelter.Enhancements.CalculateCost(wep, enh)
	local upgradeCount = wep:GetNWInt("UG_"..enh.name, 0)
	local originalPrice = enh.price
	local totalWorth = math.floor(((wep:GetNWInt("zsh_woods", 0) + wep:GetNWInt("zsh_irons", 0)) * 0.5) * enh.price_scale)
	local cost = originalPrice + totalWorth + (((originalPrice + totalWorth) * upgradeCount) * enh.price_step)

	return math.Round(cost)
end

if(SERVER) then
	util.AddNetworkString("ZShelter-OpenEnhancementStation")
	util.AddNetworkString("ZShelter-EnhancementStationUpgrade")
	util.AddNetworkString("ZShelter-EnhancementStationSyncFullAuto")

	function ZShelter.Enhancements.SyncFullAuto(ply, wep)
		net.Start("ZShelter-EnhancementStationSyncFullAuto")
			net.WriteEntity(wep)
			net.WriteBool(wep.Primary.Automatic)
		net.Send(ply)
	end

	net.Receive("ZShelter-EnhancementStationUpgrade", function(len, ply)
		local index = net.ReadInt(32)
		local wep = net.ReadEntity()
		local enh = ZShelter.Enhancements.Buffs[index]
		if(!IsValid(wep) || !wep:IsWeapon() || !enh) then return end
		local cost = ZShelter.Enhancements.CalculateCost(wep, enh)
		if(wep:GetNWInt("UG_"..enh.name, 0) >= enh.maxUpgrade || !ZShelter.RequirementsCompare(cost, cost)) then return end

		SetGlobalInt("Woods", math.max(GetGlobalInt("Woods", 0) - cost, 0))
		SetGlobalInt("Irons", math.max(GetGlobalInt("Irons", 0) - cost, 0))
		wep:SetNWInt("UG_"..enh.name, wep:GetNWInt("UG_"..enh.name, 0) + 1)

		ply:SetNWInt("WoodsUsed", ply:GetNWInt("WoodsUsed", 0) + cost)
		ply:SetNWInt("IronsUsed", ply:GetNWInt("IronsUsed", 0) + cost)

		if(enh.upgradefunc) then
			enh.upgradefunc(wep, ply)
		end

		if(!wep.Callbacks) then
			wep.Callbacks = {}
		end
		for funcName, func in pairs(enh.callbacks) do
			if(!wep.Callbacks[funcName]) then
				wep.Callbacks[funcName] = {}
			end
			wep.Callbacks[funcName][enh.name] = func
		end
		ZShelter.BroadcastNotify(false, true, ply:Nick().." Upgraded "..enh.name, Color(220, 143, 55, 255))
	end)
else
	net.Receive("ZShelter-EnhancementStationSyncFullAuto", function()
		local wep = net.ReadEntity()
		local state = net.ReadBool()
		if(!IsValid(wep)) then return end
		wep.Primary.Automatic = state
		wep.Primary_TFA.Automatic = state
		wep:ClearStatCache()
	end)
end

ZShelter.Enhancements.Register({
	name = "Damage Boost",
	desc = "Increase weapon's damage by 10%",
	price = 3,
	price_step = 0.2,
	price_scale = 0.4,
	maxUpgrade = 4,

	condfunc = function(wep)
		return true
	end,
	callbacks = {
		OnHit = function(attacker, victim, dmginfo)
			local scale = attacker:GetActiveWeapon():GetNWInt("UG_Damage Boost", 1) * 0.1
			--ZShelter.DealNoScaleDamage(attacker, victim, dmginfo:GetDamage() * scale)
			dmginfo:ScaleDamage(1 + scale)
		end
	},
})

ZShelter.Enhancements.Register({
	name = "Firerate Boost",
	desc = "Increase weapon's firerate by 5%",
	price = 12,
	price_step = 0.25,
	price_scale = 0.25,
	maxUpgrade = 3,

	condfunc = function(wep)
		return wep:GetMaxClip1() > 1
	end,
	callbacks = {
		OnFireWeapon= function(attacker, weapon)
			local scale = weapon:GetNWInt("UG_Firerate Boost", 1) * 0.05
			local nextFire = weapon:GetNextPrimaryFire() - CurTime()
			weapon:SetNextPrimaryFire(CurTime() + (nextFire * (1 - scale)))
		end
	},
})

ZShelter.Enhancements.Register({
	name = "Steady Control",
	desc = "Decrease weapon's recoil by 20%",
	price = 12,
	price_step = 0.1,
	price_scale = 0.1,
	maxUpgrade = 2,

	condfunc = function(wep)
		return wep:GetMaxClip1() > 1 && wep.IsTFAWeapon
	end,
	upgradefunc = function(wep)
		local scale = wep:GetNWInt("UG_Steady Control", 1) * 0.2
		if(!wep.InitializeOriginalRecoil) then
			wep.Primary_TFA.OldKickUp = wep.Primary_TFA.KickUp
			wep.Primary_TFA.OldKickDown = wep.Primary_TFA.KickDown
			wep.Primary_TFA.OldKickHorizontal = wep.Primary_TFA.KickHorizontal

			wep.InitializeOriginalRecoil = true
		end
		wep.Primary_TFA.KickUp = wep.Primary_TFA.OldKickUp * (1 - scale)
		wep.Primary_TFA.KickDown = wep.Primary_TFA.OldKickDown * (1 - scale)
		wep.Primary_TFA.KickHorizontal = wep.Primary_TFA.OldKickHorizontal * (1 - scale)

		wep:ClearStatCache()
	end,
	callbacks = {

	},
})

ZShelter.Enhancements.Register({
	name = "Steady Line",
	desc = "Decrease weapon's spready by 15%",
	price = 14,
	price_step = 0.15,
	price_scale = 0.1,
	maxUpgrade = 3,

	condfunc = function(wep)
		return wep:GetMaxClip1() > 1 && wep.IsTFAWeapon
	end,
	upgradefunc = function(wep)
		local scale = wep:GetNWInt("UG_Steady Line", 1) * 0.2
		if(!wep.InitializeOriginalSpread) then
			wep.Primary_TFA.OldSpread = wep.Primary_TFA.Spread
			wep.InitializeOriginalSpread = true
		end
		wep.Primary_TFA.Spread = wep.Primary_TFA.OldSpread * (1 - scale)
		wep:ClearStatCache()
	end,
	callbacks = {

	},
})

ZShelter.Enhancements.Register({
	name = "Extended Magazine",
	desc = "Increase magazine size by 20%",
	price = 12,
	price_step = 0.25,
	price_scale = 0.15,
	maxUpgrade = 3,

	condfunc = function(wep)
		return wep:GetMaxClip1() > 1 && wep.IsTFAWeapon
	end,
	upgradefunc = function(wep)
		local scale = wep:GetNWInt("UG_Extended Magazine", 1) * 0.2
		if(!wep.InitializeOriginalMag) then
			wep.Primary_TFA.OldClipSize = wep.Primary_TFA.ClipSize
			wep.InitializeOriginalMag = true
		end
		wep.Primary_TFA.ClipSize = wep.Primary_TFA.OldClipSize * (1 + scale)
	
		wep:ClearStatCache()
	end,
	callbacks = {

	},
})

ZShelter.Enhancements.Register({
	name = "Homemade full-auto",
	desc = "Make an smei-auto weapon into full-auto",
	price = 20,
	price_step = 0.1,
	price_scale = 0.2,
	maxUpgrade = 1,

	condfunc = function(wep)
		return wep:GetMaxClip1() > 1 && wep.IsTFAWeapon && wep.Primary_TFA.Automatic == false
	end,
	upgradefunc = function(wep, ply)
		wep.Primary.Automatic = true
		wep.Primary_TFA.Automatic = true
		wep:ClearStatCache()
		ZShelter.Enhancements.SyncFullAuto(ply, wep) -- So guns will work properly
	end,
	callbacks = {

	},
})

ZShelter.Enhancements.Register({
	name = "Piercing Rounds",
	desc = "Increase weapon's penetration by 20%",
	price = 17,
	price_step = 0.3,
	price_scale = 0.1,
	maxUpgrade = 4,

	condfunc = function(wep)
		return wep:GetMaxClip1() > 1 && wep.IsTFAWeapon
	end,
	upgradefunc = function(wep)
		local scale = wep:GetNWInt("UG_Piercing Rounds", 1) * 0.2
		wep.Primary_TFA.PenetrationMultiplier = 1 - scale
		wep:ClearStatCache()
	end,
	callbacks = {

	},
})

ZShelter.Enhancements.Register({
	name = "Ignition Strike",
	desc = "Ignites enemy everytime you hit it, +1s duration and 5 damage per upgrade",
	price = 20,
	price_step = 0.25,
	price_scale = 0.55,
	maxUpgrade = 2,

	condfunc = function(wep)
		return true
	end,
	callbacks = {
		OnHit = function(attacker, victim, dmginfo)
			if(ZShelter.IsFriendlyFire(attacker, victim)) then return end
			local scale = attacker:GetActiveWeapon():GetNWInt("UG_Ignition Strike", 1)
			ZShelter.Ignite(victim, attacker, 2 + scale, 5 * scale)
		end
	},
})

ZShelter.Enhancements.Register({
	name = "Frostbite",
	desc = "Freezes enemy after specific amount of hits, +25% freeze buildup and duration per upgrade",
	price = 35,
	price_step = 0.4,
	price_scale = 0.75,
	maxUpgrade = 3,

	condfunc = function(wep)
		return true
	end,
	callbacks = {
		OnHit = function(attacker, victim, dmginfo)
			if(victim:IsPlayer()) then return end
			local scale = (0.25 * attacker:GetActiveWeapon():GetNWInt("UG_Frostbite", 1))
			ZShelter.Freeze(victim, 1 + scale, 1 + (scale * 2))
		end
	},
})

ZShelter.Enhancements.Register({
	name = "Explosive Rounds",
	desc = "Spawn a small explosion when killed enemy, +20% range per upgrade (Damage based on weapon)",
	price = 75,
	price_step = 0.4,
	price_scale = 0.5,
	maxUpgrade = 2,

	condfunc = function(wep)
		return wep.IsTFAWeapon
	end,
	callbacks = {
		OnKill = function(attacker, victim)
			if(victim.DoNotExplode) then return end -- Prevent chain reaction
			local effectdata = EffectData()
				effectdata:SetOrigin(victim:GetPos() + victim:OBBCenter())
				util.Effect("exp_thanatos5_2", effectdata)

			local wep = attacker:GetActiveWeapon()
			local basedamage = wep.Primary.Damage
			if(wep.Primary.Attacks) then
				basedamage = wep.Primary.Attacks[math.random(1, #wep.Primary.Attacks)].dmg
			end

			local dmg = math.max(((basedamage || 80) * (wep.DamageScaling || 1)) * 0.35, 15)
			local scale = 1 + (attacker:GetActiveWeapon():GetNWInt("UG_Explosive Rounds", 1) * 0.2)
			--util.BlastDamage(attacker, attacker, victim:GetPos() + victim:OBBCenter(), 64 * scale, dmg * scale) -- Fucking chain reaction lmfao
			local damage = dmg
			for k,v in ipairs(ents.FindInSphere(victim:GetPos(), 86 * scale)) do
				if(!ZShelter.HurtableTarget(v) || v:Health() <= 0 || v == attacker) then continue end
				v.LastExplosionDamagedTime = CurTime() + 0.05
				if(v:Health() <= damage) then
					v.DoNotExplode = true
				end
				ZShelter.DealNoScaleDamage(attacker, v, damage)
			end
		end
	},
})

concommand.Add("zshelter_debug_infinite_resource", function(ply)
	if(!ply:IsAdmin()) then return end
	SetGlobalInt("Woods", 999999)
	SetGlobalInt("Irons", 999999)
end)