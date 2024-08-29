 function EFFECT:Init(effect_data)
    self.Origin = effect_data:GetOrigin()
    self.Target = effect_data:GetEntity()
    self.TargetPos = effect_data:GetStart()

    self.CurTime = 0.5
    self.KillTime = CurTime() + self.CurTime
    self:SetPos(self.TargetPos)

    self:SetRenderBoundsWS(self.TargetPos, self.Origin)
end

function EFFECT:Think()
    if(self.KillTime < CurTime() || !IsValid(self.Target) || !self.Target:IsPlayer() || !self.Target:Alive()) then
        return false
    else
        self.TargetPos = self.Target:GetPos() + Vector(0, 0, self.Target:OBBMaxs().z * 0.5)
    end
    return true
end

local mat = Material("zsh/mutations/beam.png")
function EFFECT:Render()
    local alpha = 255 * math.Clamp((self.KillTime - CurTime()) / self.CurTime, 0, 1)
    render.SetMaterial(mat)
    render.DrawBeam(self.Origin, self.TargetPos, 3, 1, 1, Color(75, 75, 75, alpha))
end