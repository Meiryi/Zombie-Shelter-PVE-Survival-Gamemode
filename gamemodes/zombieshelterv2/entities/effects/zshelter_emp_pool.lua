 function EFFECT:Init(effect_data)
    local rad = 256
    local pos = effect_data:GetOrigin()
    local radius = effect_data:GetRadius() or 256
    local emitter = ParticleEmitter(pos)
    self:SetPos(pos)

    self.CurTime = 4
    self.rad = rad
    self.hei = 3
    self.RemoveTime = CurTime() + self.CurTime
end

function EFFECT:Think()
    if(self.RemoveTime < CurTime()) then
        return false
    else
        return true
    end
end

function EFFECT:Render()
    local fraction = math.Clamp((self.RemoveTime - CurTime()) / self.CurTime, 0, 1)
    local offs = (self.rad / 2) * (1 - fraction)
    local offs_raw = self.rad / 2
    local pos = self:GetPos()
    render.SetColorMaterial()
    render.DrawBox(pos, Angle(0, 0, 0), Vector(-offs, -offs, 0), Vector(offs, offs, self.hei * fraction), Color(10, 10, 255, 5 * fraction))
    render.DrawBox(pos, Angle(0, 0, 0), Vector(-offs_raw, -offs_raw, 0), Vector(offs_raw, offs_raw, self.hei), Color(10, 10, 255, 5 * fraction))
end