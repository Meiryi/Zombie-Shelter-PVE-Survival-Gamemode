AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/zshelter/turret_laser.mdl"
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.PlayerFriendly = true
ENT.IsBuilding = true
ENT.IsVJBaseSNPC_Animal = true
ENT.MaximumDistance = 2048
ENT.AimTarget = nil

function ENT:RunAI() -- Disable VJ Base's AI
	return
end

function ENT:FindEnemy()
	local dst = 0
	local vec = self:GetPos() + Vector(0, 0, 20)
	for k,v in pairs(ents.FindInSphere(self:GetPos(), self.MaximumDistance)) do
		if(!ZShelter.ValidateEntity(self, v)) then continue end
		if(!ZShelterVisible_Vec(self, vec, v)) then continue end
		local distance = self:GetPos():Distance(v:GetPos())
		if(dst == 0) then -- Choose closest enemy
			self.AimTarget = v
			dst = distance
		else
			if(dst > distance) then
				self.AimTarget = v
				dst = distance
			end
		end
	end
end

ENT.Firerate = 0.105
ENT.NextShootTime = 0
ENT.RotateSpeed = 0.25
ENT.LosAngle = 8
ENT.CheckValidTime = 0

ENT.InstantSwitch = false
ENT.Deployed = false
ENT.BarrelIndex = 1

function ENT:RunSequence(sequence)
	if(self:GetSequence() != sequence) then
		self:ResetSequence(sequence)
	else
		self:SetSequence(sequence)
	end
end

function ENT:Think()
	if(!IsValid(self.AimTarget)) then
		self:FindEnemy()
		if(!IsValid(self.AimTarget)) then
			self.BarrelIndex = 1
			self:RunSequence(0)
			self:NextThink(CurTime() + 0.33)
		end
		return true
	else
		local vec = self:GetPos() + Vector(0, 0, 20)
		if(self.CheckValidTime < CurTime()) then
			if(!ZShelterVisible_Vec(self, vec, self.AimTarget) || !ZShelter.ValidateTarget(self.AimTarget)) then
				self.AimTarget = nil
				return
			end
			self.CheckValidTime = CurTime() + 0.2
		end

		self.InstantSwitch = true
		local enemy = self.AimTarget

		local los = true
		local rotate = self:GetBoneController(0)
		local targetPos = (enemy:GetPos() + enemy:OBBCenter())
		local angle = (targetPos - self:EyePos()):Angle()
		angle:Normalize()
		local targetAngle = angle.y - self:GetAngles().y
		local barrelPos = self:GetPos() + Vector(0, 0, 20)

		local returnAngle = LerpAngle(self.RotateSpeed, Angle(0, rotate, 0), Angle(0, targetAngle, 0))
		self:SetBoneController(0, returnAngle.y)
		rotate = self:GetBoneController(0)

		if(math.abs(math.AngleDifference(rotate, angle.y - self:GetAngles().y)) < self.LosAngle) then
			los = false
		end

		if(los) then
			self:RunSequence(2)
		else
			self:RunSequence(1)
		end

		if(self.NextShootTime < CurTime() && !los) then
			local attch = self:GetAttachment(1)
			if(self.BarrelIndex == 1) then
				attch = self:GetAttachment(1)
			elseif(self.BarrelIndex == 2) then
				attch = self:GetAttachment(2)
			elseif(self.BarrelIndex == 3) then
				attch = self:GetAttachment(3)
			elseif(self.BarrelIndex == 4) then
				attch = self:GetAttachment(4)
			end
			if(attch) then
				barrelPos = attch.Pos
			end
			sound.Play("shigure/laserturret.wav", self:GetPos(), 100, 100, 0.75)
			local e = EffectData()
				e:SetOrigin(barrelPos)
				e:SetStart(targetPos)
			util.Effect("zshelter_laser_minigun", e)
			enemy:TakeDamage(20, self, self)

			self.BarrelIndex = self.BarrelIndex + 1
			if(self.BarrelIndex >= 5) then
				self.BarrelIndex = 1
			end
			self.NextShootTime = CurTime() + self.Firerate
		end

	end
	self:NextThink(CurTime() + 0.02)
	return true
end