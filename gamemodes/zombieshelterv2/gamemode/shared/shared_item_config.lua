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

function ZShelter.AddItem(category, class, title, woods, irons, damage, no_ammo_supply, requiredskills, icon, volume, ammocapacity, ammoregen, shelterlevel, requiredLevel)
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
		shelterlevel = shelterlevel,
		requiredLevel = requiredLevel || 0,
	})
end

function ZShelter.CreateDefaultItems()
			ZShelter.AddItem("Pistol", "tfa_cso_usp", "USP-45", 3, 5, 1.5, true, {}, nil, 0.35, -1, -1, 1)
			ZShelter.AddItem("Pistol", "tfa_cso_glock", "Glock", 6, 8, 2, true, {}, nil, 0.35, -1, -1, 1)
			ZShelter.AddItem("Pistol", "tfa_cso_fiveseven", "Five-Seven", 8, 10, 2.5, true, {}, nil, 0.5, -1, -1, 1)
			ZShelter.AddItem("Pistol", "tfa_cso_deagle", "Desert Eagle", 10, 14, 3.5, true, {}, nil, 1, -1, -1, 1)
			ZShelter.AddItem("Pistol", "tfa_zsh_cso_mauser_c96", "Mauser C96", 12, 10, 2, true, {}, nil, 0.85, -1, -1, 1)
			ZShelter.AddItem("Pistol", "tfa_cso_elite", "Dual Elites", 16, 14, 2.25, true, {}, nil, 0.45, -1, -1, 1)

			ZShelter.AddItem("Pistol", "tfa_cso_sapientia", "Sapientia", 14, 18, 3, true, {}, nil, 1.5, -1, -1, 2)
			ZShelter.AddItem("Pistol", "tfa_cso_skull1", "SKULL 1", 18, 15, 4, true, {}, nil, 1.5, -1, -1, 2)
			ZShelter.AddItem("Pistol", "tfa_cso_balrog1", "Barlog 1", 20, 16, 3, true, {}, nil, 2.25, -1, -1, 2)
			ZShelter.AddItem("Pistol", "tfa_cso_vulcanus1", "Vulcanus 1", 21, 20, 2, true, {}, nil, 0.35, -1, -1, 2)
			ZShelter.AddItem("Pistol", "tfa_cso_ddeagle", "Duel Desert Eagle", 30, 30, 0.7, true, {}, nil, 0.35, -1, -1, 2)
			ZShelter.AddItem("Pistol", "tfa_zsh_cso_thanatos1", "Thanatos 7", 45, 42, 1, true, {}, nil, 1.5, -1, -1, 2)

			ZShelter.AddItem("Pistol", "tfa_cso_m950_attack", "M950", 25, 21, 1.5, true, {}, nil, 0.35, -1, -1, 3)
			ZShelter.AddItem("Pistol", "tfa_cso_cyclone", "Cyclone", 30, 30, 1, true, {}, nil, 1, -1, -1, 3)

			ZShelter.AddItem("Pistol", "tfa_zsh_cso_desperado", "Desperado", 48, 55, 1, true, {}, nil, 2.25, -1, -1, 4)

			ZShelter.AddItem("SMG", "tfa_cso_ump45", "UMP45", 7, 6, 1.25, true, {"Beginner Gun Mastery"}, nil, 0.8, -1, -1)
			ZShelter.AddItem("SMG", "tfa_cso_mp5", "MP5", 8, 9, 1.5, true, {"Beginner Gun Mastery"}, nil, 0.8, -1, -1, 1)
			ZShelter.AddItem("SMG", "tfa_cso_mac10_v2", "MAC-10", 10, 12, 2, true, {"Beginner Gun Mastery"}, nil, 0.8, -1, -1, 1)
			ZShelter.AddItem("SMG", "tfa_cso_mp40", "MP40", 12, 10, 1.15, true, {"Beginner Gun Mastery"}, nil, 0.8, -1, -1, 1)
			ZShelter.AddItem("SMG", "tfa_cso_tmp", "TMP", 20, 18, 2, true, {"Beginner Gun Mastery"}, nil, 0.35, -1, -1)

			ZShelter.AddItem("SMG", "tfa_cso_k1a", "K1A", 15, 12, 1.5, true, {"Beginner Gun Mastery"}, nil, 1.25, -1, -1, 2)
			ZShelter.AddItem("SMG", "tfa_cso_thompson_chicago", "Thompson", 26, 26, 1.75, true, {"Beginner Gun Mastery"}, nil, 1, -1, -1, 2)
			ZShelter.AddItem("SMG", "tfa_cso_p90", "P90", 28, 30, 1.85, true, {"Beginner Gun Mastery"}, nil, 1, -1, -1, 2)
			ZShelter.AddItem("SMG", "tfa_cso_bizon", "PP-19", 33, 35, 2, true, {"Beginner Gun Mastery"}, nil, 1.15, -1, -1, 2)

			ZShelter.AddItem("SMG", "tfa_cso_skull3_a", "SKULL 3", 50, 53, 1.5, true, {"Beginner Gun Mastery"}, nil, 0.5, -1, -1, 3)
			ZShelter.AddItem("SMG", "tfa_cso_dmp7a1", "Dual MP7A1", 61, 55, 0.7, true, {"Beginner Gun Mastery"}, nil, 1.35, -1, -1, 3)

			ZShelter.AddItem("Shotgun", "tfa_cso_m3", "M3", 10, 12, 4, true, {"Beginner Gun Mastery"}, nil, 10, -1, -1, 1)
			ZShelter.AddItem("Shotgun", "tfa_cso_ksg12", "KSG12", 16, 18, 4, true, {"Beginner Gun Mastery"}, nil, 8, -1, -1, 1)
			ZShelter.AddItem("Shotgun", "tfa_cso_m1887", "M1887", 16, 20, 4, true, {"Beginner Gun Mastery"}, nil, 10, -1, -1, 1)
			ZShelter.AddItem("Shotgun", "tfa_cso_spas12", "SPAS 12", 20, 22, 5, true, {"Beginner Gun Mastery"}, nil, 10, -1, -1, 1)

			ZShelter.AddItem("Shotgun", "tfa_cso_dbarrel", "Double Barrel", 15, 18, 2.5, true, {"Beginner Gun Mastery"}, nil, 12, -1, -1, 2)
			ZShelter.AddItem("Shotgun", "tfa_cso_xm1014", "XM1014", 25, 24, 4, true, {"Beginner Gun Mastery"}, nil, 6, -1, -1, 2)
			ZShelter.AddItem("Shotgun", "tfa_cso_uts15", "UTS15", 28, 28, 3, true, {"Beginner Gun Mastery"}, nil, 6, -1, -1, 2)
			ZShelter.AddItem("Shotgun", "tfa_cso_usas12", "USAS-12", 33, 30, 3.35, true, {"Beginner Gun Mastery"}, nil, 5, -1, -1, 2)
			ZShelter.AddItem("Shotgun", "tfa_zsh_cso_qbarrel", "Quad Barrel", 36, 37, 2, true, {"Beginner Gun Mastery"}, nil, 10, -1, -1, 2)

			ZShelter.AddItem("Shotgun", "tfa_cso_mk3a1", "MK3A1", 37, 29, 2, true, {"Beginner Gun Mastery"}, nil, 5, -1, -1, 3)
			ZShelter.AddItem("Shotgun", "tfa_cso_skull11", "SKULL 11", 40, 40, 2, true, {"Beginner Gun Mastery"}, nil, 6, -1, -1, 3)
			ZShelter.AddItem("Shotgun", "tfa_cso_volcano", "Volcano", 54, 60, 1.8, true, {"Beginner Gun Mastery"}, nil, 4, -1, -1, 3)
			ZShelter.AddItem("Shotgun", "tfa_zsh_cso_balrog11", "Balrog 11", 55, 68, 3, true, {"Beginner Gun Mastery"}, nil, 6, -1, -1, 3)

			ZShelter.AddItem("Rifle", "tfa_cso_famas", "FAMAS", 14, 12, 2, true, {"Beginner Gun Mastery,Intermediate Gun Mastery"}, nil, 1.75, -1, -1, 1)
			ZShelter.AddItem("Rifle", "tfa_cso_ak47", "AK-47", 18, 21, 2, true, {"Beginner Gun Mastery,Intermediate Gun Mastery"}, nil, 1.75, -1, -1, 1)
			ZShelter.AddItem("Rifle", "tfa_cso_scarh", "Scar-H", 20, 23, 2.25, true, {"Beginner Gun Mastery,Intermediate Gun Mastery"}, nil, 1.75, -1, -1, 1)
			ZShelter.AddItem("Rifle", "tfa_cso_aug", "Steyr AUG", 22, 22, 2.25, true, {"Beginner Gun Mastery,Intermediate Gun Mastery"}, nil, 1.75, -1, -1, 1)
			ZShelter.AddItem("Rifle", "tfa_cso_sg552", "SG552", 25, 29, 2.35, true, {"Beginner Gun Mastery,Intermediate Gun Mastery"}, nil, 1.75, -1, -1, 1)
			ZShelter.AddItem("Rifle", "tfa_cso_xm8", "XM8", 25, 30, 2.5, true, {"Beginner Gun Mastery,Intermediate Gun Mastery"}, nil, 1.75, -1, -1, 1)

			ZShelter.AddItem("Rifle", "tfa_cso_m14ebr", "M14 EBR", 25, 22, 2.5, true, {"Beginner Gun Mastery,Intermediate Gun Mastery"}, nil, 2, -1, -1, 2)
			ZShelter.AddItem("Rifle", "tfa_cso_balrog5", "Balrog 5", 28, 30, 1.65, true, {"Beginner Gun Mastery,Intermediate Gun Mastery"}, nil, 1.75, -1, -1, 2)
			ZShelter.AddItem("Rifle", "tfa_cso_ethereal", "Ethereal", 30, 32, 2.15, true, {"Beginner Gun Mastery,Intermediate Gun Mastery"}, nil, 1.75, -1, -1, 2)

			ZShelter.AddItem("Rifle", "tfa_cso_skull4", "SKULL 4", 38, 42, 2, true, {"Beginner Gun Mastery,Intermediate Gun Mastery"}, nil, 2.25, -1, -1, 3)
			ZShelter.AddItem("Rifle", "tfa_cso_tornadoa", "Tornado", 45, 49, 1.25, true, {"Beginner Gun Mastery,Intermediate Gun Mastery"}, nil, 1.5, -1, -1, 3)
			ZShelter.AddItem("Rifle", "tfa_cso_plasmagun", "Plasma Gun", 45, 49, 1.75, true, {"Beginner Gun Mastery,Intermediate Gun Mastery"}, nil, 1.5, -1, -1, 3)

			ZShelter.AddItem("Rifle", "tfa_cso_guardian", "AUG Guardian", 75, 69, 0.85, true, {"Beginner Gun Mastery,Intermediate Gun Mastery"}, nil, 1.75, -1, -1, 4)
			ZShelter.AddItem("Rifle", "tfa_zsh_cso_lycanthrope", "SG552 Lycanthrope", 88, 75, 1, true, {"Beginner Gun Mastery,Intermediate Gun Mastery"}, nil, 1.75, -1, -1, 4)
			ZShelter.AddItem("Rifle", "tfa_zsh_cso_darkknight", "M4A1 Dark Knight", 105, 129, 0.85, true, {"Beginner Gun Mastery,Intermediate Gun Mastery"}, nil, 1.75, -1, -1, 4)
			ZShelter.AddItem("Rifle", "tfa_zsh_cso_paladin", "AK-47 Paladin", 155, 159, 0.85, true, {"Beginner Gun Mastery,Intermediate Gun Mastery"}, nil, 1.75, -1, -1, 4)
			ZShelter.AddItem("Rifle", "tfa_zsh_cso_cerberus", "SG552 Cerberus", 180, 190, 1, true, {"Beginner Gun Mastery,Intermediate Gun Mastery"}, nil, 1.75, -1, -1, 4)

			ZShelter.AddItem("Sniper Rifle", "tfa_cso_scout", "Scout", 18, 12, 6, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery"}, nil, 5, -1, -1, 1)
			ZShelter.AddItem("Sniper Rifle", "tfa_cso_m24", "M24", 24, 29, 5, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery"}, nil, 9, -1, -1, 1)
			ZShelter.AddItem("Sniper Rifle", "tfa_cso_xm2010", "XM2010", 32, 35, 6, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery"}, nil, 14, -1, -1, 1)

			ZShelter.AddItem("Sniper Rifle", "tfa_cso_m95", "M95", 35, 33, 2, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery"}, nil, 14, -1, -1, 2)
			ZShelter.AddItem("Sniper Rifle", "tfa_cso_awp", "AWP", 39, 42, 7.25, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery"}, nil, 14, -1, -1, 2)
			ZShelter.AddItem("Sniper Rifle", "tfa_cso_vsk94", "VSK94", 40, 40, 4, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery"}, nil, 1.15, -1, -1, 2)

			ZShelter.AddItem("Sniper Rifle", "tfa_cso_sl8", "SL8", 32, 30, 1.85, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery"}, nil, 3.5, -1, -1, 3)
			ZShelter.AddItem("Sniper Rifle", "tfa_cso_sg550", "SG550", 40, 44, 2.35, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery"}, nil, 3.5, -1, -1, 3)
			ZShelter.AddItem("Sniper Rifle", "tfa_cso_wa2000", "WA2000", 50, 52, 2.85, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery"}, nil, 6, -1, -1, 3)
			ZShelter.AddItem("Sniper Rifle", "tfa_cso_skull5", "SKULL 5", 55, 60, 2.5, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery"}, nil, 3.5, -1, -1, 3)
			ZShelter.AddItem("Sniper Rifle", "tfa_cso_bendita", "Bendita", 60, 54, 1.15, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery"}, nil, 6, -1, -1, 3)

			ZShelter.AddItem("Sniper Rifle", "tfa_cso_destroyer", "Destroyer", 89, 82, 0.7, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery"}, nil, 20, -1, -1, 4)
			ZShelter.AddItem("Sniper Rifle", "tfa_cso_thunderbolt", "Thunderbolt", 102, 98, 2, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery"}, nil, 30, -1, -1, 4)

			ZShelter.AddItem("Heavy", "tfa_cso_mg42", "MG42", 18, 20, 1.25, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery", "Advanced Gun Mastery"}, nil, 2, -1, -1, 1)
			ZShelter.AddItem("Heavy", "tfa_cso_mk48", "MK48", 22, 26, 1.35, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery", "Advanced Gun Mastery"}, nil, 2, -1, -1, 1)
			ZShelter.AddItem("Heavy", "tfa_cso_m249", "M249", 26, 29, 2, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery", "Advanced Gun Mastery"}, nil, 2, -1, -1, 1)
			ZShelter.AddItem("Heavy", "tfa_cso_hk23", "HK23", 31, 35, 2.15, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery", "Advanced Gun Mastery"}, nil, 2, -1, -1, 1)
			ZShelter.AddItem("Heavy", "tfa_cso_m60", "M60", 36, 42, 2.5, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery", "Advanced Gun Mastery"}, nil, 2, -1, -1, 1)

			ZShelter.AddItem("Heavy", "tfa_cso_m249ex", "SKULL 7", 40, 42, 1.65, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery", "Advanced Gun Mastery"}, nil, 2, -1, -1, 2)
			ZShelter.AddItem("Heavy", "tfa_cso_mg36_xmas", "MG36 XMAS", 45, 42, 1.5, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery", "Advanced Gun Mastery"}, nil, 0.75, -1, -1, 2)
			ZShelter.AddItem("Heavy", "tfa_cso_k3", "K3", 52, 50, 2.75, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery", "Advanced Gun Mastery"}, nil, 2, -1, -1, 2)
			ZShelter.AddItem("Heavy", "tfa_cso_avalanche", "Avalanche", 62, 63, 1.15, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery", "Advanced Gun Mastery"}, nil, 2, -1, -1, 2)

			ZShelter.AddItem("Heavy", "tfa_cso_mg3", "MG3", 79, 72, 1.75, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery", "Advanced Gun Mastery"}, nil, 2, -1, -1, 3)
			ZShelter.AddItem("Heavy", "tfa_zsh_cso_m134", "M134 Minigun", 79, 72, 1.5, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery", "Advanced Gun Mastery"}, nil, 2, -1, -1, 3)
			ZShelter.AddItem("Heavy", "tfa_zsh_cso_thanatos7", "Thanatos 7", 102, 90, 1, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery", "Advanced Gun Mastery"}, nil, 2, -1, -1, 3)

			ZShelter.AddItem("Heavy", "tfa_cso_balrog7", "Balrog 7", 133, 122, 1.75, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery", "Advanced Gun Mastery"}, nil, 2, -1, -1, 4)
			ZShelter.AddItem("Heavy", "tfa_cso_broad", "Broad Divine", 145, 140, 1.75, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery", "Advanced Gun Mastery"}, nil, 2, -1, -1, 4)
			ZShelter.AddItem("Heavy", "tfa_zsh_cso_m249phoenix", "M249 Phoenix", 180, 190, 1.25, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery", "Advanced Gun Mastery"}, nil, 2, -1, -1, 4)

			ZShelter.AddItem("Explosive", "tfa_cso_m79", "M79", 30, 35, 1, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery", "Advanced Gun Mastery"}, nil, 15, -1, -1, 1)
			ZShelter.AddItem("Explosive", "tfa_cso_rpg7", "RPG-7", 80, 75, 0.65, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery", "Advanced Gun Mastery"}, nil, 20, 5, 8, 3)
			ZShelter.AddItem("Explosive", "tfa_cso_at4ex", "AT4", 103, 84, 0.7, true, {"Beginner Gun Mastery", "Intermediate Gun Mastery", "Advanced Gun Mastery"}, nil, 25, 5, 8, 4)

			ZShelter.AddItem("Miscellaneous", "tfa_zsh_cso_tritacknife", "Throwing Knife", 25, 25, 1, false, {"Silence"}, nil, 0.0, -1, -1, 1)
			ZShelter.AddItem("Miscellaneous", "tfa_zsh_cso_rockbreaker", "Construction Drill", 30, 33, 1, false, {"Transporting Drone", "Defense Matrix"}, nil, 0.0, -1, -1, 1)
			ZShelter.AddItem("Miscellaneous", "tfa_zsh_cso_bow", "Compound Bow", 20, 20, 1, false, {}, nil, 0.0, -1, -1, 1)
			ZShelter.AddItem("Miscellaneous", "tfa_zsh_cso_bow_v6", "Compound Bow EX", 35, 35, 1, false, {"Beginner Gun Mastery"}, nil, 0.0, -1, -1, 1)

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
