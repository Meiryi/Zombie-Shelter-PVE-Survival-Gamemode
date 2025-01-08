function EFFECT:Init(effectdata)
	local pos = effectdata:GetOrigin()
	local normal = effectdata:GetNormal()

	local particle

	sound.Play("Gunkata.SkilllastExp", pos, 180, 100)

	local emitter = ParticleEmitter(pos)
	local emitter2 = ParticleEmitter(pos, true)
	emitter:SetNearClip(24, 32)
	emitter2:SetNearClip(24, 32)

	local ringstart = pos + normal * -3
	local count = 10
	for i = 1, count do
		particle = emitter2:Add("effects/select_ring", ringstart)
		particle:SetDieTime(i * 0.025)
		particle:SetColor(255, 150, 0, 255 - i * 50)
		particle:SetStartAlpha(128 + 80 * (i / count))
		particle:SetEndAlpha(0)
		particle:SetStartSize(0)
		particle:SetEndSize(150 + i * 5)
		particle:SetAngles(Angle(90,0,0))
		particle:SetPos( Vector(pos) + Vector(0,0,4) )
	end

	emitter:Finish()
	emitter2:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
