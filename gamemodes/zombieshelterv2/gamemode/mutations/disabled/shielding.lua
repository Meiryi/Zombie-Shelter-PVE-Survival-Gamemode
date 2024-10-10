local m = {}
m.Name = "shielding" -- id to use in config system
m.Day = 8 -- Day to start apply this mutation
m.Chance = 3 -- Chance to spawn
m.Difficulty = 4 -- Minimum difficulty to spawn
m.Color = Color(255, 255, 255, 255)

--[[
	ALWAYS CALL ORIGINAL HOOK, SYSTEM WILL CREATE A BACKUP (o + Original name, eg oThink, oOnRemove, etc)

	Custom hooks
		OnApplyMutation(self)
		OnDealingDamage(self, target, dmginfo)
]]

m.Variables = {
	zsh_CheckTime = 0,
	zsh_ShieldEntity = nil,
} -- Variables for mutation functions, leave empty for nothing

m.Callbacks = { -- https://wiki.facepunch.com/gmod/ENTITY_Hooks
	OnApplyMutation = function(self)
		self:SetCollisionGroup(1)
		self.zsh_ShieldEntity = ents.Create("obj_zshelter_shield")
		self.zsh_ShieldEntity:SetOwner(self)
		self.zsh_ShieldEntity:Spawn()

		self.ForceValid = true
	end,
	Think = function(self, ...)
		if(IsValid(self.zsh_ShieldEntity)) then
			local pos = self:GetPos() + (self:GetAngles():Forward() * 48)
			self.zsh_ShieldEntity:SetPos(pos)
			self.zsh_ShieldEntity:SetAngles(self:GetAngles() + Angle(0, 90, 0))

			if(self.zsh_CheckTime < CurTime()) then
				local enemy = self:GetEnemy()
				if(IsValid(enemy) && ZShelterVisible_VecExtra(self, self:GetPos() + Vector(0, 0, self:OBBMaxs().z * 0.5), enemy, self.zsh_ShieldEntity) && enemy.IsTurret && enemy:GetPos():Distance(self:GetPos()) < 768) then
					self.DisableChasingEnemy = true
					self.DisableFindEnemy = true
					self:ClearGoal()

					self:SetAngles((enemy:GetPos() - self:GetPos()):Angle())
				else
					self.DisableChasingEnemy = false
					self.DisableFindEnemy = false
				end
				self.zsh_CheckTime = CurTime() + 0.1
			end
		else
			self.DisableChasingEnemy = false
			self.DisableFindEnemy = false
		end
		self.oThink(self, ...)
	end,
}

ZShelter.RegisterMutation(m)