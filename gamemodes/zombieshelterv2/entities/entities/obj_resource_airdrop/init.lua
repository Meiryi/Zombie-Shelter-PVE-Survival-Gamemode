AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/zshelter/space_a_box01.mdl"
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.PlayerFriendly = true
ENT.IsVJBaseSNPC_Animal = true

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)
	self:SetTrigger(true)
	if(self:GetPhysicsObject()) then
		self:GetPhysicsObject():EnableMotion(false)
	end
	self.StartDay = GetGlobalInt("Day")
	self:AddEFlags(EFL_IN_SKYBOX)
end

ENT.PositionSet = false
function ENT:Think()
	if(!self.actualPosition || math.abs(self.StartDay - GetGlobalInt("Day")) > 1) then self:Remove() end
	if(self:GetPos().z <= self.actualPosition.z || self.PositionSet) then
		self:SetPos(self.actualPosition)
		self.PositionSet = true
	else
		self:SetPos(self:GetPos() - Vector(0, 0, 1500 * FrameTime()))
	end
	self:NextThink(CurTime())
	return true
end