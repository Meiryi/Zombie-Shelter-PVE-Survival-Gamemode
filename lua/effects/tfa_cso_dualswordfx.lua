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
    self.EffectModel.KillTime = CurTime() + 0.5
    table.insert(DrawList, {
        cycle = 0,
        alpha = 170,
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
hook.Add("PostRender", "TFA_CSO_DualSwordFX", function()
    local ply = LocalPlayer()
    if(!IsValid(ply) || !ply:Alive()) then return end
    local vm = ply:GetViewModel()
    local offset = vm:GetPos() - ply:EyePos()
    cam.Start3D()
    cam.IgnoreZ(true)
    for _, fxs in ipairs(DrawList) do
        local fx = fxs.fx
        if(!IsValid(fx)) then
            table.remove(DrawList, _)
            continue
        else
            if(!fx.KillTime || fx.KillTime < CurTime()) then
                fxs.alpha = math.max(fxs.alpha - (200 * RealFrameTime()), 0)
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
        fx:SetPos(LocalPlayer():EyePos() + offset)
        local angleFix = AngleFix[fx:GetSequence()] || angle_zero
        fx:SetAngles(LocalPlayer():EyeAngles() + angleFix)
        fx:SetCycle(fxs.cycle)
        if(!ply:ShouldDrawLocalPlayer()) then
            fx:DrawModel()
        end
    end
    cam.End3D()
    cam.IgnoreZ(false)
    render.SetBlend(1)
end)