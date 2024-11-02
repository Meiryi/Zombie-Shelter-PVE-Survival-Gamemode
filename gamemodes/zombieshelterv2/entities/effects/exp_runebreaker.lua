EFFECT.mat = Material("sprites/runebreaker_exp")

function EFFECT:Init(data)
	self.pos = data:GetOrigin()
	self.Fraction = 0
end

local maxFrame = 30
function EFFECT:Think()
	self.Fraction = self.Fraction + FrameTime()
	return self.Fraction < 1
end

function EFFECT:Render()
	render.SetMaterial(self.mat)
	self.mat:SetInt("$frame", math.Clamp(math.floor(self.Fraction * maxFrame), 0, maxFrame))
	render.DrawSprite(self.pos + Vector(0, 0, 0), 128, 128, Color(255, 255, 255, 255))
end