ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "PlasmaEXA"
ENT.Category		= "None"
ENT.Spawnable		= false
ENT.AdminSpawnable	= false
ENT.MyModel = "models/items/ar2_grenade.mdl"

if SERVER then
	AddCSLuaFile()
	function ENT:Initialize()
		self:SetModel("models/items/ar2_grenade.mdl")
		self.KillTime = CurTime() + 1.6
	end
	function ENT:Think()
		if(self.KillTime < CurTime()) then self:Remove() end
	end
end


ENT.Mat = Material("sprites/spr_boomer")
ENT.Frame = 0
function ENT:Draw()
	render.SetMaterial(self.Mat)
	self.Frame = self.Frame + FrameTime() * 0.6
	self.Mat:SetInt("$frame", math.Clamp(math.floor(self.Frame * 27), 0, 27))
	local size = 400
	render.DrawSprite(self:GetPos() + Vector(0, 0, size * 0.2) , size, size, Color(255, 255, 255, 255))
end