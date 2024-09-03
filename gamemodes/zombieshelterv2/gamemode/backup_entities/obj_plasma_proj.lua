ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "PlasmaEXA"
ENT.Category		= "None"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false


ENT.MyModel = "models/items/ar2_grenade.mdl"
ENT.MyModelScale = 0
ENT.Damage = 130
ENT.Radius = 128
if SERVER then

	AddCSLuaFile()

	function ENT:Initialize()

		local model = self.MyModel and self.MyModel or "models/items/ar2_grenade.mdl"
		
		self.Class = self:GetClass()
		
		self.NoCollide = true
		self:SetModel(model)
		self:PhysicsInitBox(Vector(-1, -1, -1), Vector(1, 1, 1))
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:DrawShadow(false)
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
        local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:SetMass(1)
			phys:EnableDrag(false)
			phys:EnableGravity(false)
			phys:SetBuoyancyRatio(0)
		end
				
		local phys = self:GetPhysicsObject()
		
		if (phys:IsValid()) then
			phys:Wake()
		end
	end

	function ENT:PhysicsCollide(data, physobj)	
	    local owent = self.Owner
	    if(!IsValid(owent)) then
	    	owent = self
	    end
		util.BlastDamage(self,owent, self:GetPos(), self.Radius, self.Damage)
		local fx = EffectData()
		fx:SetOrigin(self:GetPos())
		fx:SetNormal(data.HitNormal)
		util.Effect("exp_plasma_turret",fx)
		self:Remove()
	    self.Entity:EmitSound("shigure/plasmahit.wav", 100, 100 )
	end
end

ENT.Mat = Material("sprites/ef_y20s3plasmaexab_ball")
function ENT:Draw()
	render.SetMaterial(self.Mat)
	render.DrawSprite(self.Entity:GetPos() + ((Vector(0,0,0))),32,32,Color(255, 255, 255))
end