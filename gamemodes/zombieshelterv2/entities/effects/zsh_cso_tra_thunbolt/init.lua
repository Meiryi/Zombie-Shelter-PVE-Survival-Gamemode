TRACER_FLAG_USEATTACHMENT = 0x0002
SOUND_FROM_WORLD = 0
CHAN_STATIC = 6
EFFECT.Thickness = 8
EFFECT.Life = 1
EFFECT.RotVelocity = 30
EFFECT.InValid = false
local Mat_Impact = Material("tracers/impact_rail")
local Mat_Beam = Material("effects/blueblacklargebeam")
local Mat_TracePart = Material("effects/select_ring")
local tesla = Material("effects/bloodstream")

function EFFECT:Init(data)
	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	local owent

	if IsValid(self.WeaponEnt) then
		owent = self.WeaponEnt.Owner or self.WeaponEnt:GetOwner()

		if not IsValid(owent) then
			owent = self.WeaponEnt:GetParent()
		end
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
	self.Fraction = 1
	self.data = data
	self.rot = 0
end

function EFFECT:Think()
	if self.InValid then return false end
	self.LifeTime = self.LifeTime - FrameTime()
	self.StartTime = self.StartTime + FrameTime()
	self.Fraction = math.Clamp(self.Fraction - RealFrameTime() * 5, 0, 1)

	return self.LifeTime > 0
end

local beamcol = table.Copy(color_white)
local beamcol2 = Color(0, 50, 255, 255)

function EFFECT:Render()
	if self.InValid then return false end
	local startPos = self.StartPos
	local endPos = self.EndPos
	local tracerpos
	local fraction = 1 - (self.StartTime / self.Life)
	local offset = endPos - startPos
	local endvec = startPos + (offset * (1 - self.Fraction))
	local size = 10 * fraction
	beamcol.a = fraction * 255
	self.rot = self.rot + FrameTime() * self.RotVelocity
	render.SetMaterial(Mat_Impact)
	render.DrawSprite(endPos, 12, 12, Color(120, 120, 255, 255))
	render.SetMaterial(Mat_Beam)
	render.DrawBeam(startPos, endPos, size, 0 + beamcol.a / 128, endPos:Distance(startPos) / 64 + beamcol.a / 128, beamcol)
	render.SetMaterial(tesla)
	render.DrawBeam(startPos, endvec, size * 2, math.Rand(0, 0.25), math.Rand(0.75, 1), Color(255, 255, 255, beamcol.a))
end
