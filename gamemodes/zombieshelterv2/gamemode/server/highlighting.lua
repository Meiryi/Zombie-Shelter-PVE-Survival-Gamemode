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

util.AddNetworkString("ZShelter-HighlightEntity")

function ZShelter.HighlightBuildings()
	local day = GetGlobalInt("Day", 1)
	local list = {}
	for k,v in pairs(ents.GetAll()) do
		if(!v.IsBuilding) then continue end
		if(!v.HasHL || v.HLDay > day) then continue end
		table.insert(list, {
			index = v:EntIndex(),
			color = v.HLColor,
		})
	end

	local data, len = ZShelter.CompressTable(list)

	net.Start("ZShelter-HighlightEntity")
	net.WriteUInt(len, 32)
	net.WriteData(data, len)
	net.Broadcast()
end