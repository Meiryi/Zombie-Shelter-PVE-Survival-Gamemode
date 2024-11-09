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

local proplist = {
	prop_physics = true,
	prop_physics_override = true,
	prop_physics_multiplayer = true,
}
function ZShelter_IsProp(class)
	return proplist[class]
end

function ZShelter.IsAttackableEntity(ent)
	if(!IsValid(ent)) then return false end
	return ent:IsPlayer() || ent.IsBuilding
end

function ZShelter.ValidateEntity(o, c)
	if(o == c || c:IsPlayer() || c.IsBuilding || c:Health() <= 0) then return false end
	if(!c:IsNPC() && !c:IsNextBot()) then return false end
	if(c:GetNWBool("Invisible", false) && c:GetNWFloat("DetectedTime", 0) < CurTime()) then return false end
	return true
end

function ZShelter.ValidTarget(o, c)
	if(o == c || c:IsPlayer() || c.IsBuilding || c:Health() <= 0) then return false end
	if(!c:IsNPC() && !c:IsNextBot()) then return false end
	return true
end

function ZShelter.HurtableTarget(v)
	return v:IsNPC() || v:IsNextBot() || v:IsPlayer()
end

function ZShelter.ShouldDetonate(player, trap)
	if(!IsValid(player)) then return true end
	if(player.Callbacks && player.Callbacks.OnTrapDetonate) then
		local shouldExplode = true
		for k,v in pairs(player.Callbacks.OnTrapDetonate) do
			if(v(player, trap)) then shouldExplode = false end
		end
		return shouldExplode
	else
		return true
	end
end

function ZShelter.ValidateTarget(target)
	if(target:Health() <= 0) then return false end
	if(!target:IsNPC() && !target:IsNextBot()) then return false end
	if(target:GetNWBool("Invisible", false) && target:GetNWFloat("DetectedTime", 0) < CurTime()) then return false end
	return true
end

function ZShelter.IsEnemy(ent)
	if(ent:IsPlayer() || ent.IsBuilding) then return false end
	if(!ent:IsNPC() && !ent:IsNextBot()) then return false end
	return true
end

function ZShelter.CalcStartSkillPoints(amount)
	if(amount <= 2) then
		return 3
	else
		local pla = (amount - 2)
		return math.max(3 - pla, 0)
	end
end

function ZShelter.ValidatePlayer(player)
	return player:Alive()
end

ZShelter_WhiteListedEntity = {}

function ZShelterAddWhitelistedEntity(class)
	ZShelter_WhiteListedEntity[class] = true
end

function ZShelterVisible(self, target)
	local tr = {
		start = self:GetPos(),
		endpos = target:GetPos() + Vector(0, 0, target:OBBMaxs().z / 2),
		filter = {self, target},
		mask = MASK_SHOT,
	}
	local ret = util.TraceLine(tr)
	local ent = ret.Entity
	return ret.Fraction == 1 || (!ret.HitWorld && IsValid(ent) && !ZShelter_IsProp(ent:GetClass()) && !ent.IsBuilding && target.LastStuckTime && target.LastStuckTime > CurTime()) || (IsValid(ent) && ZShelter_WhiteListedEntity[ent:GetClass()]) 
end

function ZShelterVisible_Vec(self, vec, target)
	local tr = {
		start = vec,
		endpos = target:GetPos() + Vector(0, 0, target:OBBMaxs().z / 2),
		filter = {self, target},
		mask = MASK_SHOT,
		collisiongroup = COLLISION_GROUP_NPC_SCRIPTED,
	}
	local ret = util.TraceLine(tr)
	local ent = ret.Entity
	if(IsValid(ent)) then
		local mins, maxs = ent:GetCollisionBounds()
		mins.z = 0
		maxs.z = 0
		local dst = mins:Distance(maxs)
		if(ent.IsPlayerBarricade || ent.IsBarricade) then return false end
		return ent:GetPos():Distance(tr.endpos) <= dst || (IsValid(ent) && ZShelter_WhiteListedEntity[ent:GetClass()])
	else
		return ret.Fraction == 1
	end
end

