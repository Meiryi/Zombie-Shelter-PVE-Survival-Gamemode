ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "BALROG-11 Round"
ENT.Category		= "None"
ENT.Spawnable		= false
ENT.AdminSpawnable	= false
ENT.KillTime = 0
ENT.AliveTime = 0.55
ENT.StartingDamage = 65

if SERVER then
	AddCSLuaFile()
	function ENT:Initialize()
		self:SetModel("models/Items/AR2_Grenade.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_WORLD)
		self:SetCollisionBounds(Vector(-24, -24, -24), Vector(24, 24, 24))
		local phys = self:GetPhysicsObject()
		if(IsValid(phys)) then
			phys:Wake()
			phys:EnableGravity(false)
		end
		self:SetTrigger(true)
		self.KillTime = CurTime() + self.AliveTime
	end

	function ENT:Think()
		if(self.KillTime < CurTime()) then
			self:Remove()
		end
		self:NextThink(CurTime())
		return true
	end

	function ENT:StartTouch(ent)
		if(!IsValid(self.Owner) || ent == self.Owner || (ent.LastBlastTime && ent.LastBlastTime > CurTime())) then
			return
		end
		local wep = self.Owner:GetActiveWeapon()
		if(!IsValid(wep)) then
			wep = self
		end
		ent:TakeDamage(self.StartingDamage, self.Owner, wep)
		ent.LastBlastTime = CurTime() + 0.1
		self.StartingDamage = self.StartingDamage * 0.85
	end

	function ENT:PhysicsCollide(data, physobj)	
		local hitworld = data.HitEntity
		if(data.HitEntity == game.GetWorld()) then
			self:Remove()
		end
	end
end

if(CLIENT) then
	function ENT:Initialize()
		self.KillTime = CurTime() + self.AliveTime
	end
end

local mat = Material("sprites/flame_puff01")
local size = 128
local scaling = 0
local forwardedRendering = 4
local yaw = Angle(0, 180, 0)
function ENT:Draw()
	local fraction = math.Clamp((self.KillTime - CurTime()) / self.AliveTime, 0, 1)
	for i = forwardedRendering, 1, -1 do
		local sx = size * ((i - forwardedRendering) / forwardedRendering)
		local vec = self:GetAngles():Forward() * (size * i) * 0.5
		render.SetMaterial(mat)
		render.DrawSprite(self:GetPos() - vec, sx, sx, Color(255, 255, 255))
	end
end