ENT.Base 			= "base_gmodentity"
ENT.Type 			= "anim"
ENT.PrintName 		= "ZShelter Mini Turret"
ENT.Author 			= "Meika"
ENT.Contact 		= ""
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "ZShelter"

function ENT:Think()
end

local use = Material("zsh/icon/usable.png", "smooth")
ENT.UsePos = Vector(0, 0, 0)
function ENT:Draw()
	local mins, maxs = self:GetCollisionBounds()
	if(self.UsePos == Vector(0, 0, 0)) then
		self.UsePos = self:GetPos() + Vector(0, 0, maxs.z * 0.5) - self:GetRight() * 20
	end
	render.SetColorMaterial()
	render.DrawBox(self:GetPos(), self:GetAngles(), mins, maxs, Color(200, 255, 200, 1))
	render.SetMaterial(use)
	render.DrawSprite(self.UsePos, 8, 8, Color(255, 255, 255))
end