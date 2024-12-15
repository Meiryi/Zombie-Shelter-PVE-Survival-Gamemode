ZShelter.Modifiers = ZShelter.Modifiers || {}
ZShelter.Modifiers.List = {}
ZShelter.Modifiers.Actived = ZShelter.Modifiers.Actived || {}
ZShelter.Modifiers.VoteList = {}
ZShelter.Modifiers.Hooks = ZShelter.Modifiers.Hooks || {} -- Do not reset it, otherwise will lose track of hooks
ZShelter.Modifiers.HasEasyMode = false

if(SERVER) then
	util.AddNetworkString("ZShelter_SyncVoteModifiers")
	util.AddNetworkString("ZShelter_SendVoteModifiers")

	function ZShelter.Modifiers.ApplyModifiers()
		ZShelter.Modifiers.ClearHooks()
		ZShelter.Modifiers.Actived = {}
		for modifierName, modifier in pairs(ZShelter.Modifiers.List) do
			SetGlobalBool("MDF_Enabled_"..modifier.title, false)
			local votes = ZShelter.Modifiers.VoteList[modifierName]
			if(!votes) then continue end
			local count = 0
			for _, vote in pairs(votes) do
				if(!vote) then continue end
				count = count + 1
			end
			if(count <= 0 || count < math.Round(player.GetCount() * 0.5)) then continue end
			if(modifier.category == "Decrease_Diff_Mods2") then
				ZShelter.Modifiers.HasEasyMode = true
			end
			ZShelter.Modifiers.ApplyModifier(modifierName)
		end
	end

	net.Receive("ZShelter_SendVoteModifiers", function(len, ply)
		if(GetGlobalBool("GameStarted")) then return end
		local str = net.ReadString()
		local voted = ply:GetNWBool(str.."Voted", false)
		if(GetGlobalInt("Day") > 1) then return end
		if(voted) then
			ply:SetNWBool(str.."Voted", false)
		else
			ply:SetNWBool(str.."Voted", true)
		end
		if(!ZShelter.Modifiers.VoteList[str]) then
			ZShelter.Modifiers.VoteList[str] = {}
		end
		ZShelter.Modifiers.VoteList[str][ply:EntIndex()] = ply:GetNWBool(str.."Voted", false)
		local data, len = ZShelter.CompressTable(ZShelter.Modifiers.VoteList)
		net.Start("ZShelter_SyncVoteModifiers")
		net.WriteUInt(len, 32)
		net.WriteData(data, len)
		net.Broadcast()
	end)
else

	net.Receive("ZShelter_SyncVoteModifiers", function()
		local len = net.ReadUInt(32)
		local data = net.ReadData(len)
		local tab = ZShelter.DecompressTable(data)
		if(!tab) then return end
		ZShelter.Modifiers.VoteList = tab
		ZShelter.RefreshModifierVote()
	end)
end

function ZShelter.Modifiers.ClearHooks()
	for hookname,hooks in pairs(ZShelter.Modifiers.Hooks) do
		for funcname, _ in pairs(hooks) do
			hook.Remove(hookname, funcname)
		end
	end
	ZShelter.Modifiers.Hooks = {}
end

function ZShelter.Modifiers.ApplyModifier(name)
	local modifier = ZShelter.Modifiers.List[name]
	if(!modifier) then return end
	local hooks = modifier.hooks
	for hookname, hookfunc in pairs(hooks) do
		local funcname = hookname.."_"..name
		if(!ZShelter.Modifiers.Hooks[hookname]) then
			ZShelter.Modifiers.Hooks[hookname] = {}
		end
		ZShelter.Modifiers.Hooks[hookname][funcname] = true
		hook.Add(hookname, funcname, hookfunc)
	end
	ZShelter.Modifiers.Actived[name] = modifier.scoreMul
	SetGlobalBool("MDF_Enabled_"..name, true)
end

