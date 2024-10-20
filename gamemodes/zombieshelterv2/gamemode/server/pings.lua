util.AddNetworkString("ZShelter_SendPings")

net.Receive("ZShelter_SendPings", function(len, ply)
	local name = ply:Nick()
	local vec = net.ReadVector()
	local ent = net.ReadEntity()

	net.Start("ZShelter_SendPings")
	net.WriteVector(vec)
	net.WriteEntity(ent)
	net.WriteString(name)
	net.Broadcast()
end)