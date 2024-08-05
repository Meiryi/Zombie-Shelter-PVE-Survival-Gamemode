AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/shigure/hbeam.mdl"
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.PlayerFriendly = true
ENT.IsBuilding = true
ENT.IsVJBaseSNPC_Animal = true
ENT.MaximumDistance = 64
ENT.AimTarget = nil
ENT.ResourceType = "Irons"
ENT.Amount = 3

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)
	self:SetCollisionGroup(2)

	if(self:GetPhysicsObject()) then
		self:GetPhysicsObject():EnableMotion(false)
	end

	self:SetNWBool("IsBuilding", true)
	self:SetNWBool("NoBuildSystem", true)
	self:SetNWBool("NoHUD", true)
	self:SetNWBool("IsResource", true)
	self:SetNWString("ResourceType", self.ResourceType)
end