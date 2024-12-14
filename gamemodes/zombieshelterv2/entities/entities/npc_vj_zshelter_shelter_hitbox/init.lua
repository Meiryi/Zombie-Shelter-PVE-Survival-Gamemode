AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/items/ar2_grenade.mdl"
ENT.StartHealth = 2100000000
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.IsBuilding = true
ENT.IgnoreCollision = true
ENT.MaximumDistance = 1500
ENT.AimTarget = nil

function ENT:RunAI() -- Disable VJ Base's AI
	return
end

function ENT:Think()
	if(!IsValid(self:GetOwner())) then
		self:Remove()
	end
	self:SetNWBool("IsBait", true)
	self:SetNoDraw(true)
end