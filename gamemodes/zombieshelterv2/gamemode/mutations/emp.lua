local m = {}
m.Name = "emp" -- id to use in config system
m.Day = 6 -- Day to start apply this mutation
m.Chance = 1.5 -- Chance to spawn
m.Difficulty = 3 -- Minimum difficulty to spawn
m.Color = Color(71, 234, 252, 255)

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
			for i = 1, 5 do
				local e = EffectData()
				e:SetOrigin(pos + Vector(math.random(mins.x, maxs.x), math.random(mins.y, maxs.y), math.random(0, maxs.z)))
				util.Effect("zshelter_emp", e, true, true)
			end
			self.zsh_NextParticleTime = CurTime() + 0.2
		end
		self.oThink(self, ...)
	end,

	OnRemove = function(self, ...)
		local silenced = self:GetNWFloat("SilencedTime", 0) > CurTime()
		if(!silenced) then
			sound.Play("npc/scanner/scanner_explode_crash2.wav", self:GetPos(), 100, 150, 1)
			local pos = self:GetPos()
			local e = EffectData()
				e:SetOrigin(pos)
				util.Effect("zshelter_emp_pool", e)
			local e = EffectData()
			e:SetMagnitude(2)
			e:SetScale(1)
			e:SetRadius(2)
			for i = 1, 10 do
				e:SetOrigin(self:GetPos())
				util.Effect("Sparks", e)
			end
			for i = 1, 14 do
				timer.Simple(i * 0.3, function()
					for i = 1, 15 do
						local e = EffectData()
						e:SetOrigin(pos + Vector(math.random(-200, 200), math.random(-200, 200), math.random(10, 25)))
						util.Effect("zshelter_emp", e, true, true)
					end
					for k,v in pairs(ents.FindInSphere(pos, 256)) do
						if(!v.IsBuilding) then continue end
						if(v.IsTrap) then
							ZShelter.ApplyDamageFast(v, 1, true, true)
						else
							ZShelter.ApplyDamageNerf(v, 2)
						end
					end
				end)
			end
		end
		self.oOnRemove(self, ...)
	end
}

ZShelter.RegisterMutation(m)