local m = {}
m.Name = "shadow" -- id to use in config system
m.Day = 6 -- Day to start apply this mutation
m.Chance = 4 -- Chance to spawn
m.Difficulty = 6 -- Minimum difficulty to spawn
m.Color = Color(0, 0, 0, 220)

--[[
	ALWAYS CALL ORIGINAL HOOK, SYSTEM WILL CREATE A BACKUP (o + Original name, eg oThink, oOnRemove, etc)

	Custom hooks
		OnApplyMutation(self)
		OnDealingDamage(self, target, dmginfo)
]]

m.Variables = {} -- Variables for mutation functions, leave empty for nothing

m.Callbacks = { -- https://wiki.facepunch.com/gmod/ENTITY_Hooks
	OnApplyMutation = function(self)
		self:SetNWBool("Invisible", true)
	end,
}

ZShelter.RegisterMutation(m)