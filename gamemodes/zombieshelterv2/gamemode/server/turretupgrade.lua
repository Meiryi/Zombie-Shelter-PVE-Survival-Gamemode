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

util.AddNetworkString("ZShelter-UpgradeTurret")

net.Receive("ZShelter-UpgradeTurret", function(len, ply)
	if(ply.UpgradeCD && ply.UpgradeCD > CurTime()) then return end -- Prevent spamming
	local building = net.ReadEntity()
	if(!building:GetNWBool("Upgradable", false) || building:GetNWInt("UpgradeCount", 0) >= building:GetNWInt("MaxUpgrade", 2)) then return end
	local req_woods, req_irons = math.floor(math.max(building:GetNWInt("Woods", 0), 1)), math.floor(math.max(building:GetNWInt("Irons", 0) * 0.5, 1))
	local canUpgrade, useStorage = ZShelter.CanUpgradeTurret(ply, req_woods, req_irons)
	if(GetConVar("zshelter_debug_disable_building_upgrade_checks"):GetInt() == 0 && !canUpgrade) then return end
	if(!useStorage) then
		ply:SetNWInt("Woods", math.max(ply:GetNWInt("Woods", 0) - req_woods, 0))
		ply:SetNWInt("Irons", math.max(ply:GetNWInt("Irons", 0) - req_irons, 0))
	else
		SetGlobalInt("Woods", math.max(GetGlobalInt("Woods", 0) - req_woods, 0))
		SetGlobalInt("Irons", math.max(GetGlobalInt("Irons", 0) - req_irons, 0))
	end

	if(!building.AttackDamage) then building.AttackDamage = 0 end

	building.AttackDamage = building.AttackDamage + math.floor(building:GetNWInt("oAttackDamage", 0) * building:GetNWFloat("AttackScale", 0))
	building:SetNWInt("AttackDamage", building.AttackDamage)
	local sethp = building:Health() >= building:GetMaxHealth()
	building:SetMaxHealth(building:GetMaxHealth() + math.floor(building:GetNWInt("oMaxHealth", building:GetMaxHealth()) * building:GetNWFloat("HealthScale", 0)))
	if(sethp) then
		building:SetHealth(building:GetMaxHealth())
	end

	ply:SetNWInt("WoodsUsed", ply:GetNWInt("WoodsUsed", 0) + req_woods)
	ply:SetNWInt("IronsUsed", ply:GetNWInt("IronsUsed", 0) + req_irons)
	
	building:SetNWInt("UpgradeCount", building:GetNWInt("UpgradeCount", 0) + 1)
	ZShelter.SyncTurretLevel(building, building:GetNWInt("UpgradeCount", 0))
	ZShelter.SyncHP(building, ply)
	sound.Play("shigure/upgrade.wav", building:GetPos(), 100, 100, 1)
	ply.UpgradeCD = CurTime() + 0.5
end)
