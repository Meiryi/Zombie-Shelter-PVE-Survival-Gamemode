function EFFECT:Init(effect_data)
    local pos = Vector(0, 0, 0)
    local radius = 5

    self.Owner = effect_data:GetEntity()
    if(!IsValid(self.Owner)) then return end
    self.CurTime = effect_data:GetScale()
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

local m1 = Material("arknights/torappu/chenmo_01.png")
local m2 = Material("arknights/torappu/chenmo_02.png")
local size1 = 24
local size2 = 16
function EFFECT:Render()
    if(!IsValid(self) || !self.KillTime) then return end
    local fraction = (SysTime() % 1)
    if(fraction > 0.5) then
        fraction = 1 - fraction
    end
    fraction = fraction * 1.5
    local alpha = 255 * fraction
    render.SetMaterial(m1)
    render.DrawSprite(self.pos, size1, size1, Color(255, 255, 255, 255))
    render.SetMaterial(m2)
    render.DrawSprite(self.pos, size2, size2, Color(255, 255, 255, alpha))
end