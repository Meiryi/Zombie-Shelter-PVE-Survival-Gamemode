function EFFECT:Init(effect_data)
    local rad = 200
    local pos = effect_data:GetOrigin()
    local radius = effect_data:GetRadius() or 300
    local emitter = ParticleEmitter(pos)

    local smoke

    for i = 1, 128 do
        local smoke = emitter:Add("effects/spark", pos)
        smoke:SetGravity(Vector(0, 0, 0))
        smoke:SetDieTime(math.Rand(0.1, 0.3))
        smoke:SetStartAlpha(255)
        smoke:SetEndAlpha(200)
        smoke:SetStartSize(5)
        smoke:SetEndSize(2)
        smoke:SetRoll(math.Rand(-180, 180))
        smoke:SetRollDelta(math.Rand(250, 350))
        smoke:SetColor(255, 255, 100)
        smoke:SetPos(self:GetPos() + Vector(math.random(-rad, rad), math.random(-rad, rad), math.random(0, rad * 0.5)))
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