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

net.Receive("ZShelter-PlayMusic", function()
	if(!GetConVar("zshelter_client_enable_music"):GetInt() == 1) then return end
	local music = net.ReadString()
	sound.PlayFile(music, "noplay", function(station, errCode, errStr)
		if(!IsValid(station)) then return end
		station:Play()
	end)
end)

function ZShelter.PlaySound(sd)
	sound.PlayFile(sd, "noplay", function(station, errCode, errStr)
		if(!IsValid(station)) then return end
		station:Play()
	end)
end