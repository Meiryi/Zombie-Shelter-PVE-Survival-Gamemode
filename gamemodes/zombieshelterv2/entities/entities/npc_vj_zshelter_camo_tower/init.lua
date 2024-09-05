AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/props_lab/powerbox01a.mdl"
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.PlayerFriendly = true
ENT.IsBuilding = true
ENT.IsVJBaseSNPC_Animal = true
ENT.MaximumDistance = 128
ENT.Damage = 70

ENT.ShootingTarget = nil
ENT.CamoedTower = {}

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)
	if(self:GetPhysicsObject()) then
		self:GetPhysicsObject():EnableMotion(false)
	end
	self:SetNWBool("IsBuilding", true)
end

function ENT:RunAI()
	return
end

function ENT:Think()
	local camos = {}
	for k,v in ipairs(ents.FindInSphere(self:GetPos(), self.MaximumDistance)) do
		if(!v.IsBuilding || !v.IsTurret) then continue end
		table.insert(camos, v)
	end
	for k,v in ipairs(camos) do
		v:AddFlags(FL_NOTARGET)
		v:SetColor(Color(0, 0, 0, 120))
	end
	self.CamoedTower = camos
	self:NextThink(CurTime() + 1)
	return true
end

function ENT:OnRemove()
	for k,v in ipairs(self.CamoedTower) do
		print(v)
		v:RemoveFlags(FL_NOTARGET)
		v:SetColor(Color(255, 255, 255, 255))
	end
end