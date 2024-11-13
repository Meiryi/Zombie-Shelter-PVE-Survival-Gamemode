EFFECT.Sprites = {}
EFFECT.MaterialIndex = 1
local materials = {
    Material("sprites/flamelet1"),
    Material("sprites/flamelet2"),
    Material("sprites/flamelet3"),
    Material("sprites/flamelet4"),
    Material("sprites/flamelet5")
}

function EFFECT:Init(effect_data)
    local pos = effect_data:GetOrigin()
    local radius = effect_data:GetRadius() or 500
    self:SetPos(pos)
        local emitter = ParticleEmitter(pos)
        local smoke
        local rad = 256
        local zdiff = rad * 0.1
        for i = 1, 15 do
            smoke = emitter:Add("effects/energysplash", pos)
            smoke:SetPos(pos + Vector(math.random(-rad, rad), math.random(-rad, rad), math.random(-zdiff, zdiff)))
            smoke:SetGravity(Vector(0, 0, math.random(2500, 3000)))
            smoke:SetVelocity(VectorRand() * 25)
            smoke:SetDieTime(math.Rand(0.4, 0.8))
            smoke:SetStartAlpha(255)
            smoke:SetEndAlpha(0)
            smoke:SetStartSize(10)
            smoke:SetEndSize(1)
            smoke:SetRoll(math.Rand(-180, 180))
            smoke:SetRollDelta(math.Rand(-0.2,0.2))
            smoke:SetColor(255, 90, 0)
            smoke:SetAirResistance(1000)
            smoke:SetBounce(0)

            smoke = emitter:Add(materials[math.random(1, 5)], pos)
            smoke:SetPos(pos + Vector(math.random(-rad, rad), math.random(-rad, rad), 0))
            local vel = VectorRand() * math.random(64, 86)
            vel.z = 0
            smoke:SetVelocity(vel)
            smoke:SetDieTime(math.Rand(2, 4))
            smoke:SetStartAlpha(255)
            smoke:SetEndAlpha(0)
            smoke:SetStartSize(math.random(32, 48))
            smoke:SetEndSize(1)
            smoke:SetRoll(math.Rand(-180, 180))
            smoke:SetRollDelta(math.Rand(-1.5, 1.5))
            smoke:SetColor(255, 255, 255)
            smoke:SetBounce(0)
        end

        emitter:Finish()
end

function EFFECT:Think()
    return false
end