function EFFECT:Init(effect_data)
    local pos = effect_data:GetOrigin()
    local radius = 5
    self.Owner = effect_data:GetEntity()
    if(!IsValid(self.Owner)) then return end
    self.CurTime = 1
    self.pos = self.Owner:GetPos() + Vector(0, 0, self.Owner:OBBMaxs().z * 1.25)
end

function EFFECT:Think()
    if(!IsValid(self.Owner)) then
        return false
    end
    self.pos = self.Owner:GetPos() + Vector(0, 0, self.Owner:OBBMaxs().z * 1.25)
    self:SetPos(self.pos)
    return true
end

local material = Material("zsh/mutations/def_main.png")
function EFFECT:Render()
    if(!IsValid(self.Owner)) then return end
    local size = 20
    render.SetMaterial(material)
    render.DrawSprite(self.pos, size, size, Color(255, 255, 255, 255))
end