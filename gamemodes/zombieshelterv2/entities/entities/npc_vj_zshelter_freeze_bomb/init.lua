AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/shigure/gastank.mdl"
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.PlayerFriendly = true
ENT.IsBuilding = true
ENT.IsVJBaseSNPC_Animal = true
ENT.MaximumDistance = 200
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
	for k,v in pairs(ents.FindInSphere(self:GetPos(), self.MaximumDistance * 0.5)) do
		if(!ZShelter.ValidTarget(self, v)) then continue end
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
		for k,v in pairs(ents.FindInSphere(self:GetPos(), self.MaximumDistance)) do
			if(!ZShelter.ValidTarget(self, v)) then continue end
			ZShelter.StunEntity(v, 10)
			if(!v.OriginalColor) then
				v.OriginalColor = v:GetColor()
			end
			v:SetColor(Color(55, 55, 255, 255))
			timer.Simple(10, function()
				if(!IsValid(v)) then return end
				v:SetColor(v.OriginalColor)
			end)
		end

		local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos())
			effectdata:SetMagnitude(10)
			effectdata:SetScale(4)
			effectdata:SetRadius(5)
			util.Effect("Sparks", effectdata)

		sound.Play("ambient/explosions/explode_5.wav", self:GetPos(), 80, 100, 1)

		self:Remove()
	end
	self:NextThink(CurTime() + 0.1)
	return true
end