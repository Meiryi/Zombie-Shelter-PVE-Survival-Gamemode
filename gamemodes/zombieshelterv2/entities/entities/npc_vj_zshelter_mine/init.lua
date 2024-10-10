AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/zshelter/shelter_b_mine01.mdl"
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
	self:SetCollisionGroup(2)

	if(self:GetPhysicsObject()) then
		self:GetPhysicsObject():EnableMotion(false)
	end
	self:SetNWBool("IsBuilding", true)
end

function ENT:FindEnemy()
	for k,v in pairs(ents.FindInSphere(self:GetPos(), self.MaximumDistance)) do
		if(!ZShelter.ValidateEntity(self, v)) then continue end
		self.AimTarget = v
		return
	end
end

ENT.NextSpikeTime = 0
ENT.NextSpikeInterval = 1
ENT.WaitTime = 1
ENT.CurWaitTime = 0

function ENT:Think()
	if(!IsValid(self.AimTarget)) then
		self:FindEnemy()
	else
		local dmginfo = DamageInfo()
			dmginfo:SetDamageType(64)
			dmginfo:SetDamage(200)
			dmginfo:SetAttacker(self)
			dmginfo:SetInflictor(self)
		for k,v in pairs(ents.FindInSphere(self:GetPos(), self.MaximumDistance * 2.5)) do
			if(!ZShelter.ValidTarget(self, v)) then continue end
			v:TakeDamageInfo(dmginfo)
		end
		local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos())
			util.Effect("HelicopterMegaBomb", effectdata)
		sound.Play("ambient/explosions/explode_1.wav", self:GetPos(), 80, 100, 1)

		if(ZShelter.ShouldDetonate(self:GetOwner(), self)) then
			self:Remove()
		else
			self.AimTarget = nil
			self:NextThink(CurTime() + 10)
			return true
		end
	end
	self:NextThink(CurTime() + 0.1)
	return true
end