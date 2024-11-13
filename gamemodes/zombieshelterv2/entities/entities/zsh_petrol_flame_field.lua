ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Flame"
ENT.Category		= "None"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false

ENT.MyModel = "models/items/ar2_grenade.mdl"
ENT.MyModelScale = 0
ENT.Damage = 300
ENT.Radius = 50
ENT.StartFade = false
ENT.vAlpha = 255
ENT.KillTime = 0
ENT.DamageInterval = 0
ENT.FlySpeed = 75

if SERVER then
	AddCSLuaFile()
	function ENT:Initialize()
		self:SetModel("models/items/ar2_grenade.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		self:DrawShadow(false)
		self:SetRenderMode(RENDERMODE_TRANSALPHA)
		local phys = self:GetPhysicsObject()
		if(IsValid(phys)) then
			phys:Wake()
		end
		self.KillTime = CurTime() + 8
	end

	ENT.NextParticleTime = 0
	function ENT:Think()
		if(self.KillTime < CurTime()) then
			self:Remove()
			return
		end
		if(self.NextParticleTime < CurTime()) then
			local e = EffectData()
				e:SetOrigin(self:GetPos())
				e:SetRadius(256)
			util.Effect("zshelter_petrol_flame_field", e)
			for _, ent in ipairs(ents.FindInSphere(self:GetPos(), 300)) do
				if(!ZShelter.HurtableTarget(ent) || ent == self.Owner) then continue end
				ZShelter.Ignite(ent, self.Owner, 2, 10)
				ent:TakeDamage(10, self.Owner, self)
			end
			self.NextParticleTime = CurTime() + 0.2
		end

		self:NextThink(CurTime() + 0.1)
		return true
	end
end

function ENT:Draw()
	return
end
