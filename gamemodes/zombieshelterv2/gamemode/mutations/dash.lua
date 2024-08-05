local m = {}
m.Name = "dash" -- id to use in config system
m.Day = 4 -- Day to start apply this mutation
m.Chance = 5 -- Chance to spawn
m.Difficulty = 4 -- Minimum difficulty to spawn
m.Color = Color(255, 255, 255, 255)

--[[
	ALWAYS CALL ORIGINAL HOOK, SYSTEM WILL CREATE A BACKUP (o + Original name, eg oThink, oOnRemove, etc)

	Custom hooks
		OnApplyMutation(self)
		OnDealingDamage(self, target, dmginfo)
]]

m.Variables = {
	zsh_NextParticleTime = 0,
	zsh_NextCheckTime = 0,
	zsh_NextDashTime = 0,
} -- Variables for mutation functions, leave empty for nothing

m.Callbacks = { -- https://wiki.facepunch.com/gmod/ENTITY_Hooks
	OnApplyMutation = function(self)
		if(self:GetMaxHealth() > 500) then return true end -- Don't apply this mutation on enemy with alot of health, it'll be cancer
		self:SetCollisionGroup(2)
	end,
	Think = function(self, ...)
		if(self.zsh_NextParticleTime < CurTime()) then
			local mins, maxs = self:OBBMins(), self:OBBMaxs()
			for i = 1, 10 do
			local e = EffectData()
				e:SetOrigin(self:GetPos() + Vector(math.random(mins.x, maxs.x), math.random(mins.y, maxs.y), math.random(mins.z, maxs.z)))
				util.Effect("zshelter_dash", e)
			end
			self.zsh_NextParticleTime = CurTime() + 0.15
		end
		if(self.zsh_NextDashTime < CurTime()) then
			local enemy = self:GetEnemy()
			if(IsValid(enemy)) then
				if(self:GetPos():Distance(enemy:GetPos()) < 768) then
					if(self.zsh_NextCheckTime < CurTime()) then
						local mins, maxs = self:GetCollisionBounds()
						local tr = {
							start = self:GetPos(),
							endpos = self:GetPos(),
							mins = mins,
							maxs = maxs,
							filter = self,
							mask = MASK_SHOT,
						}
						if(!util.TraceHull(tr).HitWorld) then
							self:SetPos(enemy:GetPos())
							sound.Play("shigure/teleport.wav", self:GetPos(), 120, 100, 1)
						end
						self.zsh_NextCheckTime = CurTime() + 0.33
					end
				end
			end
			self.zsh_NextDashTime = CurTime() + 15
		end
		self.oThink(self, ...)
	end,
}

ZShelter.RegisterMutation(m)