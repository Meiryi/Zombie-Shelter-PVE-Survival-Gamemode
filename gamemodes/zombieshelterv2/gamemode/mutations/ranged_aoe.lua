local m = {}
m.Name = "ranged_aoe" -- id to use in config system
m.Day = 5 -- Day to start apply this mutation
m.Chance = 1 -- Chance to spawn
m.Difficulty = 8 -- Minimum difficulty to spawn
m.Color = Color(255, 0, 115, 255)

--[[
	ALWAYS CALL ORIGINAL HOOK, SYSTEM WILL CREATE A BACKUP (o + Original name, eg oThink, oOnRemove, etc)

	Custom hooks
		OnApplyMutation(self)
		OnDealingDamage(self, target, dmginfo)
]]

m.Variables = {
	zsh_NextFindTime = 0,
	zsh_NextRangedAttack = 0,
	zsh_NextCheckValidTime = 0,
	zsh_AimTarget = nil,
	zsh_MaximumRange = 1000,
	zsh_DamageInfo = DamageInfo()
} -- Variables for mutation functions, leave empty for nothing

m.Callbacks = { -- https://wiki.facepunch.com/gmod/ENTITY_Hooks
	OnApplyMutation = function(self)
		if(self:Health() >= 1000) then return true end
		if(!GetGlobalBool("RangedMutationEnabled")) then return true end
		self:SetCollisionGroup(1)
		local e = EffectData()
			e:SetEntity(self)
			util.Effect("zshelter_ranged_aoe_main", e)
	end,
	ZShelter_DoRangeAttack = function(self, target)
		local e = EffectData()
			e:SetOrigin(self:GetPos() + Vector(0, 0, (self:OBBMaxs().z * 1.25) + 5))
			e:SetEntity(target)
		util.Effect("zshelter_ranged_aoe", e)
		local pos = target:GetPos()
		timer.Simple(1.885, function()
			local dmg = (1 + (GetConVar("zshelter_difficulty"):GetInt() * 0.04)) * 35
			for k,v in pairs(ents.FindInSphere(pos, 220)) do
				if(!v.IsBuilding) then continue end
				if(v.IsTrap) then
					ZShelter.ApplyDamageFast(v, dmg * 0.5, true, true)
				else
					ZShelter.ApplyDamageFast(v, dmg, true)
				end
			end
			local e = EffectData()
				e:SetOrigin(pos)
			util.Effect("zshelter_exploding", e)
		end)
	end,
	ZShelter_FindEnemy = function(self)
		local vec = self:GetPos() + Vector(0, 0, (self:OBBMaxs().z * 1.25) + 5)
		for k,v in ipairs(ents.FindInSphere(self:GetPos(), self.zsh_MaximumRange)) do
			if(!v.IsTurret || !ZShelterVisible_NPCVec(self, vec, v)) then continue end
			self.zsh_AimTarget = v
			return
		end
	end,
	Think = function(self, ...)
		if(!IsValid(self.zsh_AimTarget)) then
			if(self.zsh_NextFindTime < CurTime()) then
				self:ZShelter_FindEnemy(self)
				self.zsh_NextFindTime = CurTime() + 0.2
			end
			self.DisableChasingEnemy = false
			self.DisableFindEnemy = false
		else
			self.DisableChasingEnemy = true
			self.DisableFindEnemy = true
			self:ClearGoal()
			if(self.zsh_NextCheckValidTime < CurTime()) then
				local vec = self:GetPos() + Vector(0, 0, (self:OBBMaxs().z * 1.25) + 5)
				if(!ZShelterVisible_NPCVec(self, vec, self.zsh_AimTarget)) then
					self.zsh_AimTarget = nil
					return
				end
				self.zsh_NextCheckValidTime = CurTime() + 0.2
			end
			if(self.zsh_NextRangedAttack < CurTime()) then
				local vec = self:GetPos() + Vector(0, 0, (self:OBBMaxs().z * 1.25) + 5)
				local count = 0
				for k,v in ipairs(ents.FindInSphere(self:GetPos(), self.zsh_MaximumRange)) do
					if(!v.IsTurret || !ZShelterVisible_NPCVec(self, vec, v)) then continue end
					self.ZShelter_DoRangeAttack(self, v)
					break
				end
				self.zsh_NextRangedAttack = CurTime() + 7.5
			end
		end
		self.oThink(self, ...)
	end,
}

ZShelter.RegisterMutation(m)