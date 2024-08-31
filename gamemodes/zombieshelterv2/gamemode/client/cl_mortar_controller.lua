ZShelter.Controlling = ZShelter.Controlling || false
ZShelter.ControllerGUI = ZShelter.ControllerGUI || nil
ZShelter.FireInterval = ZShelter.FireInterval || 1
ZShelter.NextFire = 0

net.Receive("ZShelter_StartMortarController", function()
	ZShelter.Controlling = true
	ZShelter.CreateControllingGUI()
end)

net.Receive("ZShelter_SyncFirerateTimer", function()
	ZShelter.NextFire = net.ReadFloat()
	ZShelter.FireInterval = net.ReadFloat()
end)

net.Receive("ZShelter_EndMortarController", function()
	ZShelter.Controlling = false
	if(IsValid(ZShelter.ControllerGUI)) then
		ZShelter.ControllerGUI:Remove()
	end
end)

function ZShelter.SendManualAttack(vec)
	net.Start("ZShelter_SendManualAttack")
	net.WriteVector(vec)
	net.SendToServer()
end

local size = 24
local bbox = Vector(size, size, 2)
function ZShelter.CreateControllingGUI()
	local scl = 0.15
	local ui = ZShelter.CreatePanel(nil, ScrW() * scl, ScrH() * scl, ScrW() * (1 - scl * 2), ScrH() * (1 - scl * 2), Color(100, 100, 100, 255))
	local xscale, yscale =  1920 / ScrW(), 1080 / ScrH()
	local md = false
	local size = ScreenScaleH(32)
	local alpha = 0
	ZShelter.NextFire = 0
	ui:SetCursor("blank")
	ui:MakePopup()
	ui.Paint = function()
		local x, y = ui:GetPos()
		local oldclip = DisableClipping(true)
		ZShelter_NoDraw = true
		ZShelter_StopFog = true

		local tr = {
			start = LocalPlayer():GetPos(),
			endpos = LocalPlayer():GetPos() + Vector(0, 0, 32767),
			mask = MASK_SOLID_BRUSHONLY,
		}
		local camvec = util.TraceLine(tr).HitPos
		render.RenderView({
			origin =	camvec,
			angles = Angle(90, 0, 0),
			x = x, y = y,
			fov = 85,
			w = ui:GetWide(), h = ui:GetTall(),
			drawviewmodel = false,
			zfar = 32767,
		})
		local aimx, aimy = ui:CursorPos()
		local scale = 3.85
		aimx = aimx - ui:GetWide() * 0.5
		aimy = aimy - ui:GetTall() * 0.5
		local aimstart = camvec - Vector((aimy * yscale) * scale, (aimx * xscale) * scale, 0)
		local tr = {
			start = aimstart,
			endpos = aimstart - Vector(0, 0, 32767),
			mask = MASK_SOLID,
		}
		local aimpos = util.TraceLine(tr).HitPos
		render.SetColorMaterial()
		cam.Start3D()
			cam.IgnoreZ(true)
				render.DrawBox(aimpos, Angle(0, 0, 0), -Vector(48, 4, 0), Vector(48, 4, 2), Color(255, 50, 50, 200))
				render.DrawBox(aimpos, Angle(0, 0, 0), -Vector(4, 48, 0), Vector(4, 48, 2), Color(255, 50, 50, 200))
			cam.IgnoreZ(false)
		cam.End3D()
		ZShelter_NoDraw = false
		ZShelter_StopFog = false
		DisableClipping(oldclip)

		if(input.IsMouseDown(107) && !md) then
			ZShelter.SendManualAttack(aimpos)
		end

		if(ZShelter.NextFire > CurTime()) then
			alpha = math.Clamp(alpha + ZShelter.GetFixedValue(15), 0, 180)
		else
			alpha = math.Clamp(alpha - ZShelter.GetFixedValue(15), 0, 180)
		end

		local fraction = math.Clamp(1 - (ZShelter.NextFire - CurTime()) / ZShelter.FireInterval, 0, 1)
		ZShelter:CircleTimerAnimation(ui:GetWide() * 0.5, ui:GetTall() * 0.5, size, ScreenScaleH(2), 1, Color(0, 0, 0, alpha * 0.75))
		ZShelter:CircleTimerAnimation(ui:GetWide() * 0.5, ui:GetTall() * 0.5, size, ScreenScaleH(2), fraction, Color(255, 255, 255, alpha))

		md = input.IsMouseDown(107)
	end
	ZShelter.ControllerGUI = ui
end

local nextSetTime = 0
function ZShelter.StartControlMortar(ent)
	if(ZShelter.Controlling || nextSetTime > SysTime()) then return end
	net.Start("ZShelter_StartMortarController")
	net.WriteEntity(ent)
	net.SendToServer()
	nextSetTime = SysTime() + 0.33
end

function ZShelter.EndControlMortar()
	net.Start("ZShelter_EndMortarController")
	net.SendToServer()
	nextSetTime = SysTime() + 0.33
end

local mdown = false
hook.Add("Think", "ZShelter_MortarContoller", function()
	if(!ZShelter.Controlling || nextSetTime > SysTime()) then return end
	if(input.IsMouseDown(109) && !mdown) then
		ZShelter.EndControlMortar()
	end
	mdown = input.IsMouseDown(109)
end)