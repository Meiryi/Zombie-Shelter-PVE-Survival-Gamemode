local m = {}
m.Name = "resistance" -- id to use in config system
m.Day = 7 -- Day to start apply this mutation
m.Chance = 3 -- Chance to spawn
m.Difficulty = 3 -- Minimum difficulty to spawn
m.Color = Color(255, 121, 25, 255)

--[[
	ALWAYS CALL ORIGINAL HOOK, SYSTEM WILL CREATE A BACKUP (o + Original name, eg oThink, oOnRemove, etc)

	Custom hooks
		OnApplyMutation(self)
		OnDealingDamage(self, target, dmginfo)
]]

m.Variables = {
	zsh_NextApplyTime = 0,
} -- Variables for mutation functions, leave empty for nothing

m.Callbacks = { -- https://wiki.facepunch.com/gmod/ENTITY_Hooks
	OnApplyMutation = function(self)
		local e = EffectData()
			e:SetEntity(self)
			util.Effect("zshelter_resistance_main", e)
			self:SetHealth(self:GetMaxHealth() * 1.5) -- 50% more health
	end,
	Think = function(self, ...)
		if(self.zsh_NextApplyTime < CurTime()) then
			for k,v in pairs(ents.FindInSphere(self:GetPos(), 256)) do
				if(!ZShelter.IsEnemy(v) || v == self) then continue end
				v:SetNWFloat("ResistanceTime", CurTime() + 1.15)

				local e = EffectData()
					e:SetEntity(v)
					util.Effect("zshelter_resistance", e)
			end
			self.zsh_NextApplyTime = CurTime() + 1
		end
		self.oThink(self, ...)
	end,
}

ZShelter.RegisterMutation(m)