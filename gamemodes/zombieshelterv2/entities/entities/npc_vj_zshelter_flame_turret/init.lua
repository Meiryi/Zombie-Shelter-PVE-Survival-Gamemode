AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/zshelter/shelter_b_firegun01.mdl"
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.PlayerFriendly = true
ENT.IsBuilding = true
ENT.IsVJBaseSNPC_Animal = true
ENT.MaximumDistance = 256
ENT.AimTarget = nil

function ENT:RunAI() -- Disable VJ Base's AI
	return
end

function ENT:FindEnemy()
	local spos = self:GetPos()
	local vec = Vector(spos.x, spos.y, self:GetBonePosition(2).z)
	for k,v in pairs(ents.FindInSphere(self:GetPos(), self.MaximumDistance)) do
		if(!ZShelter.ValidateEntity(self, v)) then continue end
		if(!ZShelterVisible_Vec_IgnoreTurret(self, vec, v)) then continue end
		self.AimTarget = v
		return
	end
end

ENT.Firerate = 0.067
ENT.NextShootTime = 0
ENT.RotateSpeed = 0.3
ENT.LosAngle = 8
ENT.CheckValidTime = 0
ENT.DmgAngle = math.cos(math.rad(30))

function ENT:Think()
	if(!IsValid(self.AimTarget)) then
		self:FindEnemy()
		self:NextThink(CurTime() + 0.33)
		return true
	else
		local spos = self:GetPos()
		local vec = Vector(spos.x, spos.y, self:GetBonePosition(2).z)
		if(self.CheckValidTime < CurTime()) then
			if(!ZShelterVisible_Vec_IgnoreTurret(self, vec, self.AimTarget) || !ZShelter.ValidateTarget(self.AimTarget)) then
				self.AimTarget = nil
				return
			end
			self.CheckValidTime = CurTime() + 0.2
		end
		
		local angle = ((self.AimTarget:GetPos() + self.AimTarget:OBBCenter()) - self:GetPos()):Angle().y

		self:SetAngles(LerpAngle(self.RotateSpeed, Angle(0, self:EyeAngles().y, 0), Angle(0, angle, 0)))

		if(self.NextShootTime < CurTime() && !los) then
			local fx = ents.Create("obj_firegun_flame")
				fx:SetPos(self:GetBonePosition(2))
				fx:SetAngles(self:GetAngles() + Angle(math.random(-5, 5), math.random(-5, 5), math.random(-5, 5)))
				fx:Spawn()

			local dmginfo = DamageInfo()
				dmginfo:SetDamage(3)
				dmginfo:SetAttacker(self)
				dmginfo:SetInflictor(self)
			for k,v in pairs(ents.FindInCone(self:GetPos(), self:EyeAngles():Forward(), self.MaximumDistance, self.DmgAngle)) do
				if(v == self || v:IsPlayer() || v.IsBuilding) then continue end
				if(!v:IsNPC() && !v:IsNextBot()) then continue end
				v:TakeDamageInfo(dmginfo)
			end
		end

	end

	self:NextThink(CurTime() + 0.115)
	return true
end