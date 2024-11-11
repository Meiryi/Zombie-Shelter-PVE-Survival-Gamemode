ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "THANATOS-1 Blade"
ENT.Category		= "None"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false


ENT.MyModel = "models/weapons/tfa_cso/thanatos11_scythe.mdl"
ENT.MyModelScale = 1
ENT.Damage = 100
ENT.Radius = 200
if SERVER then

	AddCSLuaFile()

	function ENT:Initialize()

		local model = self.MyModel and self.MyModel or "models/weapons/tfa_cso/thanatos11_scythe.mdl"
		
		self.Class = self:GetClass()
		
		self:SetModel(model)
		util.SpriteTrail(self, 0, Color(175,225,255), false, 3, 1, 0.5, 0.125, "trails/smoke.vmt")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:DrawShadow(true)
		self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
		self:SetHealth(1)
		self:SetModelScale(self.MyModelScale,0)
		
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:SetMass(1)
			phys:EnableDrag(false)
			phys:EnableGravity(false)
			phys:SetBuoyancyRatio(0)
		end

		if (phys:IsValid()) then
			phys:Wake()
		end
	end

	function ENT:PhysicsCollide(data, physobj)
		local owent = self.Owner and self.Owner or self
		util.BlastDamage(self,owent,self:GetPos(),self.Radius,self.Damage)
		local fx = EffectData()
		fx:SetOrigin(self:GetPos())
		fx:SetNormal(data.HitNormal)
		util.Effect("exp_thanatos1",fx)
		self:Remove()
	end
end

if CLIENT then
	
	function ENT:Draw()
		self:DrawModel()
	end

end