--[[
	ZShelterPostPlayerInitVariables : Called after player variables are initialized
	ZShelterGameStarted : Called after the game has started
]]

--[[
	data :
	{
		category = "",
		desc = "",
		scoreMul = 1,
		hooks = {
	
		},
	}
]]

--[[
	Global Variables
	<Float> ResourceMul = Amount of resources to spawn, 0.5 = 50%, 1.5 = 150%
	<Float> EnemySpawnMul = Amount of enemies to spawn, 0.5 = 50%, 1.5 = 150%
	<Float> EnemySpawnTimeMul = Time between enemy spawn, 0.5 = 50%, 1.5 = 150%
	<Float> TimeMul = Time for day/night, 0.5 = 50%, 1.5 = 150%
	<Int> EnemySpawnForwardDay = How many days to spawn forward, 1 = 1 day
	<Int> SkillBoxAmount = Amount of skill box to spawn
	<Bool> ShieldMutationEnabled
	<Bool> RangedMutationEnabled
]]

function ZShelter.Modifiers.GetModifierScoreMul()
	local lists = {}
	for k,v in pairs(ZShelter.Modifiers.List) do
		table.insert(lists, {name = k, scoreMul = v.scoreMul})
	end
	table.sort(lists, function(a, b) return a.scoreMul > b.scoreMul end)

	local mul = 1
	for k,v in pairs(lists) do
		if(!GetGlobalBool("MDF_Enabled_"..v.name, false)) then continue end
		if(v.scoreMul > 1) then
			mul = mul + (v.scoreMul - 1)
		else
			mul = mul * v.scoreMul
		end
	end
	return mul
end

function ZShelter.Modifiers.Register(name, data)
	data.title = name
	ZShelter.Modifiers.List[name] = data
end

ZShelter.Modifiers.Register("ModN_PlayerDmgUp", {
	category = "Decrease_Diff_Mods2",
	categoryColor = Color(55, 255, 55, 255),
	desc = "ModD_PlayerDmgUp",
	scoreMul = 0.75,

	hooks = {
		ZShelterGameStarted = function()
			for k,v in ipairs(player.GetAll()) do
				ZShelter.ApplyDamageMul(v, "ModifierBuff", 1.5, 32767, true)
			end
		end,

		PlayerSpawn = function(ply)
			ZShelter.ApplyDamageMul(ply, "ModifierBuff", 1.5, 32767, true)
		end,
	},
})

ZShelter.Modifiers.Register("ModN_ExtraSkillpoint", {
	category = "Decrease_Diff_Mods2",
	categoryColor = Color(55, 255, 55, 255),
	desc = "ModD_ExtraSkillpoint",
	scoreMul = 0.75,

	hooks = {
		ZShelterGameStarted = function()
			for k,v in ipairs(player.GetAll()) do
				v:SetNWInt("SkillPoints", v:GetNWInt("SkillPoints", 0) + 1)
			end
		end,
	},
})

ZShelter.Modifiers.Register("ModN_2xSkillpoints", {
	category = "Decrease_Diff_Mods2",
	categoryColor = Color(55, 255, 55, 255),
	desc = "ModD_2xSkillpoints",
	scoreMul = 0.2,

	hooks = {
		["ZShelter-DaySwitch"] = function()
			for k,v in ipairs(player.GetAll()) do
				v:SetNWInt("SkillPoints", v:GetNWInt("SkillPoints", 0) + 1)
			end
		end
	},
})

ZShelter.Modifiers.Register("ModN_ZombieAtkDmgDown", {
	category = "Decrease_Diff_Mods2",
	categoryColor = Color(55, 255, 55, 255),
	desc = "ModD_ZombieAtkDmgDown",
	scoreMul = 0.8,

	hooks = {
		OnEntityCreated = function(ent)
			timer.Simple(0, function()
				if(!IsValid(ent) || ent:IsPlayer() || ent.IsBuilding) then return end
				ZShelter.ApplyDamageMul(ent, "ModifierDebuff_Enemy", 0.6, 32767, true)
			end)
		end,
	},
})

