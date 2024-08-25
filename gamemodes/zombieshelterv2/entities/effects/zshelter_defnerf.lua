function EFFECT:Init(effect_data)
    local pos = effect_data:GetOrigin()
    local radius = 5

    self.Owner = effect_data:GetEntity()
    if(!IsValid(self.Owner)) then return end
    self.CurTime = 8
    self.pos = self.Owner:GetPos() + Vector(0, 0, self.Owner:OBBMaxs().z * 1.25)
    self.KillTime = CurTime() + self.CurTime
end

function EFFECT:Think()
    if(!IsValid(self.Owner) || self.KillTime < CurTime()) then
        return false
    end
    self.pos = self.Owner:GetPos() + Vector(0, 0, self.Owner:OBBMaxs().z * 1.25)
    self:SetPos(self.pos)
    return true
end

local material = Material("zsh/icon/nerf.png")
function EFFECT:Render()
    if(!IsValid(self) || !self.KillTime) then return end
    local size = 10
    local alpha = math.Clamp((self.KillTime - CurTime()) / self.CurTime, 0, 1)
    render.SetMaterial(material)
    render.DrawSprite(self.pos, size, size, Color(180, 180, 180, 255 * alpha))
end