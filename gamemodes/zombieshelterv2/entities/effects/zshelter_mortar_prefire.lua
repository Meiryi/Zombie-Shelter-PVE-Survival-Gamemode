 function EFFECT:Init(effect_data)
    self:SetPos(effect_data:GetOrigin())

    self.ePos = self:GetPos() + Vector(0, 0, 2500)
    self:SetRenderBoundsWS(self:GetPos(), self.ePos)

    self.CurTime = 2.5
    self.RemoveTime = CurTime() + self.CurTime
end

function EFFECT:Think()
    if(self.RemoveTime < CurTime()) then
        return false
    else
        return true
    end
end

local beam = Material("trails/laser")
function EFFECT:Render()
    local fraction = 1 - math.Clamp((self.RemoveTime - CurTime()) / self.CurTime, 0, 1)
    if(fraction > 0.5) then fraction = 1 - fraction end
    render.SetMaterial(beam)
    render.DrawBeam(self:GetPos(), self.ePos, fraction * 40, 0, 1, Color(255, 255, 255, 255))
end