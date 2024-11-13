if (SERVER) then
	AddCSLuaFile("cl_init.lua")
	AddCSLuaFile("shared.lua")
end

include("shared.lua")
ENT.MyModelScale = 0.75
ENT.Damage = 75
ENT.Radius = 128
function ENT:Initialize()
	self.Entity:SetModel("models/weapons/tfa_cso/w_petrol.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	util.SpriteTrail(self, 0, Color(255,255,255), false, 7, 0.5, 0.5, 0.125, "trails/smoke.vmt")
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	self:SetHealth(1)
	self:SetModelScale(self.MyModelScale,0)
	self.Entity:Ignite(10, 0)
	self.Entity:GetPhysicsObject():AddAngleVelocity(Vector(0, 0, 0))
	timer.Simple(10, function()
		if self:IsValid() then self:Remove() end
	end )
end

function ENT:Think()
	if self.Entity:WaterLevel() > 0 then self.Entity:Extinguish() end
end

function ENT:OnRemove()
	local flameField = ents.Create("zsh_petrol_flame_field")
		flameField:SetPos(self:GetPos())
		flameField:SetOwner(self.Owner)
		flameField:Spawn()
	for _, ent in ipairs(ents.FindInSphere(self:GetPos(), 256)) do
		if(!ZShelter.HurtableTarget(ent) || ent == self.Owner) then continue end
		ZShelter.Ignite(ent, self.Owner, 4, 15)
		ent:TakeDamage(100, self.Owner, self)
	end
end

function ENT:PhysicsCollide()
		local fx = EffectData()
		fx:SetOrigin(self:GetPos())
		util.Effect("exp_petrol",fx)
		self:Remove()
end