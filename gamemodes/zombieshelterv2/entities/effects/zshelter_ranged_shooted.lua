 function EFFECT:Init(effect_data)
    self.Origin = effect_data:GetOrigin()
    self.Target = effect_data:GetEntity()
    self.TargetPos = effect_data:GetStart()

    self.Offset = self.TargetPos - self.Origin
    self.CurTime = 0.625
    self.DamageApplied = false
    self.DamageTime = CurTime() + 0.125
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

local mat = Material("zsh/mutations/beam.png")
function EFFECT:Render()
    local fraction_offs = 1 - math.Clamp(((self.KillTime - 0.5) - CurTime()) / 0.125, 0, 1)
    local alpha = 255 * math.Clamp((self.KillTime - CurTime()) / self.CurTime, 0, 1)
    render.SetMaterial(mat)
    render.DrawBeam(self.Origin, self.Origin + (self.Offset * fraction_offs), 3, 1, 1, Color(255, 255, 255, alpha))
end