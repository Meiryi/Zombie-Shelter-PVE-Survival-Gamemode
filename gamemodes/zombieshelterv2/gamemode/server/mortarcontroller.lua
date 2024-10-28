util.AddNetworkString("ZShelter_StartMortarController")
util.AddNetworkString("ZShelter_EndMortarController")
util.AddNetworkString("ZShelter_SendManualAttack")
util.AddNetworkString("ZShelter_SyncFirerateTimer")
util.AddNetworkString("ZShelter_ManualAim")

function ZShelter.SyncManualAimSpot(ply, mortar)
	net.Start("ZShelter_ManualAim")
	net.WriteEntity(mortar)
	net.WriteVector(mortar:GetNWVector("ManualAimPos", Vector(0, 0, 0)))
	net.Send(ply)
end

net.Receive("ZShelter_ManualAim", function(len, ply)
	local ent = net.ReadEntity()
	local vec = net.ReadVector()
	if(!IsValid(ent) || ent != ply.ControllingMortar) then return end
	if(ent:GetNWVector("ManualAimPos", Vector(0, 0, 0)) != Vector(0, 0, 0)) then
		ply.ControllingMortar:SetNWVector("ManualAimPos", Vector(0, 0, 0))
	else
		ply.ControllingMortar:SetNWVector("ManualAimPos", vec)
	end
end)

function ZShelter.SetControllingMortar(ply, mortar)
	mortar.CurrentController = ply
	ply.ControllingMortar = mortar
	net.Start("ZShelter_StartMortarController")
	net.WriteEntity(mortar)
	net.Send(ply)
	ZShelter.SyncManualAimSpot(ply, mortar)
end

function ZShelter.UnSetControllingMortar(ply, mortar)
	mortar.CurrentController = nil
	ply.ControllingMortar = nil

	net.Start("ZShelter_EndMortarController")
	net.Send(ply)
end

function ZShelter.ShootManual(ply, vec)
	local mortar = ply.ControllingMortar
	if(!IsValid(mortar)) then return end
	local shooted = mortar:ShootManual(ply, vec)
	if(shooted) then
		net.Start("ZShelter_SyncFirerateTimer")
		net.WriteFloat(mortar.NextManualFireTime)
		net.WriteFloat(mortar.ManualFireRate)
		net.Send(ply)
	end
end

net.Receive("ZShelter_EndMortarController", function(len, ply)
	if(!IsValid(ply.ControllingMortar)) then return end
	ZShelter.UnSetControllingMortar(ply, ply.ControllingMortar)
end)

net.Receive("ZShelter_StartMortarController", function(len, ply)
	local ent = net.ReadEntity()
	if(!IsValid(ent) || !ent:GetNWBool("HasManualControl") || IsValid(ply.ControllingMortar) || IsValid(ent.CurrentController)) then return end
	ZShelter.SetControllingMortar(ply, ent)
end)

net.Receive("ZShelter_SendManualAttack", function(len, ply)
	local vec = net.ReadVector()
	ZShelter.ShootManual(ply, vec)
end)