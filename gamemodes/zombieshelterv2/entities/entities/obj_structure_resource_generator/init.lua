AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/props_wasteland/laundry_washer003.mdl"
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.PlayerFriendly = true
ENT.IsBuilding = true
ENT.IsVJBaseSNPC_Animal = true
ENT.ResourceType = "Woods"
ENT.Woods = 0
ENT.Irons = 0
ENT.BaseResources = 4

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)
	self:SetTrigger(true)

	if(self:GetPhysicsObject()) then
		self:GetPhysicsObject():EnableMotion(false)
	end
	self:SetNWInt("NextProvideTime", CurTime())
	self:SetNWInt("ProvideAmount", self.BaseResources)
	self.KillTime = CurTime() + 120
end

ENT.CurTime = 0
function ENT:Think()
	self:SetNWInt("ProvideAmount", self.BaseResources + math.floor(0.5 * GetGlobalInt("ShelterLevel", 0)))
	if(self.CurTime < CurTime() && GetGlobalBool("GameStarted")) then
		SetGlobalInt("Woods", math.min(GetGlobalInt("Woods", 0) + self:GetNWInt("ProvideAmount", 4), GetGlobalInt("Capacity", 32)))
		SetGlobalInt("Irons", math.min(GetGlobalInt("Irons", 0) + self:GetNWInt("ProvideAmount", 4), GetGlobalInt("Capacity", 32)))
		self:SetNWInt("ProvideInterval", 35 + ((player.GetCount() - 1) * 20))
		self:SetNWInt("NextProvideTime", CurTime() + self:GetNWInt("ProvideInterval", 30))
		if(IsValid(self.Builder) && self.Builder:IsPlayer()) then
			self.Builder:AddFrags(self:GetNWInt("ProvideAmount", self.BaseResources))
			self.Builder:SetNWInt("TWoods", self.Builder:GetNWInt("TWoods", 0) + self:GetNWInt("ProvideAmount", self.BaseResources))
			self.Builder:SetNWInt("TIrons", self.Builder:GetNWInt("TIrons", 0) + self:GetNWInt("ProvideAmount", self.BaseResources))
		end
		self.CurTime = CurTime() + 30
	end
	self:NextThink(CurTime() + 1)
	return true
end