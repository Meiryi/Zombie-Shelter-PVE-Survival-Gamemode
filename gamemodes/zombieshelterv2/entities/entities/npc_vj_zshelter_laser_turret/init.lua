AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/combine_turrets/ground_turret.mdl"
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.PlayerFriendly = true
ENT.IsBuilding = true
ENT.IsVJBaseSNPC_Animal = true
ENT.MaximumDistance = 3000
ENT.AimTarget = nil

function ENT:RunAI() -- Disable VJ Base's AI
	return
end

ENT.Firerate = 0.35
ENT.NextShootTime = 0
ENT.RotateSpeed = 0.45
ENT.Firerate = 0.5
ENT.LosAngle = 8
ENT.CheckValidTime = 0
ENT.Deg = math.cos(math.rad(65))
ENT.MaxTarget = 1

function ENT:Think()
	local vec = Angle(0, self:EyeAngles().y, 0):Forward()
	local vect = self:GetPos() + Vector(0, 0, 5)
	local c = 0
	local shooted = false
	self.MaxTarget = 1 + self:GetNWInt("UpgradeCount", 0) -- Make target count increase with upgrade
	for k,v in ipairs(ents.FindInCone(self:GetPos(), vec, self.MaximumDistance, self.Deg)) do
		if(c >= self.MaxTarget) then break end
		if(!ZShelter.ValidateEntity(self, v) || !ZShelterVisible_Vec_IgnoreTurret(self, vect, v)) then continue end
		local e = EffectData()
			e:SetOrigin(self:GetPos() - Vector(0, 0, 20))
			e:SetStart(v:GetPos() + Vector(0, 0, v:OBBMaxs().z * 0.5))
			v:TakeDamage(25, self, self)
		util.Effect("zshelter_laser_turret", e)
		shooted = true
		c = c + 1
	end
	if(shooted) then
		self:EmitSound("npc/turret_floor/shoot"..math.random(1, 3)..".wav")
		sound.Play("shigure/ion_cannon_shot2.wav", self:GetPos(), 60, 110, 1)
	end
	self:NextThink(CurTime() + self.Firerate)
	return true
end