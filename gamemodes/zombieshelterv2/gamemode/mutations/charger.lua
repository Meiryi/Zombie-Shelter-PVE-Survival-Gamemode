local m = {}
m.Name = "charger" -- id to use in config system
m.Day = 7 -- Day to start apply this mutation
m.Chance = 4 -- Chance to spawn
m.Difficulty = 7 -- Minimum difficulty to spawn
m.Color = Color(255, 255, 255, 255)

--[[
	ALWAYS CALL ORIGINAL HOOK, SYSTEM WILL CREATE A BACKUP (o + Original name, eg oThink, oOnRemove, etc)

	Custom hooks
		OnApplyMutation(self)
		OnDealingDamage(self, target, dmginfo)
]]

m.Variables = {
	zsh_NextParticleTime = 0,
	zsh_NextDashTime = 0,
	zsh_DashingTime = 0,
} -- Variables for mutation functions, leave empty for nothing

m.Callbacks = { -- https://wiki.facepunch.com/gmod/ENTITY_Hooks
	Think = function(self, ...)
		local silenced = self:GetNWFloat("SilencedTime", 0) > CurTime()
		if(!silenced) then
			if(self.zsh_NextParticleTime < CurTime()) then
				local mins, maxs = self:OBBMins(), self:OBBMaxs()
				for i = 1, 3 do
				local e = EffectData()
					e:SetOrigin(self:GetPos() + Vector(math.random(mins.x, maxs.x), math.random(mins.y, maxs.y), math.random(mins.z, maxs.z)))
					util.Effect("zshelter_charger", e)
				end
				self.zsh_NextParticleTime = CurTime() + 0.15
			end
			if(self.zsh_NextDashTime < CurTime()) then
				sound.Play("shigure/charge_windup.wav", self:GetPos(), 120, 100, 1)
				self.DashingTime = CurTime() + 2
				self.zsh_NextDashTime = CurTime() + 6
			end
			if(self.DashingTime > CurTime()) then
				local mins, maxs = self:OBBMins(), self:OBBMaxs()
				for i = 1, 5 do
				local e = EffectData()
					e:SetOrigin(self:GetPos() + Vector(math.random(mins.x, maxs.x), math.random(mins.y, maxs.y), math.random(mins.z, maxs.z)))
					util.Effect("zshelter_charger", e)
				end
				self:SetLocalVelocity(self:GetMoveVelocity() + self:GetAngles():Forward() * 2500)
				local basepos = self:GetPos() + Vector(0, 0, 10)
				local tr = {
					start = basepos,
					endpos = basepos + self:GetAngles():Forward() * 90,
					mask = MASK_SHOT,
					filter = self,
				}
				local ret = util.TraceLine(tr).Entity
				if(IsValid(ret)) then
					local hit = false
					if(ret:IsPlayer()) then
						ret:TakeDamage(ret:GetMaxHealth() * 0.3, self, self)
						hit = true
					end
					if(ret.IsBuilding && !ret:GetNWBool("IsResource", false)) then
						ZShelter.ApplyDamageFast(ret, 80, true)
						hit = true
					end
					if(hit) then
						sound.Play("shigure/charge_hit"..math.random(1, 3)..".wav", self:GetPos(), 120, 100, 1)
						self.DashingTime = 0
					end
				end
			end
		end
		self.oThink(self, ...)
	end,
}

ZShelter.RegisterMutation(m)