local m = {}
m.Name = "strength" -- id to use in config system
m.Day = 5 -- Day to start apply this mutation
m.Chance = 5 -- Chance to spawn
m.Difficulty = 1 -- Minimum difficulty to spawn
m.Color = Color(255, 100, 100, 255)

--[[
	ALWAYS CALL ORIGINAL HOOK, SYSTEM WILL CREATE A BACKUP (o + Original name, eg oThink, oOnRemove, etc)

	Custom hooks
		OnApplyMutation(self)
		OnDealingDamage(self, target, dmginfo)
]]

m.Variables = { -- Variables for mutation functions, leave empty for nothing
	zsh_applying_damage = false
}

m.Callbacks = { -- https://wiki.facepunch.com/gmod/ENTITY_Hooks
	OnDealingDamage = function(self, target, dmginfo)
		if(!self.zsh_applying_damage) then
			self.zsh_applying_damage = true
			target:TakeDamage(dmginfo:GetDamage(), self, self)
			self.zsh_applying_damage = false
		end
	end,
}

ZShelter.RegisterMutation(m)