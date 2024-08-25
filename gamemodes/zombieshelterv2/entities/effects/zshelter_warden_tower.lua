 function EFFECT:Init(effect_data)
    self.Origin = effect_data:GetOrigin()
    self.Target = effect_data:GetEntity()
    self.TargetPos = effect_data:GetStart()

    self.Offset = self.TargetPos - self.Origin
    self.CurTime = 0.25
    self.DamageApplied = false
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

local mat = Material("trails/laser")
local __clamp = math.Clamp
function EFFECT:Render()
    local alpha = 255 * __clamp((self.KillTime - CurTime()) / self.CurTime, 0, 1)
    render.SetMaterial(mat)
    render.DrawBeam(self.Origin, self.TargetPos, 5, 1, 1, Color(255, 30, 30, alpha))
end