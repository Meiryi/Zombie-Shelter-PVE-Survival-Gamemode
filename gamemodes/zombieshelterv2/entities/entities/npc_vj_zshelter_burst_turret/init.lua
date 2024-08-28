AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/vj_hlr/hl1/sentry.mdl"
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.PlayerFriendly = true
ENT.IsBuilding = true
ENT.IsVJBaseSNPC_Animal = true
ENT.MaximumDistance = 700
ENT.AimTarget = nil

function ENT:RunAI() -- Disable VJ Base's AI
	return
end

function ENT:FindEnemy()
	local spos = self:GetPos()
	local vec = Vector(spos.x, spos.y, self:GetBonePosition(3).z)
	for k,v in pairs(ents.FindInSphere(self:GetPos(), self.MaximumDistance)) do
		if(!ZShelter.ValidateEntity(self, v)) then continue end
		if(!ZShelterVisible_Vec(self, vec, v)) then continue end
		self.AimTarget = v
		return
	end
end

ENT.Firerate = 2.25
ENT.NextShootTime = 0
ENT.RotateSpeed = 0.3
ENT.LosAngle = 8
ENT.CheckValidTime = 0

function ENT:FixYaw(yaw) -- I hate this
	if(yaw > 0) then
		return 180 - yaw
	else
		return math.abs(yaw) - 180
	end
end

function ENT:Think()
	self:SetSequence(2)
	if(!IsValid(self.AimTarget)) then
		self:FindEnemy()
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

		local ang = self:GetAngles()

		local enemy = self.AimTarget

		local los = true
		local rotate = self:GetPoseParameter("aim_yaw")

		local targetPos = (enemy:GetPos() + enemy:OBBCenter())
		local angle = (targetPos - self:EyePos()):Angle() ;angle:Normalize()
		local targetAngle = self:FixYaw(angle.y - (self:GetAngles().y)) - 180

		local LerpedAngle = LerpAngle(self.RotateSpeed,  Angle(0, rotate, 0), Angle(0, targetAngle, 0))
		self:SetPoseParameter("aim_yaw", LerpedAngle.y)
		local barrelPos = self:GetBonePosition(3)

		local los = true
		if(math.abs(math.AngleDifference((rotate + self:GetAngles().y) - ang.y, targetAngle)) < self.LosAngle) then
			los = false
		end

		if(self.NextShootTime < CurTime() && !los) then
			for i = 1, 3 do
				timer.Simple((i - 1) * 0.1, function()
					if(!IsValid(self)) then return end
					sound.Play("weapons/shotgun/shotgun_fire6.wav", self:GetPos(), 100, 100, 0.75)
					local bullet = {}
						bullet.Num = 1
						bullet.Attacker = self
						bullet.Src = barrelPos
						bullet.Dir = targetPos - barrelPos
						bullet.Spread = Vector(math.random(-50, 50), math.random(-50, 50), 0)
						bullet.Tracer = 1
						bullet.TracerName = "VJ_HLR_Tracer"
						bullet.Force = 5
						bullet.Damage = 12
						for _ = 1, 8 do
							self:FireBullets(bullet)
						end
				end)
			end
			self.NextShootTime = CurTime() + self.Firerate
		end

	end
	self:NextThink(CurTime() + 0.05)
	return true
end