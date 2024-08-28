ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= ""
ENT.Category		= "None"
ENT.Spawnable		= false
ENT.AdminSpawnable	= false

ENT.damage = 30

if SERVER then
	AddCSLuaFile()
	function ENT:Initialize()
		self:SetModel("models/misc/zbs_bossl_big02_bomb.mdl")
		self:PhysicsInit(SOLID_BBOX)
		self:SetSolid(SOLID_BBOX)
		self:SetCollisionGroup(2)
	end

	function ENT:PhysicsCollide()
		for k,v in ipairs(ents.FindInSphere(self:GetPos(), 150)) do
			if(!v.IsBuilding && !v:IsPlayer()) then continue end
			if(v.IsBuilding) then
				ZShelter.ApplyDamageFast(v, self.damage, true, true)
			else
				v:TakeDamage(self.damage, self, self)
			end
		end
		local e = EffectData()
			e:SetOrigin(self:GetPos())
			util.Effect("Explosion", e)
		self:Remove()
	end
end