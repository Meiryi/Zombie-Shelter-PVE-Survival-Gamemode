function EFFECT:Init(effect_data)
    local pos = effect_data:GetOrigin()
    local radius = effect_data:GetRadius() or 128
    local emitter = ParticleEmitter(pos)
    local smoke = emitter:Add("effects/spark", pos)
    smoke:SetGravity( Vector(0, 0, 0) )
    smoke:SetDieTime(0.2)
    smoke:SetStartAlpha(255)
    smoke:SetEndAlpha(0)
    smoke:SetStartSize(3)
    smoke:SetEndSize(1)
    smoke:SetRoll( math.Rand(-180, 180) )
    smoke:SetRollDelta( math.Rand(250, 350) )
    smoke:SetColor(100, 100, 255)
    smoke:SetPos(self:GetPos())
    smoke:SetBounce(0)
    emitter:Finish()
end

function EFFECT:Think()
    return false
end

function EFFECT:Render()
end