ENT.Base 			= "base_gmodentity"
ENT.Type 			= "anim"
ENT.PrintName 		= "ZShelter Mini Turret"
ENT.Author 			= "Meika"
ENT.Contact 		= ""
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "ZShelter"
ENT.IsLootbox = true

function ENT:Draw()
	if(!IsValid(LocalPlayer()) || !LocalPlayer():Alive()) then return end
	self:DrawModel()
end