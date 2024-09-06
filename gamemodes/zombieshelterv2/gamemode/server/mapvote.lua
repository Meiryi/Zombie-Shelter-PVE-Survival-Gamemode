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

util.AddNetworkString("ZShelter-Endgame")
util.AddNetworkString("ZShelter-SendVote")
util.AddNetworkString("ZShelter-SendDiffVote")
util.AddNetworkString("ZShelter-SyncDiffVote")
util.AddNetworkString("ZShelter-SyncVote")

ZShelter.CurrentVotes = {}
ZShelter.CurrentDiffVotes = {}
ZShelter.CurrentRTV = {}
ZShelter.VoteStarted = false

ZShelter.MapLists = {}
ZShelter.Maps = {}
ZShelter.VotePlayers = 1
ZShelter.VotedPlayers = 0
ZShelter.PlayTime = 0
ZShelter.StartTime = -1

net.Receive("ZShelter-SendDiffVote", function(len, ply)
	local diff = net.ReadInt(32)
	ZShelter.CurrentDiffVotes[ply:EntIndex()] = diff

	local data, len = ZShelter.CompressTable(ZShelter.CurrentDiffVotes)
	net.Start("ZShelter-SyncDiffVote")
	net.WriteUInt(len, 32)
	net.WriteData(data, len)
	net.Broadcast()
end)

net.Receive("ZShelter-SendVote", function(len, ply)
	local map = net.ReadString()
	ZShelter.MapLists[ply:EntIndex()] = map
	ZShelter.VotedPlayers = table.Count(ZShelter.MapLists)

	if(ZShelter.VotePlayers - ZShelter.VotedPlayers <= 0) then
		timer.Adjust("ZShelter-CheckMapVote", 5)
	end

	local data, len = ZShelter.CompressTable(ZShelter.MapLists)
	net.Start("ZShelter-SyncVote")
	net.WriteUInt(len, 32)
	net.WriteData(data, len)
	net.WriteBool(ZShelter.VotePlayers - ZShelter.VotedPlayers <= 0)
	net.Broadcast()
end)

local runtimer = true
function ZShelter.BroadcastEnd(victory, text, reason)
	if(ZShelter.VoteStarted) then return end
	ZShelter.VoteStarted = true
	ZShelter.VotePlayers = player.GetCount()
	ZShelter.VotedPlayers = 0
	if(!text) then
		if(victory) then
			text = "Victory!"
		else
			text = "Defeat!"
		end
	end
	if(!reason) then
		reason = ""
	end
	local allmaps = file.Find("maps/*.bsp", "GAME")
	local maps = file.Find("maps/zsh*.bsp", "GAME")
	local mapchecks = {}
	for k,v in pairs(allmaps) do
		mapchecks[(string.Replace(v, ".bsp", "") || "")] = true
	end
	local list = {}
	for k,v in pairs(ZShelter.ConfigCheckOrder) do
		local f = file.Find(v.."/zombie shelter v2/mapconfig/*.txt", "GAME")
		for x,y in pairs(f) do
			local ret = string.Replace(y, ".txt", "")
			if(!mapchecks[ret]) then continue end
			table.insert(maps, ret..".bsp")
		end
	end
	for k,v in pairs(maps) do
		ZShelter.Maps[v] = k
	end

	local time = 0
	if(ZShelter.StartTime != -1) then
		time = math.max(CurTime() - ZShelter.StartTime)
	end

	local data, len = ZShelter.CompressTable(ZShelter.Maps)
	net.Start("ZShelter-Endgame")
	net.WriteUInt(len, 32)
	net.WriteData(data, len)
	net.WriteBool(victory)
	net.WriteString(text)
	net.WriteString(reason)
	net.WriteInt(time, 32)
	net.Broadcast()

	if(runtimer) then
		timer.Create("ZShelter-CheckMapVote", 35, 1, function()
			local maps = {}
			local diffs = {}
			if(table.Count(ZShelter.CurrentDiffVotes)) then
				local difvote = -1
				local dif = GetConVar("zshelter_difficulty"):GetInt()
				for k,v in pairs(ZShelter.CurrentDiffVotes) do
					if(!diffs[v]) then
						diffs[v] = 1
					else
						diffs[v] = diffs[v] + 1
					end
				end
				for k,v in pairs(diffs) do
					if(v > difvote) then
						dif = k
						difvote = v
					end
				end
				GetConVar("zshelter_difficulty"):SetInt(math.Clamp(dif, 1, ZShelter.MaximumDifficulty))
			end

			for k,v in pairs(ZShelter.MapLists) do
				if(!maps[v]) then
					maps[v] = 1
				else
					maps[v] = maps[v] + 1
				end
			end
			if(table.Count(maps) <= 0) then -- Noone votes anything
				game.ConsoleCommand("changelevel "..game.GetMap().."\n")
			else
				local map = game.GetMap()
				local vote = 0
				for k,v in pairs(maps) do
					if(v > vote) then
						map = k
						vote = v
					end
				end
				game.ConsoleCommand("changelevel "..map.."\n")
			end
		end)
	end
end

hook.Add("PlayerSay", "ZSheler_RockTheVote", function(ply, text)
	local count = math.Round(player.GetCount() * 0.5, 0)
	if(text == "rtv") then
		if(!ZShelter.CurrentRTV[ply:SteamID64()]) then
			ZShelter.CurrentRTV[ply:SteamID64()] = true
		end
		local rtvcount = table.Count(ZShelter.CurrentRTV)
		PrintMessage(HUD_PRINTTALK, ply:Nick().." Wants to change the map ["..rtvcount.."/"..count.."], say 'rtv' to skip the current map")
		if(rtvcount >= count) then
			ZShelter.BroadcastEnd(true, "Skip the current map", "The players has spoken!")
		end
	end
end)