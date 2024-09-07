ZShelter.Leaderboard = {}
util.AddNetworkString("ZShelter_SyncEXP")
util.AddNetworkString("ZShelter_SyncLeaderboard")

function ZShelter.BroadcastPlayerEXP(player, exp, difficulty, day)
	player:SetNWInt("ZShelterEXP", exp)
	net.Start("ZShelter_SyncEXP")
	net.WriteEntity(player)
	net.WriteInt(exp, 32)
	net.WriteInt(difficulty, 32)
	net.WriteInt(day, 32)
	net.Broadcast()
end

function ZShelter.SyncLeaderboard(player)
	if(table.Count(ZShelter.Leaderboard) <= 0) then
		ZShelter.ReadLeaderboard()
	end
	local data, len = ZShelter.CompressTable(ZShelter.Leaderboard)
	net.Start("ZShelter_SyncLeaderboard")
	net.WriteUInt(len, 32)
	net.WriteData(data, len)
	net.Send(player)
end

function ZShelter.BroadcastLeaderboard()
	local data, len = ZShelter.CompressTable(ZShelter.Leaderboard)
	net.Start("ZShelter_SyncLeaderboard")
	net.WriteUInt(len, 32)
	net.WriteData(data, len)
	net.Broadcast()
end

function ZShelter.ReadPlayerEXP(player)
	local steamid = player:SteamID64()
	local content = file.Read("zombie shelter v2/exps/"..steamid..".txt", "DATA")
	local data = ZShelter.DecompressTable(content)
	if(!data) then
		ZShelter.WritePlayerEXP(player, -1, -1)
		ZShelter.BroadcastPlayerEXP(player, 0, -1, -1)
	else
		local exp = data.exp || 0
		local difficulty = data.difficulty || -1
		local day = data.day || -1
		ZShelter.BroadcastPlayerEXP(player, exp, difficulty, day)
	end
end

function ZShelter.WritePlayerEXP(player, day, difficulty)
	local steamid = player:SteamID64()
	local exp = player:GetNWInt("ZShelterEXP", 0)

	local existing_data = ZShelter.DecompressTable(file.Read("zombie shelter v2/exps/"..steamid..".txt", "DATA"))
	if(!existing_data) then
		local data = {
			exp = exp,
			difficulty = difficulty,
			day = day,
		}
		file.Write("zombie shelter v2/exps/"..steamid..".txt", ZShelter.CompressTable(data))
	else
		if(existing_data.exp > exp) then print("Trying to decrease exp! blocked!") return end -- This should never happen
		existing_data.exp = exp
		if(day >= (existing_data.day || -1)) then
			existing_data.day = day
			existing_data.difficulty = difficulty
		end
		file.Write("zombie shelter v2/exps/"..steamid..".txt", ZShelter.CompressTable(existing_data))
	end
end

function ZShelter.ReloadLeaderboard()
	local files = file.Find("zombie shelter v2/exps/*.txt", "DATA")
	local ranks = {}
	for _, filename in ipairs(files) do
		local steamid = string.Replace(filename, ".txt", "")
		local content = ZShelter.DecompressTable(file.Read("zombie shelter v2/exps/"..steamid..".txt", "DATA"))
		if(!content) then continue end
		local exp = 0
		table.insert(ranks, {
			steamid = steamid,
			exp = content.exp,
			difficulty = content.difficulty,
			day = content.day,
		})
	end
	table.sort(ranks, function(a, b) return a.exp > b.exp end)
	local writeRank = {}
	local maximumAmount = 15
	for k,v in ipairs(ranks) do
		if(k > maximumAmount) then break end
		table.insert(writeRank, v)
	end
	ZShelter.Leaderboard = writeRank
	file.Write("zombie shelter v2/leaderboard/leaderboard.txt", ZShelter.CompressTable(ZShelter.Leaderboard))
end

hook.Add("ZShelter-DaySwitch", "ZShelter-GainEXP", function()
	if(!ZShelter.ShouldSend()) then return end
	local difficulty = ZShelter.StartedDifficulty || 1
	local day = GetGlobalInt("Day", 0)
	local expGain = ZShelter.CalculateEXPGain(day, difficulty)
	for k,v in ipairs(player.GetAll()) do
		if(!v.LastDayContribution) then
			v.LastDayContribution = 0
		end
		local continute = math.max(v:Frags() - v.LastDayContribution, 0)
		local exp = math.floor(continute * 0.75)
		v:SetNWInt("ZShelterEXP", v:GetNWInt("ZShelterEXP", 0) + exp + expGain)
		ZShelter.WritePlayerEXP(v, day, difficulty)
		v.LastDayContribution = v:Frags()
	end
	ZShelter.ReloadLeaderboard()
	ZShelter.BroadcastLeaderboard()
end)

function ZShelter.ReadLeaderboard()
	local content = file.Read("zombie shelter v2/leaderboard/leaderboard.txt", "DATA")
	local leaderboard = ZShelter.DecompressTable(content)
	if(!leaderboard) then return end
	ZShelter.Leaderboard = leaderboard
end

ZShelter.ReadLeaderboard()