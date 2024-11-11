util.AddNetworkString("ZShelter_CheckVoteKick")
util.AddNetworkString("ZShelter_VoteKick")
util.AddNetworkString("ZShelter_VoteUnban")
util.AddNetworkString("ZShelter_VoteDifficulty")
util.AddNetworkString("ZShelter_SendMulVote")
util.AddNetworkString("ZShelter_SyncMulVote")
util.AddNetworkString("ZShelter_SyncBannedPlayers")
util.AddNetworkString("ZShelter_RejectVote")
util.AddNetworkString("ZShelter_VoteResult")
util.AddNetworkString("ZShelter_StartMultuiplayerVote")

ZShelter.HasVoteKickGoing = false
ZShelter.CurrentVoteTitle = ""
ZShelter.CurrentVoteKick = {}
ZShelter.KickedPlayers = {}
ZShelter.VoteKickTimeout = 15

net.Receive("ZShelter_SendMulVote", function(len, ply)
	local vote = net.ReadBool()
	if(!ZShelter.HasVoteKickGoing) then return end
	ZShelter.PlayerVote(ply, vote)
end)

function ZShelter.BroadcastVote()
	local data, len = ZShelter.CompressTable(ZShelter.CurrentVoteKick)
	net.Start("ZShelter_SyncMulVote")
	net.WriteUInt(len, 32)
	net.WriteData(data, len)
	net.Broadcast()
end

function ZShelter.StartVote(starter)
	ZShelter.CurrentVoteKick = {}
	for _, ply in ipairs(player.GetAll()) do
		ZShelter.CurrentVoteKick[ply:SteamID64()] = -1
	end
	ZShelter.HasVoteKickGoing = true
	net.Start("ZShelter_StartMultuiplayerVote")
	net.WriteString(ZShelter.CurrentVoteTitle)
	net.Broadcast()
	ZShelter.PlayerVote(starter, true)
end

function ZShelter.PlayerVote(player, vote)
	ZShelter.CurrentVoteKick[player:SteamID64()] = vote
	ZShelter.BroadcastVote()
	ZShelter.CheckVote()
end

function ZShelter.BroadcastBannedPlayers()
	local data, len = ZShelter.CompressTable(ZShelter.KickedPlayers)
	net.Start("ZShelter_SyncBannedPlayers")
	net.WriteUInt(len, 32)
	net.WriteData(data, len)
	net.Broadcast()
end

function ZShelter.CheckVote()
	local voted = 0
	local requiredVotes = table.Count(ZShelter.CurrentVoteKick)
	for steamid, vote in pairs(ZShelter.CurrentVoteKick) do
		if(vote != -1) then
			voted = voted + 1
		end
	end
	if(voted >= requiredVotes) then
		timer.Adjust("ZShelter_MultiplayerVote", 1)
	end
end

function ZShelter.ResetVoteKick()
	ZShelter.HasVoteKickGoing = false
	ZShelter.CurrentVoteTitle = ""
	ZShelter.CurrentVoteKick = {}
end

function ZShelter.KickPlayer(player)
	ZShelter.KickedPlayers[player:SteamID64()] = player:Nick()
	local playTime = math.Round(CurTime() - (player.StartPlayingTime || 0))
	if(playTime <= 600) then
		local usedWoods, usedIrons = player:GetNWInt("WoodsUsed", 0), player:GetNWInt("IronsUsed", 0)
		print(usedWoods, usedIrons)
		local max = GetGlobalInt("Capacity", 32)
		SetGlobalInt("Woods", math.min(GetGlobalInt("Woods") + usedWoods, max))
		SetGlobalInt("Irons", math.min(GetGlobalInt("Irons") + usedIrons, max))
	end
	player:Kick("You have been temporary banned from this server!\nJoin next game or ask players to unban you!")
end

function ZShelter.RejectVote(player, reason)
	net.Start("ZShelter_RejectVote")
	net.WriteString(reason)
	net.Send(player)
end

function ZShelter.BroadcastVoteResult(text, success)
	net.Start("ZShelter_VoteResult")
	net.WriteString(text)
	net.WriteBool(success)
	net.Broadcast()
end

