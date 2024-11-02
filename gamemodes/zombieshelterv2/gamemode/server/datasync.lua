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

util.AddNetworkString("ZShelter-SyncConfig")
util.AddNetworkString("ZShelter-SyncEnemy")
util.AddNetworkString("ZShelter-SyncItem")
util.AddNetworkString("ZShelter-SyncBuildings")
util.AddNetworkString("ZShelter-GetShelterEntity")
util.AddNetworkString("ZShelter-GetAddress")
util.AddNetworkString("ZShelter-BuildingSyncing")
util.AddNetworkString("ZShelter-NightSyncing")
util.AddNetworkString("ZShelter-LevelSyncing")

function ZShelter.SyncBuildings(player)
	local data, len = ZShelter.CompressTable(ZShelter.BuildingConfig)
	net.Start("ZShelter-SyncBuildings")
	net.WriteUInt(len, 32)
	net.WriteData(data, len)
	net.Send(player)
end

function ZShelter.SyncAllBuildings()
	local data, len = ZShelter.CompressTable(ZShelter.BuildingConfig)
	net.Start("ZShelter-SyncBuildings")
	net.WriteUInt(len, 32)
	net.WriteData(data, len)
	net.Broadcast()
end

function ZShelter.SyncAllEnemy()
	local data, len = ZShelter.CompressTable(ZShelter.EnemyConfig)
	local data1, len1 = ZShelter.CompressTable(ZShelter.EnemyList)
	net.Start("ZShelter-SyncEnemy")
	net.WriteUInt(len, 32)
	net.WriteData(data, len)
	net.WriteUInt(len1, 32)
	net.WriteData(data1, len1)
	net.Broadcast()
end

function ZShelter.SyncAllItem()
	local data, len = ZShelter.CompressTable(ZShelter.ItemConfig)
	net.Start("ZShelter-SyncItem")
	net.WriteUInt(len, 32)
	net.WriteData(data, len)
	net.Broadcast()
end

function ZShelter.SyncPlayerEnemy(player)
	local data, len = ZShelter.CompressTable(ZShelter.EnemyConfig)
	local data1, len1 = ZShelter.CompressTable(ZShelter.EnemyList)
	net.Start("ZShelter-SyncEnemy")
	net.WriteUInt(len, 32)
	net.WriteData(data, len)
	net.WriteUInt(len1, 32)
	net.WriteData(data1, len1)
	net.Send(player)
end

function ZShelter.SyncPlayerItem(player)
	local data, len = ZShelter.CompressTable(ZShelter.ItemConfig)
	net.Start("ZShelter-SyncItem")
	net.WriteUInt(len, 32)
	net.WriteData(data, len)
	net.Send(player)
end

function ZShelter.SyncAddress(ply)
	if(GetConVar("zshelter_public_lobby"):GetInt() == 0) then return end
	local address = game.GetIPAddress()
	for k,v in ipairs(player.GetAll()) do
		if(!v:IsListenServerHost()) then continue end
		address = "p2p:"..v:SteamID64() -- Don't show their IP address since it's dangerous
	end

	net.Start("ZShelter-GetAddress")
	net.WriteString(address)
	net.Send(ply)
end

function ZShelter.SyncVariables(building, upgradable, upgradecount, currentlevel, attackscale, healthscale)
	net.Start("ZShelter-BuildingSyncing")
	net.WriteEntity(building)
	net.WriteBool(upgradable)
	net.WriteInt(upgradecount, 32)
	net.WriteInt(currentlevel, 32)
	net.WriteFloat(attackscale)
	net.WriteFloat(healthscale)
	net.Broadcast()
end

function ZShelter.SyncTurretLevel(building, level)
	net.Start("ZShelter-LevelSyncing")
	net.WriteEntity(building)
	net.WriteInt(level, 32)
	net.Broadcast()
end

function ZShelter.SyncNightState()
	local state = GetGlobalBool("Night", false)
	net.Start("ZShelter-NightSyncing")
	net.WriteBool(state)
	net.Broadcast()
end

net.Receive("ZShelter-SyncItem", function(len, ply)
	local len = net.ReadUInt(32)
	local data = net.ReadData(len)
	local tab = util.JSONToTable(util.Decompress(data))
	if(!tab || !ply:IsAdmin()) then return end
	ZShelter.ItemConfig = tab
	ZShelter.WriteItemConfig()
	ZShelter.SyncAllItem()
end)

net.Receive("ZShelter-SyncEnemy", function(len, ply)
	local len = net.ReadUInt(32)
	local data = net.ReadData(len)
	local tab = util.JSONToTable(util.Decompress(data))
	if(!tab || !ply:IsAdmin()) then return end
	ZShelter.EnemyConfig = tab
	ZShelter.WriteEnemyConfig()
	ZShelter.SyncAllEnemy()
end)

net.Receive("ZShelter-SyncConfig", function(len, ply)
	ZShelter.SyncPlayerEnemy(ply)
	ZShelter.SyncPlayerItem(ply)
	ZShelter.SyncBuildings(ply)
	ZShelter.SyncAddress(ply)
	ZShelter.SendMapStats(ply, ZShelter.UnsupportedMap)
	ZShelter.ReadPlayerEXP(ply)
	ZShelter.SyncLeaderboard(ply)
	ZShelter.SyncMelee(ply, ply:GetNWInt("SelectedMelee", 0))
	net.Start("ZShelter-GetShelterEntity")
	net.WriteEntity(ZShelter.Shelter)
	net.Send(ply)

	if(ZShelter.LoadedSave) then
		ZShelter.LoadPlayerSaveData(ply)
	end
end)