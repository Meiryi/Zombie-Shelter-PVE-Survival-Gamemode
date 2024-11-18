local materials = {
    Material("sprites/flamelet1"),
    Material("sprites/flamelet2"),
    Material("sprites/flamelet3"),
    Material("sprites/flamelet4"),
    Material("sprites/flamelet5")
}

function EFFECT:Init(effect_data)
    local pos = effect_data:GetOrigin()
    local emitter = ParticleEmitter(pos)
    local smoke
    local rad = 256
    local zdiff = rad * 0.1
    for i = 1, 6 do
        smoke = emitter:Add(materials[math.random(1, 5)], pos)
        smoke:SetPos(pos)
        local vel = VectorRand() * math.random(-128, 128)
        smoke:SetVelocity(vel)
        local vel = VectorRand() * math.random(-64, 64)
        vel.z = math.random(-512, -300)
        smoke:SetGravity(vel)
        smoke:SetDieTime(math.Rand(0.33, 1))
        smoke:SetStartAlpha(255)
        smoke:SetEndAlpha(0)
        smoke:SetStartSize(math.random(1, 5))
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

function EFFECT:Render()
end