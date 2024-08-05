 function EFFECT:Init(effect_data)
    self.Origin = effect_data:GetOrigin()
    self.Target = effect_data:GetEntity()
    self.TargetPos = Vector(0, 0, 0)
    self.Delay = 1
    self.CurTime = 0.75

    if(IsValid(self.Target)) then
        self.TargetPos = self.Target:GetPos() + Vector(0, 0, self.Target:OBBMaxs().z * 0.5)
        self:SetRenderBoundsWS(self.TargetPos, self.Origin)
    end
    self.KillTime = CurTime() + self.CurTime + self.Delay
end

function EFFECT:Think()
    if(!IsValid(self.Target) || self.KillTime < CurTime()) then
        if(self.KillTime < CurTime()) then
            local e = EffectData()
                e:SetOrigin(self.Origin)
                e:SetStart(self.TargetPos)
                e:SetEntity(Target)

            util.Effect("zshelter_ranged_shooted", e)
        end
        return false
    end
    self.TargetPos = self.Target:GetPos() + Vector(0, 0, self.Target:OBBMaxs().z * 0.5)
    self:SetPos(self.TargetPos)
    return true
end

local mat = Material("zsh/mutations/beam.png")
function EFFECT:Render()
    local fraction = 1 - math.Clamp((self.KillTime - CurTime()) / self.CurTime, 0.05, 1)
    local wide = 3.5 * fraction
    local alpha = 50 * fraction
    if((self.KillTime - CurTime()) - self.CurTime > 0) then
        wide = 0.3
        alpha = 155
    end

    render.SetMaterial(mat)
    render.DrawBeam(self.Origin, self.TargetPos, wide, 1, 1, Color(255, 30, 30, alpha))
end