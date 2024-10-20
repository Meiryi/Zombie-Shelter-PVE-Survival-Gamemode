local m = {}
m.Name = "exploder" -- id to use in config system
m.Day = 8 -- Day to start apply this mutation
m.Chance = 3 -- Chance to spawn
m.Difficulty = 4 -- Minimum difficulty to spawn
m.Color = Color(120, 0, 255, 255)

--[[
	ALWAYS CALL ORIGINAL HOOK, SYSTEM WILL CREATE A BACKUP (o + Original name, eg oThink, oOnRemove, etc)

	Custom hooks
		OnApplyMutation(self)
		OnDealingDamage(self, target, dmginfo)
]]

m.Variables = {
	zsh_NextParticleTime = 0,
} -- Variables for mutation functions, leave empty for nothing

m.Callbacks = { -- https://wiki.facepunch.com/gmod/ENTITY_Hooks
	Think = function(self, ...)
		local silenced = self:GetNWFloat("SilencedTime", 0) > CurTime()
		if(!silenced) then
			if(self.zsh_NextParticleTime < CurTime()) then
				local e = EffectData()
					e:SetOrigin(self:GetPos())

				util.Effect("zshelter_exploder", e)
				self.zsh_NextParticleTime = CurTime() + 0.33
			end

			self:SetLocalVelocity(self:GetMoveVelocity() + self:GetAngles():Forward() * 40)
			local target = self:GetEnemy()
			if(IsValid(target) && target:GetPos():Distance(self:GetPos()) < 64) then
				local e = EffectData()
					e:SetOrigin(self:GetPos())
					sound.Play("ambient/explosions/explode_7.wav", self:GetPos())
				util.Effect("Explosion", e)

				local breaked = false
				for k,v in pairs(ents.FindInSphere(self:GetPos(), 200)) do
					if(!v.IsBuilding && !v:IsPlayer()) then continue end
					if(v.IsBuilding && !v.IsShelter) then
						v:TakeDamage(55, self, self)
						if(!breaked) then
							ZShelter.ApplyDamageFast(v, 300, true)
							breaked = true
						end
					else
						v:TakeDamage(35, self, self)
					end
				end

				self:Remove()
				return
			end
		end
		self.oThink(self, ...)
	end,
}

ZShelter.RegisterMutation(m)