ZShelter.Modifiers.Register("ModN_ResourceSpawnUp", {
	category = "Decrease_Diff_Mods2",
	categoryColor = Color(55, 255, 55, 255),
	desc = "ModD_ResourceSpawnUp",
	scoreMul = 0.7,

	hooks = {
		ZShelterGameStarted = function()
			SetGlobalFloat("ResourceMul", GetGlobalFloat("ResourceMul", 1) * 1.75)
		end,
	},
})

--[[
	----------------------------------------------------------------------------------------
]]

ZShelter.Modifiers.Register("ModN_RangedAtk", {
	category = "Increase_Diff_Mods1",
	categoryColor = Color(255, 55, 55, 255),
	desc = "ModD_RangedAtk",
	scoreMul = 1.2,

	hooks = {
		ZShelterGameStarted = function()
			SetGlobalBool("RangedMutationEnabled", true)
		end,
	},
})

ZShelter.Modifiers.Register("ModN_Shield", {
	category = "Increase_Diff_Mods1",
	categoryColor = Color(255, 55, 55, 255),
	desc = "ModD_Shield",
	scoreMul = 1.2,

	hooks = {
		ZShelterGameStarted = function()
			SetGlobalBool("ShieldMutationEnabled", true)
		end,
	},
})

ZShelter.Modifiers.Register("ModN_NoSkillBox", {
	category = "Increase_Diff_Mods1",
	categoryColor = Color(255, 55, 55, 255),
	desc = "ModD_NoSkillBox",
	scoreMul = 1.4,

	hooks = {
		ZShelterGameStarted = function()
			SetGlobalInt("SkillBoxAmount", 0)
		end,
	},
})

ZShelter.Modifiers.Register("ModN_AmountZombieUp", {
	category = "Increase_Diff_Mods1",
	categoryColor = Color(255, 55, 55, 255),
	desc = "ModD_AmountZombieUp",
	scoreMul = 1.5,

	hooks = {
		ZShelterGameStarted = function()
			SetGlobalFloat("EnemySpawnMul", GetGlobalFloat("EnemySpawnMul", 1) * 2)
		end,
	},
})

ZShelter.Modifiers.Register("ModN_ZombieSpawnUp", {
	category = "Increase_Diff_Mods1",
	categoryColor = Color(255, 55, 55, 255),
	desc = "ModD_ZombieSpawnUp",
	scoreMul = 1.5,

	hooks = {
		ZShelterGameStarted = function()
			SetGlobalFloat("EnemySpawnTimeMul", GetGlobalFloat("EnemySpawnTimeMul", 1) * 0.5)
		end,
	},
})

local DayCount = 0
ZShelter.Modifiers.Register("ModN_LessSkillpoints", {
	category = "Increase_Diff_Mods1",
	categoryColor = Color(255, 55, 55, 255),
	desc = "ModD_LessSkillpoints",
	scoreMul = 1.4,

	hooks = {
		["ZShelter-DaySwitch"] = function()
			for k,v in ipairs(player.GetAll()) do
				v:SetNWInt("SkillPoints", v:GetNWInt("SkillPoints", 0) - 1)
				if(DayCount > 0) then
					v:SetNWInt("SkillPoints", v:GetNWInt("SkillPoints", 0) + 1)
				end
			end
			if(DayCount > 0) then
				DayCount = 0
			else
				DayCount = DayCount + 1
			end
		end
	},
})

ZShelter.Modifiers.Register("ModN_LessResourcesSpawn", {
	category = "Increase_Diff_Mods1",
	categoryColor = Color(255, 55, 55, 255),
	desc = "ModD_LessResourcesSpawn",
	scoreMul = 1.1,

	hooks = {
		ZShelterGameStarted = function()
			SetGlobalFloat("ResourceMul", GetGlobalFloat("ResourceMul", 1) * 0.4)
		end,
	},
})

