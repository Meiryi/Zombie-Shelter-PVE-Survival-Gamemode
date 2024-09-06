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

ZShelter.UseFunc = ZShelter.UseFunc || {}

function ZShelter.AddFunc(ent, func)
	local randIndex = bit.tohex(math.random(1, 65536), 4)
	ent.__uIndex = randIndex
	ZShelter.UseFunc[ent:EntIndex()] = {
		index = randIndex,
		func = func,
	}
end

hook.Add("PlayerUse", "ZShelter-Use", function(ply, ent)
	if(ply.NextUse && ply.NextUse > CurTime()) then return end
	local udata = ZShelter.UseFunc[ent:EntIndex()]
	if(!udata) then return end
	if(udata.index != ent.__uIndex) then return end
	udata.func(ply, ent)
	ply.NextUse = CurTime() + 0.25
end)