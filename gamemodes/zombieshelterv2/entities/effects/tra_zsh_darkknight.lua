-- 'Borrowed' from Zombie Survival's tracer_cosmos effect
-- https://github.com/JetBoom/zombiesurvival/blob/master/gamemodes/zombiesurvival/entities/effects/tracer_cosmos.lua
-- Partially based on the Railgun from AS:S, and the Gluon

EFFECT.LifeTime = 1

function EFFECT:GetDelta()
	return math.Clamp(self.DieTime - CurTime(), 0, self.LifeTime) / self.LifeTime
end

function EFFECT:Init(data)
	self.StartPos = self:GetTracerShootPos(data:GetStart(), data:GetEntity(), data:GetAttachment())
	local wep = data:GetEntity()
	if(IsValid(wep)) then
		local owner = wep:GetOwner()
		if(IsValid(owner) && data:GetStart() != owner:EyePos()) then
			self.StartPos = data:GetStart()
		end
	end
	self.EndPos = data:GetOrigin()
	self.HitNormal = data:GetNormal() * -1
	self.Color = Color(255, 255, 255, 100)
	self.DieTime = CurTime() + self.LifeTime
	self.QuadPos = self.EndPos + self.HitNormal
end

function EFFECT:Think()
	return CurTime() < self.DieTime
end

local matBeam2 = Material("sprites/physbeam")
function EFFECT:Render()
	local delta = self:GetDelta()
	if delta <= 0 then return end
	self.Color.a = delta * 60
	local startpos = self.StartPos
	local endpos = self.QuadPos
	local size = delta * 10
	render.SetMaterial(matBeam2)
	render.DrawBeam(startpos, endpos, size, 0, 0, self.Color)
	render.DrawBeam(startpos, endpos, size, 0, 0, self.Color)
end
