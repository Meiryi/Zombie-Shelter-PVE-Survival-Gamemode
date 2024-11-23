AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/props_combine/combine_generator01.mdl"
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
end

ENT.elems = {
	{
		source = "Woods",
		target = "Irons",
		require = 2,
		produce = 1,
	},
	{
		source = "Irons",
		target = "Woods",
		require = 2,
		produce = 1,
	},
}

ENT.ProcessTime = 7
ENT.BaseProcessTime = 7
ENT.BaseCapacity = 24
function ENT:Think()
	local capacity = GetGlobalInt("Capacity", 32)
	self:SetNWInt("Capacity", self.BaseCapacity + (self:GetNWInt("UpgradeCount", 0) * 12))
	self.ProcessTime = self.BaseProcessTime - (self:GetNWInt("UpgradeCount", 0) * 2)
	for _, resdata in ipairs(self.elems) do
		local holding = self:GetNWInt("r_"..resdata.source)
		local storage = GetGlobalInt(resdata.target)
		if(holding < resdata.require || storage >= capacity) then continue end
		if(!self.elems[_].nextprocess) then
			self.elems[_].nextprocess = CurTime() + self.ProcessTime
		end
		local next_t = self.elems[_].nextprocess
		local fracrtionnwstr = resdata.source.."_"..resdata.target.."_fraction"
		local fraction = math.Clamp((next_t - CurTime()) / self.ProcessTime, 0, 1)
		self:SetNWFloat(fracrtionnwstr, fraction)

		if(fraction <= 0) then
			self.elems[_].nextprocess = nil
			self:SetNWInt("r_"..resdata.source, math.max(holding - resdata.require, 0))
			SetGlobalInt(resdata.target, math.min(storage + resdata.produce, capacity))
		end
	end

	self:NextThink(CurTime() + 0.15)
	return true
end

function ENT:Use(ent)
	if(!IsValid(ent) || !ent:IsPlayer()) then return end
	ZShelter.ResourceConverterUI(ent, self)
end