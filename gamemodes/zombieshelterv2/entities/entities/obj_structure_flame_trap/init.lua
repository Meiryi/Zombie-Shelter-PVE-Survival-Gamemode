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
	if(!self.StartAttack) then
		self:FindEnemy()
		self:NextThink(CurTime() + 0.15)
		return true
	else
		self:SetAngles(Angle(-90, 0, 0))
		if(!self.FlameAttached) then
			ParticleEffectAttach("vj_hlr_garg_flame", PATTACH_POINT_FOLLOW, self, 0)
			sound.Play("vj_hlr/hl1_npc/garg/gar_flameon1.wav", self:GetPos() + Vector(0, 0, 15), 100, 75, 1)
			self.FlameAttached = true
		end
		if(self.NextDamageTime < CurTime()) then
			for k,v in pairs(ents.FindInSphere(self:GetPos(), 100)) do
				if(!ZShelter.ValidateEntity(self, v)) then continue end
				v:TakeDamage(30, self, self)
			end
			self.NextDamageTime = CurTime() + 0.1
		end
		if(self.KillTime < CurTime()) then
			local e = EffectData()
				e:SetOrigin(self:GetPos() + Vector(0, 0, 10))
				util.Effect("HelicopterMegaBomb", e)
				sound.Play("vj_hlr/hl1_weapon/explosion/explode"..math.random(3, 5)..".wav", self:GetPos() + Vector(0, 0, 15), 100, 100, 1)
			
			if(ZShelter.ShouldDetonate(self.Owner, self)) then
				self:Remove()
			end
		end
	end
	self:NextThink(CurTime() + 0.05)
	return true
end