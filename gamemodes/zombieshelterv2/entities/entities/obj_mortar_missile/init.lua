AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/items/ar2_grenade.mdl"
ENT.MaximumDistance = 3072

ENT.ReachedHeight = false
ENT.ReachZ = 0
ENT.FallbackTime = 0
ENT.Damage = 70

function ENT:Initialize()
	self:SetModel(self.Model)
	if(!self.TargetPos || !self.StartZAxis) then
		self:Remove()
	end
	self:SetModelScale(2.5)
	self.FallbackTime = CurTime() + 10
	self.ReachZ = self.StartZAxis + 3600
	util.SpriteTrail(self, 0, Color(255, 255, 255, 255), false, 15, 1, 0.1, 1, "trails/smoke")
end
ENT.FlySpeed = 100

function ENT:Think()

	if(self.FallbackTime < CurTime()) then
		self:Remove()
		return
	end

	if(IsValid(self.Target)) then
		self.TargetPos = self.Target:GetPos()
	end
	local pos = self:GetPos()
	if(!self.ReachedHeight) then
		self:SetPos(pos + Vector(0, 0, self.FlySpeed))
		if(pos.z >= self.ReachZ) then
			self.ReachedHeight = true
		end
	else
		self:SetPos(Vector(self.TargetPos.x, self.TargetPos.y, pos.z - self.FlySpeed))
		if(pos:Distance(self.TargetPos) < 128) then
			sound.Play("ambient/explosions/explode_"..math.random(1, 3)..".wav", pos, 80, 100, 1)
			local effectdata = EffectData()
				effectdata:SetOrigin(self.TargetPos)
				util.Effect("HelicopterMegaBomb", effectdata)
			local owner = self:GetOwner()
			if(!IsValid(self:GetOwner())) then owner = self end
			local dmginfo = DamageInfo()
				dmginfo:SetInflictor(owner)
				dmginfo:SetAttacker(owner)
				dmginfo:SetDamage(self.Damage)
				dmginfo:SetDamageType(64)

				for k,v in pairs(ents.FindInSphere(self.TargetPos, 150)) do
					if(v == owner || v.IsBuilding) then continue end
					if(v:IsPlayer()) then continue end
					if(!v:IsNPC() && !v:IsNextBot()) then continue end
					v:TakeDamageInfo(dmginfo)
				end
			self:Remove()
		end
	end

	self:NextThink(CurTime() + 0.05)
	return true
end