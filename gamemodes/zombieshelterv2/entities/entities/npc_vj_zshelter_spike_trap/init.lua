AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/zshelter/shelter_b_thron01.mdl"
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.PlayerFriendly = true
ENT.IsBuilding = true
ENT.IsVJBaseSNPC_Animal = true
ENT.MaximumDistance = 45
ENT.AimTarget = nil

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
end

function ENT:DoAttack()
	for k,v in pairs(ents.FindInSphere(self:GetPos(), self.MaximumDistance)) do
		if(!ZShelter.ValidateTarget(self, v)) then continue end
		v:TakeDamage(30, self, self)
	end
end

function ENT:RunSequence(sequence)
	if(self:GetSequence() != sequence) then
		self:ResetSequence(sequence)
	else
		self:SetSequence(sequence)
	end
end

function ENT:FindEnemy()
	for k,v in pairs(ents.FindInSphere(self:GetPos(), self.MaximumDistance)) do
		if(!ZShelter.ValidTarget(self, v)) then continue end
		self.AimTarget = v
		return
	end
end

ENT.NextSpikeTime = 0
ENT.NextSpikeInterval = 2
ENT.WaitTime = 1.25
ENT.CurWaitTime = 0
ENT.Backed = false

function ENT:Think()
	if(!IsValid(self.AimTarget)) then
		self:FindEnemy()
		self:RunSequence(0)
	else
		if(self.AimTarget:GetPos():Distance(self:GetPos()) > self.MaximumDistance || !ZShelter.ValidateTarget(self.AimTarget)) then
			self.AimTarget = nil
			return
		end
		if(self.NextSpikeTime < CurTime()) then
			self:RunSequence(1)
			self:SetCycle(0.5)
			self:DoAttack()
			self.Backed = false
			self.NextSpikeTime = CurTime() + self.NextSpikeInterval
			self.CurWaitTime = CurTime() + self.WaitTime
		else
			if(self.CurWaitTime < CurTime()) then
				self:RunSequence(0)
				self.Backed = true
			end
		end
	end

	self:NextThink(CurTime() + 0.1)
	return true
end