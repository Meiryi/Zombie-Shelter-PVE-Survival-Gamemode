AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/props_c17/trappropeller_engine.mdl"
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.PlayerFriendly = true
ENT.IsBuilding = true
ENT.IsVJBaseSNPC_Animal = true
ENT.MaximumDistance = 64
ENT.AimTarget = nil

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(2)
	if(self:GetPhysicsObject()) then
		self:GetPhysicsObject():EnableMotion(false)
	end
end

function ENT:Think()
	for k,v in pairs(ents.FindInSphere(self:GetPos(), 80)) do
		if(v == self || v:IsPlayer() || v.IsBuilding || v:Health() <= 0) then continue end
		if(!v:IsNPC() && !v:IsNextBot()) then continue end
		v:TakeDamage(10, self, self)
	end
	self:NextThink(CurTime() + 0.2)
	return true
end