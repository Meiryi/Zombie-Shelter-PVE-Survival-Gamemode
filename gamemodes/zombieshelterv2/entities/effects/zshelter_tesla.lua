EFFECT.FX = {}

function EFFECT:Init(effect_data)
   self.Origin = effect_data:GetOrigin() + VectorRand(-2, 2)
   self.TargetPos = effect_data:GetStart() + VectorRand(-6, 6)
    self.Offset = self.TargetPos - self.Origin
    self.CurTime = 0.45
    self.KillTime = CurTime() + self.CurTime
    self:SetPos(self.TargetPos)
    self:SetRenderBoundsWS(self.TargetPos, self.Origin)
end

function EFFECT:Think()
    if(self.KillTime < CurTime()) then
        return false
    end
    return true
end

local mat = Material("effects/tool_tracer")
local mat2 = Material("effects/bloodstream")
function EFFECT:Render()
    local alpha = 255 * math.Clamp((self.KillTime - CurTime()) / self.CurTime, 0, 1)
    render.SetMaterial(mat)
    render.DrawBeam(self.Origin, self.TargetPos, 20, math.Rand(0, 0.5), math.Rand(0.5, 1), Color(255, 180, 50, alpha * 0.25))
    render.SetMaterial(mat2)
    render.DrawBeam(self.Origin, self.TargetPos, 7, math.Rand(0, 0.25), math.Rand(0.75, 1), Color(255, 255, 255, alpha))
end