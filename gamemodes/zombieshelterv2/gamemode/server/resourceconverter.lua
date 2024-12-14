util.AddNetworkString("ZShelter_ResourceConverterUI")
util.AddNetworkString("ZShelter_DepositResources")

function ZShelter.ResourceConverterUI(ply, ent)
	net.Start("ZShelter_ResourceConverterUI")
	net.WriteEntity(ent)
	net.Send(ply)
end

net.Receive("ZShelter_DepositResources", function(len, ply)
	local ent = net.ReadEntity()
	local amount = net.ReadInt(8)
	local type = net.ReadString()

	if(!IsValid(ent) || !ent.IsBuilding) then return end
	if(ply:GetNWInt(type) < amount) then return end
	local spaceleft = ent:GetNWInt("Capacity") - ent:GetNWInt("r_"..type)
	if(spaceleft <= 0) then return end
	local amountAllowed = math.Clamp(amount, 0, spaceleft)

	ent:SetNWInt("r_"..type, ent:GetNWInt("r_"..type) + amountAllowed)
	ply:SetNWInt(type, math.max(ply:GetNWInt(type) - amountAllowed, 0))
end)