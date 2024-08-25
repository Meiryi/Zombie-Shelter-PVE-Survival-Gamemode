 function EFFECT:Init(effect_data)
    local rad = 260
    local pos = effect_data:GetOrigin()
    local radius = effect_data:GetRadius() or 450
    local emitter = ParticleEmitter(pos)
    self:SetPos(pos)

    self.CurTime = 0.25
    self.rad = rad
    self.Forwarded = pos + effect_data:GetAngles():Forward() * (rad)
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
    local size = 200 * (1 - fraction)
    local pos = self:GetPos()
    render.SetColorMaterial()
    render.DrawSphere(pos, size, 10, 10, Color(255, 48, 48, 85 * fraction))
end