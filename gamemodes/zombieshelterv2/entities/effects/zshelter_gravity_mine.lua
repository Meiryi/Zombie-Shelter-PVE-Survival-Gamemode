function EFFECT:Init(effect_data)
    self.pos = effect_data:GetOrigin()
    self.ParticleTime = 0
    self.DrawSize = 0
    self.SizeTime = CurTime() + 0.15
    self.KillTime = CurTime() + 6.5
end

local range = 360
local range2x = 100
function EFFECT:Think()
    if(self.KillTime < CurTime()) then return false end

    if(self.ParticleTime < CurTime()) then
        local emitter = ParticleEmitter(self:GetPos())
        local smoke
        for i = 1, 6 do
            local pos = self:GetPos() + Vector(math.random(-range, range), math.random(-range, range), math.random(0, range2x))
            local vel = (self:GetPos() - pos)
            vel:Normalize()
            vel = vel * math.random(100, 600)
            smoke = emitter:Add("effects/spark", pos)
            smoke:SetPos(pos + VectorRand() * 15)
            smoke:SetGravity(vel)
            smoke:SetVelocity(vel)
            smoke:SetDieTime(math.Rand(0.2, 0.4))
            smoke:SetStartAlpha(255)
            smoke:SetEndAlpha(0)
            smoke:SetStartSize(10)
            smoke:SetEndSize(2)
            smoke:SetRoll(math.Rand(-180, 180))
            smoke:SetRollDelta(math.Rand(-0.2,0.2))
            smoke:SetColor(50, 50, 255)
        end

        emitter:Finish()
        self.ParticleTime = CurTime() + 0.05
    end

    return true
end

function EFFECT:Render()
    local fraction = 1
    if(self.KillTime - CurTime() <= 0.5) then
        fraction = math.Clamp((self.KillTime - CurTime()) / 0.5, 0, 1)
    end
    self.DrawSize = 360 * math.Clamp(1 - (self.SizeTime - CurTime()) / 0.15, 0, 1)
    render.SetColorMaterial()
    render.DrawSphere(self:GetPos(), self.DrawSize, 8, 8, Color(55, 55, 255, 50 * fraction))
end