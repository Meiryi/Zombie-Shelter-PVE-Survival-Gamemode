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
	ZShelter.BroadcastMessage("Rescue will come in 5 minutes!", Color(255, 255, 255, 255), true)
end

function ZShelter.ProcessRescue(ply)
	if(GetGlobalBool("Rescuing")) then return end
	if(ZShelter.RescueList[ply:EntIndex()]) then return end
	ZShelter.RescueList[ply:EntIndex()] = true
	local count = table.Count(ZShelter.RescueList)
	ZShelter.BroadcastMessage(ply:Nick().." Called for rescue!   ["..count.."/"..(player.GetCount()).."]", Color(255, 255, 255, 255), true)

	if(count >= player.GetCount()) then
		ZShelter.StartRescue()
	end
end

hook.Add("PlayerDisconnected", "ZShelter-DisconnectRescueCheck", function(ply)
	local count = player.GetCount() - 1
	if(!GetGlobalBool("GameStarted") || table.Count(ZShelter.RescueList) <= 0) then return end
	if(count >= table.Count(ZShelter.RescueList)) then
		ZShelter.StartRescue()
	end
end)