function ZShelterVisible_Vec_IgnoreTurret(self, vec, target)
	local tr = {
		start = vec,
		endpos = target:GetPos() + Vector(0, 0, target:OBBMaxs().z / 2),
		filter = ZShelter.TurretClasses,
		mask = MASK_SHOT,
	}
	local ret = util.TraceLine(tr)
	local ent = ret.Entity
	if(IsValid(ent)) then
		local mins, maxs = ent:GetCollisionBounds()
		mins.z = 0
		maxs.z = 0
		local dst = mins:Distance(maxs)
		if(ent.IsPlayerBarricade || ent.IsBarricade) then return false end
		return ent:GetPos():Distance(tr.endpos) <= dst || (IsValid(ent) && ZShelter_WhiteListedEntity[ent:GetClass()])
	else
		return ret.Fraction == 1
	end
end

function ZShelterVisible_VecExtra(self, vec, target, ignore)
	local tr = {
		start = vec,
		endpos = target:GetPos() + Vector(0, 0, target:OBBMaxs().z / 2),
		filter = {self, target, ignore},
		mask = MASK_SHOT,
	}
	return util.TraceLine(tr).Fraction == 1
end

function ZShelterVisible_NPC(self, target) -- This is costy
	local tr = {
		start = self:GetPos(),
		endpos = target:GetPos() + Vector(0, 0, target:OBBMaxs().z / 2),
		filter = {self, target},
		mask = MASK_NPCSOLID_BRUSHONLY,
	}
	local ret = util.TraceLine(tr)
	if(ret.Fraction != 1) then return false end
	tr.mask = MASK_SHOT
	local ent = util.TraceLine(tr).Entity
	if(IsValid(ent) && !ent.IsTurret) then if(ent.IsBarricade || ent.IsBuilding || ent.IsShelter) then return false end end -- Is blocked by barricades
	return true
end

function ZShelterVisibleNPC(self, target)
	local tr = {
		start = self:GetPos() + self:OBBCenter(),
		endpos = target:GetPos() + target:OBBCenter(),
		filter = {self, target},
		mask = MASK_NPCSOLID_BRUSHONLY,
	}
	return util.TraceLine(tr).Fraction == 1
end

function ZShelterVisible_NPCVec(self, vec, target) -- This is costy
	local tr = {
		start = vec,
		endpos = target:GetPos() + Vector(0, 0, target:OBBMaxs().z / 2),
		filter = {self, target},
		mask = MASK_NPCSOLID_BRUSHONLY,
	}
	local ret = util.TraceLine(tr)
	if(ret.Fraction != 1) then return false end
	tr.mask = MASK_SHOT
	local ent = util.TraceLine(tr).Entity
	if(IsValid(ent) && ent.IsBuilding && !ent.IsTurret) then return false end -- Is blocked by barricades
	return true
end

function ZShelter.ValidatePlayerDistance(self, player, distance)
	return player:Alive() && self:GetPos():Distance(player:GetPos()) <= distance
end

local cvar = GetConVar("zshelter_friendly_fire")
function ZShelter.IsFriendlyFire(attacker, victim)
	return (attacker:IsPlayer() && victim:IsPlayer() && cvar:GetInt() == 0)
end

ZShelter.Melees = {}
function ZShelter.ClearMelee(player)
	for k,v in pairs(player:GetWeapons()) do
		if(ZShelter.Melees[v:GetClass()]) then
			v:Remove()
		end
	end
end

function ZShelter.IsMeleeWeapon(class)
	return ZShelter.Melees[class]
end

function ZShelter.RegisterMeleeWeapon(class)
	ZShelter.Melees[class] = true
end

ZShelter.RegisterMeleeWeapon("tfa_zsh_cso_shelteraxe")
ZShelter.RegisterMeleeWeapon("tfa_zsh_cso_machete")
ZShelter.RegisterMeleeWeapon("tfa_zsh_cso_crowbar")
ZShelter.RegisterMeleeWeapon("tfa_zsh_cso_clawhammer")
ZShelter.RegisterMeleeWeapon("tfa_zsh_cso_skull9")
ZShelter.RegisterMeleeWeapon("tfa_zsh_cso_mastercombatknife")

ZShelterAddWhitelistedEntity("obj_zshelter_shield")