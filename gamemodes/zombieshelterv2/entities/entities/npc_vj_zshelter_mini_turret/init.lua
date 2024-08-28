AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/gturret_mini.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 300
ENT.VJC_Data = {
    ThirdP_Offset = Vector(0, 0, 10), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Dummy02", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = false, -- Should the bone shrink? Useful if the bone is obscuring the player's view
}
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}

ENT.MaximumDistance = 1500
ENT.AimTarget = nil

function ENT:CustomOnInitialize()
	self:SetNWBool("IsBuilding", true)
	self:SetNWBool("NoHUD", true)
	self.IsBuilding = true
	self.RemoveTime = CurTime() + 15
end

function ENT:RunAI() -- Disable VJ Base's AI
	return
end

function ENT:FindEnemy()
	local dst = 0
	for k,v in pairs(ents.FindInSphere(self:GetPos(), self.MaximumDistance)) do
		if(!ZShelter.ValidateEntity(self, v)) then continue end
		if(!v:Visible(self)) then continue end
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
ENT.RotateSpeed = 0.3
ENT.LosAngle = 8

ENT.Deployed = false

function ENT:RunSequence(sequence)
	if(self:GetSequence() != sequence) then
		self:ResetSequence(sequence)
	else
		self:SetSequence(sequence)
	end
end

function ENT:FixYaw(yaw) -- I hate this
	if(yaw > 0) then
		return 180 - yaw
	else
		return math.abs(yaw) - 180
	end
end

function ENT:Think()
	if(self.RemoveTime < CurTime()) then
		self:Remove()
		return
	end
	if(!IsValid(self.AimTarget)) then
		self:FindEnemy()
		self:RunSequence(2)
	else
		if(!self:Visible(self.AimTarget) || !ZShelter.ValidateTarget(self.AimTarget)) then
			self.AimTarget = nil
			return
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

		if(los) then
			self:RunSequence(3)
		else
			self:RunSequence(3)
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
			bullet.Damage = 50
			bullet.AmmoType = "SMG1"
			self:FireBullets(bullet)

			self.NextShootTime = CurTime() + self.Firerate
		end

	end
	self:NextThink(CurTime() + 0.05)
	return true
end