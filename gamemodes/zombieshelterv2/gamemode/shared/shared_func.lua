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

function ZShelter.IsRequirementMeet(player, building)
	if(!building) then return false, false end
	local woods = player:GetNWInt("Woods", 0)
	local irons = player:GetNWInt("Irons", 0)
	local power = GetGlobalInt("Powers", 0)

	local req_woods = math.floor(math.max(building.woods * player:GetNWFloat("ResCost", 1), 1))
	local req_irons = math.floor(math.max(building.irons * player:GetNWFloat("ResCost", 1), 1))
	local req_powers = math.floor(math.max(building.powers * player:GetNWFloat("PowerCost", 1), 0))
	if(building.tdata && building.tdata.maxamount) then
		if(GetGlobalInt("Build_"..building.title, 0) >= building.tdata.maxamount) then return end
	end
	if(GetConVar("zshelter_debug_disable_build_checks"):GetInt() == 1) then return true, false end
	if(req_powers > power && building.powers > 0) then return false, false end
	if(building.shelterlvl > GetGlobalInt("ShelterLevel", 0)) then return false, false end

	if(building.specialreq) then
		for k,v in pairs(building.specialreq) do
			if(player:GetNWInt("SK_"..v, 0) <= 0) then return false, false end
		end
	end

	if(building.finddata) then
		if(building.finddata.find) then
			if(!GetGlobalBool("BP_"..building.title, false)) then return false, false end
		end
	end

	local useStorage = building.category == "Public Construction"
	if(player.Callbacks && player.Callbacks.ShouldUseStorage) then
		for k,v in pairs(player.Callbacks.ShouldUseStorage) do
			if(v(player, building)) then
				useStorage = true
			end
		end
	end

	local meet = true

	if(!useStorage) then
		if(woods < req_woods || irons < req_irons) then
			meet = false
		end
	else
		if(GetGlobalInt("Woods", 0) < req_woods || GetGlobalInt("Irons", 0) < req_irons) then
			meet = false
		end
	end

	return meet, useStorage
end

function ZShelter.CanUpgradeTurret(ply, woods, irons)
	return (ply:GetNWInt("Woods", 0) >= woods && ply:GetNWInt("Irons", 0) >= irons)
end

function ZShelter.CanUpgradeShelter(level, wood, iron, power, requiredbuilds)
	local shelter = GetGlobalEntity("ShelterEntity")
	if(GetConVar("zshelter_debug_disable_upgrade_checks"):GetInt() == 1) then return true end
	if(!IsValid(shelter)) then return false end
	if(level - GetGlobalInt("ShelterLevel") > 1) then return false end
	if(wood > GetGlobalInt("Woods") || iron > GetGlobalInt("Irons") || power > GetGlobalInt("Powers")) then return false end
	for k,v in pairs(requiredbuilds) do
		if(GetGlobalInt("Build_"..k, 0) <= 0) then return false end
	end
	return true
end

function ZShelter.AllowedToUpgrade(player, class, tier, index)
	if(!ZShelter.SkillList[class] || !ZShelter.SkillList[class][tier] || !ZShelter.SkillList[class][tier][index]) then error("Skill data is invalid!", 1) return false end
	local skill = ZShelter.SkillList[class][tier][index]
	if(player:GetNWInt("SK_"..skill.title, 0) >= skill.maximum) then return false end
	if(GetConVar("zshelter_debug_disable_skill_checks"):GetInt() == 1) then return true end
	if(player:GetNWInt("SkillPoints", 0) <= 0) then return false end
	if(tier == 4) then
		if(player:GetNWInt("Tier4Spent", 0) > 0) then return false end
	end
	if(tier > 1) then
		if(player:GetNWInt(class.."SkillSpent", 0) < math.floor((2 + (tier * 0.25)) * (tier - 1))) then
			return false
		end
	end
	--[[
		title = title,
		callbackhook = callbackhook,
		callback = callback,
		callback_onselect = callback_onselect,
		maximum = maximum,
		tier = tier,
		icon = icon,
		blacklist = blacklisted,
	]]

	if(skill.blacklist) then
		for k,v in next, skill.blacklist do
			if(player:GetNWInt("SK_"..v, 0) > 0) then
				return false
			end
		end
	end

	return true
end

function ZShelter.CanCraftWeapon(player, data)
	if(GetConVar("zshelter_debug_disable_craft_checks"):GetInt() == 1) then return true end
	--[[
		title = title,
		class = class,
		icon = icon,
		woods = woods,
		irons = irons,
		requiredskills = requiredskills,
	]]
	local woods = GetGlobalInt("Woods", 0)
	local irons = GetGlobalInt("Irons", 0)
	if(woods < data.woods || irons < data.irons) then return end
	if(data.requiredskills) then
		for k,v in pairs(data.requiredskills) do
			if(player:GetNWInt("SK_"..v, 0) <= 0) then return false end
		end
	end
	return true
end

function ZShelter.CompressTable(tab)
	local data = util.Compress(util.TableToJSON(tab))
	local len = string.len(data)
	return data, len
end