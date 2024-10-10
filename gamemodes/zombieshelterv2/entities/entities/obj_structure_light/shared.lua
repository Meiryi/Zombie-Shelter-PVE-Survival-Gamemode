ENT.Base 			= "base_gmodentity"
ENT.Type 			= "anim"
ENT.PrintName 		= "ZShelter Mini Turret"
ENT.Author 			= "Meika"
ENT.Contact 		= ""
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "ZShelter"

ENT.LightEntity = nil


if(CLIENT) then
	function ENT:Think()
		if(!self:GetNWBool("Completed", false)) then return end
		if(!self.LightEntity) then
			self.LightEntity = DynamicLight(self:EntIndex())
			if(self.LightEntity) then
				self.LightEntity.pos = self:GetPos() + Vector(0, 0, 1)
				self.LightEntity.r = 255
				self.LightEntity.g = 255
				self.LightEntity.size = 768
				self.LightEntity.b = 255
				self.LightEntity.brightness = 8
				self.LightEntity.dietime = CurTime() + 0.5
			end
		else
			if(!GetGlobalBool("Night")) then
				self.LightEntity.brightness = 2
			else
				self.LightEntity.brightness = 8
			end
			self.LightEntity.dietime = CurTime() + 0.5
		end
		self:SetNextClientThink(CurTime() + 0.1)
		return true
	end
end

