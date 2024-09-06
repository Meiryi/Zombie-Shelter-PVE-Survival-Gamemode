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

net.Receive("ZShelter-Worktable", function(len, ply)
	local index1 = net.ReadInt(32)
	local data = ZShelter.ItemConfig[index1]
	if(!data || !ZShelter.CanCraftWeapon(ply, data) || ply:HasWeapon(data.class)) then return end

	local wep = ents.Create(data.class)
	wep:Spawn()
	wep.DamageScaling = data.dmgscale
	wep.CanGetAmmoSupply = data.ammo_supply
	ply:PickupWeapon(wep)
	ply:GiveAmmo(wep:GetMaxClip1(), wep:GetPrimaryAmmoType(), true)

	SetGlobalInt("Woods", math.max(GetGlobalInt("Woods", 0) - data.woods, 0))
	SetGlobalInt("Irons", math.max(GetGlobalInt("Irons", 0) - data.irons, 0))
end)