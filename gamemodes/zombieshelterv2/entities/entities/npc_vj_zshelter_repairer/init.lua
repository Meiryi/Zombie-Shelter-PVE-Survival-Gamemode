AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/props_lab/reciever_cart.mdl"
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.PlayerFriendly = true
ENT.IsBuilding = true
ENT.IsVJBaseSNPC_Animal = true
ENT.MaximumDistance = 250
ENT.Damage = 70

ENT.ShootingTarget = nil

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
	local owner = self:GetOwner()
	
	if(IsValid(owner)) then
		repair = repair * owner:GetNWFloat("RepairSpeed", 1)
	end
	local min, max = self:GetPos() + Vector(-self.MaximumDistance, -self.MaximumDistance, -self.MaximumDistance), self:GetPos() + Vector(self.MaximumDistance, self.MaximumDistance, self.MaximumDistance)
	for k,v in pairs(ents.FindInBox(min, max)) do
		if(!v.IsBuilding || !v:GetNWBool("Completed") || v:GetNWBool("DurabilitySystem", false)) then continue end
		if(v:Health() > v:GetMaxHealth() * 1.1 || v == self) then continue end
		if(v.LastDamageTime && v.LastDamageTime > CurTime()) then continue end
		local repair = 10
		local hp, mhp = v:Health(), v:GetMaxHealth()
		if(v:GetClass() == "npc_vj_zshelter_repairer") then
			repair = 5
		end
		v:SetHealth(math.min(hp + repair, mhp * 1.1))
	end

	local e = EffectData()
		e:SetOrigin(self:GetPos() - Vector(0, 0, 30))
		util.Effect("zshelter_repair", e)
	self:NextThink(CurTime() + 1.5)
	return true
end