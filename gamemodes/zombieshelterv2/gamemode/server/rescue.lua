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

ZShelter.RescueList = {}

function ZShelter.StartRescue()
	SetGlobalInt("Time", 300)
	SetGlobalBool("Rescuing", true)
	ZShelter.RemovePathFinder()
	ZShelter.RestorePaths()
	ZShelter.FilteEnemy(true)
	ZShelter.ToggleBarricadeCollision(true)
	ZShelter.BroadcastMessage(ZShelter_GetTranslate("#Evac5Min"), Color(255, 255, 255, 255), true)
end

local cd = {}
function ZShelter.ProcessRescue(ply)
	if(GetGlobalBool("Rescuing")) then return end
	if(cd[ply:SteamID64()] && cd[ply:SteamID64()] > CurTime()) then return end
	ZShelter.RescueList[ply:EntIndex()] = true
	local count = table.Count(ZShelter.RescueList)
	ZShelter.BroadcastMessage(ply:Nick()..ZShelter_GetTranslate("#PlayerCalledevac")..count.."/"..(player.GetCount()).."]", Color(255, 255, 255, 255), true)

	if(count >= player.GetCount()) then
		ZShelter.StartRescue()
	end
	cd[ply:SteamID64()] = CurTime() + 5
end
