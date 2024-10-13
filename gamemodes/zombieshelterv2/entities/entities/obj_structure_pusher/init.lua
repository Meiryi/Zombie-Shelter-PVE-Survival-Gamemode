AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/props_combine/combine_light001b.mdl"
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.PlayerFriendly = true
ENT.IsBuilding = true
ENT.IsVJBaseSNPC_Animal = true
ENT.MaximumDistance = 256
ENT.AimTarget = nil
ENT.NextPush = 0

function ENT:FindEnemy()
	for k,v in pairs(ents.FindInSphere(self:GetPos(), self.MaximumDistance)) do
		if(v == self) then continue end
		if(!ZShelter.ValidateEntity(self, v) && v:GetClass() != "npc_grenade_frag") then continue end -- Omega trolling
		if(!v:Visible(self)) then continue end
		return true
	end
end

function ENT:Think()
	if(self.NextPush < CurTime()) then
		if(self:FindEnemy()) then
			for k,v in pairs(ents.FindInSphere(self:GetPos(), self.MaximumDistance)) do
				if(v == self || v.NoPush) then continue end
				if(!ZShelter.ValidateEntity(self, v)) then continue end
				v:SetVelocity((self:GetAngles() - Angle(7, 180, 0)):Forward() * 2048)
			end
		local e = EffectData()
			e:SetOrigin(self:GetPos())
			e:SetAngles(self:GetAngles() - Angle(0, 180, 0))
			util.Effect("zshelter_pushing", e)
			self.NextPush = CurTime() + 6
		end
	end
	self:NextThink(CurTime() + 0.1)
	return true
end