ZShelter.ResourceToMoney = 100
ZShelter.ResourceToMoney_ENH = 50

function ZShelter.EconomyEnabled()
	return GetConVar("zshelter_economy"):GetInt() == 1
end

if(SERVER) then
	util.AddNetworkString("ZShelter_SyncMoney")
	function ZShelter.SyncMoney(ply)
		net.Start("ZShelter_SyncMoney")
		net.WriteInt(ply:GetNWInt("ZShelter_Money"), 32)
		net.Send(ply)
	end

	function ZShelter.AddMoney(ply, amount)
		ply:SetNWInt("ZShelter_Money", math.min(ply:GetNWInt("ZShelter_Money") + amount, 120000))
		ZShelter.SyncMoney(ply)
	end

	function ZShelter.RemoveMoney(ply, amount)
		ply:SetNWInt("ZShelter_Money",  math.max(ply:GetNWInt("ZShelter_Money") - amount, 0))
		ZShelter.SyncMoney(ply)
	end

else
	ZShelter.Money = 0
	net.Receive("ZShelter_SyncMoney", function()
		LocalPlayer():SetNWInt("ZShelter_Money", net.ReadInt(32))
	end)
end