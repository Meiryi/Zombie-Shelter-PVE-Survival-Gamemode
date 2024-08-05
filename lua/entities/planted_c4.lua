AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Spawnable = false

function ENT:Draw()
	self.Entity:DrawModel()
	render.SetMaterial( Material( "sprites/redglow1" ) )
	render.DrawSprite( self:GetPos() + Vector( 1, -1, 9.5 ), 16, 16, Color( 255, 255, 255, self.Entity:GetNWInt( "LightAlpha", 0 ) ) )
end

function ENT:Initialize()
	if SERVER then
		self.Entity:SetModel( "models/weapons/w_c4_planted.mdl" )
		self.Entity:SetMoveType( MOVETYPE_NONE )
		self.Entity:SetSolid( SOLID_NONE )
		self.Entity:PhysicsInit( SOLID_NONE )
		self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		self.Entity:EmitSound( "c4.plant" )
	end
	self.LightAlpha = 0
	self.BeepTimer = CurTime() + 1
	self.ExplodeTimer = CurTime() + 7
	self.Entity:SetNWInt( "LightAlpha", 0 )
end

function ENT:Think()
	if self.BeepTimer <= CurTime() then
	if SERVER then
		self.Entity:EmitSound( "c4.click" )
	end
	self.BeepTimer = CurTime() + ( self.ExplodeTimer - CurTime() ) / 15 * 4
	self.LightAlpha = 255
	end
	if self.LightAlpha > 0 then
		self.LightAlpha = self.LightAlpha - 10
	end
	if self.LightAlpha < 0 then
		self.LightAlpha = 0
	end
	self.Entity:SetNWInt( "LightAlpha", self.LightAlpha )
	if SERVER and self.ExplodeTimer <= CurTime() then
		self.Entity:Remove()
	end
end

function ENT:OnRemove()
	if SERVER then
		local explode = ents.Create( "info_particle_system" )
		explode:SetKeyValue( "effect_name", "explosion_silo" )
		explode:SetOwner( self.Owner )
		explode:SetPos( self:GetPos() )
		explode:Spawn()
		explode:Activate()
		explode:Fire( "start", "", 0 )
		explode:Fire( "kill", "", 3 )
		self.Entity:EmitSound( "c4.explode" )
		util.BlastDamage( self, self.Owner, self:GetPos(), 800, 8000 )
		if(!IsValid(self:GetOwner())) then return end
		for k,v in pairs(ents.FindInSphere(self:GetPos(), 1024)) do
			if(!v.IsBarricade) then continue end
			ZShelter.HandleBarricade(v, self:GetOwner(), 999999)
		end
	end
end