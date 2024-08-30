AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/props_combine/combine_mortar01a.mdl"
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.PlayerFriendly = true
ENT.IsBuilding = true
ENT.IsVJBaseSNPC_Animal = true
ENT.MaximumDistance = 4096
ENT.AimTarget = nil

ENT.ManuallyControlling = false
ENT.CurrentUser = nil
ENT.UnMountTime = 0
ENT.MountTime = 0

function ENT:RunAI() -- Disable VJ Base's AI
	return
end

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

function ENT:FindEnemy()
	local hp = 0
	local td = 0
	local highhp = false
	for k,v in pairs(ents.FindInSphere(self:GetPos(), self.MaximumDistance)) do
		if(!ZShelter.ValidateEntity(self, v) || (v.IsBoss && !v.Awake)) then continue end
		local h = v:Health()
		if(h >= 2000) then
			if(!highhp) then
				hp = h
				self.AimTarget = v
				highhp = true
			end
			if(hp == 0) then
				hp = h
				self.AimTarget = v
			else
				if(h > hp) then
					hp = h
					self.AimTarget = v
				end
			end
		else -- So they will attack multiple target if there's currently no tanky enemy
			if(highhp) then continue end
			if(!v.LastTargetedTime) then
				v.LastTargetedTime = math.random(0, 65536)
			end
			if(hp == 0) then
				hp = v.LastTargetedTime
				self.AimTarget = v
			else
				if(v.LastTargetedTime > hp) then
					hp = v.LastTargetedTime
					self.AimTarget = v
				end
			end
		end
	end
end

ENT.NextFireTime = 0
ENT.NextFireTime_Manual = 0
ENT.NextFireTime_Interval = 2
function ENT:Think()
	if(self.ManuallyControlling) then
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
				if(self.NextFireTime_Manual <= CurTime()) then
					sound.Play("weapons/mortar/mortar_fire1.wav", self:GetPos(), 120, 100, 1)
					local pos = self:GetPos() + self.Height
					local tr = {
						start = pos,
						endpos = pos + self.CurrentUser:EyeAngles():Forward() * 32767,
						mask = MASK_SHOT,
						filter = self,
					}
					local vec = util.TraceLine(tr).HitPos
					local e = EffectData()
						e:SetOrigin(self:GetPos() + self:GetUp() * 100 + self:GetForward() * 15 + self:GetRight() * 7)
					util.Effect("zshelter_mortar_prefire", e)
						e:SetOrigin(vec)
					util.Effect("zshelter_mortar_prefire", e)
					util.Effect("zshelter_mortar_impact", e)
					timer.Simple(0.5, function()
						sound.Play("weapons/mortar/mortar_shell_incomming1.wav", vec, 140, 100, 1)
					end)
					local attacker = self.CurrentUser
					timer.Simple(1.5, function()
						sound.Play("weapons/mortar/mortar_explode"..math.random(1, 3)..".wav", vec, 100, 100, 1)
						local e = EffectData()
						e:SetOrigin(vec + Vector(0, 0, 1))
						e:SetNormal(Vector(0, 0, 1))
						e:SetRadius(100)
						util.Effect("AR2Explosion", e)
						for k,v in ipairs(ents.FindInSphere(vec, 64)) do
							if(!ZShelter.ValidateTarget(v) && v != attacker) then continue end
							v:TakeDamage(self.damage || 200, attacker, attacker)
						end
					end)
					self.NextFireTime_Manual = CurTime() + self.NextFireTime_Interval
				end
			end
			self:SetNWEntity("ZShelter_Controller", self.CurrentUser)
		end
		self:NextThink(CurTime())
		return true
	else
		self:SetNWEntity("ZShelter_Controller", self)
		if(!IsValid(self.AimTarget)) then
			--self:FindEnemy()
		else
			if(self.NextFireTime < CurTime()) then
				sound.Play("weapons/mortar/mortar_fire1.wav", self:GetPos(), 120, 100, 1)
				local target = self.AimTarget
				target.LastTargetedTime = CurTime()
				local e = EffectData()
					e:SetOrigin(self:GetPos() + self:GetUp() * 100 + self:GetForward() * 15 + self:GetRight() * 7)
				util.Effect("zshelter_mortar_prefire", e)
					e:SetOrigin(target:GetPos())
				util.Effect("zshelter_mortar_prefire", e)
				util.Effect("zshelter_mortar_impact", e)
				timer.Simple(0.5, function()
					if(!IsValid(target)) then return end
					sound.Play("weapons/mortar/mortar_shell_incomming1.wav", target:GetPos(), 140, 100, 1)
				end)
				local pos = target:GetPos()
				timer.Simple(1.5, function()
					sound.Play("weapons/mortar/mortar_explode"..math.random(1, 3)..".wav", pos, 100, 100, 1)
					local e = EffectData()
					e:SetOrigin(pos + Vector(0, 0, 1))
					e:SetNormal(Vector(0, 0, 1))
					e:SetRadius(100)
					util.Effect("AR2Explosion", e)
					if(IsValid(target)) then
						pos = target:GetPos()
						local e = EffectData()
						e:SetOrigin(pos + Vector(0, 0, 1))
						e:SetNormal(Vector(0, 0, 1))
						e:SetRadius(100)
						util.Effect("AR2Explosion", e)
						target:TakeDamage(400, self, self)
					end
				end)
				self.NextFireTime = CurTime() + 4.5
			end
		end
	end
	self:NextThink(CurTime() + 0.5)
	return true
end

function ENT:Use(user)
	if(!user:IsPlayer() || IsValid(self.CurrentUser) || user == self.CurrentUser || !self:GetNWBool("Completed")) then return end
	self:Mount(user)
end

function ENT:OnRemove()
	self:UnMount()
end