AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/vj_hlr/hl1/alien_cannon.mdl"
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.PlayerFriendly = true
ENT.IsBuilding = true
ENT.IsVJBaseSNPC_Animal = true
ENT.MaximumDistance = 1500
ENT.AimTarget = nil
ENT.AimOffset = Vector(0, 0, 25)

function ENT:RunAI() -- Disable VJ Base's AI
	return
end

function ENT:FindEnemy()
	local target = nil
	local vec = self:GetPos() + Vector(0, 0, self.AimOffset)
	for k,v in pairs(ents.FindInSphere(self:GetPos(), self.MaximumDistance)) do
		if(!ZShelter.ValidateEntity(self, v)) then continue end
		if(!ZShelterVisible_Vec(self, vec, v)) then continue end
		if(!IsValid(target)) then
			target = v
			self.AimTarget = v
		else
			if(target:Health() < v:Health()) then
				target = v
				self.AimTarget = v
			end
		end
	end
end

ENT.Firerate = 4.5
ENT.NextShootTime = 0
ENT.RotateSpeed = 0.6
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
	self.Firerate = 4.5 - (self:GetNWInt("UpgradeCount", 0) * 0.75)
	self:SetSequence(2)
	if(!IsValid(self.AimTarget)) then
		self:FindEnemy()
	else
		local vec = self:GetPos() + Vector(0, 0, self.AimOffset)
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
		local barrelPos = self:GetBonePosition(1)
		local los = true
		if(math.abs(math.AngleDifference((rotate + self:GetAngles().y) - ang.y, targetAngle)) < self.LosAngle) then
			los = false
		end

		if(self.NextShootTime < CurTime() && !los) then
			self:EmitSound("vj_hlr/hl1_npc/xencannon/fire.wav", 100, 100, 2)

			local elec = EffectData()
				elec:SetStart(self:GetPos())
				elec:SetOrigin(targetPos)
				elec:SetEntity(self)
				elec:SetAttachment(1)
				util.Effect("VJ_HLR_XenCannon_Beam", elec)

			self.AimTarget:TakeDamage(100, self, self)
			self.AimTarget:SetNWInt("ZShelter-BreakTime", CurTime() + 15)
			self.AimTarget:SetNWFloat("DefenseNerfTime", CurTime() + 8)
			local e = EffectData()
				e:SetOrigin(self.AimTarget:GetPos())
				e:SetEntity(self.AimTarget)
			util.Effect("zshelter_defnerf", e)

			self.NextShootTime = CurTime() + self.Firerate
		end

	end
	self:NextThink(CurTime() + 0.2)
	return true
end