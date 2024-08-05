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

function ZShelter.AddWinCount(day, diff)
	day = math.Clamp(day, 1, 31)
	diff = math.Clamp(diff, 1, ZShelter.MaximumDifficulty)
	HTTP({
		failed = function(reason)
		end,
		success = function(code, body, headers)
		end,
		method = "POST",
		url = "https://meiryiservice.xyz/zshelter/api/zshelter_win.php?day="..day.."&diff="..diff
	})
end

function ZShelter.AddFailCount(day, diff)
	day = math.Clamp(day, 1, 31)
	diff = math.Clamp(diff, 1, ZShelter.MaximumDifficulty)
	HTTP({
		failed = function(reason)
		end,
		success = function(code, body, headers)
		end,
		method = "POST",
		url = "https://meiryiservice.xyz/zshelter/api/zshelter_fail.php?day="..day.."&diff="..diff
	})
end