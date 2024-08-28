local m = {}
m.Name = "ranged" -- id to use in config system
m.Day = 5 -- Day to start apply this mutation
m.Chance = 2 -- Chance to spawn
m.Difficulty = 4 -- Minimum difficulty to spawn
m.Color = Color(119, 52, 235, 255)

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
		self:SetCollisionGroup(1)
		local e = EffectData()
			e:SetEntity(self)
			util.Effect("zshelter_ranged_main", e)
	end,
	ZShelter_DoRangeAttack = function(self, target)
		local e = EffectData()
			e:SetOrigin(self:GetPos() + Vector(0, 0, (self:OBBMaxs().z * 1.25) + 5))
			e:SetEntity(target)
		util.Effect("zshelter_ranged", e)
		timer.Simple(1.885, function()
			if(!IsValid(target)) then return end
		local diff = 1 + (GetConVar("zshelter_difficulty"):GetInt() * 0.04)
		ZShelter.ApplyDamageFast(target, 30 * diff, true)
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
					if(count >= 1) then break end
					if(!v.IsTurret || !ZShelterVisible_NPCVec(self, vec, v)) then continue end
					self.ZShelter_DoRangeAttack(self, v)
					count = count + 1
				end
				self.zsh_NextRangedAttack = CurTime() + 5
			end
		end
		self.oThink(self, ...)
	end,
}

ZShelter.RegisterMutation(m)