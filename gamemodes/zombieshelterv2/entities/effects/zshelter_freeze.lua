 function EFFECT:Init(effect_data)
    local rad = 512
    local pos = effect_data:GetOrigin()
    local radius = effect_data:GetRadius() or 512
    self:SetPos(pos)

    self.Ent = effect_data:GetEntity()
    self.CurTime = 0.75
    self.rad = rad
    self.hei = 3
    self.RemoveTime = CurTime() + self.CurTime
    self.offs = rad / 2
end

function EFFECT:Think()
    if(!IsValid(self.Ent)) then return false end
    self:SetPos(self.Ent:GetPos())
    return true
end

function EFFECT:Render()
    local pos = self:GetPos()
    render.SetColorMaterial()
    render.DrawBox(pos, Angle(0, 0, 0), Vector(-self.offs, -self.offs, 0), Vector(self.offs, self.offs, 10), Color(52, 125, 235, 10))
end