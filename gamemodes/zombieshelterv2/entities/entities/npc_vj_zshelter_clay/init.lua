AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/zshelter/shelter_b_claymore01.mdl"
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.PlayerFriendly = true
ENT.IsBuilding = true
ENT.IsVJBaseSNPC_Animal = true
ENT.MaximumDistance = 86
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
			dmginfo:SetDamage(500)
			dmginfo:SetAttacker(self)
			dmginfo:SetInflictor(self)
		for k,v in pairs(ents.FindInCone(self:GetPos(), self:EyeAngles():Forward(), self.MaximumDistance * 2, -1)) do
			if(!ZShelter.ValidTarget(self, v)) then continue end
			v:TakeDamageInfo(dmginfo)
		end

		for i = -8, 8 do
			local fx = ents.Create("obj_firegun_flame")
				fx:SetAngles(self:GetAngles() + Angle(0, 8 * i, 0))
				fx:SetPos(self:GetPos() + Vector(0, 0, 5))
				fx:Spawn()
				fx.MaxSpriteSize = 1024
				fx.KillTime = CurTime() + 0.45
				fx.FlySpeed = 70
		end
		local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos())
			util.Effect("HelicopterMegaBomb", effectdata)
		sound.Play("ambient/explosions/explode_"..math.random(1, 3)..".wav", self:GetPos(), 80, 100, 1)

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