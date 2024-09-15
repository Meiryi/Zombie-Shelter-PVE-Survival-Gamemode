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

ZShelter.ColorModify = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

net.Receive("ZShelter-UpdateLighting", function()
	local fullUpdate = net.ReadBool()
	render.RedownloadAllLightmaps(fullUpdate, fullUpdate)
end)

local fogColor = 160
local minfogColor = 40
local maxfogColor = 160
local mincontrast = 0.5
local maxcontrast = 1
local nextExecute = 0
local incSpeed = 0.5
local decSpeed = 0.5
local contrastinc = 0.005
local contrastdec = 0.005
local st = SysTime()
hook.Add("Think", "ZShelter-ScreenController", function()
	if(nextExecute > SysTime()) then return end
	local contrast = ZShelter.ColorModify["$pp_colour_contrast"]
	if(GetGlobalBool("Night")) then
		if(GetGlobalInt("Time", 0) <= 20) then
			ZShelter.ColorModify["$pp_colour_contrast"] = math.min(maxcontrast, contrast + contrastinc)
			fogColor = math.min(maxfogColor, fogColor + incSpeed)
		else
			ZShelter.ColorModify["$pp_colour_contrast"] = math.max(mincontrast, contrast - contrastdec)
			fogColor = math.max(minfogColor, fogColor - decSpeed)
		end
		ZShelter.FogColor = Color(fogColor, fogColor, fogColor, 255)
	else
		if(GetGlobalInt("Time", 0) <= 30) then
			ZShelter.ColorModify["$pp_colour_contrast"] = math.max(mincontrast, contrast - contrastdec)
			fogColor = math.max(minfogColor, fogColor - decSpeed)
		else
			ZShelter.ColorModify["$pp_colour_contrast"] = math.min(maxcontrast, contrast + contrastdec)
			fogColor = math.min(maxfogColor, fogColor + decSpeed)
		end
		ZShelter.FogColor = Color(fogColor, fogColor, fogColor, 255)
	end
	nextExecute = SysTime() + 0.1
end)

hook.Add("RenderScreenspaceEffects", "ZShelter-ScreenDim", function()
	DrawColorModify(ZShelter.ColorModify)
end)