ZShelter_Controlling = ZShelter_Controlling || false
net.Receive("ZShelter_SetMortarController", function()
	ZShelter_Controlling = net.ReadBool()
end)

local rangemat = Material("arknights/torappu/sprite_attack_range.png", "noclamp")
local fraction = 0
local animtime = 2
local textureSX = 24
local vec = Vector(0, 0, 1)
local offset = Vector(0, 0, 1200)
hook.Add("HUDPaintBackground", "ZShelter-ManualController", function()
	local ply = LocalPlayer()
	if(!ZShelter_Controlling) then ZShelter_NoFog = false return end
	ZShelter_NoDraw = true
	ZShelter_NoFog = true
	surface.SetDrawColor(255, 100, 100, 255)
	local pos = ply:GetPos() + offset
	render.RenderView({
		origin = pos,
		angles = ply:EyeAngles(),
		drawviewmodel = false,
		zfar = 32767,
	})
	local scrw, scrh = ScrW() * 0.5, ScrH() * 0.5
	local sx = ScreenScaleH(2)
	surface.DrawRect(scrw - sx * 0.5, scrh - sx * 0.5, sx, sx)

	ZShelter_NoDraw = false
	ZShelter_NoFog = false
end)