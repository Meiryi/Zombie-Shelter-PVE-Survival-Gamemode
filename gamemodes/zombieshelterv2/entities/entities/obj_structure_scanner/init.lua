AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/zshelter/obj_decoy01.mdl"
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.PlayerFriendly = true
ENT.IsBuilding = true
ENT.IsVJBaseSNPC_Animal = true
ENT.ResourceType = "Woods"
ENT.Woods = 0
ENT.Irons = 0

function ENT:RunAI()
	return false
end

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)
	if(self:GetPhysicsObject()) then
		self:GetPhysicsObject():EnableMotion(false)
	end
	self:SetPlaybackRate(0.1)
	self:SetNWBool("IsBuilding", true)
end

ENT.CurTime = 0
ENT.ResetTime = 0
function ENT:Think()
	if(!self:GetSequence() != 1) then
		self:ResetSequence(1)
	end
	for k,v in pairs(ents.FindInSphere(self:GetPos(), 400)) do
		if(!v.IsZShelterEnemy) then continue end
		v:SetNWFloat("DetectedTime", CurTime() + 10)
	end
	self:NextThink(CurTime() + 0.2)
	return true
end