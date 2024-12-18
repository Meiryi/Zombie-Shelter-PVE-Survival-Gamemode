ZShelter.Controlling = ZShelter.Controlling || false
ZShelter.ControllerGUI = ZShelter.ControllerGUI || nil
ZShelter.FireInterval = ZShelter.FireInterval || 1
ZShelter.ControllingMortar = ZShelter.ControllingMortar || nil
ZShelter.NextFire = 0

--[[
	net.Start("ZShelter_ManualAim")
	net.WriteVector(mortar:GetNWVector("ManualAimPos", Vector(0, 0, 0)))
	net.Send(ply)
]]

function ZShelter.SendManualAim(vec)
	net.Start("ZShelter_ManualAim")
	net.WriteEntity(ZShelter.ControllingMortar)
	net.WriteVector(vec)
	net.SendToServer()
end

net.Receive("ZShelter_ManualAim", function()
	local ent = net.ReadEntity()
	local vec = net.ReadVector()
	if(!IsValid(ent)) then return end
	ent:SetNWVector("ManualAimPos", vec)
end)

net.Receive("ZShelter_StartMortarController", function()
	ZShelter.Controlling = true
	ZShelter.ControllingMortar = net.ReadEntity()
	ZShelter.CreateControllingGUI()
end)

net.Receive("ZShelter_SyncFirerateTimer", function()
	ZShelter.NextFire = net.ReadFloat()
	ZShelter.FireInterval = net.ReadFloat()
end)

net.Receive("ZShelter_EndMortarController", function()
	ZShelter.Controlling = false
	ZShelter.ControllingMortar = nil
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
local hideList = {
	obj_resource_airdrop = true,
	obj_resource_blueprint = true,
	obj_resource_wood = true,
	obj_resource_iron = true,
	obj_resource_lootbox = true,
	obj_resource_box = true,
	obj_resource_backpack = true,
}
function ZShelter.CreateControllingGUI()
	local scl = 0
	local ui = ZShelter.CreatePanel(nil, ScrW() * scl, ScrH() * scl, ScrW() * (1 - scl * 2), ScrH() * (1 - scl * 2), Color(100, 100, 100, 255))
	local xscale, yscale =  1920 / ScrW(), 1080 / ScrH()
	local md = false
	local md2 = false
	local size = ScreenScaleH(32)
	local offset = Vector(0, 0, 0)
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
		if(input.IsKeyDown(KEY_W)) then
			offset.x = offset.x + ZShelter.GetFixedValue(16)
		end
		if(input.IsKeyDown(KEY_A)) then
			offset.y = offset.y + ZShelter.GetFixedValue(16)
		end
		if(input.IsKeyDown(KEY_S)) then
			offset.x = offset.x - ZShelter.GetFixedValue(16)
		end
		if(input.IsKeyDown(KEY_D)) then
			offset.y = offset.y - ZShelter.GetFixedValue(16)
		end
		local limit = 1024
		offset.x = math.Clamp(offset.x, -limit, limit)
		offset.y = math.Clamp(offset.y, -limit, limit)
		local scale = 3.85
		local ent = ents.GetAll()
		for k,v in ipairs(ent) do
			if(!v:GetNWBool("IsResource") && !hideList[v:GetClass()]) then continue end
			v:SetNoDraw(true)
		end
		render.RenderView({
			origin =	camvec + offset,
			angles = Angle(90, 0, 0),
			x = x, y = y,
			fov = 85,
			w = ui:GetWide(), h = ui:GetTall(),
			drawviewmodel = false,
			zfar = 32767,
		})
		for k,v in ipairs(ent) do
			if(!v:GetNWBool("IsResource") && !hideList[v:GetClass()]) then continue end
			v:SetNoDraw(false)
		end
		local aimx, aimy = ui:CursorPos()
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
				if(IsValid(ZShelter.ControllingMortar)) then
					local manualAimPos = ZShelter.ControllingMortar:GetNWVector("ManualAimPos", Vector(0, 0, 0))
					if(manualAimPos != Vector(0, 0, 0)) then
						render.DrawBox(manualAimPos, Angle(0, 0, 0), -Vector(128, 128, 0), Vector(128, 128, 2), Color(128, 0, 255, 100))
					end
				end
			cam.IgnoreZ(false)
		cam.End3D()
		ZShelter_NoDraw = false
		ZShelter_StopFog = false
		DisableClipping(oldclip)

		if(input.IsMouseDown(107) && !md) then
			ZShelter.SendManualAttack(aimpos)
		end

		if(input.IsMouseDown(108) && !md2) then
			ZShelter.SendManualAim(aimpos)
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
		md2 = input.IsMouseDown(108)
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