net.Receive("ZShelter_VoteKick", function(len, ply)
	local target = net.ReadEntity()
	if(ZShelter.HasVoteKickGoing) then
		ZShelter.RejectVote(ply, "A vote is already going on!")
		return
	end
	if(!IsValid(target)) then
		ZShelter.RejectVote(ply, "Invalid target!")
		return
	end
	if(target:IsAdmin()) then
		ZShelter.RejectVote(ply, "You can't kick an admin!")
		return
	end
	ZShelter.CurrentVoteTitle = "Kick player "..target:Nick().."?"
	ZShelter.StartVote(ply)
	timer.Create("ZShelter_MultiplayerVote", ZShelter.VoteKickTimeout, 1, function()
		local voteYes = 0
		for steamid, vote in pairs(ZShelter.CurrentVoteKick) do
			if(vote == true) then
				voteYes = voteYes + 1
			end
		end
		local count = table.Count(ZShelter.CurrentVoteKick)
		local requiredVotes = math.floor(math.Round(count * 0.5))
		if(voteYes < requiredVotes) then
			ZShelter.BroadcastVoteResult("Not enough players vote yes!", false)
		else
			ZShelter.BroadcastVoteResult("Player "..target:Nick().." has been temoprary banned!", true)
			ZShelter.KickPlayer(target)
			ZShelter.BroadcastBannedPlayers()
		end
		ZShelter.ResetVoteKick()
	end)
end)

net.Receive("ZShelter_VoteUnban", function(len, ply)
	local target = net.ReadString()
	if(ZShelter.HasVoteKickGoing) then
		ZShelter.RejectVote(ply, "A vote is already going on!")
		return
	end
	if(!ZShelter.KickedPlayers[target]) then
		ZShelter.RejectVote(ply, "Player is not banned!")
		return
	end
	ZShelter.CurrentVoteTitle = "Unban player "..ZShelter.KickedPlayers[target].."?"
	ZShelter.StartVote(ply)
	timer.Create("ZShelter_MultiplayerVote", ZShelter.VoteKickTimeout, 1, function()
		local voteYes = 0
		for steamid, vote in pairs(ZShelter.CurrentVoteKick) do
			if(vote == true) then
				voteYes = voteYes + 1
			end
		end
		local count = table.Count(ZShelter.CurrentVoteKick)
		local requiredVotes = math.floor(math.Round(count * 0.5))
		if(voteYes < requiredVotes) then
			ZShelter.BroadcastVoteResult("Not enough players vote yes!", false)
		else
			ZShelter.BroadcastVoteResult("Player "..ZShelter.KickedPlayers[target].." has been unbanned!", true)
			ZShelter.KickedPlayers[target] = nil
			ZShelter.BroadcastBannedPlayers()
		end
		ZShelter.ResetVoteKick()
	end)
end)

net.Receive("ZShelter_VoteDifficulty", function(len, ply)
	if(ZShelter.HasVoteKickGoing) then
		ZShelter.RejectVote(ply, "A vote is already going on!")
		return
	end
	local difficulty = net.ReadInt(32)
	local diffname = ZShelter.GetDiffName(difficulty)
	ZShelter.CurrentVoteTitle = "Change difficulty to "..diffname.."?"
	ZShelter.StartVote(ply)
	timer.Create("ZShelter_MultiplayerVote", ZShelter.VoteKickTimeout, 1, function()
		local voteYes = 0
		for steamid, vote in pairs(ZShelter.CurrentVoteKick) do
			if(vote == true) then
				voteYes = voteYes + 1
			end
		end
		local count = table.Count(ZShelter.CurrentVoteKick)
		local requiredVotes = math.floor(math.Round(count * 0.5))
		if(voteYes < requiredVotes) then
			ZShelter.BroadcastVoteResult("Not enough players vote yes!", false)
		else
			ZShelter.BroadcastVoteResult("Difficulty has been changed to "..diffname.."!", true)
			GetConVar("zshelter_difficulty"):SetInt(difficulty)
		end
		ZShelter.ResetVoteKick()
	end)
end)

hook.Add("PlayerInitialSpawn", "ZShelter_KickTemporaryBannedPlayers", function(player)
	local steamid = player:SteamID64()
	player.StartPlayingTime = CurTime()
	if(ZShelter.KickedPlayers[steamid]) then
		player:Kick("You have been temporary banned from this server!\nJoin next game or ask players to unban you!")
		PrintMessage(HUD_PRINTTALK, "Player "..player:Nick().." has been disconnected. Reason: Temporary banned")
	end
end)