EFFECT.FX = {}

function EFFECT:Init(effect_data)
    self.Origin = effect_data:GetOrigin()
    self.TargetPos = effect_data:GetStart() + VectorRand(-6, 6)
    self.Offset = self.TargetPos - self.Origin
    self.CurTime = 0.1
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
local mat3 = Material("zsh/mutations/beam.png")
local tclr = Color(255, 50, 50)
function EFFECT:Render()
    local fraction = math.Clamp((self.KillTime - CurTime()) / self.CurTime, 0, 1)
    local rev_fraction = 1 - fraction
    local alpha = 255 * fraction
    render.SetMaterial(mat2)
    render.DrawBeam(self.Origin, self.TargetPos, 1, math.Rand(0, 0.5), math.Rand(0.5, 1), Color(tclr.r, tclr.g, tclr.b, alpha * 0.5))
    render.SetMaterial(mat3)
    render.DrawBeam(self.Origin, self.Origin + (self.Offset * rev_fraction), 3 * fraction, math.Rand(0, 0.25), math.Rand(0.75, 1), Color(tclr.r, tclr.g, tclr.b, alpha))
end