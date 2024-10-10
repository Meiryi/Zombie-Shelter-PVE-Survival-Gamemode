local m = {}
m.Name = "healer" -- id to use in config system
m.Day = 3 -- Day to start apply this mutation
m.Chance = 3 -- Chance to spawn
m.Difficulty = 1 -- Minimum difficulty to spawn
m.Color = Color(150, 255, 150, 255)

--[[
	ALWAYS CALL ORIGINAL HOOK, SYSTEM WILL CREATE A BACKUP (o + Original name, eg oThink, oOnRemove, etc)

	Custom hooks
		OnApplyMutation(self)
		OnDealingDamage(self, target, dmginfo)
]]

m.Variables = {
	zsh_NextHealTime = 0,
} -- Variables for mutation functions, leave empty for nothing

m.Callbacks = { -- https://wiki.facepunch.com/gmod/ENTITY_Hooks
	Think = function(self, ...)
		if(self.zsh_NextHealTime < CurTime()) then
			local pos = self:GetPos()
			local mins, maxs = self:GetCollisionBounds()
			local e = EffectData()
			e:SetOrigin(pos + Vector(math.random(mins.x, maxs.x), math.random(mins.y, maxs.y), math.random(0, maxs.z)))
			util.Effect("zshelter_healing_bubbles", e, true, true)
			for k,v in pairs(ents.FindInSphere(self:GetPos(), 256)) do
				if(!ZShelter.IsEnemy(v) || v:Health() <= 0) then continue end
				local hp = 75
				v:SetHealth(math.min(v:Health() + hp, v:GetMaxHealth()))
			end
			self.zsh_NextHealTime = CurTime() + 1
		end
		self.oThink(self, ...)
	end,
}

ZShelter.RegisterMutation(m)