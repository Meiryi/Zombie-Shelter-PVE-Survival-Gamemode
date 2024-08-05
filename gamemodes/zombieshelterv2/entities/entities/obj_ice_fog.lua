ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Flame"
ENT.Category		= "None"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false

ENT.MyModel = "models/items/ar2_grenade.mdl"
ENT.MyModelScale = 0
ENT.Damage = 300
ENT.Radius = 50
ENT.StartFade = false
ENT.vAlpha = 255
ENT.KillTime = 0
ENT.DamageInterval = 0
ENT.FlySpeed = 60

if SERVER then
	AddCSLuaFile()
	function ENT:Initialize()
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:DrawShadow(false)
		self:SetRenderMode(RENDERMODE_TRANSALPHA)
		self.KillTime = CurTime() + 0.75
	end

	function ENT:Think()
		self:SetPos(self:GetPos() + self:GetAngles():Forward() * self.FlySpeed)
		if(self.KillTime < CurTime()) then
			self:Remove()
		end
		self:NextThink(CurTime() + 0.1)
		return true
	end
end

ENT.StartTime = nil
ENT.MaxTime = 0.2
ENT.MaxSpriteSize = 60
ENT.SpriteMaterial = Material("sprites/shelter_ice")
function ENT:Draw()
	if(!self.StartTime) then
		self.StartTime = CurTime()
	end
	local sx = self.MaxSpriteSize * (math.min(CurTime() - self.StartTime, 3) / self.MaxTime)
	render.SetMaterial(self.SpriteMaterial)
	render.DrawSprite(self:GetPos(), sx, sx, Color(50, 50, 255, 255))
end
