net.Receive("ZShelter_SyncEXP", function()
	local player = net.ReadEntity()
	local num = net.ReadInt(32)
	local difficulty = net.ReadInt(32)
	local day = net.ReadInt(32)
	if(!IsValid(player) || !player:IsPlayer()) then return end
	player:SetNWInt("ZShelterEXP", num)	
	player:SetNWInt("ZShelterSurvivedDifficulty", difficulty)	
	player:SetNWInt("ZShelterSurvivedDays", day)	
end)

net.Receive("ZShelter_SyncLeaderboard", function()
	local len = net.ReadUInt(32)
	local data = net.ReadData(len)
	local leaderboard = ZShelter.DecompressTable(data)
	if(!leaderboard) then return end
	ZShelter.Leaderboard = leaderboard
end)
