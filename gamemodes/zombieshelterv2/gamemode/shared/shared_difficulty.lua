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

function ZShelter.GetDiffColor(diff)
	local c = {
		[1] = Color(0, 255, 89, 255),
		[2] = Color(145, 255, 102, 255),
		[3] = Color(247, 255, 102, 255),
		[4] = Color(255, 154, 31, 255),
		[5] = Color(255, 94, 31, 255),
		[6] = Color(255, 68, 31, 255),
		[7] = Color(255, 0, 0, 255),
		[8] = Color(217, 0, 112, 255),
		[9] = Color(112, 0, 217, 255),
	}
	return c[diff] || Color(255, 255, 255, 255)
end

function ZShelter.GetDiffName(diff)
	return ZShelter_GetTranslate("#Dif"..diff)
end