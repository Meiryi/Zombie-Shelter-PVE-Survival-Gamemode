AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/items/ar2_grenade.mdl"

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)

	if(self:GetPhysicsObject()) then
		self:GetPhysicsObject():EnableMotion(false)
	end

	self:SetNoDraw(false)
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