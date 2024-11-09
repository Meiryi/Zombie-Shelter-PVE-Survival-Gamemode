AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/props_combine/combine_mine01.mdl"
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.PlayerFriendly = true
ENT.IsBuilding = true
ENT.IsVJBaseSNPC_Animal = true
ENT.MaximumDistance = 86
ENT.AimTarget = nil

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)
	self:SetTrigger(true)
	self:SetCollisionGroup(2)
	self:AddFlags(65536)
	if(self:GetPhysicsObject()) then
		self:GetPhysicsObject():EnableMotion(false)
		self:GetPhysicsObject():Wake()
	end
end

function ENT:FindEnemy()
	for k,v in pairs(ents.FindInSphere(self:GetPos(), self.MaximumDistance)) do
		if(!ZShelter.ValidateEntity(self, v)) then continue end
		self.AimTarget = v
		return
	end
end

ENT.AimTarget = nil

function ENT:Think()
	local pos = self:GetPos()
	local shouldTakeHP = false
	if(self:Health() <= 0) then return end
	for k,v in ipairs(ents.FindInSphere(pos, 186)) do
		if(!ZShelter.ValidTarget(nil, v)) then continue end
		if((v.LastEFTime && v.LastEFTime > CurTime())) then
			v:SetMoveVelocity(v:GetMoveVelocity() * 0.4)
		end
		if(!v.LastApplyEffectTime || v.LastApplyEffectTime < CurTime()) then
			ZShelter.Freeze(v)
			v.LastApplyEffectTime = CurTime() + 0.2
		end
		v.LastEFTime = CurTime() + 0.2
		shouldTakeHP = true
	end
	if(shouldTakeHP) then
		self:SetHealth(math.max(0, self:Health() - 1))
	end
	local e = EffectData()
	e:SetOrigin(pos)
	util.Effect("zshelter_cyro_field", e)
	self:NextThink(CurTime() + 0.4)
	return true
end