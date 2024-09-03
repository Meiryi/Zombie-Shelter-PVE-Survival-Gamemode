ENT.Base 			= "base_ai"
ENT.Type 			= "anim"
ENT.PrintName 		= "ZShelter Mini Turret"
ENT.Author 			= "Meika"
ENT.Contact 		= ""
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "ZShelter"

function ENT:Draw()
	self:DrawModel()
	if(!self:GetNWBool("Completed", false)) then return end
	local ply = LocalPlayer()
	cam.Start3D2D(self:GetPos() + Vector(0, 0, 50), self:GetAngles() - Angle(0, 90, -90), 0.15)
		draw.DrawText("Ammos : "..self:GetNWInt("CurrentAmmos", 0).." / "..self:GetNWInt("MaxAmmos", 0), "TargetID", 0, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	cam.End3D2D()
end