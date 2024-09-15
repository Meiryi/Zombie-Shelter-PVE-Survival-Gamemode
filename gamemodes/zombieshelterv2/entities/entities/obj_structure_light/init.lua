AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/props_combine/combine_light002a.mdl"
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

function ENT:Think()
end