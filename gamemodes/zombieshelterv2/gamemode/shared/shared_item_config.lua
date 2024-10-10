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

function ZShelter.SortItemConfig()
	table.sort(ZShelter.ItemConfig, function(a,b) return (a.woods + a.irons) < (b.woods + b.irons) end)
end

function ZShelter.ConvertConfigToCode()
	local output = ""
	local lastCategory = nil
	for _, config in ipairs(ZShelter.ItemConfig) do
		if(!lastCategory) then
			lastCategory = config.category
		end
		local code = [[
			ZShelter.AddItem("]]..config.category..[[", "]]..config.class..[[", "]]..config.title..[[", ]]..config.woods..[[, ]]..config.irons..[[, ]]..config.dmgscale..[[, ]]..tostring(config.ammo_supply)..[[, {]]
		local tablestring = ""
		for index, skill in pairs(config.requiredskills) do
			if(index == #config.requiredskills) then
				tablestring = tablestring..[["]]..skill..[["]]
			else
				tablestring = tablestring..[["]]..skill..[[", ]]
			end
		end
		code = code..tablestring.."}"
		code = code..[[, ]]..(config.icon || "nil")..[[, ]]..(config.volume || "nil")..[[, ]]..(config.ammo_capacity || "nil")..[[, ]]..tostring(config.ammoregen)..[[)]]
		code = code.."\n"
		if(lastCategory != config.category) then -- New line between categories
			code = "\n"..code
		end
		lastCategory = config.category
		output = output..code
	end

	SetClipboardText(output)
end

function ZShelter.AddItem(category, class, title, woods, irons, damage, no_ammo_supply, requiredskills, icon, volume, ammocapacity, ammoregen)
	table.insert(ZShelter.ItemConfig, {
		category = category,
		title = title,
		class = class,
		dmgscale = damage,
		icon = icon,
		woods = woods,
		irons = irons,
		ammo_supply = no_ammo_supply,
		ammo_capacity = ammocapacity || -1,
		ammoregen = ammoregen || -1,
		requiredskills = requiredskills,
		volume = volume,
	})
end

function ZShelter.CreateDefaultItems()
			ZShelter.AddItem("Pistol", "tfa_cso_usp", "USP-45", 3, 5, 1.5, true, {}, nil, 0.35, -1, -1)
			ZShelter.AddItem("Pistol", "tfa_cso_mauser_c96", "Mauser C96", 6, 5, 2, true, {}, nil, 0.35, -1, -1)
			ZShelter.AddItem("Pistol", "tfa_cso_glock", "Glock", 6, 8, 2, true, {}, nil, 0.35, -1, -1)
			ZShelter.AddItem("Pistol", "tfa_cso_fiveseven", "Five-Seven", 8, 10, 2.5, true, {}, nil, 0.5, -1, -1)
			ZShelter.AddItem("Pistol", "tfa_cso_deagle", "Desert Eagle", 10, 14, 3.5, true, {}, nil, 1, -1, -1)
			ZShelter.AddItem("Pistol", "tfa_cso_elite", "Dual Elites", 16, 14, 2.25, true, {}, nil, 0.45, -1, -1)
			ZShelter.AddItem("Pistol", "tfa_cso_sapientia", "Sapientia", 14, 18, 3, true, {}, nil, 1.5, -1, -1)
			ZShelter.AddItem("Pistol", "tfa_cso_skull1", "SKULL 1", 18, 15, 4, true, {}, nil, 1.5, -1, -1)
			ZShelter.AddItem("Pistol", "tfa_cso_balrog1", "Barlog 1", 20, 16, 3, true, {}, nil, 2.25, -1, -1)
			ZShelter.AddItem("Pistol", "tfa_cso_vulcanus1", "Vulcanus 1", 21, 20, 2, true, {}, nil, 0.35, -1, -1)
			ZShelter.AddItem("Pistol", "tfa_cso_skull2", "SKULL 2", 22, 23, 3, true, {}, nil, 0.35, -1, -1)
			ZShelter.AddItem("Pistol", "tfa_cso_m950_attack", "M950", 25, 21, 2, true, {}, nil, 0.35, -1, -1)
			ZShelter.AddItem("Pistol", "tfa_cso_cyclone", "Cyclone", 30, 30, 2.25, true, {}, nil, 1, -1, -1)

			ZShelter.AddItem("SMG", "tfa_cso_mp5", "MP5", 6, 9, 2, true, {"Beginner Gun Mastery"}, nil, 0.8, -1, -1)
			ZShelter.AddItem("SMG", "tfa_cso_mac10_v2", "MAC-10", 9, 12, 2.05, true, {"Beginner Gun Mastery"}, nil, 0.8, -1, -1)
			ZShelter.AddItem("SMG", "tfa_cso_mp40", "MP40", 12, 10, 1.5, true, {"Beginner Gun Mastery"}, nil, 0.8, -1, -1)
			ZShelter.AddItem("SMG", "tfa_cso_kriss_v", "KRISS Vector", 14, 14, 2, true, {"Beginner Gun Mastery"}, nil, 0.8, -1, -1)
			ZShelter.AddItem("SMG", "tfa_cso_ump45", "UMP45", 16, 18, 2, true, {"Beginner Gun Mastery"}, nil, 0.8, -1, -1)
			ZShelter.AddItem("SMG", "tfa_cso_tmp", "TMP", 20, 18, 2, true, {"Beginner Gun Mastery"}, nil, 0.35, -1, -1)
			ZShelter.AddItem("SMG", "tfa_cso_k1a", "K1A", 22, 26, 2.25, true, {"Beginner Gun Mastery"}, nil, 1.25, -1, -1)
			ZShelter.AddItem("SMG", "tfa_cso_thompson_chicago", "Thompson", 26, 26, 2.15, true, {"Beginner Gun Mastery"}, nil, 1, -1, -1)
			ZShelter.AddItem("SMG", "tfa_cso_p90", "P90", 28, 30, 2.35, true, {"Beginner Gun Mastery"}, nil, 1, -1, -1)
			ZShelter.AddItem("SMG", "tfa_cso_bizon", "PP-19", 33, 35, 2.5, true, {"Beginner Gun Mastery"}, nil, 1.15, -1, -1)
			ZShelter.AddItem("SMG", "tfa_cso_skull3_a", "SKULL 3", 50, 53, 1.65, true, {"Beginner Gun Mastery"}, nil, 0.5, -1, -1)
			ZShelter.AddItem("SMG", "tfa_cso_dmp7a1", "Dual MP7A1", 61, 55, 0.9, true, {"Beginner Gun Mastery"}, nil, 1.35, -1, -1)

			ZShelter.AddItem("Shotgun", "tfa_cso_m3", "M3", 10, 12, 4, true, {"Beginner Gun Mastery"}, nil, 10, -1, -1)
			ZShelter.AddItem("Shotgun", "tfa_cso_ksg12", "KSG12", 16, 18, 4, true, {"Beginner Gun Mastery"}, nil, 8, -1, -1)
			ZShelter.AddItem("Shotgun", "tfa_cso_m1887", "M1887", 16, 20, 4, true, {"Beginner Gun Mastery"}, nil, 10, -1, -1)
			ZShelter.AddItem("Shotgun", "tfa_cso_spas12", "SPAS 12", 20, 22, 5, true, {"Beginner Gun Mastery"}, nil, 10, -1, -1)
			ZShelter.AddItem("Shotgun", "tfa_cso_xm1014", "XM1014", 20, 24, 4, true, {"Beginner Gun Mastery"}, nil, 6, -1, -1)
			ZShelter.AddItem("Shotgun", "tfa_cso_dbarrel", "Double Barrel", 25, 24, 6, true, {"Beginner Gun Mastery"}, nil, 12, -1, -1)
			ZShelter.AddItem("Shotgun", "tfa_cso_usas12", "USAS-12", 30, 33, 3.35, true, {"Beginner Gun Mastery"}, nil, 5, -1, -1)
			ZShelter.AddItem("Shotgun", "tfa_cso_uts15", "UTS15", 33, 28, 3, true, {"Beginner Gun Mastery"}, nil, 6, -1, -1)
			ZShelter.AddItem("Shotgun", "tfa_cso_mk3a1", "MK3A1", 37, 29, 4, true, {"Beginner Gun Mastery"}, nil, 5, -1, -1)
			ZShelter.AddItem("Shotgun", "tfa_cso_skull11", "SKULL 11", 40, 40, 2, true, {"Beginner Gun Mastery"}, nil, 6, -1, -1)
			ZShelter.AddItem("Shotgun", "tfa_zsh_cso_qbarrel", "Quad Barrel", 45, 40, 2, true, {"Beginner Gun Mastery"}, nil, 10, -1, -1)
			ZShelter.AddItem("Shotgun", "tfa_cso_volcano", "Volcano", 54, 60, 1.8, true, {"Beginner Gun Mastery"}, nil, 4, -1, -1)

			ZShelter.AddItem("Rifle", "tfa_cso_famas", "FAMAS", 14, 12, 3, true, {"Beginner Gun Mastery,Intermediate Gun Mastery"}, nil, 1.75, -1, -1)
			ZShelter.AddItem("Rifle", "tfa_cso_ak47", "AK-47", 18, 21, 3, true, {"Beginner Gun Mastery,Intermediate Gun Mastery"}, nil, 1.75, -1, -1)
			ZShelter.AddItem("Rifle", "tfa_cso_scarh", "Scar-H", 20, 23, 3.5, true, {"Beginner Gun Mastery,Intermediate Gun Mastery"}, nil, 1.75, -1, -1)
			ZShelter.AddItem("Rifle", "tfa_cso_aug", "Steyr AUG", 22, 22, 3, true, {"Beginner Gun Mastery,Intermediate Gun Mastery"}, nil, 1.75, -1, -1)
			ZShelter.AddItem("Rifle", "tfa_cso_fnc", "FNC", 22, 23, 3.75, true, {"Beginner Gun Mastery,Intermediate Gun Mastery"}, nil, 1.75, -1, -1)
			ZShelter.AddItem("Rifle", "tfa_cso_sg552", "SG552", 25, 29, 3.25, true, {"Beginner Gun Mastery,Intermediate Gun Mastery"}, nil, 1.75, -1, -1)
			ZShelter.AddItem("Rifle", "tfa_cso_xm8", "XM8", 25, 30, 4, true, {"Beginner Gun Mastery,Intermediate Gun Mastery"}, nil, 1.75, -1, -1)
			ZShelter.AddItem("Rifle", "tfa_cso_balrog5", "Balrog 5", 28, 30, 2.85, true, {"Beginner Gun Mastery,Intermediate Gun Mastery"}, nil, 1.75, -1, -1)
			ZShelter.AddItem("Rifle", "tfa_cso_ethereal", "Ethereal", 30, 32, 4, true, {"Beginner Gun Mastery,Intermediate Gun Mastery"}, nil, 1.75, -1, -1)
			ZShelter.AddItem("Rifle", "tfa_cso_m14ebr", "M14 EBR", 33, 35, 4, true, {"Beginner Gun Mastery,Intermediate Gun Mastery"}, nil, 2, -1, -1)
			ZShelter.AddItem("Rifle", "tfa_cso_skull4", "SKULL 4", 38, 42, 3, true, {"Beginner Gun Mastery,Intermediate Gun Mastery"}, nil, 2.25, -1, -1)
			ZShelter.AddItem("Rifle", "tfa_cso_tornadoa", "Tornado", 45, 49, 1.25, true, {"Beginner Gun Mastery,Intermediate Gun Mastery"}, nil, 1.5, -1, -1)
			ZShelter.AddItem("Rifle", "tfa_cso_plasmagun", "Plasma Gun", 45, 49, 0.8, true, {"Beginner Gun Mastery,Intermediate Gun Mastery"}, nil, 1.5, -1, -1)
			ZShelter.AddItem("Rifle", "tfa_cso_guardian", "AUG Guardian", 75, 69, 1, true, {"Beginner Gun Mastery,Intermediate Gun Mastery"}, nil, 1.75, -1, -1)
			ZShelter.AddItem("Rifle", "tfa_zsh_cso_darkknight", "M4A1 Dark Knight", 105, 129, 1, true, {"Beginner Gun Mastery,Intermediate Gun Mastery"}, nil, 1.75, -1, -1)
			ZShelter.AddItem("Rifle", "tfa_zsh_cso_paladin", "AK-47 Paladin", 155, 159, 1, true, {"Beginner Gun Mastery,Intermediate Gun Mastery"}, nil, 1.75, -1, -1)

			ZShelter.AddItem("Sniper Rifle", "tfa_cso_scout", "Scout", 18, 12, 7, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery"}, nil, 5, -1, -1)
			ZShelter.AddItem("Sniper Rifle", "tfa_cso_m24", "M24", 24, 29, 6, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery"}, nil, 14, -1, -1)
			ZShelter.AddItem("Sniper Rifle", "tfa_cso_vsk94", "VSK94", 28, 26, 6.5, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery"}, nil, 1.15, -1, -1)
			ZShelter.AddItem("Sniper Rifle", "tfa_cso_xm2010", "XM2010", 32, 35, 7, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery"}, nil, 14, -1, -1)
			ZShelter.AddItem("Sniper Rifle", "tfa_cso_m95", "M95", 35, 33, 2.5, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery"}, nil, 14, -1, -1)
			ZShelter.AddItem("Sniper Rifle", "tfa_cso_awp", "AWP", 39, 42, 8, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery"}, nil, 14, -1, -1)
			ZShelter.AddItem("Sniper Rifle", "tfa_cso_sg550", "SG550", 40, 40, 4.25, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery"}, nil, 3.5, -1, -1)
			ZShelter.AddItem("Sniper Rifle", "tfa_cso_skull5", "SKULL 5", 47, 45, 3.75, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery"}, nil, 3.5, -1, -1)
			ZShelter.AddItem("Sniper Rifle", "tfa_cso_sl8", "SL8", 58, 55, 3.25, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery"}, nil, 3.5, -1, -1)
			ZShelter.AddItem("Sniper Rifle", "tfa_cso_wa2000", "WA2000", 62, 70, 4.25, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery"}, nil, 6, -1, -1)
			ZShelter.AddItem("Sniper Rifle", "tfa_cso_destroyer", "Destroyer", 89, 82, 0.5, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery"}, nil, 20, -1, -1)
			ZShelter.AddItem("Sniper Rifle", "tfa_cso_thunderbolt", "Thunderbolt", 102, 98, 3, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery"}, nil, 30, 5, 5)

			ZShelter.AddItem("Heavy", "tfa_cso_mk48", "MK48", 22, 26, 1.35, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery", "Advanced Gun Mastery"}, nil, 2, -1, -1)
			ZShelter.AddItem("Heavy", "tfa_cso_m249", "M249", 26, 29, 2, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery", "Advanced Gun Mastery"}, nil, 2, -1, -1)
			ZShelter.AddItem("Heavy", "tfa_cso_hk23", "HK23", 31, 35, 2.15, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery", "Advanced Gun Mastery"}, nil, 2, -1, -1)
			ZShelter.AddItem("Heavy", "tfa_cso_m60", "M60", 36, 42, 2.5, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery", "Advanced Gun Mastery"}, nil, 2, -1, -1)
			ZShelter.AddItem("Heavy", "tfa_cso_m249ex", "SKULL 7", 40, 42, 1.65, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery", "Advanced Gun Mastery"}, nil, 2, -1, -1)
			ZShelter.AddItem("Heavy", "tfa_cso_skull8", "SKULL 8", 42, 44, 1.7, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery", "Advanced Gun Mastery"}, nil, 2, -1, -1)
			ZShelter.AddItem("Heavy", "tfa_cso_mg36_xmas", "MG36 XMAS", 45, 42, 1.5, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery", "Advanced Gun Mastery"}, nil, 0.75, -1, -1)
			ZShelter.AddItem("Heavy", "tfa_cso_k3", "K3", 65, 63, 2.75, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery", "Advanced Gun Mastery"}, nil, 2, -1, -1)
			ZShelter.AddItem("Heavy", "tfa_cso_mg3", "MG3", 79, 72, 2, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery", "Advanced Gun Mastery"}, nil, 2, -1, -1)
			ZShelter.AddItem("Heavy", "tfa_zsh_cso_m134", "M134 Minigun", 79, 72, 1.5, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery", "Advanced Gun Mastery"}, nil, 2, -1, -1)
			ZShelter.AddItem("Heavy", "tfa_cso_balrog7", "Balrog 7", 133, 122, 2.25, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery", "Advanced Gun Mastery"}, nil, 2, -1, -1)
			ZShelter.AddItem("Heavy", "tfa_cso_broad", "Broad Divine", 145, 140, 2.25, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery", "Advanced Gun Mastery"}, nil, 2, -1, -1)

			ZShelter.AddItem("Explosive", "tfa_cso_rpg7", "RPG-7", 65, 68, 1, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery", "Advanced Gun Mastery"}, nil, 20, 5, 8)
			ZShelter.AddItem("Explosive", "tfa_cso_at4ex", "AT4", 80, 84, 0.85, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery", "Advanced Gun Mastery"}, nil, 25, 5, 8)

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
