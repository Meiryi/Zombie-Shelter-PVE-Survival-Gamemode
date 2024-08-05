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

util.AddNetworkString("ZShelter-Storage")
util.AddNetworkString("ZShelter-OpenStorage")

net.Receive("ZShelter-Storage", function(len, ply)
	local type = net.ReadString()
	local take = net.ReadBool()
	local amount = net.ReadInt(8)
	
	local storageAmount = GetGlobalInt(type, 0)
	local playerAmount = ply:GetNWInt(type, 0)

	local plyCapacity = ply:GetNWInt("ResourceCapacity", 24)
	local capacity = GetGlobalInt("Capacity", 32)

	if(take) then
		if(storageAmount <= 0 || storageAmount <= 0) then return end
		amount = math.min(amount, storageAmount)
		local amount_to_take = amount - math.max(amount - storageAmount, 0)
		local new_value = amount - math.max(((playerAmount + amount_to_take) - plyCapacity), 0)
		ply:SetNWInt(type, math.min(playerAmount + new_value, plyCapacity))
		SetGlobalInt(type, math.max(storageAmount - new_value, 0))
	else
		if(playerAmount <= 0 || storageAmount >= capacity) then return end
		amount = math.min(amount, playerAmount)
		local amount_to_put = amount - math.max(amount - playerAmount, 0)
		local new_value = amount - math.max(((storageAmount + amount_to_put) - capacity), 0)
		ply:SetNWInt(type, math.max(playerAmount - new_value, 0))
		SetGlobalInt(type, math.min(storageAmount + new_value, capacity))
	end
end)