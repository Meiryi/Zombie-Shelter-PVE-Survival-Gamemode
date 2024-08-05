AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/zshelter/zb_backpack.mdl"
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.PlayerFriendly = true
ENT.IsBuilding = true
ENT.IsVJBaseSNPC_Animal = true
ENT.ResourceType = "Woods"
ENT.Woods = 0
ENT.Irons = 0

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)
	self:SetCollisionGroup(2)
	self:SetTrigger(true)

	if(self:GetPhysicsObject()) then
		self:GetPhysicsObject():EnableMotion(false)
	end

	self.KillTime = CurTime() + 120
end

function ENT:Think()
	if(self.KillTime < CurTime()) then
		self:Remove()
		return
	end
	self:NextThink(CurTime() + 1)
	return true
end

function ENT:StartTouch(ent)
	if(!ent:IsPlayer() || !ent:Alive()) then return end
	ZShelter.AddResourceToPlayer(ent, "Woods", self.Woods)
	ZShelter.AddResourceToPlayer(ent, "Irons", self.Irons)
	self:Remove()
end