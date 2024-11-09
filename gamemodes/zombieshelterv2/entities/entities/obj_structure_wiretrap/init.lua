AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/zshelter/barricade_wire.mdl"
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
	self:DrawShadow(false)
	self:SetTrigger(true)
	self:SetCollisionGroup(2)
	self:AddFlags(65536)
	if(self:GetPhysicsObject()) then
		self:GetPhysicsObject():EnableMotion(false)
		self:GetPhysicsObject():Wake()
	end
end

ENT.NextDamageTime = 0
function ENT:Touch(ent)
	if(!self:GetNWBool("Completed", false) || self:Health() <= 0) then return end
	if(!ZShelter.ValidateTarget(ent)) then return end
	if(ent.LastFreezeTime && ent.LastFreezeTime > CurTime()) then return end
	local owner = self:GetOwner()
	local sd_amount = 1
	if(IsValid(owner)) then
		sd_amount = math.min((1 - (owner:GetNWFloat("TrapDamageScale", 1) - 1)) * 2.5, 0.8)
	end

	ent:TakeDamage(5, self, self)
	ent:SetMoveVelocity(ent:GetMoveVelocity() * sd_amount)
	ent.LastFreezeTime = CurTime() + 0.175
end