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

net.Receive("ZShelter-SyncBuildings", function()
	local len = net.ReadUInt(32)
	local data = net.ReadData(len)
	local tab = util.JSONToTable(util.Decompress(data))
	ZShelter.BuildingConfig = {}
	ZShelter.BuildingData = {}
	ZShelter.BuildingConfig = tab

	for k,v in pairs(ZShelter.BuildingConfig) do
		for x,y in pairs(v) do
			local idx = y.title
			if(!idx) then continue end
			ZShelter.BuildingData[idx] = { -- These variables should always be valid
				woods = y.woods,
				irons = y.irons,
				powers = y.powers,
				model = y.model,
				offset = y.offset,
				shelterlvl = y.shelterlvl,
			}
		end
	end
end)

net.Receive("ZShelter-SyncEnemy", function()
	local len = net.ReadUInt(32)
	local data = net.ReadData(len)
	local tab = util.JSONToTable(util.Decompress(data))
	ZShelter.EnemyConfig = tab
end)

net.Receive("ZShelter-SyncItem", function()
	local len = net.ReadUInt(32)
	local data = net.ReadData(len)
	local tab = util.JSONToTable(util.Decompress(data))
	ZShelter.ItemConfig = tab
end)

net.Receive("ZShelter-GetAddress", function()
	ZShelter.ConnectAddress = net.ReadString()
end)

net.Receive("ZShelter-GetShelterEntity", function()
	SetGlobalEntity("ShelterEntity", net.ReadEntity())
end)

function ZShelter.SyncEnemy()
	local data, len = ZShelter.CompressTable(ZShelter.EnemyConfig)
	net.Start("ZShelter-SyncEnemy")
	net.WriteUInt(len, 32)
	net.WriteData(data, len)
	net.SendToServer()
end

function ZShelter.SyncItem()
	local data, len = ZShelter.CompressTable(ZShelter.ItemConfig)
	net.Start("ZShelter-SyncItem")
	net.WriteUInt(len, 32)
	net.WriteData(data, len)
	net.SendToServer()
end

hook.Add("InitPostEntity", "ZShelter-InitPlayer", function()
	net.Start("ZShelter-SyncConfig")
	net.SendToServer()
	ZShelter.ShouldOpenPanel()
end)