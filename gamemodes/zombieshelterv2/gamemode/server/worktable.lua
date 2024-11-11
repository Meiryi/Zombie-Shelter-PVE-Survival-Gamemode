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

util.AddNetworkString("ZShelter-OpenWorktable")
util.AddNetworkString("ZShelter-Worktable")
util.AddNetworkString("ZShelter-UncraftWeapon")

local refundScale = 0.5
net.Receive("ZShelter-UncraftWeapon", function(len, ply)
	local wep = net.ReadEntity()
	if(!IsValid(wep) || !wep:IsWeapon() || wep:GetNWInt("zsh_index", -1) == -1) then return end
	local data = ZShelter.ItemConfig[wep:GetNWInt("zsh_index")]
	if(!ply:HasWeapon(data.class)) then return end
	if(IsValid(wep)) then
		SetGlobalInt("Woods", math.min(math.floor(GetGlobalInt("Woods", 0) + data.woods * refundScale), GetGlobalInt("Capacity", 32)))
		SetGlobalInt("Irons", math.min(math.floor(GetGlobalInt("Irons", 0) + data.irons * refundScale), GetGlobalInt("Capacity", 32)))
		ply:StripWeapon(data.class)
	end
end)

net.Receive("ZShelter-Worktable", function(len, ply)
	local index1 = net.ReadInt(32)
	local data = ZShelter.ItemConfig[index1]
	if(!data || !ZShelter.CanCraftWeapon(ply, data) || ply:HasWeapon(data.class)) then return end

	local wep = ents.Create(data.class)
	wep:Spawn()
	wep.DamageScaling = data.dmgscale
	wep.CanGetAmmoSupply = data.ammo_supply
	wep.VolumeMultiplier = data.volume || 1
	wep.AmmoCapacity = data.ammo_capacity || -1
	wep.AmmoRegenSpeed = data.ammoregen || -1
	wep.Category = data.category
	wep:SetNWInt("zsh_index", index1)
	wep:SetNWInt("zsh_woods", data.woods)
	wep:SetNWInt("zsh_irons", data.irons)

	ply:PickupWeapon(wep)
	ply:GiveAmmo(wep:GetMaxClip1(), wep:GetPrimaryAmmoType(), true)

	ply:SetNWInt("WoodsUsed", ply:GetNWInt("WoodsUsed", 0) + data.woods)
	ply:SetNWInt("IronsUsed", ply:GetNWInt("IronsUsed", 0) + data.irons)

	timer.Simple(0, function()
		if(!IsValid(wep) || !IsValid(wep:GetOwner()) || wep.AmmoCapacity == -1) then return end
		wep:GetOwner():SetAmmo(0, wep:GetPrimaryAmmoType())
	end)

	sound.Play("shigure/gunpickup2.wav", ply:GetPos())
	ZShelter.BroadcastNotify(false, true, ply:Nick().." Crafted "..data.title, Color(220, 143, 55, 255))

	SetGlobalInt("Woods", math.max(GetGlobalInt("Woods", 0) - data.woods, 0))
	SetGlobalInt("Irons", math.max(GetGlobalInt("Irons", 0) - data.irons, 0))
end)