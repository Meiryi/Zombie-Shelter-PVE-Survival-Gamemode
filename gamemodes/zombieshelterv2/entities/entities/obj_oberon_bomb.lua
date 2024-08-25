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
		util.BlastDamage(self, self, self:GetPos(), 100, self.damage)
		local e = EffectData()
			e:SetOrigin(self:GetPos())
			util.Effect("Explosion", e)
		self:Remove()
	end
end