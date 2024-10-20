local m = {}
m.Name = "charged" -- id to use in config system
m.Day = 8 -- Day to start apply this mutation
m.Chance = 1.5 -- Chance to spawn
m.Difficulty = 4 -- Minimum difficulty to spawn
m.Color = nil

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
		if(self.zsh_NextParticleTime < CurTime()) then
			local pos = self:GetPos()
			local mins, maxs = self:GetCollisionBounds()
			for i = 1, 8 do
				local e = EffectData()
				e:SetOrigin(pos + Vector(math.random(mins.x, maxs.x), math.random(mins.y, maxs.y), math.random(0, maxs.z)))
				util.Effect("zshelter_shock", e, true, true)
			end
			self.zsh_NextParticleTime = CurTime() + 0.5
		end
		self.oThink(self, ...)
	end,

	OnRemove = function(self, ...)
		local silenced = self:GetNWFloat("SilencedTime", 0) > CurTime()
		if(!silenced) then
			sound.Play("npc/roller/mine/rmine_explode_shock1.wav", self:GetPos(), 100, 120, 1)
			local e = EffectData()
			e:SetOrigin(self:GetPos())
			util.Effect("zshelter_shock_explode", e, true, true)
			for k,v in pairs(ents.FindInSphere(self:GetPos(), 200)) do
				if(!v.IsTurret && !v.canstun) then continue end
				ZShelter.StunBuilding(v, 5)
			end
		end
		self.oOnRemove(self, ...)
	end
}

ZShelter.RegisterMutation(m)