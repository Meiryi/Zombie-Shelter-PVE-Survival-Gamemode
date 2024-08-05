local m = {}
m.Name = "camo" -- id to use in config system
m.Day = 5 -- Day to start apply this mutation
m.Chance = 2 -- Chance to spawn
m.Difficulty = 5 -- Minimum difficulty to spawn
m.Color = Color(30, 155, 30, 200)

--[[
	ALWAYS CALL ORIGINAL HOOK, SYSTEM WILL CREATE A BACKUP (o + Original name, eg oThink, oOnRemove, etc)

	Custom hooks
		OnApplyMutation(self)
		OnDealingDamage(self, target, dmginfo)
]]

m.Variables = {
	zsh_CheckStuckTime = 0
} -- Variables for mutation functions, leave empty for nothing

m.Callbacks = { -- https://wiki.facepunch.com/gmod/ENTITY_Hooks
	OnApplyMutation = function(self)
		self:SetNWBool("Invisible", true)
		self:SetCollisionGroup(2)
		self.DisableTouchFindEnemy = true
		self.DisableFindEnemy = true
		self.NextProcessTime = 5
	end,
	Think = function(self, ...)
		local sh = ZShelter.Shelter
		local ta = self:GetGoalTarget()
		if(IsValid(sh)) then
			if(IsValid(ta)) then
				self:ClearGoal()
				self:NavSetGoalPos(sh:GetPos())
			end
			local dst = self:GetPos():Distance(sh:GetPos())
			if(dst > 86) then
				if(self.IsVJBaseSNPC) then
					self:VJ_DoSetEnemy(sh, true, true)
				end
				self:SetEnemy(sh)
			end
			if(self:GetMoveVelocity():Length() <= 0) then
				self:SetVelocity(self:GetAngles():Forward() * 512)
				self:NavSetGoalPos(sh:GetPos()) -- I hate it
			end
		end
		self.oThink(self, ...)
	end,
}

ZShelter.RegisterMutation(m)