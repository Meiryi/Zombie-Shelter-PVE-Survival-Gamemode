ENT.Base 			= "base_gmodentity"
ENT.Type 			= "ai"
ENT.PrintName 		= "ZShelter Mini Turret"
ENT.Author 			= "Meika"
ENT.Contact 		= ""
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "ZShelter"

if(CLIENT) then
	local choppers = {}
	local clr = Color(50, 255, 50)
	ENT.Added = false
	function ENT:Think()
		if(!self.Added) then
			table.insert(choppers, self)
			self.Added = true
		end
	end

	hook.Add("PreDrawHalos", "ZShelter_ChopperGlow", function()
		if(#choppers <= 0) then return end
		for k,v in pairs(choppers) do
			if(!IsValid(v)) then
				table.remove(choppers, k)
			end
		end
		halo.Add(choppers, clr, 3, 3, 1, true, true)
	end)
end