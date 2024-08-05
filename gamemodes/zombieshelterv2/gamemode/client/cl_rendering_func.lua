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

function ZShelter.ShadowText(text, font, x, y, color, shadowcolor, align, amount)
	draw.DrawText(text, font, x + ScreenScaleH(amount), y + ScreenScaleH(amount), shadowcolor, align)
	draw.DrawText(text, font, x, y, color, align)
end

--[[
	text
	font
	color

	start_alpha
	start_pos
	time_until_stay
	time_for_stay

	time_to_stay
	alpha_for_stay
	pos_for_stay

	time_to_leave
	time_for_leave
	alpha_for_leave
	pos_for_leave

	ease_method
]]
function ZShelter.TextAnimation(a)
	local time = SysTime()
	if(a.time_until_stay > SysTime()) then -- To Stay
		local fraction = math.ease[a.ease_method_start](math.Clamp(1 - ((a.time_until_stay - SysTime()) / a.time_for_stay), 0, 1))
		local offx, offy = (a.pos_for_stay.x - a.start_pos.x) * fraction, (a.pos_for_stay.y - a.start_pos.y) * fraction
		local alpha = a.start_alpha + (a.alpha_for_stay - a.start_alpha) * fraction
		draw.DrawText(a.text, a.font, a.start_pos.x + offx, a.start_pos.y + offy, Color(a.color.r, a.color.g, a.color.b, alpha), TEXT_ALIGN_CENTER)
	else
		if(a.time_to_stay > SysTime()) then -- Staying
			draw.DrawText(a.text, a.font, a.pos_for_stay.x, a.pos_for_stay.y, Color(a.color.r, a.color.g, a.color.b, a.alpha_for_stay), TEXT_ALIGN_CENTER)
		else -- To Leave
			if(a.time_to_leave > SysTime()) then
				local fraction = math.ease[a.ease_method_leave](math.Clamp(1 - ((a.time_to_leave - SysTime()) / a.time_for_leave), 0, 1))
				local offx, offy = (a.pos_for_leave.x - a.pos_for_stay.x) * fraction, (a.pos_for_leave.y - a.pos_for_stay.y) * fraction
				local alpha = a.alpha_for_stay + (a.alpha_for_leave - a.alpha_for_stay) * fraction
				draw.DrawText(a.text, a.font, a.pos_for_stay.x + offx, a.pos_for_stay.y + offy, Color(a.color.r, a.color.g, a.color.b, alpha), TEXT_ALIGN_CENTER)
			else
				draw.DrawText(a.text, a.font, a.pos_for_leave.x, a.pos_for_leave.y, Color(a.color.r, a.color.g, a.color.b, a.alpha_for_leave), TEXT_ALIGN_CENTER)
			end
		end
	end
end

--[[
	material
	wide
	tall
	color

	start_alpha
	start_pos
	time_until_stay
	time_for_stay

	time_to_stay
	alpha_for_stay
	pos_for_stay

	time_to_leave
	time_for_leave
	alpha_for_leave
	pos_for_leave

	ease_method
]]
function ZShelter.ImageAnimation(a)
	local time = SysTime()
	surface.SetMaterial(a.material)
	if(a.time_until_stay > SysTime()) then -- To Stay
		local fraction = math.ease[a.ease_method_start](math.Clamp(1 - ((a.time_until_stay - SysTime()) / a.time_for_stay), 0, 1))
		local offx, offy = (a.pos_for_stay.x - a.start_pos.x) * fraction, (a.pos_for_stay.y - a.start_pos.y) * fraction
		local alpha = a.start_alpha + (a.alpha_for_stay - a.start_alpha) * fraction
		surface.SetDrawColor(a.color.r, a.color.g, a.color.b, alpha)
		surface.DrawTexturedRect((a.start_pos.x + offx) - a.wide / 2, (a.start_pos.y + offy) - a.tall / 2, a.wide, a.tall)
	else
		if(a.time_to_stay > SysTime()) then -- Staying
			surface.SetDrawColor(a.color.r, a.color.g, a.color.b, a.alpha_for_stay)
			surface.DrawTexturedRect((a.pos_for_stay.x) - a.wide / 2, (a.pos_for_stay.y) - a.tall / 2, a.wide, a.tall)
		else -- To Leave
			if(a.time_to_leave > SysTime()) then
				local fraction = math.ease[a.ease_method_leave](math.Clamp(1 - ((a.time_to_leave - SysTime()) / a.time_for_leave), 0, 1))
				local offx, offy = (a.pos_for_leave.x - a.pos_for_stay.x) * fraction, (a.pos_for_leave.y - a.pos_for_stay.y) * fraction
				local alpha = a.alpha_for_stay + (a.alpha_for_leave - a.alpha_for_stay) * fraction
				surface.SetDrawColor(a.color.r, a.color.g, a.color.b, alpha)
				surface.DrawTexturedRect((a.pos_for_stay.x + offx) - a.wide / 2, (a.pos_for_stay.y + offy) - a.tall / 2, a.wide, a.tall)
			else
				surface.SetDrawColor(a.color.r, a.color.g, a.color.b, a.alpha_for_leave)
				surface.DrawTexturedRect((a.pos_for_leave.x) - a.wide / 2, (a.pos_for_leave.y) - a.tall / 2, a.wide, a.tall)
			end
		end
	end
end

function ZShelter.GetFractionFromTime(target, t)
	return math.Clamp(1 - ((target - SysTime()) / t), 0, 1)
end