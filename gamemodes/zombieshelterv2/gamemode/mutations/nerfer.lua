local m = {}
m.Name = "nerfer" -- id to use in config system
m.Day = 7 -- Day to start apply this mutation
m.Chance = 3 -- Chance to spawn
m.Difficulty = 6 -- Minimum difficulty to spawn
m.Color = Color(35, 35, 35, 255)

--[[
	ALWAYS CALL ORIGINAL HOOK, SYSTEM WILL CREATE A BACKUP (o + Original name, eg oThink, oOnRemove, etc)

	Custom hooks
		OnApplyMutation(self)
		OnDealingDamage(self, target, dmginfo)
]]

m.Variables = {
	zsh_AimTarget = nil,
	zsh_NextApplyTime = 0,
} -- Variables for mutation functions, leave empty for nothing

m.Callbacks = { -- https://wiki.facepunch.com/gmod/ENTITY_Hooks
	OnApplyMutation = function(self)
		if(self:Health() >= 500) then return true end
	end,
	Think = function(self, ...)
		local pos = self:GetPos()
		if(self.zsh_NextApplyTime < CurTime() && !self.Dead) then
			for k,v in ipairs(player.GetAll()) do
				if(!v:IsPlayer() || !ZShelterVisible_NPC(self, v) || pos:Distance(v:GetPos()) > 1000) then continue end
				local e = EffectData()
					e:SetOrigin(self:GetPos())
					e:SetStart(v:GetPos())
					e:SetEntity(v)
					util.Effect("zshelter_atknerf_beam", e)

					v.AttackNerfTime = CurTime() + 0.75
					if(!v.LastNerfTargets) then v.LastNerfTargets = {} end
					v.LastNerfTargets[self:EntIndex()] = true
			end
			self.zsh_NextApplyTime = CurTime() + 0.15
		end
		self.oThink(self, ...)
	end,
}

ZShelter.RegisterMutation(m)