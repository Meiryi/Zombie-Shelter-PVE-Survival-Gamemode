net.Receive("ZShelter-BuildingSyncing", function()
	local entity = net.ReadEntity()
	if(!IsValid(entity)) then return end
	local upgradable = net.ReadBool()
	local count = net.ReadInt(32)
	local curlevel = net.ReadInt(32)
	local attackscale = net.ReadFloat()
	local healthscale = net.ReadFloat()

	entity:SetNWBool("IsBuilding", true)
	entity:SetNWBool("Upgradable", upgradable)
	entity:SetNWInt("MaxUpgrade", count)
	entity:SetNWInt("UpgradeCount", curlevel)
	entity:SetNWFloat("AttackScale", attackscale)
	entity:SetNWFloat("HealthScale", healthscale)
end)

net.Receive("ZShelter-LevelSyncing", function()
	local entity = net.ReadEntity()
	if(!IsValid(entity)) then return end
	entity:SetNWInt("UpgradeCount", net.ReadInt(32))
end)

net.Receive("ZShelter-NightSyncing", function()
	local state = net.ReadBool()
	SetGlobalBool("Night", state)
end)