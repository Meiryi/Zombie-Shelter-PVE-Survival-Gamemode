function EFFECT:Init(effect_data)
    self:SetPos(effect_data:GetOrigin() + Vector(0, 0, 32))

    self.FXModels = {}
    self.FXCycle = 0

    table.insert(self.FXModels,
        ClientsideModel("models/effects/tfa_cso/ef_halogun_chargingshot.mdl")
    )
    table.insert(self.FXModels, 
        ClientsideModel("models/effects/tfa_cso/ef_halogun_chargingshot2.mdl")
    )

    sound.Play("weapons/tfa_cso/halogun/exp.wav", self:GetPos(), 120, 100, 1)
end

function EFFECT:Think()
    if(#self.FXModels <= 0) then
        return false
    else
        self.FXCycle = math.Clamp(self.FXCycle + RealFrameTime(), 0, 1)

        for _, fx in ipairs(self.FXModels) do
            if(!IsValid(fx)) then continue end

            fx:SetPos(self:GetPos())
            fx:SetCycle(self.FXCycle)

            if(self.FXCycle >= 1) then
                fx:Remove()
            end
        end

        if(self.FXCycle >= 1) then
            return false
        else
            return true
        end
    end
end

function EFFECT:Render()
    return
end