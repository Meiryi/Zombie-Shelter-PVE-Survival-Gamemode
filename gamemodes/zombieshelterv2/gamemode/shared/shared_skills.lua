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

ZShelter.SkillList = {}
ZShelter.SkillDescs = {}
ZShelter.SkillDatas = {}

--[[
	Available callbacks:

		ClientSide :
			OnHUDPaint()

		ServerSide :
			OnDayPassed(player)
			OnSecondPassed(player)
			OnGiveMelee(player)
			OnDealingDamage(attacker, victim, dmginfo)
			OnTakingDamage(attacker, victim, dmginfo)
			OnGatheringResources(player, resource, type, amount, full, nocallback)
			OnEnemyKilled(player, victim, killedbyturrets)
			OnRepairBuildings(player, building, buildspeed)
			OnBuildingPlaced(player, building)
			OnBuildingTakeDamage(player, building, attacker, damage)
			OnBuildingDestroyed(player, building, wood, iron, power)
			OnSkillCalled(player) -- Only available for tier 4 skill
			OnFireBullets(player, bulletdata)
			OnTrapDetonate(player, trapent) -- Return true to prevent trap being removed due to detonation
			OnBuildingDealDamage(building, dmginfo, target)
			OnRepairingTraps(player, trapent, repair) -- repair will be true if this hit repairs the trap
			OnTurretsChanged()

		Shared :
			ShouldUseStorage(player, buildingdata) -- Note : return true will bypass resource checks (Excluding skill, shelter level checks)
			OnMeleeDamage(attacker, victim, dmginfo, melee2) -- Won't be called on buildings
			CreateMove(cmd) -- It explains itself
]]

function ZShelter.AddSkills(category, callbackhook, callback, callback_onselect, maximum, icon, tier, title, blacklisted, cooldown)
	if(!ZShelter.SkillList[category]) then
		ZShelter.SkillList[category] = {}
	end
	if(!ZShelter.SkillList[category][tier]) then
		ZShelter.SkillList[category][tier] = {}
	end
	if(!blacklisted) then blacklisted = {} end
	if(!cooldown) then
		cooldown = 60
	end
	if(icon == "") then icon = "zsh/icon/questionmark.png" end

	table.insert(ZShelter.SkillList[category][tier], {
		title = title,
		callbackhook = callbackhook,
		callback = callback,
		callback_onselect = callback_onselect,
		maximum = maximum,
		tier = tier,
		icon = icon,
		blacklist = blacklisted,
		cooldown = cooldown,
	})
	local material = "zsh/skills/"..icon..".png"
	if(icon == "zsh/icon/questionmark.png") then
		material = "zsh/icon/questionmark.png"
	end
	ZShelter.SkillDatas[title] = {
		title = title,
		icon = Material(material),
		iconpath = material,
		callbackhook = callbackhook,
		callback = callback,
		callback_onselect = callback_onselect,
		cooldown = cooldown,
	}
end

function ZShelter.AddInfo(title, info)
	ZShelter.SkillDescs[title] = info
end

function ZShelter.PickInfo(title)
	local _title, _info = title, "No info"
	local language = GetConVar("gmod_language"):GetString()
	if(ZShelter.SkillDescs[_title]) then
		local info = ZShelter.SkillDescs[_title]
		if(info.title[language]) then
			_title = info.title[language]
		else
			if(info.title["en"]) then
				_title = info.title["en"]
			end
		end
		if(info.desc[language]) then
			_info = info.desc[language]
		else
			if(info.desc["en"]) then
				_info= info.desc["en"]
			end
		end
	end

	return _title, _info
end

function ZShelter.LoadSkillsDesc()
	local fn = file.Find(ZShelter.BasePath.."skill_info/*", "LUA")
	for k,v in pairs(fn) do
		if(SERVER) then
			AddCSLuaFile(ZShelter.BasePath.."skill_info/"..v)
		end
		include(ZShelter.BasePath.."skill_info/"..v)
	end
end

function ZShelter.LoadSkills()
	local fn = file.Find(ZShelter.BasePath.."skills/*", "LUA")

	for k,v in pairs(fn) do
		if(SERVER) then
			AddCSLuaFile(ZShelter.BasePath.."skills/"..v)
		end
		include(ZShelter.BasePath.."skills/"..v)
	end
end

ZShelter.LoadSkills()
ZShelter.LoadSkillsDesc()

concommand.Add("zshelter_debug_reload_skills", function(ply, cmd, args)
	ZShelter.SkillList = {}
	ZShelter.SkillDescs = {}
	ZShelter.LoadSkills()
	ZShelter.LoadSkillsDesc()
end)

concommand.Add("zshelter_debug_reset_skills", function(ply, cmd, args)
	if(!ply:IsAdmin()) then return end
	ZShelter.RS()
end)
