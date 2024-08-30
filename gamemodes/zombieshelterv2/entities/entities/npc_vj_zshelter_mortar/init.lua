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

function ENT:UnMount()
	if(self.UnMountTime > CurTime()) then return end
	self.MountTime = CurTime() + 1
	if(IsValid(self.CurrentUser)) then
		self.CurrentUser:SetNWEntity("ZShelter_MortarController", self.CurrentUser)
		ZShelterSetController(self.CurrentUser, false)
	end
	self.CurrentUser = nil
	self.ManuallyControlling = false
	self:SetNWEntity("ZShelter_Controller", self)
end

function ENT:Mount(user)
	if(self.MountTime > CurTime()) then return end
	self.UnMountTime = CurTime() + 1
	self.CurrentUser = user
	self.ManuallyControlling = true
	self:SetNWEntity("ZShelter_Controller", user)
	ZShelterSetController(user, true)
end


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

ENT.NextFire_Manual = 0
ENT.Height = Vector(0, 0, 1200)
ENT.ManualAttacker = nil

function ENT:FireMissile()
	local owner = self
	if(IsValid(self.ManualAttacker)) then
		owner = self.ManualAttacker
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

function ENT:Think()
	self.MaxShot = 4 + math.floor(self:GetNWInt("UpgradeCount", 0) * 0.5)
	self.ShootingInterval = 0.8 - (self:GetNWInt("UpgradeCount", 0) * 0.05)
	local rotate = self:GetBoneController(1)
	if(!self.Shooting) then
		if(!self.ManuallyControlling) then
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
		else
			local newAngle = LerpAngle(self.RotateSpeed, Angle(rotate, 0, 0), Angle(90, 0, 0))
			self:SetBoneController(1, newAngle.p)
			if(!IsValid(self.CurrentUser) || !self.CurrentUser:Alive()) then
				self:UnMount()
				self:SetNWEntity("ZShelter_Controller", self)
			else
				self.CurrentUser:SetPos(self:GetPos())
				if(self.CurrentUser:KeyDown(32)) then
					self:UnMount()
					return
				end
				if(self.CurrentUser:KeyDown(1)) then
					local pos = self:GetPos() + self.Height
					local tr = {
						start = pos,
						endpos = pos + self.CurrentUser:EyeAngles():Forward() * 32767,
						mask = MASK_SHOT,
						filter = self,
					}
					local vec = util.TraceLine(tr).HitPos
					self.AimVec = vec
					if(!self.Shooting) then
						self.ShootingTarget = nil
						self.ManualAttacker = self.CurrentUser
						self.Shooting = true
					end
				end
				self:SetNWEntity("ZShelter_Controller", self.CurrentUser)
			end
			self:NextThink(CurTime() + 0.05)
			return true
		end
	else
		if(self.ManuallyControlling && IsValid(self.CurrentUser)) then
			self.CurrentUser:SetPos(self:GetPos())
		end
		if(self.MaxShot > self.CurrentShot) then
			if(self.NextShooting < CurTime()) then
				self:FireMissile()
				self:EmitSound("shigure/mortarfire.wav")
				self.CurrentShot = self.CurrentShot + 1
				self.NextShooting = CurTime() + self.ShootingInterval
			end
			self.NextFire_Manual = CurTime() + 2
		else
			if(self.NextShooting < CurTime()) then
				if(!self.ManuallyControlling) then
					local newAngle = LerpAngle(self.RotateSpeed, Angle(rotate, 0, 0), Angle(0, 0, 0))
					self:SetBoneController(1, newAngle.p)
					if(rotate <= 1) then
						self.AimVec = Vector(0, 0, 0)
						self.NextStartTime = CurTime() + self.NextStartCooldown
						self.CurrentShot = 0
						self.Shooting = false
					end
					self.ManualAttacker = nil
				else
					if(self.NextFire_Manual < CurTime()) then
						self.CurrentShot = 0
						self.Shooting = false
					end
				end
			end
		end
	end

	self:NextThink(CurTime() + 0.1)
	return true
end

function ENT:Use(user)
	if(!user:IsPlayer() || IsValid(self.CurrentUser) || user == self.CurrentUser || !self:GetNWBool("Completed")) then return end
	self:Mount(user)
end

function ENT:OnRemove()
	self:UnMount()
end