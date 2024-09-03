AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/combine_turrets/floor_turret.mdl"
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.PlayerFriendly = true
ENT.IsBuilding = true
ENT.IsTurret = true
ENT.IsVJBaseSNPC_Animal = true
ENT.MaximumDistance = 900
ENT.AimTarget = nil

function ENT:RunAI() -- Disable VJ Base's AI
	return
end

ENT.NextShootTime = 0
ENT.RotateSpeed = 0.45
ENT.Firerate = 2
ENT.LosAngle = 8
ENT.CheckValidTime = 0
ENT.Deg = math.cos(math.rad(65))
ENT.MaxChainCount = 6
ENT.CurrentChainCount = 0
ENT.ChainTargets = {}
ENT.StopChain = false

function ENT:NextChainTarget(ent)
	if(self.CurrentChainCount >= self.MaxChainCount) then return end
	local vpos = ent:GetPos() + Vector(0, 0, ent:OBBMaxs().z * 0.5)
	local localchained = 1
	for k,v in ipairs(ents.FindInSphere(ent:GetPos(), 256)) do
		if(localchained > 2 || self.StopChain) then return end
		if(!ZShelter.ValidateEntity(self, v) || v == target || self.ChainTargets[v:EntIndex()]) then continue end
		v:TakeDamage(40, self, self)
		local e = EffectData()
			e:SetOrigin(vpos)
			e:SetStart(v:GetPos() + Vector(0, 0, v:OBBMaxs().z * 0.5))
			util.Effect("zshelter_tesla", e)
		self.ChainTargets[v:EntIndex()] = true
		localchained = localchained + 1
		self.CurrentChainCount = self.CurrentChainCount + 1
		if(self.CurrentChainCount >= self.MaxChainCount) then
			self.StopChain = true
			return
		else
			self:NextChainTarget(v)
		end
	end
end

function ENT:Think()
	local vec = Angle(0, self:EyeAngles().y, 0):Forward()
	local vect = self:GetPos() + Vector(0, 0, 50)
	local c = 0
	local dst = 0
	local target = nil
	self.StopChain = false
	self.ChainTargets = {}
	self.CurrentChainCount = 0
	for k,v in ipairs(ents.FindInCone(self:GetPos(), vec, self.MaximumDistance, self.Deg)) do
		if(!ZShelter.ValidateEntity(self, v) || !ZShelterVisible_Vec_IgnoreTurret(self, vect, v)) then continue end
		local _dst = vect:Distance(v:GetPos())
		if(!target) then
			target = v
			dst = _dst
		else
			if(dst > _dst) then
				target = v
				dst = _dst
			end
		end
	end
	if(IsValid(target)) then
		self.ChainTargets[target:EntIndex()] = true
		local e = EffectData()
			e:SetOrigin(self:GetPos() + self:GetUp() * 53 + self:GetForward() * 8 + self:GetRight() * -5)
			e:SetStart(target:GetPos() + Vector(0, 0, target:OBBMaxs().z * 0.5))
			util.Effect("zshelter_tesla", e)
		self:EmitSound("weapons/gauss/fire1.wav")
		sound.Play("shigure/ion_cannon_shot2.wav", self:GetPos(), 60, 110, 1)
		target:TakeDamage(30, self, self)
		self:NextChainTarget(target)
	end
	self:NextThink(CurTime() + self.Firerate)
	return true
end