ENT.Base 			= "base_gmodentity"
ENT.Type 			= "anim"
ENT.PrintName 		= "ZShelter Mini Turret"
ENT.Author 			= "Meika"
ENT.Contact 		= ""
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "ZShelter"

ENT.EffectModel = nil
ENT.Yaw = 0
ENT.NextYawUpdate = 0

function ENT:Draw()
	self:DrawModel()
	if(!self:GetNWBool("Completed", false)) then return end
	if(!IsValid(self.EffectModel)) then
		self.EffectModel = ClientsideModel("models/props_c17/trappropeller_blade.mdl")
	else
		self.EffectModel:SetPos(self:GetPos() + Vector(0, 0, 25))
		self.EffectModel:SetAngles(Angle(0, self.Yaw, 0))
		if(self.NextYawUpdate < CurTime() && self:GetNWFloat("StunTime", 0) < CurTime() && self:Health() > 0) then
			self.Yaw = self.Yaw + (1250 * FrameTime())
			if(self.Yaw >= 360) then
				self.Yaw = 0
			end
		end
	end
end

function ENT:OnRemove()
	if(IsValid(self.EffectModel)) then
		self.EffectModel:Remove()
	end
end