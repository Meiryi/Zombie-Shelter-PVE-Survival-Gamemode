AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/vj_hlr/decay/sentry.mdl"
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.PlayerFriendly = true
ENT.IsBuilding = true
ENT.IsVJBaseSNPC_Animal = true
ENT.MaximumDistance = 450
ENT.AimTarget = nil

function ENT:RunAI() -- Disable VJ Base's AI
	return
end

function ENT:FindEnemy()
	local spos = self:GetPos()
	local vec = Vector(spos.x, spos.y, self:GetBonePosition(5).z)
	for k,v in pairs(ents.FindInSphere(self:GetPos(), self.MaximumDistance)) do
		if(!ZShelter.ValidateEntity(self, v)) then continue end
		if(!ZShelterVisible_Vec(self, vec, v)) then continue end
		self.AimTarget = v
		return
	end
end

ENT.Firerate = 0.067
ENT.NextShootTime = 0
ENT.RotateSpeed = 0.45
ENT.LosAngle = 8
ENT.CheckValidTime = 0
ENT.DmgAngle = math.cos(math.rad(35))

function ENT:Think()
	if(!IsValid(self.AimTarget)) then
		self:FindEnemy()
		if(!IsValid(self.AimTarget)) then
			self:NextThink(CurTime() + 0.15)
		end
		return true
	else
		local spos = self:GetPos()
		local vec = Vector(spos.x, spos.y, self:GetBonePosition(5).z)
		if(self.CheckValidTime < CurTime()) then
			if(!ZShelterVisible_Vec(self, vec, self.AimTarget) || !ZShelter.ValidateTarget(self.AimTarget)) then
				self.AimTarget = nil
				return
			end
			self.CheckValidTime = CurTime() + 0.2
		end
		local angle = ((self.AimTarget:GetPos() + self.AimTarget:OBBCenter()) - self:GetPos()):Angle().y
		self:SetAngles(LerpAngle(self.RotateSpeed, Angle(0, self:EyeAngles().y, 0), Angle(0, angle, 0)))
		if(self.NextShootTime < CurTime() && !los) then
			local fx = ents.Create("obj_ice_fog")
				fx:SetPos(self:GetBonePosition(5))
				fx:SetAngles(self:GetAngles() + Angle(math.random(-5, 5), math.random(-5, 5), math.random(-5, 5)))
				fx:Spawn()

			local dmginfo = DamageInfo()
				dmginfo:SetDamage(1)
				dmginfo:SetAttacker(self)
				dmginfo:SetInflictor(self)
			local targethit = false
			for k,v in pairs(ents.FindInCone(self:GetPos(), self:GetAimVector(), self.MaximumDistance, self.DmgAngle)) do
				if(v == self || v:IsPlayer() || v.IsBuilding) then continue end
				if(!v:IsNPC() && !v:IsNextBot()) then continue end
				v:TakeDamageInfo(dmginfo)
				if(v.SetMoveVelocity) then
					if(v.LastFreezeTime) then
						if(v.LastFreezeTime > CurTime()) then
							continue
						else
							v.LastFreezeTime = CurTime() + 0.15
						end
					else
						v.LastFreezeTime = CurTime() + 0.1
					end
					v:SetMoveVelocity(v:GetMoveVelocity() * 0.7)
				end
				if(v == self.AimTarget) then
					targethit = true
				end
			end
			if(!targethit) then
				self.AimTarget:TakeDamage(1, self, self)
			end
		end

	end

	self:NextThink(CurTime() + 0.2)
	return true
end