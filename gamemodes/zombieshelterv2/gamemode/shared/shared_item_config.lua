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

ZShelter.ItemConfig = {}

function ZShelter.AddItem(category, class, title, woods, irons, damage, no_ammo_supply, requiredskills, icon)
	table.insert(ZShelter.ItemConfig, {
		category = category,
		title = title,
		class = class,
		dmgscale = damage,
		icon = icon,
		woods = woods,
		irons = irons,
		ammo_supply = no_ammo_supply,
		requiredskills = requiredskills,
	})
end

function ZShelter.CreateDefaultItems()
	ZShelter.AddItem("Pistol", "arccw_go_usp", "USP-S", 2, 5, 1, true, {})
	ZShelter.AddItem("Pistol", "arccw_go_p2000", "P2000", 2, 5, 1, true, {})
	ZShelter.AddItem("Pistol", "arccw_go_cz75", "CZ75", 3, 5, 1, true, {})
	ZShelter.AddItem("Pistol", "arccw_go_p250", "P250", 3, 7, 1, true, {})
	ZShelter.AddItem("Pistol", "arccw_go_glock", "Glock", 3, 7, 1, true, {})
	ZShelter.AddItem("Pistol", "arccw_go_m9", "M92", 3, 8, 1.2, true, {})
	ZShelter.AddItem("Pistol", "arccw_go_fiveseven", "FiveSeven", 3, 10, 1, true, {})
	ZShelter.AddItem("Pistol", "arccw_go_tec9", "Tec 9", 4, 11, 1, true, {})
	ZShelter.AddItem("Pistol", "arccw_go_deagle", "Desert Eagle", 4, 13, 2, true, {})
	ZShelter.AddItem("Pistol", "arccw_go_r8", "R8 Revolver", 4, 13, 2.25, true, {})

	ZShelter.AddItem("SMG", "arccw_go_mac10", "Mac 10", 4, 12, 1, true, {"Beginner Gun Mastery"})
	ZShelter.AddItem("SMG", "arccw_go_mp9", "MP9", 4, 13, 1, true, {"Beginner Gun Mastery"})
	ZShelter.AddItem("SMG", "arccw_go_mp7", "MP7", 5, 14, 1,  true,{"Beginner Gun Mastery"})
	ZShelter.AddItem("SMG", "arccw_go_mp5", "MP5", 5, 15, 1, true, {"Beginner Gun Mastery"})
	ZShelter.AddItem("SMG", "arccw_go_ump", "UMP45", 6, 15, 1, true, {"Beginner Gun Mastery"})
	ZShelter.AddItem("SMG", "arccw_go_p90", "P90", 7, 17, 1, true, {"Beginner Gun Mastery"})
	ZShelter.AddItem("SMG", "arccw_go_bizon", "PP Bizon", 7, 20, 1, true, {"Beginner Gun Mastery"})

	ZShelter.AddItem("Shotgun", "arccw_go_nova", "Nova", 11, 18, 3, true, {"Beginner Gun Mastery"})
	ZShelter.AddItem("Shotgun", "arccw_go_870", "Sawed off", 11, 20, 3.5, true, {"Beginner Gun Mastery"})
	ZShelter.AddItem("Shotgun", "arccw_go_mag7", "Mag 7", 13, 21, 3.8, true, {"Beginner Gun Mastery"})
	ZShelter.AddItem("Shotgun", "arccw_go_m1014", "XM1014", 15, 22, 3.25, true, {"Beginner Gun Mastery"})

	ZShelter.AddItem("Rifle", "arccw_go_ar15", "M4A1", 10, 18, 1, true, {"Intermediate Gun Mastery"})
	ZShelter.AddItem("Rifle", "arccw_go_famas", "Famas", 12, 20, 1, true, {"Intermediate Gun Mastery"})
	ZShelter.AddItem("Rifle", "arccw_go_ace", "Galil", 13, 22, 1, true, {"Intermediate Gun Mastery"})
	ZShelter.AddItem("Rifle", "arccw_go_m4", "M4A4", 14, 23, 1, true, {"Intermediate Gun Mastery"})
	ZShelter.AddItem("Rifle", "arccw_go_ak47", "AK47", 15, 25, 1, true, {"Intermediate Gun Mastery"})
	ZShelter.AddItem("Rifle", "arccw_go_aug", "AUG", 17, 28, 1, true, {"Intermediate Gun Mastery"})
	ZShelter.AddItem("Rifle", "arccw_go_sg556", "SG556", 17, 28, 1, true, {"Intermediate Gun Mastery"})
	ZShelter.AddItem("Rifle", "arccw_go_scar", "Scar-H", 20, 40, 1.1, true, {"Intermediate Gun Mastery"})
	ZShelter.AddItem("Rifle", "arccw_go_g3", "G3SG1", 20, 44, 1.15, true, {"Intermediate Gun Mastery"})
	ZShelter.AddItem("Rifle", "arccw_go_ssg08", "SSG08", 20, 40, 5, true, {"Intermediate Gun Mastery"})
	ZShelter.AddItem("Rifle", "arccw_go_awp", "AWP", 25, 45, 10, true, {"Intermediate Gun Mastery"})

	ZShelter.AddItem("Heavy", "arccw_go_negev", "Negev", 30, 50, 1, true, {"Advanced Gun Mastery"})
	ZShelter.AddItem("Heavy", "arccw_go_m249para", "M249", 33, 55, 1, true, {"Advanced Gun Mastery"})

	--ZShelter.AddItem("Misc", "arccw_go_nade_frag", "Frag Grenade", 1, 4, 1, false, {"Advanced Gun Mastery"})
	--ZShelter.AddItem("Misc", "arccw_go_nade_molotov", "Molotov", 1, 5, 1, false, {"Advanced Gun Mastery"})

	if(!file.Exists("zombie shelter v2/item.txt", "DATA")) then
		ZShelter.WriteItemConfig()
	end
end

function ZShelter.WriteItemConfig()
	file.Write("zombie shelter v2/item.txt", util.TableToJSON(ZShelter.ItemConfig))
end

function ZShelter.CheckLocalItemConfig()
	if(file.Exists("zombie shelter v2/item.txt", "DATA")) then
		local ret = util.JSONToTable(file.Read("zombie shelter v2/item.txt", "DATA"))
		if(ret) then
			if(table.Count(ret) > 0) then
				ZShelter.ItemConfig = ret
			else
				ZShelter.CreateDefaultItems()
			end
		else
			ZShelter.CreateDefaultItems()
		end
	else
		ZShelter.CreateDefaultItems()
	end
end

if(GetConVar("zshelter_default_item_config"):GetInt() == 1) then -- default config
	ZShelter.CreateDefaultItems()
else
	local configdir = GetConVar("zshelter_config_name"):GetString()
	if(configdir != "") then
		local load = false
		for k,v in ipairs(ZShelter.ConfigCheckOrder) do
			local ctx = file.Read(v.."/zombie shelter v2/config/"..configdir.."/item.txt", "GAME")
			if(ctx) then
				local ret = util.JSONToTable(ctx)
				if(ret && table.Count(ret) > 0) then
					ZShelter.ItemConfig = ret
					load = true
					print("[Zombie Shelter] Custom item config loaded! : ", configdir)
					break
				end
			end
		end
		if(!load) then
			ZShelter.CheckLocalItemConfig()
		end
	else
		ZShelter.CheckLocalItemConfig()
	end
end
