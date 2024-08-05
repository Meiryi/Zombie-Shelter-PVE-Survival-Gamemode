 function EFFECT:Init(effect_data)
    local rad = 400
    local pos = effect_data:GetOrigin()
    local radius = effect_data:GetRadius() or 400
    local emitter = ParticleEmitter(pos)
    self:SetPos(pos)
    self.Owner = effect_data:GetEntity()
    self.CurTime = 1
    self.rad = rad
    self.hei = 3
end

function EFFECT:Think()
    if(!IsValid(self.Owner) || self.Owner:GetNWInt("SK_Damage Amplifier", 0) < 1) then
        return false
    else
        self:SetPos(self.Owner:GetPos())
        return true
    end
end

function EFFECT:Render()
    if(!IsValid(self.Owner) || !self.Owner:Alive()) then return end
    local fraction = CurTime() % 1
    if(fraction > 0.5) then fraction = 1 - fraction end
    local offs_raw = self.rad / 2
    local pos = self:GetPos()
    render.SetColorMaterial()
    render.DrawBox(pos, Angle(0, 0, 0), Vector(-offs_raw, -offs_raw, 0), Vector(offs_raw, offs_raw, self.hei), Color(255, 55, 55, 3 + 10 * fraction), false)
end