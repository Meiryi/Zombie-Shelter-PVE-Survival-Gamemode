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

ZShelter = ZShelter || {}
ZShelter.VarInited = ZShelter.VarInited || false

--[[
resource.AddWorkshop("3300404406")
resource.AddWorkshop("2257255110")
resource.AddWorkshop("2548809283")
resource.AddWorkshop("2131057232")
resource.AddWorkshop("131759821")
]]

game.SetSkillLevel(2) -- So player receives full amount of damage
RunConsoleCommand("p2p_enabled", "1") -- Enable p2p so players can connect to the lobby

include("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

local safeCtrlS = false

function ZShelter.ResetServer()
	game.ConsoleCommand("changelevel "..game.GetMap().."\n")
end

if(!safeCtrlS || !ZShelter.VarInited) then
	SetGlobalInt("Day", 1)
	SetGlobalBool("Night", false)
	SetGlobalBool("Rescuing", false)
	SetGlobalBool("ReadyState", true)
	SetGlobalBool("RunSequence", true)
	SetGlobalInt("Time", 240)
	SetGlobalInt("Woods", 0)
	SetGlobalInt("Irons", 0)
	SetGlobalInt("Capacity", 32)
	SetGlobalInt("Powers", 0)
	SetGlobalInt("KillCount", 0)
	SetGlobalInt("ShelterLevel", 0)
	SetGlobalFloat("NoiseLevel", 0)
	SetGlobalFloat("ReadyTime", -1)
	SetGlobalBool("GameStarted", false)
	SetGlobalEntity("ShelterEntity", nil)

	if(ZShelter.ClearEnemies) then
		ZShelter.ClearEnemies()
	end
	ZShelter.UnsupportedMap = false
	ZShelter.VarInited = true
end