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

local convarChecks = {
	zshelter_debug_disable_build_checks = 0,
	zshelter_debug_disable_building_damage = 0,
	zshelter_debug_disable_building_upgrade_checks  = 0,
	zshelter_debug_disable_craft_checks = 0,
	zshelter_debug_disable_sanity = 0,
	zshelter_debug_disable_skill_checks = 0,
	zshelter_debug_disable_upgrade_checks = 0,
	zshelter_debug_enable_sandbox = 0,
	zshelter_debug_instant_build = 0,

	ai_disabled = 0,
	ai_ignoreplayers = 0,
	sv_cheats = 0,
}
function ZShelter.ShouldSend() -- Don't record games with debug stuff enabled (aka cheating)
	for k,v in pairs(convarChecks) do
		local cvar = GetConVar(k)
		if(!cvar) then continue end -- This should NEVER happen, just in case
		if(cvar:GetInt() != v) then return false end
	end
	return true
end

function ZShelter.AddWinCount(day, diff)
	if(!ZShelter.ShouldSend()) then return end
	day = math.Clamp(day, 1, 31)
	diff = math.Clamp(diff, 1, ZShelter.MaximumDifficulty)
	if(diff >= ZShelter.MaximumDifficulty - 2 && ZShelter.Modifiers.HasEasyMode) then
		return
	end
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
	if(!ZShelter.ShouldSend()) then return end
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