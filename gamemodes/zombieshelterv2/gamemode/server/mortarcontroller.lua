util.AddNetworkString("ZShelter_SetMortarController")

function ZShelterSetController(ply, mount)
	net.Start("ZShelter_SetMortarController")
	net.WriteBool(mount)
	net.Send(ply)
end