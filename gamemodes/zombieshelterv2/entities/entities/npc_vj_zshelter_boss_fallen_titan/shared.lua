ENT.Base 			= "npc_vj_creature_base"
ENT.Type 			= "ai"
ENT.PrintName 		= "Prototype Phobos"
ENT.Author 			= ""
ENT.Contact 		= ""
ENT.Purpose 		= "Create and kill it"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= ""

function ENT:Draw()
	local matrix = Matrix()
	matrix:Translate(Vector(0, 0, 32))
	self:EnableMatrix("RenderMultiply", matrix)
	self:DrawModel()
end