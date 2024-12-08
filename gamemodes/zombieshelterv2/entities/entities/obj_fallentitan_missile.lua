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
		self:SetModel("models/weapons/tfa_cso/w_mgsm_missile.mdl")
		self:PhysicsInit(SOLID_BBOX)
		self:SetSolid(SOLID_BBOX)
		self:SetCollisionGroup(2)
		util.SpriteTrail(self, 0, Color(255, 255, 255, 255), false, 10, 1, 1, 1/(15+1)*0.5, "trails/smoke.vmt")
	end

	function ENT:PhysicsCollide()
		for k,v in ipairs(ents.FindInSphere(self:GetPos(), 200)) do
			if(!v.IsBuilding && !v:IsPlayer()) then continue end
			if(v.IsBuilding) then
				ZShelter.ApplyDamageFast(v, self.damage * 0.65, true, true)
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