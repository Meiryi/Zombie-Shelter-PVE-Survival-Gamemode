function EFFECT:Init(effect_data)
    local pos = effect_data:GetOrigin()
    local radius = 7
    local emitter = ParticleEmitter(pos)
    local smoke

    for i = 1, math.random(1,15) do
        smoke = emitter:Add("effects/slime1", pos)
        smoke:SetPos(pos + Vector(math.random(-256, 256), math.random(-256, 256), 5))
        smoke:SetVelocity(VectorRand() * 50)
        smoke:SetDieTime(math.Rand(0.1, 0.65))
        smoke:SetStartAlpha(math.random(100, 200))
        smoke:SetEndAlpha(0)
        smoke:SetStartSize(1)
        smoke:SetEndSize(radius)
        smoke:SetRoll(0)
        smoke:SetRollDelta(0)
        smoke:SetColor(0, 0, 255)
        smoke:SetAirResistance(1000)
        smoke:SetLighting(false)
        smoke:SetCollide(true)
        smoke:SetBounce(0)
    end

    emitter:Finish()
end

function EFFECT:Think()
    return false
end

function EFFECT:Render()
end