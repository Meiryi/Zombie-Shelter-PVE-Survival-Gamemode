AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/items/ar2_grenade.mdl"

function ENT:Initialize()
	self:SetModel(self.Model)
end

function ENT:Think()
	if(!IsValid(self:GetOwner())) then
		self:Remove()
		print("Owner is invalid! removing")
		return
	end
	self:NextThink(CurTime() + 1)
	return true
end

function ENT:Use(ent)
	if(!ent:IsPlayer()) then return end
	if(ent.NextUseTime && ent.NextUseTime > CurTime()) then return end

	net.Start("ZShelter-OpenStorage")
	net.Send(ent)

	ent.NextUseTime = CurTime() + 0.1
end