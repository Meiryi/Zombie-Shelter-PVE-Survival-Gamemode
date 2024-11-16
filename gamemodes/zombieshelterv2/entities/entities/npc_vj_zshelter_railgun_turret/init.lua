AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/vj_hlr/hl1/alien_cannon.mdl"
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.PlayerFriendly = true
ENT.IsBuilding = true
ENT.IsVJBaseSNPC_Animal = true
ENT.MaximumDistance = 2000
ENT.AimTarget = nil
ENT.AimOffset = Vector(0, 0, 35)

function ENT:RunAI() -- Disable VJ Base's AI
	return
end

function ENT:FindEnemy()
	local target = nil
	local vec = self:GetPos() + self.AimOffset
	for k,v in pairs(ents.FindInSphere(self:GetPos(), self.MaximumDistance)) do
		if(!ZShelter.ValidateEntity(self, v)) then continue end
		if(!ZShelterVisible_Vec_IgnoreTurret(self, vec, v)) then continue end
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
	local upgrade = self:GetNWInt("UpgradeCount", 0)
	self.Firerate = 4.5 - (upgrade * 1)
	self:SetSequence(2)
	if(!IsValid(self.AimTarget)) then
		self:FindEnemy()
	else
		local vec = self:GetPos() + self.AimOffset
		if(self.CheckValidTime < CurTime()) then
			if(!ZShelterVisible_Vec_IgnoreTurret(self, vec, self.AimTarget) || !ZShelter.ValidateTarget(self.AimTarget)) then
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
			if(upgrade >= 2) then
				sound.Play("npc/scanner/scanner_electric1.wav", self:GetPos(), 100, 100, 1)
				local owner = self:GetOwner()
				if(!IsValid(owner)) then owner = self end
				for k,v in ipairs(ents.FindInSphere(targetPos, 70)) do
					if(!ZShelter.ValidateTarget(v) || v == self.AimTarget || v.IsBuilding) then continue end
					v:SetNWInt("ZShelter-BreakTime", CurTime() + 15)
					v:SetNWFloat("DefenseNerfTime", CurTime() + 8)
					local e = EffectData()
						e:SetOrigin(v:GetPos())
						e:SetEntity(v)
					util.Effect("zshelter_defnerf", e)
				end
				ZShelter.StunEntity(self.AimTarget, 0.2)
				local elec = EffectData()
					elec:SetStart(targetPos)
					elec:SetOrigin(self:GetAttachment(1).Pos)
					util.Effect("zshelter_railgun", elec)
			else
				local elec = EffectData()
					elec:SetStart(self:GetPos())
					elec:SetOrigin(targetPos)
					elec:SetEntity(self)
					elec:SetAttachment(1)
					util.Effect("VJ_HLR_XenCannon_Beam", elec)
			end
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