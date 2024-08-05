--[[
	EN :
	Zombie Shelter v2.0 by Meiryi / Meika / Shiro / Shigure
	You SHOULD NOT edit / modify / reupload the codes, it includes editing gamemode's name
	If you have any problems, feel free to contact me on steam, thank you for reading this

	ZH-TW :
	夜襲生存戰 v2.0 by Meiryi  / Meika / Shiro / Shigure
	任何的修改是不被允許的 (包括模式的名稱)，有問題請在Steam上聯絡我, 謝謝!
	
	ZH-CN :
	昼夜求生 v2.0 by Meiryi  / Meika / Shiro / Shigure
	任何形式的编辑是不被允许的 (包括模式的名称), 若有问题请在Steam上联络我
]]

surface.CreateFont("ZShelter-MessageFont", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(32),
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

net.Receive("ZShelter-StartMessage", function()
	local diff = GetConVar("zshelter_difficulty"):GetInt()
	local difname = ZShelter.GetDiffName(diff)
	local color = ZShelter.GetDiffColor(diff)
	local message = difname.." - "..game.GetMap()
	local style = false
	if(diff >= 5) then
		style = true
	end
	ZShelter.TextAnim(message, style, color)
end)

net.Receive("ZShelter-Messages", function()
	local style = net.ReadBool()
	local message = net.ReadString()
	local color = net.ReadColor(false)
	ZShelter.TextAnim(ZShelter_ShouldTranslate(message), style, color)
end)

local footer = Material("zsh/icon/footer_white.png", "smooth")
function ZShelter.TextAnim(text, style, color)
	if(IsValid(ZShelter.MessageWindow)) then
		ZShelter.MessageWindow:Remove()
	end
	if(!color) then color = color_white end
	local ui = ZShelter.CreatePanel(nil, 0, ScrH() * 0.15, ScrW(), ScrH() * 0.15, Color(0, 0, 0, 120))
	ui.Alpha = 0
	ui.KillTime = SysTime() + 2.5
	ui.Think = function()
		if(ui.KillTime < SysTime() && ui.Alpha <= 0) then
			ui:Remove()
		end
	end

	local w, h = ScrW(), ScrH() * 0.15
	local centerX = ScrW() * 0.5
	local _w = 0
	local t1, t2 = SysTime() + 0.33, SysTime() + 2.17
	local t = 0.33
	local ct = 0
	local _h = ScreenScaleH(2)
	ui.Paint = function()
		if(ui.KillTime > SysTime()) then
			ui.Alpha = math.Clamp(ui.Alpha + ZShelter.GetFixedValue(15), 0, 255)
		else
			ui.Alpha = math.Clamp(ui.Alpha - ZShelter.GetFixedValue(15), 0, 255)
		end
		if(SysTime() < t2) then
			ct = ZShelter.GetFractionFromTime(t1, t)
		else
			ct = 1 - ZShelter.GetFractionFromTime(ui.KillTime, t)
		end
		_w = w * ct
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, ui.Alpha * 0.5))
		if(!style) then
			draw.RoundedBox(0, 0, 0, _w, _h, Color(color.r, color.g, color.b, ui.Alpha))
			draw.RoundedBox(0, ScrW() - _w, h - _h, _w, _h, Color(color.r, color.g, color.b, ui.Alpha))
		else
			local __h = (_h * ct) * 1.5
			_w = w
			surface.SetDrawColor(color.r, color.g, color.b, ui.Alpha * 0.25)
			surface.SetMaterial(footer)
			surface.DrawTexturedRect(0, 0, _w, __h)
			surface.DrawTexturedRect(ScrW() - _w, h - __h, _w, __h)
		end
		draw.DrawText(text, "ZShelter-MessageFont", ScrW() * 0.5, ScrH() * 0.04, Color(255, 255, 255, ui.Alpha), TEXT_ALIGN_CENTER)
	end

	ZShelter.MessageWindow = ui
end

function ZShelter.CenterMessage(msg, parent)
	if(!msg) then msg = "Forgot to put message?" end
	local tall = ScrH() * 0.08
	local ui = ZShelter.CreatePanel(parent, 0, (ScrH() * 0.5) - (tall * 0.5), ScrW(), tall, Color(0, 0, 0, 120))
	ui.Alpha = 0
	ui.KillTime = SysTime() + 1.5
	ui.Think = function()
		if(ui.KillTime < SysTime() && ui.Alpha <= 0) then
			ui:Remove()
		end
	end

	ui.Paint = function()
		if(ui.KillTime > SysTime()) then
			ui.Alpha = math.Clamp(ui.Alpha + ZShelter.GetFixedValue(15), 0, 255)
		else
			ui.Alpha = math.Clamp(ui.Alpha - ZShelter.GetFixedValue(15), 0, 255)
		end
		draw.RoundedBox(0, 0, 0, ui:GetWide(), ui:GetTall(), Color(0, 0, 0, ui.Alpha * 0.5))
		draw.DrawText(msg, "ZShelter-HUDFont", ScrW() * 0.5, ScrH() * 0.018, Color(255, 255, 255, ui.Alpha), TEXT_ALIGN_CENTER)
	end
end