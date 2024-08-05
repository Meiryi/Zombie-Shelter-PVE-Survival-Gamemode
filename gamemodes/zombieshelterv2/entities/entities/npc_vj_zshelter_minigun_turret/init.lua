AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/zshelter/shelter_b_turret_bg01.mdl"
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.PlayerFriendly = true
ENT.IsBuilding = true
ENT.IsVJBaseSNPC_Animal = true
ENT.MaximumDistance = 1500
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

ENT.Firerate = 0.08
ENT.NextShootTime = 0
ENT.RotateSpeed = 0.35
ENT.LosAngle = 8
ENT.CheckValidTime = 0

ENT.InstantSwitch = false
ENT.Deployed = false

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
		if(self.InstantSwitch) then
			self.InstantSwitch = false
			self:NextThink(CurTime() + 0.08)
			return true
		end
		self:RunSequence(7)
		self:NextThink(CurTime() + 0.33)
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
			sound.Play("shigure/turretfire.wav", self:GetPos(), 100, 100, 0.45)
			--self:EmitSound("shigure/turretfire.wav")
			local bullet = {}
			bullet.Num = 1
			bullet.Src = barrelPos
			bullet.Dir = targetPos - barrelPos
			bullet.Spread = Vector(math.random(-10,10), math.random(-10,10), 0)
			bullet.Tracer = 1
			bullet.TracerName = "VJ_HLR_Tracer"
			bullet.Force = 5
			bullet.Damage = 12
			bullet.AmmoType = "SMG1"
			self:FireBullets(bullet)

			self.NextShootTime = CurTime() + self.Firerate
		end

	end
	self:NextThink(CurTime() + 0.05)
	return true
end