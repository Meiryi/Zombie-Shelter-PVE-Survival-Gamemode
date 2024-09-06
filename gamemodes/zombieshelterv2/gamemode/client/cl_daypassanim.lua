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

surface.CreateFont("ZShelter-DayPassFont", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(28),
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

net.Receive("ZShelter-DayPassed", function()
	ZShelter.DayPassAnimation(net.ReadInt(32))
end)

local dayMaterial = Material("zsh/icon/day_count.png", "smooth")
function ZShelter.DayPassAnimation(day)
	local ui = ZShelter.CreatePanel(nil, 0, 0, ScrW(), ScrH() * 0.4, Color(0, 0, 0, 0))
	ui.AlphaMul = 0
	ui.KillTime = SysTime() + 2.5
	ui.Think = function()
		if(ui.KillTime < SysTime()) then
			ui:Remove()
		end
	end

	local centerX = ScrW() * 0.5
	local renderY = ScrH() * 0.25
	local size = ScreenScaleH(86)
	local time = SysTime()

	local prevDay = day - 1
	local imageAnimData = {
		material = dayMaterial,
		wide = size,
		tall = size,
		color = Color(255, 255, 255, 255),
		start_alpha = 0,
		start_pos = Vector(centerX, ScrH() * 0.215, 0),
		time_until_stay = time + 0.33,
		time_for_stay = 0.33,

		pos_for_stay = Vector(centerX, ScrH() * 0.25, 0),
		time_to_stay = time + 2.17,
		alpha_for_stay = 255,

		time_to_leave = ui.KillTime,
		time_for_leave = 0.33,
		alpha_for_leave = 0,
		pos_for_leave = Vector(centerX, ScrH() * 0.285, 0),

		ease_method_start = "OutCubic",
		ease_method_leave = "InCubic",
	}
	local textOffs = ScreenScaleH(10)
	local textAnimOffs = ScreenScaleH(24)
	local animData1 = {
		text = prevDay,
		font = "ZShelter-DayPassFont",
		color = Color(0, 0, 0, 255),
		start_alpha = 0,
		start_pos = Vector(centerX, ScrH() * 0.215 - textOffs, 0),
		time_until_stay = time + 0.33,
		time_for_stay = 0.33,

		pos_for_stay = Vector(centerX, ScrH() * 0.25 - textOffs, 0),
		time_to_stay = time + 1,
		alpha_for_stay = 255,

		time_to_leave = time + 1.33,
		time_for_leave = 0.33,
		alpha_for_leave = 0,
		pos_for_leave = Vector(centerX - textAnimOffs, ScrH() * 0.25 - textOffs, 0),

		ease_method_start = "OutCubic",
		ease_method_leave = "InQuart",
	}
	local animData2 = {
		text = day,
		font = "ZShelter-DayPassFont",
		color = Color(0, 0, 0, 255),
		start_alpha = 0,
		start_pos = Vector(centerX + textAnimOffs, ScrH() * 0.25 - textOffs, 0),
		time_until_stay = time + 1.575,
		time_for_stay = 0.32,

		pos_for_stay = Vector(centerX, ScrH() * 0.25 - textOffs, 0),
		time_to_stay = time + 2,
		alpha_for_stay = 255,

		time_to_leave = ui.KillTime,
		time_for_leave = 0.33,
		alpha_for_leave = 0,
		pos_for_leave = Vector(centerX, ScrH() * 0.285 - textOffs, 0),

		ease_method_start = "OutQuart",
		ease_method_leave = "InCubic",
	}
	ui.Paint = function()
		ZShelter.ImageAnimation(imageAnimData)
		ZShelter.TextAnimation(animData1)
		ZShelter.TextAnimation(animData2)
	end
end