ZShelter.Modifiers.Register("ModN_LessResourcesSpawn", {
	category = "Increase_Diff_Mods1",
	categoryColor = Color(255, 55, 55, 255),
	desc = "ModD_LessResourcesSpawn",
	scoreMul = 1.125,

	hooks = {
		ZShelterGameStarted = function()
			SetGlobalFloat("ResourceMul", GetGlobalFloat("ResourceMul", 1) * 0.4)
		end,
	},
})

ZShelter.Modifiers.Register("ModN_LessPlayerDmg", {
	category = "Increase_Diff_Mods1",
	categoryColor = Color(255, 55, 55, 255),
	desc = "ModD_LessPlayerDmg",
	scoreMul = 1.1,

	hooks = {
		ZShelterGameStarted = function()
			for k,v in ipairs(player.GetAll()) do
				v:SetNWInt("SkillPoints", 0)
				ZShelter.ApplyDamageMul(v, "Hardcore_Debuff_1x", 0.75, 32767, true)
			end
		end,

		PlayerSpawn = function(ply)
			ZShelter.ApplyDamageMul(ply, "Hardcore_Debuff_1x", 0.75, 32767, true)
		end,
	},
})

ZShelter.Modifiers.Register("ModN_LessTime", {
	category = "Increase_Diff_Mods1",
	categoryColor = Color(255, 55, 55, 255),
	desc = "ModD_LessTime",
	scoreMul = 1.2,

	hooks = {
		ZShelterGameStarted = function()
			SetGlobalFloat("TimeMul", 0.75)
		end,
	},
})

ZShelter.Modifiers.Register("ModN_EnemyAtkDmgUp", {
	category = "Increase_Diff_Mods1",
	categoryColor = Color(255, 55, 55, 255),
	desc = "ModD_EnemyAtkDmgUp",
	scoreMul = 1.35,

	hooks = {
		OnEntityCreated = function(ent)
			timer.Simple(0, function()
				if(!IsValid(ent) || ent:IsPlayer() || ent.IsBuilding) then return end
				ZShelter.ApplyDamageMul(ent, "ModifierBuff_Enemy", 1.5, 32767, true)
			end)
		end,
	},
})

--[[
ZShelter.Modifiers.Register("ModN_OnePunchmanZombie", {
	category = "Increase_Diff_Mods1",
	categoryColor = Color(255, 55, 55, 255),
	desc = "ModD_OnePunchmanZombie",
	scoreMul = 1.1,

	hooks = {
		OnEntityCreated = function(ent)
			timer.Simple(0, function()
				if(!IsValid(ent) || ent:IsPlayer() || ent.IsBuilding) then return end
				ZShelter.ApplyDamageMul(ent, "ModifierBuff_Enemy", 10, 32767, true)
			end)
		end,
	},
})
]]

ZShelter.Modifiers.Register("ModN_RunnersDay", {
	category = "Increase_Diff_Mods1",
	categoryColor = Color(255, 55, 55, 255),
	desc = "ModD_RunnersDay",
	scoreMul = 1.25,

	hooks = {
		OnEntityCreated = function(ent)
			timer.Simple(0, function()
				if(!IsValid(ent) || ent:IsPlayer() || ent.IsBuilding) then return end
				ent.AnimTbl_Walk = {ACT_RUN}
				ent.AnimTbl_Run = {ACT_RUN}
			end)
		end,
	},
})

