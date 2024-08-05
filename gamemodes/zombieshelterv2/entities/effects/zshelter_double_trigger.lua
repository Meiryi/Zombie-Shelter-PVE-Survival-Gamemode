 function EFFECT:Init(effect_data)
    self.Position = effect_data:GetOrigin() + VectorRand()
    self.EndPos = effect_data:GetStart()
    self.StartPos = self.Position

    self:SetPos(self.EndPos)
    self:SetRenderBoundsWS(self.StartPos, self.EndPos)

    self.CurTime = 0.35
    self.KillTime = CurTime() + self.CurTime
end

function EFFECT:Think()
    if(self.KillTime < CurTime()) then
        return false
    end
    return true
end

local mat = Material("trails/laser")
function EFFECT:Render()
    local fraction = math.Clamp((self.KillTime - CurTime()) / self.CurTime, 0, 1)
    local mfraction = 1 - fraction
    local offs = self.EndPos - self.StartPos

    render.SetMaterial(mat)
    render.DrawBeam(self.StartPos, self.StartPos + (offs * mfraction), 5 * fraction, 1, 0, Color(255, 0, 125, 255 * fraction))
end