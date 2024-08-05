 function EFFECT:Init(effect_data)
    self:SetPos(effect_data:GetOrigin())
    self.CurTime = 2.5
    self.RemoveTime = CurTime() + self.CurTime
end

EFFECT.NextParticleTime = 0

function EFFECT:Think()
    if(self.RemoveTime < CurTime()) then
        return false
    else
        if(self.NextParticleTime < CurTime()) then
            local pos = self:GetPos()
            local emitter = ParticleEmitter(pos)
            local smoke
            for i = 1, 2 do
                smoke = emitter:Add("effects/spark", pos)
                local rand = VectorRand() * 50
                rand.z = rand.z * 0.25
                smoke:SetPos(pos + rand)
                smoke:SetGravity(Vector(0, 0, math.random(2000, 2500)))
                smoke:SetVelocity(VectorRand() * 25)
                smoke:SetDieTime(math.Rand(0.6, 1))
                smoke:SetStartAlpha(255)
                smoke:SetEndAlpha(0)
                smoke:SetStartSize(math.random(5, 10))
                smoke:SetEndSize(1)
                smoke:SetRoll(math.Rand(-180, 180))
                smoke:SetRollDelta(math.Rand(-0.2,0.2))
                smoke:SetColor(255, 255, 255)
                smoke:SetAirResistance(1000)
                smoke:SetBounce(0)
            end
            emitter:Finish()
            self.NextParticleTime = CurTime() + 0.1
        end
        return true
    end
end

local mat = Material("effects/combinemuzzle2_nocull")
function EFFECT:Render()
    local fraction = 1 - math.Clamp((self.RemoveTime - CurTime()) / self.CurTime, 0, 1)
    if(fraction > 0.5) then fraction = 1 - fraction end
    local size = 400 * fraction
    render.SetMaterial(mat)
    render.DrawQuadEasy(self:GetPos() + Vector(0, 0, 1), Vector(0, 0, 1), size, size, Color(255, 255, 255, 255), 0)
end