ZShelter.Modifiers.Register("ModN_Hardcore", {
	category = "Increase_Diff_Mods1",
	categoryColor = Color(255, 55, 55, 255),
	desc = "ModD_Hardcore",
	scoreMul = 5,

	hooks = {
		ZShelter_GetRespawnTime = function()
			return GetGlobalInt("Time")
		end,
		ZShelter_PreTriggerHorde = function()
			local classes = {"npc_vj_zshelter_boss_fallen_titan", "npc_vj_zshelter_boss_prototype_phobos_siege", "npc_vj_zshelter_boss_ampsuit"}
			for i = 1, 3 do
				local pos = ZShelter.ValidRaiderSpawnPoints[math.random(1, #ZShelter.ValidRaiderSpawnPoints)]
				if(!pos) then return true end
				local boss = ents.Create(classes[math.random(1, #classes)])
					boss.damage = 80
					boss:Spawn()
					boss:SetPos(pos)
					boss:SetMaxHealth(40000)
					boss:SetHealth(40000)
					boss:SetRenderMode(RENDERMODE_TRANSCOLOR)
					boss:SetColor(Color(255, 0, 0, 255))

					boss:SetNWBool("IsZShelterEnemy", true)
					boss:SetNWBool("ZShelterDisplayHP", true)
					boss.IsBoss = true
					boss.IsZShelterEnemy = true

					boss:SetCollisionGroup(COLLISION_GROUP_NPC_SCRIPTED)
					boss.ImmunityNightDamage = true
			end
			return true
		end,
		ZShelterGameStarted = function()
			GetConVar("zshelter_difficulty"):SetInt(9)
			ZShelter.StartedDifficulty = GetConVar("zshelter_difficulty"):GetInt()
			SetGlobalInt("Time", 480)
			SetGlobalFloat("EnemySpawnTimeMul", GetGlobalFloat("EnemySpawnTimeMul", 1) * 0.85)

			for _, ply in ipairs(player.GetAll()) do
				ply:SetNWInt("SkillPoints", ply:GetNWInt("SkillPoints") + 1)
			end

			ZShelter.EnemyConfig = {}

			local CurMinDifficulty, CurMaxDifficulty = 9, 9
			-- day, night_or_day, isboss, noclear, class, mutation, chance, attack, hp, end_day, maxamount, hp_boost_day, color, max_exists, min_difficulty, max_difficulty
			ZShelter.AddEnemy(1, false, true, true, "npc_vj_zshelter_heavy_boss", "none", 100, 45, 20000, -1, -1, 200, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(4, false, true, true, "npc_vj_zshelter_boss_prototype_phobos_siege", "none", 100, 85, 30000, -1, -1, 200, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(8, false, true, true, "npc_vj_zshelter_boss_ampsuit", "none", 100, 65, 40000, -1, -1, 200, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)

			ZShelter.AddEnemy(1, false, false, false, "npc_vj_zshelter_common_h", "none", 100, 12, 110, -1, -1, 8, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(1, true, false, false, "npc_vj_zshelter_common_h", "none", 100, 12, 110, -1, -1, 8, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(1, false, false, false, "npc_vj_zshelter_common_o", "none", 100, 14, 170, -1, -1, 3, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(1, true, false, false, "npc_vj_zshelter_common_o", "none", 100, 14, 170, -1, -1, 3, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(1, false, false, false, "npc_vj_zshelter_light_h", "none", 100, 13, 110, -1, -1, 3, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(1, true, false, false, "npc_vj_zshelter_light_h", "none", 100, 13, 110, -1, -1, 3, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(1, false, false, false, "npc_vj_zshelter_light_o", "none", 100, 13, 140, -1, -1, 3, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(1, true, false, false, "npc_vj_zshelter_light_o", "none", 100, 13, 140, -1, -1, 3, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(2, true, false, false, "npc_vj_zshelter_dog", "none", 100, 15, 150, -1, -1, 8, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(3, false, false, false, "npc_vj_zshelter_psycho_h", "none", 100, 12, 170, -1, -1, 3, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(3, true, false, false, "npc_vj_zshelter_psycho_h", "none", 100, 12, 170, -1, -1, 3, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(3, false, false, false, "npc_vj_zshelter_psycho_o", "none", 100, 12, 170, -1, -1, 3, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(3, true, false, false, "npc_vj_zshelter_psycho_o", "none", 100, 12, 170, -1, -1, 3, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(5, false, false, false, "npc_vj_zshelter_heavy_h", "none", 100, 10, 550, -1, -1, 35, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(5, true, false, false, "npc_vj_zshelter_heavy_h", "none", 100, 10, 550, -1, -1, 35, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(5, false, false, false, "npc_vj_zshelter_heavy_o", "none", 100, 10, 550, -1, -1, 35, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(5, true, false, false, "npc_vj_zshelter_heavy_o", "none", 100, 10, 550, -1, -1, 35, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(6, false, false, false, "npc_vj_zshelter_boomer_h", "none", 100, 25, 170, -1, -1, 3, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(6, true, false, false, "npc_vj_zshelter_boomer_h", "none", 100, 25, 170, -1, -1, 3, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(6, false, false, false, "npc_vj_zshelter_boomer_o", "none", 100, 25, 170, -1, -1, 3, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(6, true, false, false, "npc_vj_zshelter_boomer_o", "none", 100, 25, 170, -1, -1, 3, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)

			ZShelter.AddEnemy(1, false, false, false, "npc_vj_zshelter_common_h_grenade", "none", 100, 10, 150, -1, -1, 0, Color(55, 255, 55, 255), 1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(1, true, false, false, "npc_vj_zshelter_common_h_grenade", "none", 100, 10, 150, -1, -1, 0, Color(55, 255, 55, 255), 3, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(2, true, false, false, "npc_vj_zshelter_common_o_grenade", "none", 100, 10, 220, -1, -1, 0, Color(55, 255, 55, 255), 3, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(5, true, false, false, "npc_vj_zshelter_common_o_grenade", "none", 100, 10, 220, -1, -1, 0, Color(55, 255, 55, 255), 1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(7, true, false, false, "npc_vj_zshelter_common_o_grenade", "none", 100, 10, 220, -1, -1, 0, Color(55, 255, 55, 255), 1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(8, true, false, false, "npc_vj_zshelter_common_o_grenade", "none", 100, 10, 220, -1, -1, 0, Color(55, 255, 55, 255), 1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(9, true, false, false, "npc_vj_zshelter_common_o_grenade", "none", 100, 10, 220, -1, -1, 0, Color(55, 255, 55, 255), 1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(10, true, false, false, "npc_vj_zshelter_common_o_grenade", "none", 100, 10, 220, -1, -1, 0, Color(55, 255, 55, 255), 3, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(15, true, false, false, "npc_vj_zshelter_common_o_grenade", "none", 100, 10, 220, -1, -1, 0, Color(55, 255, 55, 255), 3, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(20, true, false, false, "npc_vj_zshelter_common_o_grenade", "none", 100, 10, 220, -1, -1, 0, Color(55, 255, 55, 255), 5, CurMinDifficulty, CurMaxDifficulty)

			ZShelter.AddEnemy(3, true, false, false, "npc_vj_zshelter_heavy_boss", "none", 100, 50, 8000, 4, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(5, true, false, false, "npc_vj_zshelter_boss_fallen_titan", "none", 100, 85, 8000, 6, 1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(7, true, false, false, "npc_vj_zshelter_heavy_boss", "none", 100, 20, 6000, 10, -1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(8, true, false, false, "npc_vj_zshelter_boss_ampsuit", "none", 100, 65, 17000, 9, 1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(10, true, false, false, "npc_vj_zshelter_boss_fallen_titan", "none", 100, 65, 20000, 11, 1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(10, true, false, false, "npc_vj_zshelter_boss_ampsuit", "none", 100, 65, 20000, 11, 1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(12, true, false, false, "npc_vj_zshelter_boss_ampsuit", "none", 100, 65, 24000, 13, 1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(12, true, false, false, "npc_vj_zshelter_boss_prototype_phobos_siege", "none", 100, 85, 24000, 13, 1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(13, true, false, false, "npc_vj_zshelter_boss_prototype_phobos_siege", "none", 100, 85, 24000, 14, 1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(14, true, false, false, "npc_vj_zshelter_boss_prototype_phobos_siege", "none", 100, 85, 25000, 15, 1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(14, true, false, false, "npc_vj_zshelter_boss_oberon", "none", 100, 85, 25000, 15, 1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(15, true, false, false, "npc_vj_zshelter_boss_prototype_phobos_siege", "none", 100, 85, 24000, 16, 1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(15, true, false, false, "npc_vj_zshelter_boss_ampsuit", "none", 100, 85, 24000, 16, 1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)

			ZShelter.AddEnemy(16, true, false, false, "npc_vj_zshelter_boss_prototype_phobos_siege", "none", 100, 85, 24000, 18, 1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(17, true, false, false, "npc_vj_zshelter_boss_ampsuit", "none", 100, 85, 24000, 18, 1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)

			ZShelter.AddEnemy(18, true, false, false, "npc_vj_zshelter_boss_oberon", "none", 100, 85, 24000, 20, 1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(19, true, false, false, "npc_vj_zshelter_boss_fallen_titan", "none", 100, 85, 24000, 20, 1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)

			ZShelter.AddEnemy(20, true, false, false, "npc_vj_zshelter_boss_prototype_phobos_siege", "none", 100, 85, 24000, -1, 1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(20, true, false, false, "npc_vj_zshelter_boss_ampsuit", "none", 100, 85, 24000, -1, 1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(20, true, false, false, "npc_vj_zshelter_boss_fallen_titan", "none", 100, 85, 24000, -1, 1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)

			ZShelter.AddEnemy(10, true, false, false, "npc_vj_zshelter_heavy_boss", "none", 100, 20, 7000, 14, -1, 0, Color(255, 255, 255, 255), 2, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(14, true, false, false, "npc_vj_zshelter_heavy_boss", "none", 100, 20, 8000, 17, -1, 0, Color(255, 255, 255, 255), 3, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(17, true, false, false, "npc_vj_zshelter_heavy_boss", "none", 100, 20, 8000, -1, -1, 0, Color(255, 255, 255, 255), 4, CurMinDifficulty, CurMaxDifficulty)

			ZShelter.AddEnemy(1, true, false, false, "npc_vj_zshelter_deimos_o", "none", 100, 25, 2200, 3, 1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(3, true, false, false, "npc_vj_zshelter_deimos_o", "none", 100, 25, 2600, 5, 2, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(5, true, false, false, "npc_vj_zshelter_deimos_o", "none", 100, 25, 3000, 8, 4, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(8, true, false, false, "npc_vj_zshelter_deimos_o", "none", 100, 25, 3000, 11, 6, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(11, true, false, false, "npc_vj_zshelter_deimos_o", "none", 100, 25, 3200, 13, 8, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(13, true, false, false, "npc_vj_zshelter_deimos_o", "none", 100, 25, 3400, 15, 10, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(15, true, false, false, "npc_vj_zshelter_deimos_o", "none", 100, 25, 3400, 17, 14, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
			ZShelter.AddEnemy(17, true, false, false, "npc_vj_zshelter_deimos_o", "none", 100, 25, 3400, -1, 20, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)

			SetGlobalBool("BP_Mending Tower", true)
			SetGlobalBool("BP_Freeze Tower", true)

			ZShelter.SpawnResources(130)
			ZShelter.FilteEnemy()
		end,
	},
})

--[[
	----------------------------------------------------------------------------------------
]]

ZShelter.Modifiers.Register("ModN_FriendlyFire", {
	category = "Other_Mods",
	categoryColor = Color(255, 255, 255, 255),
	desc = "ModD_FriendlyFire",
	scoreMul = 1,

	hooks = {
		ZShelterGameStarted = function()
			GetConVar("zshelter_friendly_fire"):SetInt(1)
		end,
	},
})