AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/zshelter/zb_turret.mdl"
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
	local spos = self:GetPos()
	local vec = Vector(spos.x, spos.y, self:GetBonePosition(3).z)
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

ENT.Firerate = 0.25
ENT.NextShootTime = 0
ENT.RotateSpeed = 0.45
ENT.LosAngle = 8
ENT.CheckValidTime = 0

function ENT:Think()
	self.Firerate = 0.25 - (self:GetNWInt("UpgradeCount", 0) * 0.015)
	if(!IsValid(self.AimTarget)) then
		self:FindEnemy()
		self:NextThink(CurTime() + 0.33)
		return true
	else
		local spos = self:GetPos()
		local vec = Vector(spos.x, spos.y, self:GetBonePosition(3).z)
		if(self.CheckValidTime < CurTime()) then
			if(!ZShelterVisible_Vec(self, vec, self.AimTarget) || !ZShelter.ValidateTarget(self.AimTarget)) then
				self.AimTarget = nil
				return
			end
			self.CheckValidTime = CurTime() + 0.2
		end
		local enemy = self.AimTarget

		local los = true
		local rotate = self:GetBoneController(0)
		local targetPos = (enemy:GetPos() + enemy:OBBCenter())
		local angle = (targetPos - self:EyePos()):Angle()
		angle:Normalize()
		local targetAngle = angle.y - self:GetAngles().y
		local barrelPos = self:GetBonePosition(3)

		local returnAngle = LerpAngle(self.RotateSpeed, Angle(0, rotate, 0), Angle(0, targetAngle, 0))
		self:SetBoneController(0, returnAngle.y)
		rotate = self:GetBoneController(0)

		if(math.abs(math.AngleDifference(rotate, angle.y - self:GetAngles().y)) < self.LosAngle) then
			los = false
		end

		if(self.NextShootTime < CurTime() && !los) then
			sound.Play("shigure/turretfire.wav", self:GetPos(), 100, 100, 0.75)

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
	self:NextThink(CurTime() + 0.025)
	return true
end