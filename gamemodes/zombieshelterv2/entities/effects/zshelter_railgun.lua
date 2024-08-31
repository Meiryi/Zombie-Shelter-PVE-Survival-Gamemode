local rand = math.Rand
local random = math.random
function EFFECT:Init(effect_data)
    self.Origin = effect_data:GetOrigin()
    self.TargetPos = effect_data:GetStart()

    local start, endpos = self.Origin, self.TargetPos

    self.Offset = self.TargetPos - self.Origin
    self.CurTime = 0.5
    self.KillTime = CurTime() + self.CurTime
    self:SetPos(self.TargetPos)

    local step = math.max(math.floor(start:Distance(endpos) / 30), 3)
    local step_single = 1
    local vel = (endpos - start)
    vel:Normalize()
    local emitter = ParticleEmitter(start)
    local offs = endpos - start
    local smoke
    for i = 1, step do
        local fraction = i / step
        local pos = start + offs * fraction
            smoke = emitter:Add("effects/spark", pos)
            smoke:SetPos(pos + VectorRand(-5, 5))
            smoke:SetGravity(vel * 3500 + VectorRand() * 600)
            smoke:SetDieTime(rand(0.8, 1.5))
            smoke:SetStartAlpha(random(100, 200))
            smoke:SetEndAlpha(0)
            smoke:SetStartSize(random(3, 10))
            smoke:SetEndSize(1)
            smoke:SetRoll(rand(-180, 180))
            smoke:SetRollDelta(rand(-0.2,0.2))
            smoke:SetColor(50, 50, 255)
            smoke:SetAirResistance(800)
            smoke:SetLighting(false)
            smoke:SetCollide(true)
            smoke:SetBounce(0)
    end
    emitter:Finish()
    self:SetRenderBoundsWS(self.TargetPos, self.Origin)
end

function EFFECT:Think()
    if(self.KillTime < CurTime()) then
        return false
    end
    return true
end

local mat = Material("zsh/mutations/beam.png")
function EFFECT:Render()
    local fraction = math.Clamp((self.KillTime - CurTime()) / self.CurTime, 0, 1)
    local fraction_offs = 1 - math.Clamp(((self.KillTime - 0.4) - CurTime()) / 0.125, 0, 1)
    local calpha = 255 * fraction
    render.SetMaterial(mat)
    render.DrawBeam(self.Origin, self.Origin + (self.Offset * fraction_offs), 8 * fraction, 1, 1, Color(calpha, calpha, 255, calpha))
end