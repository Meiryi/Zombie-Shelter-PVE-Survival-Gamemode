AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Model = {"models/Gibs/wood_gib01e.mdl"}
ENT.MoveType = MOVETYPE_VPHYSICS
ENT.MoveCollideType = MOVECOLLIDE_DEFAULT
ENT.SolidType = SOLID_CUSTOM
ENT.RemoveOnHit = true
ENT.DoesRadiusDamage = true
ENT.RadiusDamageRadius = 180
ENT.RadiusDamage = 20
ENT.RadiusDamageUseRealisticRadius = true
ENT.RadiusDamageType = DMG_SHOCK
ENT.SoundTbl_OnCollide = {"zshelter/zombies/deimos_skill_hit.wav"}
ENT.OnCollideSoundPitch1 = 100
ENT.OnCollideSoundPitch2 = 100
ENT.NextMeleeAttackTime = 1

function ENT:CustomPhysicsObjectOnInitialize(phys)
	phys:Wake()
	phys:EnableGravity(false)
	phys:SetBuoyancyRatio(0)
	phys:EnableDrag(false)
end

function ENT:CustomOnInitialize()
	self:SetMaterial("models/ihvtest/eyeball_l.vmt")
	self:SetColor(Color(255,93,0,255))
	util.SpriteTrail( self, 0, Color(255, 93, 0), true, 15, 3, 0.5, 0.14, "sprites/physgbeamb.vmt" )
end

function ENT:DeathEffects()
	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	util.Effect( "blood_zombie_split", effectdata )

	self.ExplosionLight1 = ents.Create("light_dynamic")
	self.ExplosionLight1:SetKeyValue("brightness", "4")
	self.ExplosionLight1:SetKeyValue("distance", "300")
	self.ExplosionLight1:SetLocalPos(self:GetPos())
	self.ExplosionLight1:SetLocalAngles( self:GetAngles() )
	self.ExplosionLight1:Fire("Color", "255 93 0")
	self.ExplosionLight1:SetParent(self)
	self.ExplosionLight1:Spawn()
	self.ExplosionLight1:Activate()
	self.ExplosionLight1:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(self.ExplosionLight1)

	//local tr = self:EyePos()

	self.exp_radius = 120

	local zget = ents.FindInSphere(self:GetPos(),self.exp_radius)
	for k,v in ipairs(zget) do
		if(!ZShelter.ValidateEntity(self, v)) then continue end
		v:TakeDamage(20, self, self)
	end

	self:SetLocalPos(Vector(self:GetPos().x,self:GetPos().y,self:GetPos().z +4)) -- Because the entity is too close to the ground
	
	self:SetDeathVariablesTrue(nil,nil,false)
end