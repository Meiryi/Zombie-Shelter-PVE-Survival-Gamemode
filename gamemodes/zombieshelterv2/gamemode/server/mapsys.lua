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

ZShelter.UnsupportedMap = ZShelter.UnsupportedMap || false

util.AddNetworkString("ZShelter-SendMapStats")
util.AddNetworkString("ZShelter-SendMapConfig")

net.Receive("ZShelter-SendMapConfig", function(len, ply)
	if(ply.LastSendMapCFGTime && ply.LastSendMapCFGTime > CurTime()) then return end
	local len = net.ReadUInt(32)
	local data = net.ReadData(len)
	local tab = util.Decompress(data)
	--if(!ZShelter.ValidateMapConfig(tab)) then return end -- This should never happen
	file.Write("zombie shelter v2/mapconfig/"..game.GetMap()..".txt", tab)
	ZShelter.InitShelter()
	GetConVar("zshelter_debug_enable_sandbox"):SetInt(0)
	ply.LastSendMapCFGTime = CurTime() + 0.5
end)

local required = {
	shelter = 1,
	barricade = -1,
	treasure = -1,
	bonus = -1,
}
function ZShelter.ValidateMapConfig(ctx)
	if(!ctx) then return end
	local ret = util.JSONToTable(ctx)
	if(!ret || table.Count(ret) < 1) then return false end
	for k,v in pairs(required) do
		if(v == -1) then continue end
		local cfg = ret[k]
		if(!cfg) then return false end
		if(table.Count(cfg) < v) then return false end
	end
	return true
end

function ZShelter.BroadcastMapStats(supported)
	net.Start("ZShelter-SendMapStats")
	net.WriteBool(supported)
	net.Broadcast()
end

function ZShelter.SendMapStats(player, supported)
	net.Start("ZShelter-SendMapStats")
	net.WriteBool(supported)
	net.Send(player)
end

function ZShelter.IsCurrentMapSupported()
	for k,v in ipairs(ents.GetAll()) do
		if(v:GetClass() != "info_zshelter_shelter_position") then continue end
		return true
	end
	return false
end

function ZShelter.GetCurrentMapConfig()
	for k,v in pairs(ZShelter.ConfigCheckOrder) do
		local ctx = file.Read(v.."/zombie shelter v2/mapconfig/"..game.GetMap()..".txt", "GAME")
		if(!ZShelter.ValidateMapConfig(ctx)) then continue end
		local ret = util.JSONToTable(ctx)
		return ret
	end
	return false
end