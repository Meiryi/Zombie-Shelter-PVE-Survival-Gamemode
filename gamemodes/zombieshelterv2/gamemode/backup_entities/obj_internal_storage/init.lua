AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/items/ar2_grenade.mdl"

function ENT:Initialize()
	self:SetModel(self.Model)
end

function ENT:Think()
	if(!IsValid(self:GetOwner())) then
		self:Remove()
		return
	else
		if(self.Position) then
			self:SetPos(self.Position)
			self:SetAngles(Angle(0, 0, 0))
			local phys = self:GetPhysicsObject()
			if(IsValid(phys)) then
				phys:EnableMotion(false)
			end
		end
	end
	self:NextThink(CurTime() + 0.5)
	return true
end

function ENT:Use(ent)
	if(!ent:IsPlayer()) then return end
	if(ent.NextUseTime && ent.NextUseTime > CurTime()) then return end

	net.Start("ZShelter-OpenStorage")
	net.Send(ent)

	ent.NextUseTime = CurTime() + 0.1
end