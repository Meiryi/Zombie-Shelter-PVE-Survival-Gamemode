ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Flame"
ENT.Category		= "None"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false

ENT.Damage = 300
ENT.Radius = 50
ENT.StartFade = false
ENT.vAlpha = 255
ENT.KillTime = 0
ENT.DamageInterval = 0
ENT.FlySpeed = 128
ENT.HitWorld = false

if SERVER then
	AddCSLuaFile()
	local bounds = Vector(72, 72, 72)
	function ENT:Initialize()
		self:SetModel("models/Items/AR2_Grenade.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_WORLD)
		local phys = self:GetPhysicsObject()
		if(IsValid(phys)) then
			phys:Wake()
			phys:EnableGravity(false)
			local vel = self:GetAngles():Forward() * 1250
			phys:SetVelocity(vel)
		end

		self.Damage = 17 * (1 + (GetConVar("zshelter_difficulty"):GetInt() * 0.025))

		self:SetTrigger(true)
		self:SetCollisionBounds(-bounds, bounds)
	end

	ENT.Hits = {}
	function ENT:Think()
		if(self.KillTime < CurTime() || !IsValid(self:GetOwner())) then
			self:Remove()
		else
			local tr = util.TraceEntity({
				start = self:GetPos(),
				endpos = self:GetPos(),
				filter = {"obj_ampsuit_flame"},
				ignoreworld = true,
			},self)
			if(IsValid(tr.Entity) && !self.Hits[tr.Entity:EntIndex()]) then
				if(tr.Entity:IsPlayer()) then
					tr.Entity:TakeDamage(self.Damage, self:GetOwner(), self:GetOwner())
				else
					tr.Entity:TakeDamage(self.Damage * 0.33, self:GetOwner(), self:GetOwner())
				end
				if(tr.Entity.IsPlayerBarricade) then
					self:Remove()
					return
				end
				self.Hits[tr.Entity:EntIndex()] = true
			end
		end
		self:NextThink(CurTime() + 0.025)
		return true
	end

	function ENT:PhysicsCollide(data, physobj)	
		local hitworld = data.HitEntity
		if(data.HitEntity == game.GetWorld() && !self.HitWorld) then
			self.KillTime = CurTime() + 0.15
			self.HitWorld = true
		end
	end
end

ENT.StartTime = nil
ENT.MaxTime = 0.25
ENT.MaxSpriteSize = 128
ENT.SpriteMaterial = Material("sprites/shelter_flame")
function ENT:Draw()
	if(!self.StartTime) then
		self.StartTime = CurTime()
	end
	local sx = self.MaxSpriteSize * (math.min(CurTime() - self.StartTime, 3) / self.MaxTime)
	render.SetMaterial(self.SpriteMaterial)
	render.DrawSprite(self:GetPos(), sx, sx, Color(255, 255, 255, 255))
end
