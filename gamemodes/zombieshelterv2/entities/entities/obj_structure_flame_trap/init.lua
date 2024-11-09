AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/combine_helicopter/helicopter_bomb01.mdl"
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.PlayerFriendly = true
ENT.IsBuilding = true
ENT.IsVJBaseSNPC_Animal = true
ENT.MaximumDistance = 80
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
		self.StartAttack = true
		self.KillTime = CurTime() + 2
		return
	end
end

ENT.StartAttack = false
ENT.FlameAttached = false
ENT.KillTime = 0
ENT.NextDamageTime = 0
ENT.FlameSound = "vj_hlr/hl1_npc/garg/gar_flamerun1.wav"
function ENT:Think()
	local takeHealth = false
	if(self:Health() <= 0) then return end
	local e = EffectData()
		e:SetOrigin(self:GetPos() + Vector(0, 0, 10))
		util.Effect("zshelter_flame_field", e)
	local attacker = self:GetOwner() || self
	for k,v in ipairs(ents.FindInSphere(self:GetPos(), 186)) do
		if(!ZShelter.ValidTarget(nil, v)) then continue end
		ZShelter.Ignite(v, attacker, 2.5, self.AttackDamage)
		takeHealth = true
	end

	if(takeHealth) then
		self:SetHealth(math.max(self:Health() - 1, 0))
	end

	self:NextThink(CurTime() + 0.33)
	return true
end