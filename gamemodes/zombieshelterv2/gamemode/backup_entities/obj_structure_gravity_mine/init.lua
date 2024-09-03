AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/roller_spikes.mdl"
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
	self:SetTrigger(true)
	self:SetCollisionGroup(2)
	self:AddFlags(65536)
	if(self:GetPhysicsObject()) then
		self:GetPhysicsObject():EnableMotion(false)
		self:GetPhysicsObject():Wake()
	end
end

function ENT:FindEnemy()
	for k,v in pairs(ents.FindInSphere(self:GetPos(), self.MaximumDistance)) do
		if(!ZShelter.ValidateEntity(self, v)) then continue end
		self.AimTarget = v
		return
	end
end

ENT.AimTarget = nil
ENT.EndPullTime = 0

function ENT:Think()
	if(!self.Pulling) then
		self:FindEnemy()
		if(IsValid(self.AimTarget)) then
			self.Pulling = true
			self.EndPullTime = CurTime() + 6.5
			local pos = self:GetPos()
			local effectdata = EffectData()
				effectdata:SetOrigin(self:GetPos() + Vector(0, 0, 8))
				util.Effect("VortDispel", effectdata)
				util.Effect("zshelter_gravity_mine", effectdata)
				sound.Play("weapons/physcannon/energy_disintegrate5.wav", pos + Vector(0, 0, 8), 120, 100, 1)
				sound.Play("weapons/physcannon/physcannon_charge.wav", pos + Vector(0, 0, 8), 120, 100, 1)
		end
	else
		if(self.EndPullTime > CurTime()) then
			local pos = self:GetPos()
			for k,v in ipairs(ents.FindInSphere(self:GetPos(), 360)) do
				if(!ZShelter.ValidateEntity(self, v)) then continue end
				local vel = (pos - v:GetPos())
				local f = math.Clamp((pos:Distance(v:GetPos()) / 360) + 0.75, 0, 1)
				vel:Normalize()
				v:SetLocalVelocity(vel * (800 * f))
			end
		else
			self.Pulling = false
			sound.Play("weapons/physcannon/energy_sing_explosion2.wav", self:GetPos() + Vector(0, 0, 8), 120, 100, 1)
			local e = EffectData()
				e:SetOrigin(self:GetPos() + Vector(0, 0, 8))
				e:SetAngles(self:GetAngles() - Angle(0, 180, 0))
				util.Effect("zshelter_pushing", e)
			for k,v in ipairs(ents.FindInSphere(self:GetPos(), 200)) do
				if(!ZShelter.ValidateEntity(self, v)) then continue end
				v:TakeDamage(100, self, self)
			end
			if(ZShelter.ShouldDetonate(self:GetOwner(), self)) then
				self:Remove()
			else
				self.AimTarget = nil
				self:NextThink(CurTime() + 15)
				return true
			end
		end
	end

	self:NextThink(CurTime() + 0.1)
	return true
end