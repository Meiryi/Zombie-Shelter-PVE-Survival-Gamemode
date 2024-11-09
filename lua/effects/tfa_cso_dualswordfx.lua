local Models = {
    "models/effects/tfa_cso/dualswordfx.mdl",
    "models/effects/tfa_cso/dualswordmfx.mdl",
    "models/effects/tfa_cso/dualswordpaintgs18fx.mdl",
}
local DrawList = {}
local SequenceFix = {

}

function EFFECT:Init(effect_data)
    self.SwordType = effect_data:GetFlags()
    self.SlashCount = effect_data:GetScale()

    self.EffectModel = ClientsideModel(Models[self.SwordType])
    self.EffectModel:ResetSequence(self.SlashCount - 1)
    self.EffectModel:SetRenderMode(RENDERMODE_TRANSALPHA)
    self.EffectModel.KillTime = CurTime() + 1.5
    table.insert(DrawList, {
        cycle = 0,
        alpha = 255,
        fx = self.EffectModel,
    })
    self.EffectModel:SetNoDraw(true)
end

local AngleFix = {
    Angle(0, 0, 0),
    Angle(0, 0, 0),
    Angle(0, 0, 0),
    Angle(0, 0, 0),
}
hook.Add("PostDrawOpaqueRenderables", "TFA_CSO_DualSwordFX", function()
    cam.IgnoreZ(true)
    for _, fxs in ipairs(DrawList) do
        local fx = fxs.fx
        if(!IsValid(fx)) then
            table.remove(DrawList, _)
            continue
        else
            if(!fx.KillTime || fx.KillTime < CurTime()) then
                fxs.alpha = math.max(fxs.alpha - (510 * RealFrameTime()), 0)
                if(fxs.alpha <= 0) then
                    fx:Remove()
                    table.remove(DrawList, _)
                    continue
                end
            end
        end
        render.SetBlend(math.max(fxs.alpha, 1) / 255)
        fxs.cycle = math.min(fxs.cycle + RealFrameTime() * 1.25)
        fx:SetColor(Color(255, 255, 255, fxs.alpha))
        fx:SetPos(LocalPlayer():EyePos())
        local angleFix = AngleFix[fx:GetSequence()] || angle_zero
        fx:SetAngles(LocalPlayer():EyeAngles() + angleFix)
        fx:SetCycle(fxs.cycle)
        fx:DrawModel()
    end
    cam.IgnoreZ(false)
    render.SetBlend(1)
end)