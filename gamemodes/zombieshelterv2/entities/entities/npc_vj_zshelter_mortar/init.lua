AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/zshelter/shelter_b_turret01.mdl"
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.PlayerFriendly = true
ENT.IsBuilding = true
ENT.IsVJBaseSNPC_Animal = true
ENT.MaximumDistance = 3072
ENT.Damage = 70

ENT.ShootingTarget = nil
ENT.ManuallyControlling = false
ENT.CurrentUser = nil
ENT.UnMountTime = 0
ENT.MountTime = 0

function ENT:RunAI() -- Disable VJ Base's AI
	return
end

function ENT:FindEnemy()
	local pos = self:GetPos()
	local vec = Vector(0, 0, 0)
	local trg = nil
	local dst = 0
	for k,v in pairs(ents.FindInSphere(self:GetPos(), self.MaximumDistance)) do
		if(!ZShelter.ValidateEntity(self, v) || (v.IsBoss && !v.Awake)) then continue end
		local _dst = self:GetPos():Distance(pos)
		if(!trg) then
			trg = v
			vec = v:GetPos()
			dst = _dst
		else
			if(_dst > dst) then
				trg = v
				vec = v:GetPos()
				dst = _dst
			end
		end
	end
	self.ShootingTarget = trg
	self.AimVec = vec
end

ENT.Shooting = false
ENT.AimVec = Vector(0, 0, 0)

ENT.NextStartTime = 0
ENT.NextStartCooldown = 5

ENT.NextShooting = 0
ENT.ShootingInterval = 0.8

ENT.MaxShot = 4
ENT.CurrentShot = 0
ENT.RotateSpeed = 0.125

ENT.NextManualFireTime = 0
ENT.ManualFireRate = 6.35
ENT.CurrentAttacker = nil

function ENT:FireMissile()
	local owner = self
	if(IsValid(self.CurrentAttacker)) then
		owner = self.CurrentAttacker
	end
	local pos = self:GetBonePosition(1)
	local missile = ents.Create("obj_mortar_missile")
		missile:SetOwner(owner)
		missile:SetPos(pos)
		missile.Target = self.ShootingTarget
		missile.TargetPos = self.AimVec
		missile.StartZAxis = pos.z
		missile:Spawn()
		missile:SetAngles(Angle(90, 0, 0))
end

function ENT:ManualControlling()
	return IsValid(self.CurrentController)
end

function ENT:RunControllerCode()
	if(IsValid(self.CurrentController)) then
		if(!self.CurrentController:Alive()) then
			ZShelter.UnSetControllingMortar(self.CurrentController, self)
			return
		end
		self.CurrentController:SetPos(self:GetPos())
	end
end

function ENT:ShootManual(ply, vec)
	if(self.Shooting || self.NextManualFireTime > CurTime()) then return end
	self.ManualFireRate = 6.35 - (self:GetNWInt("UpgradeCount", 0) * 0.125)
	self.AimVec = vec
	self.CurrentAttacker = ply
	self.ShootingTarget = nil
	self.Shooting = true
	self.CurrentShot = 0

	self.NextManualFireTime = CurTime() + self.ManualFireRate
	return true
end

function ENT:Think()
	self.MaxShot = 4 + math.floor(self:GetNWInt("UpgradeCount", 0) * 0.5)
	self.ShootingInterval = 0.8 - (self:GetNWInt("UpgradeCount", 0) * 0.05)
	local rotate = self:GetBoneController(1)
	local manual = self:ManualControlling()
	if(manual) then
		self:RunControllerCode()
	end
	if(!self.Shooting) then
		if(!manual) then
			if(!IsValid(self.ShootingTarget) || self.AimVec == Vector(0, 0, 0)) then
				local newAngle = LerpAngle(0.3, Angle(rotate, 0, 0), Angle(0, 0, 0))
				self:SetBoneController(1, newAngle.p)
				self:FindEnemy()
				self:NextThink(CurTime() + 0.2)
				return true
			end
			if(self.AimVec != Vector(0, 0, 0)) then
				if(self.NextStartTime < CurTime()) then
					local newAngle = LerpAngle(self.RotateSpeed, Angle(rotate, 0, 0), Angle(90, 0, 0))
					self:SetBoneController(1, newAngle.p)
					if(rotate >= 89) then
						self.Shooting = true
					end
				end
			end
			self.CurrentAttacker = nil
		else
			local newAngle = LerpAngle(0.33, Angle(rotate, 0, 0), Angle(90, 0, 0))
			self:SetBoneController(1, newAngle.p)
		end
	else
		if(self.MaxShot > self.CurrentShot) then
			if(self.NextShooting < CurTime()) then
				self:FireMissile()
				self:EmitSound("shigure/mortarfire.wav")
				self.CurrentShot = self.CurrentShot + 1
				self.NextShooting = CurTime() + self.ShootingInterval
			end
		else
			if(!manual) then
				if(self.NextShooting < CurTime()) then
					local newAngle = LerpAngle(self.RotateSpeed, Angle(rotate, 0, 0), Angle(0, 0, 0))
					self:SetBoneController(1, newAngle.p)
					if(rotate <= 1) then
						self.AimVec = Vector(0, 0, 0)
						self.NextStartTime = CurTime() + self.NextStartCooldown
						self.CurrentShot = 0
						self.Shooting = false
					end
				end
			else
				if(self.NextManualFireTime < CurTime()) then
					self.Shooting = false
				end
			end
		end
	end
	self:NextThink(CurTime() + 0.1)
	return true
end

function ENT:OnRemove()
	if(IsValid(self.CurrentController)) then
		ZShelter.UnSetControllingMortar(self.CurrentController, self)
	end
end