ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= ""
ENT.Category		= "None"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false


if SERVER then
	AddCSLuaFile()
	local bounds = Vector(128, 128, 64)
	function ENT:Initialize()
		self:SetModel("models/effects/tfa_cso/ef_halogun_projectile.mdl")
		self:PhysicsInitBox(-bounds, bounds)
		self:DrawShadow(false)
		self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		local s, e = 48, 1
		util.SpriteTrail(self, 0, Color(255, 0, 0, 255), true, s, e, 0.5, 1 / (s + 1) * 0.25, "models/weapons/tfa_cso/halogun/$20@004halogun_projectile")
		self:SetTrigger(true)
		self.KillTime = CurTime() + 2
		self:Think()
	end

	ENT.HitTargets = {}
	ENT.BlackListEnts = {}
	function ENT:Touch(ent)
		if(ent == self:GetOwner() || ent.IsBuilding || self.BlackListEnts[ent:EntIndex()]) then return end
		if(!self.HitTargets[ent:EntIndex()]) then
			self.HitTargets[ent:EntIndex()] = 0
		end
		if(!ent.NoPush) then
			local vel = self:GetAngles():Forward() * 1024
			vel.z = 0
			ent:SetVelocity(ent:GetVelocity() * -1 + vel + Vector(0, 0, 64)) -- No escape for you lol
		end

		local dmg = 100
		if(self.HitTargets[ent:EntIndex()] < CurTime()) then
			if(ent:IsPlayer() || (ent:IsNPC() && !ent.IsBuilding) || ent:IsNextBot()) then
				local attacker = self:GetOwner()
				local inflictor = self.Inflictor
				if(!IsValid(attacker)) then
					attacker = self
				end
				if(!IsValid(inflictor)) then
					inflictor = self
				end

				if(ent:IsPlayer()) then
					ent:TakeDamage(8, ent, ent)

					if(IsValid(self.Owner) && self.Owner:IsPlayer()) then
						net.Start("ZShelter-DamageNumber")
						net.WriteInt(ent:EntIndex(), 32)
						net.WriteInt(8, 32)
						net.WriteVector(ent:GetPos() + ent:OBBCenter())
						net.Send(self.Owner)
					end
				end

				local dmginfo = DamageInfo()
				if(ent.IsBoss) then
					dmginfo:SetDamage(2000)
					self.BlackListEnts[ent:EntIndex()] = true
				else
					dmginfo:SetDamage(dmg)
				end
				dmginfo:SetAttacker(attacker)
				dmginfo:SetInflictor(inflictor)
				dmginfo:SetDamageType(DMG_BULLET)
				dmginfo:SetDamagePosition(ent:GetPos() + ent:OBBCenter())
				ent:TakeDamageInfo(dmginfo)
			end
			self.HitTargets[ent:EntIndex()] = CurTime() + 0.1
		end
	end

	function ENT:Think()
		if(self.KillTime < CurTime()) then
			self:Remove()
			return
		end

        local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableGravity(false)
			phys:EnableCollisions(false)

			phys:SetVelocity(phys:GetAngles():Forward() * 1024)
		end

		self:NextThink(CurTime())
		return true
	end
end

local mat = Material("models/weapons/tfa_cso/halogun/$20@004halogun_projectile")
function ENT:Draw()
	local ang = self:GetAngles()
	local roll = ang.r
	roll = roll + (720 * RealFrameTime())
	if(roll >= 360) then
		roll = roll - 360
	end
	self:SetRenderAngles(Angle(ang.p, ang.y, roll))
	self:DrawModel()
end