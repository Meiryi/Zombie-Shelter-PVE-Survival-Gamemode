local m = {}
m.Name = "frenzy" -- id to use in config system
m.Day = 6 -- Day to start apply this mutation
m.Chance = 3 -- Chance to spawn
m.Difficulty = 7 -- Minimum difficulty to spawn
m.Color = Color(255, 0, 0, 255)

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
	Think = function(self, ...)
		if(self:Health() <= 0) then return end
		if(self.zsh_NextApplyTime < CurTime()) then
			for k,v in pairs(ents.FindInSphere(self:GetPos(), 256)) do
				if(!ZShelter.IsEnemy(v)) then continue end
				v:SetNWFloat("DamageBoostTime", CurTime() + 1.15)
				local e = EffectData()
					e:SetEntity(v)
					util.Effect("zshelter_dmgboost", e)
			end
			self.zsh_NextApplyTime = CurTime() + 1
		end
		self.oThink(self, ...)
	end,
}

ZShelter.RegisterMutation(m)