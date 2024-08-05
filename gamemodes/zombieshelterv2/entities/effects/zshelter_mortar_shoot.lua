 function EFFECT:Init(effect_data)
    self:SetPos(effect_data:GetOrigin())

    self.ePos = self:GetPos() + Vector(0, 0, 2500)
    self:SetRenderBoundsWS(self:GetPos(), self.ePos)

    self.CurTime = 0.2
    self.RemoveTime = CurTime() + self.CurTime
end

function EFFECT:Think()
    if(self.RemoveTime < CurTime()) then
        return false
    else
        return true
    end
end

local beam = Material("trails/plasma")
function EFFECT:Render()
    local fraction = 1 - math.Clamp((self.RemoveTime - CurTime()) / self.CurTime, 0, 1)
    render.DrawBeam(self:GetPos(), self.ePos, fraction * 32, 0, 1, Color(255, 255, 255, 255))
end