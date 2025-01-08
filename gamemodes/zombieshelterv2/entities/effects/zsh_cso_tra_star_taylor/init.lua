TRACER_FLAG_USEATTACHMENT = 0x0002
SOUND_FROM_WORLD = 0
CHAN_STATIC = 6
EFFECT.Thickness = 5
EFFECT.Life = 0.1
EFFECT.RotVelocity = 30
EFFECT.InValid = false
local Mat_Impact = Material("tracers/ef_y22s2sfpistol_star")
local Mat_Beam = Material("tracers/ef_y22s2sfpistol_laser")
local Mat_TracePart = Material("effects/select_ring")

function EFFECT:Init(data)
	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	local owent

	if(!IsValid(self.WeaponEnt)) then
		self.InValid = true
		return
	end

	local pos = data:GetOrigin()
    local emitter = ParticleEmitter(pos)
    local smoke

    for i = 1, math.random(1, 3) do
        smoke = emitter:Add("effects/spark", pos)
        smoke:SetPos(pos)
        smoke:SetGravity(Vector(math.random(-256, 256), math.random(-256, 256), math.random(1000, 1500)))
        smoke:SetVelocity(VectorRand() * 50)
        smoke:SetDieTime(math.Rand(0.2, 0.5))
        smoke:SetStartAlpha(math.random(100, 200))
        smoke:SetEndAlpha(0)
        smoke:SetStartSize(16)
        smoke:SetEndSize(0)
        smoke:SetRoll(math.Rand(-180, 180))
        smoke:SetRollDelta(math.Rand(-0.2,0.2))
        smoke:SetColor(155, 155, 255)
        smoke:SetAirResistance(1000)
        smoke:SetLighting(false)
        smoke:SetCollide(true)
        smoke:SetBounce(0)
    end

	if IsValid(self.WeaponEnt) then
		owent = self.WeaponEnt.Owner or self.WeaponEnt:GetOwner()

		if not IsValid(owent) then
			owent = self.WeaponEnt:GetParent()
		end
	end
	if(owent == LocalPlayer() && !LocalPlayer():ShouldDrawLocalPlayer()) then
		self.InValid = true
	end
	if IsValid(owent) and owent:IsPlayer() then
		if owent ~= LocalPlayer() or owent:ShouldDrawLocalPlayer() then
			self.WeaponEnt = owent:GetActiveWeapon()
			if not IsValid(self.WeaponEnt) then return end
		else
			self.WeaponEnt = owent:GetViewModel()
			local theirweapon = owent:GetActiveWeapon()

			if IsValid(theirweapon) and theirweapon.ViewModelFlip or theirweapon.ViewModelFlipped then
				self.Flipped = true
			end

			if not IsValid(self.WeaponEnt) then return end
		end
	end

	if IsValid(self.WeaponEntOG) and self.WeaponEntOG.MuzzleAttachment then
		self.Attachment = self.WeaponEnt:LookupAttachment(self.WeaponEntOG.MuzzleAttachment)

		if not self.Attachment or self.Attachment <= 0 then
			self.Attachment = 1
		end

		if self.WeaponEntOG.Akimbo then
			self.Attachment = 2 - self.WeaponEntOG.AnimCycle
		end
	end

	local angpos

	if IsValid(self.WeaponEnt) then
		angpos = self.WeaponEnt:GetAttachment(self.Attachment)
	end

	if not angpos or not angpos.Pos then
		angpos = {
			Pos = data:GetStart(),
			Ang = data:GetNormal():Angle()
		}
	end

	if self.Flipped then
		local tmpang = (self.Dir or angpos.Ang:Forward()):Angle()
		local localang = self.WeaponEnt:WorldToLocalAngles(tmpang)
		localang.y = localang.y + 180
		localang = self.WeaponEnt:LocalToWorldAngles(localang)
		--localang:RotateAroundAxis(localang:Up(),180)
		--tmpang:RotateAroundAxis(tmpang:Up(),180)
		self.Dir = localang:Forward()
	end

	-- Keep the start and end Pos - we're going to interpolate between them
	if IsValid(owent) and self.Position:Distance(owent:GetShootPos()) > 72 then
		self.WeaponEnt = nil
	end

	self.StartPos = self:GetTracerShootPos(self.WeaponEnt and angpos.Pos or self.Position, self.WeaponEnt, self.Attachment)
	self.EndPos = data:GetOrigin()
	self.Entity:SetRenderBoundsWS(self.StartPos, self.EndPos)
	self.Normal = (self.EndPos - self.StartPos):GetNormalized()
	self.StartTime = 0
	self.LifeTime = self.Life
	self.data = data
	self.rot = 0
end

function EFFECT:Think()
	if self.InValid then return false end
	self.LifeTime = self.LifeTime - FrameTime()
	self.StartTime = self.StartTime + FrameTime()

	return self.LifeTime > 0
end

local beamcol = table.Copy(color_white)
local beamcol2 = Color(0, 50, 255, 255)

function EFFECT:Render()
	if self.InValid then return false end
	local startPos = self.StartPos
	local endPos = self.EndPos
	if(IsValid(self.WeaponEnt) && IsValid(self.WeaponEnt:GetOwner())) then
		local owner = self.WeaponEnt:GetOwner()
		local vm = owner:GetViewModel()
		local att = vm:GetAttachment(self.Attachment)
		if(att) then
			self.StartPos = self:GetTracerShootPos(att.Pos, self.WeaponEnt, self.Attachment)
			endPos = util.TraceLine({
				start = self.StartPos,
				endpos = owner:EyePos() + owner:EyeAngles():Forward() * 32767,
				mask = MASK_SHOT,
				filter = {self.WeaponEnt, owner},
				collisiongroup = COLLISION_GROUP_DEBRIS,
			}).HitPos
		else
			self.StartPos = self:GetTracerShootPos(owner:GetShootPos(), self.WeaponEnt, self.Attachment)
			endPos = util.TraceLine({
				start = self.StartPos,
				endpos = owner:EyePos() + owner:EyeAngles():Forward() * 32767,
				mask = MASK_SHOT,
				filter = {self.WeaponEnt, owner},
				collisiongroup = COLLISION_GROUP_DEBRIS,
			}).HitPos
		end
	end
	local tracerpos
	beamcol.a = self.LifeTime / self.Life * 255
	self.rot = self.rot + FrameTime() * self.RotVelocity
	render.SetMaterial(Mat_Impact)
	render.DrawSprite(endPos, 12, 12, Color(255, 255, 255, 255))
	render.SetMaterial(Mat_Beam)
	render.DrawBeam(startPos, endPos, self.Thickness, 0 + beamcol.a / 128, endPos:Distance(startPos) / 128 + beamcol.a / 128, beamcol)
end
