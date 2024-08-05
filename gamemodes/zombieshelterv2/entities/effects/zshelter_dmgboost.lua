function EFFECT:Init(effect_data)
    self.Owner = effect_data:GetEntity()
    self.ParticleTime = 0
    self.KillTime = CurTime() + 1
end

function EFFECT:Think()
    if(!IsValid(self.Owner) || self.KillTime < CurTime()) then return false end

    if(self.ParticleTime < CurTime()) then
        local pos = self.Owner:GetPos() + Vector(0, 0, 5)
        local emitter = ParticleEmitter(pos)
        local smoke

        for i = 1, 2 do
            smoke = emitter:Add("effects/spark", pos)
            smoke:SetPos(pos + VectorRand() * 15)
            smoke:SetGravity(Vector(0, 0, math.random(2500, 3000)))
            smoke:SetVelocity(VectorRand() * 25)
            smoke:SetDieTime(math.Rand(0.2, 0.4))
            smoke:SetStartAlpha(255)
            smoke:SetEndAlpha(0)
            smoke:SetStartSize(5)
            smoke:SetEndSize(1)
            smoke:SetRoll(math.Rand(-180, 180))
            smoke:SetRollDelta(math.Rand(-0.2,0.2))
            smoke:SetColor(255, 0, 0)
            smoke:SetAirResistance(1000)
            smoke:SetBounce(0)
        end

        emitter:Finish()
        self.ParticleTime = CurTime() + 0.125
    end

    return true
end

function EFFECT:Render()
end