AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/zshelter/shelter_b_laser_tower.mdl"
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.PlayerFriendly = true
ENT.IsBuilding = true
ENT.IsVJBaseSNPC_Animal = true
ENT.MaximumDistance = 2500
ENT.AimTarget = nil

function ENT:RunAI() -- Disable VJ Base's AI
	return
end

function ENT:FindEnemy()
	local spos = self:GetPos()
	local vec = Vector(spos.x, spos.y, self:GetBonePosition(3).z)
	for k,v in pairs(ents.GetAll()) do
		if(!ZShelter.ValidateEntity(self, v)) then continue end
		if(!ZShelterVisible_Vec(self, vec, v)) then continue end
		if(v:GetPos():Distance(self:GetPos()) > self.MaximumDistance) then continue end
		self.AimTarget = v
		return
	end
end

ENT.Firerate = 0.08
ENT.NextShootTime = 0
ENT.RotateSpeed = 0.5
ENT.LosAngle = 8
ENT.CheckValidTime = 0

ENT.Deployed = false

function ENT:RunSequence(sequence)
	if(self:GetSequence() != sequence) then
		self:ResetSequence(sequence)
	else
		self:SetSequence(sequence)
	end
end

function ENT:FixYaw(yaw)
	if(yaw > 0) then
		return 180 - yaw
	else
		return math.abs(yaw) - 180
	end
end

ENT.ShouldShoot = false
ENT.NextFire = 4

function ENT:Think()
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

		local ang = self:GetAngles()

		local enemy = self.AimTarget

		local los = true
		local rotate = self:GetBoneController(0)

		local targetPos = (enemy:GetPos() + enemy:OBBCenter())
		local angle = (targetPos - self:EyePos()):Angle() ;angle:Normalize()
		local targetAngle = self:FixYaw(angle.y - (self:GetAngles().y))

		local LerpedAngle = LerpAngle(self.RotateSpeed,  Angle(0, rotate, 0), Angle(0, targetAngle, 0))
		self:SetBoneController(0, LerpedAngle.y)
		local barrelPos = self:GetBonePosition(3)

		local los = true
		if(math.abs(math.AngleDifference(rotate - ang.y, targetAngle)) < self.LosAngle) then
			los = false
		end

		if(self.NextShootTime < CurTime()) then
			self.ParticleTime = CurTime() + 1.5
			sound.Play("shigure/plasmatower_shoot_start.wav", self:GetPos(), 100, 100, 2)
			sound.Play("shigure/plasmatower_shoot_start.wav", self:GetPos(), 100, 100, 2)
			timer.Simple(1.5, function()
				if(!IsValid(enemy)) then
					self:FindEnemy()
					if(!IsValid(self.AimTarget)) then
						self.ParticleTime = CurTime()
						self.NextShootTime = CurTime()
						return
					end
					enemy = self.AimTarget
				end
				sound.Play("shigure/plasmatower_shoot.wav", self:GetPos(), 100, 100, 2)
				self:ResetSequence(2)

				local forward = targetPos - self:EyePos()
				forward:Normalize()

				if(IsValid(enemy)) then
					if(IsValid(self.AimTarget)) then
						enemy = self.AimTarget
					end
					forward = (enemy:GetPos() + enemy:OBBCenter()) - self:EyePos()
					forward:Normalize()
				end

				local origin = self:GetBonePosition(3)
				local pos = origin
				local projectile = ents.Create("obj_plasma_proj")
					projectile:SetPos(pos)
					projectile:SetOwner(self)
					projectile:Spawn()
					projectile:GetPhysicsObject():SetVelocity(forward * 5000)
			end)

			self.NextShootTime = CurTime() + self.NextFire
		end
	end

	self:NextThink(CurTime() + 0.1)
	return true
end