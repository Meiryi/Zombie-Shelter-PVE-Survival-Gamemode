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
			if(modifier.category == "Decrease Difficulty") then
				ZShelter.Modifiers.HasEasyMode = true
			end
			ZShelter.Modifiers.ApplyModifier(modifierName)
		end
	end

	net.Receive("ZShelter_SendVoteModifiers", function(len, ply)
		if(GetGlobalBool("GameStarted")) then return end
		local str = net.ReadString()
		local voted = ply:GetNWBool(str.."Voted", false)

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

ZShelter.Modifiers.Register("Increased player damage", {
	category = "Decrease Difficulty",
	categoryColor = Color(55, 255, 55, 255),
	desc = "+50% Player damage",
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

ZShelter.Modifiers.Register("+1 Starting skillpoint", {
	category = "Decrease Difficulty",
	categoryColor = Color(55, 255, 55, 255),
	desc = "1 Extra starting skillpoint",
	scoreMul = 0.75,

	hooks = {
		ZShelterGameStarted = function()
			for k,v in ipairs(player.GetAll()) do
				v:SetNWInt("SkillPoints", v:GetNWInt("SkillPoints", 0) + 1)
			end
		end,
	},
})

ZShelter.Modifiers.Register("Double skillpoint", {
	category = "Decrease Difficulty",
	categoryColor = Color(55, 255, 55, 255),
	desc = "Gain 2 skillpoints every day",
	scoreMul = 0.2,

	hooks = {
		["ZShelter-DaySwitch"] = function()
			for k,v in ipairs(player.GetAll()) do
				v:SetNWInt("SkillPoints", v:GetNWInt("SkillPoints", 0) + 1)
			end
		end
	},
})

ZShelter.Modifiers.Register("Decreased zombie attack damage", {
	category = "Decrease Difficulty",
	categoryColor = Color(55, 255, 55, 255),
	desc = "-40% Zombie attack damage",
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

ZShelter.Modifiers.Register("Increased resource spawn", {
	category = "Decrease Difficulty",
	categoryColor = Color(55, 255, 55, 255),
	desc = "+75% Resource spawns",
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

ZShelter.Modifiers.Register("Ranged attack mutation", {
	category = "Increase Difficulty",
	categoryColor = Color(255, 55, 55, 255),
	desc = "Enable ranged attack mutation",
	scoreMul = 1.2,

	hooks = {
		ZShelterGameStarted = function()
			SetGlobalBool("RangedMutationEnabled", true)
		end,
	},
})

ZShelter.Modifiers.Register("Shield mutation", {
	category = "Increase Difficulty",
	categoryColor = Color(255, 55, 55, 255),
	desc = "Enable shield mutation",
	scoreMul = 1.2,

	hooks = {
		ZShelterGameStarted = function()
			SetGlobalBool("ShieldMutationEnabled", true)
		end,
	},
})

ZShelter.Modifiers.Register("No skill boxes", {
	category = "Increase Difficulty",
	categoryColor = Color(255, 55, 55, 255),
	desc = "No skillboxes will spawn",
	scoreMul = 1.2,

	hooks = {
		ZShelterGameStarted = function()
			SetGlobalInt("SkillBoxAmount", 0)
		end,
	},
})

ZShelter.Modifiers.Register("Increased amount of zombie", {
	category = "Increase Difficulty",
	categoryColor = Color(255, 55, 55, 255),
	desc = "+100% Amount of zombies",
	scoreMul = 1.15,

	hooks = {
		ZShelterGameStarted = function()
			SetGlobalFloat("EnemySpawnMul", GetGlobalFloat("EnemySpawnMul", 1) * 2)
		end,
	},
})

ZShelter.Modifiers.Register("Increased spawn rate", {
	category = "Increase Difficulty",
	categoryColor = Color(255, 55, 55, 255),
	desc = "+100% Spawn rate",
	scoreMul = 1.15,

	hooks = {
		ZShelterGameStarted = function()
			SetGlobalFloat("EnemySpawnTimeMul", GetGlobalFloat("EnemySpawnTimeMul", 1) * 0.5)
		end,
	},
})

local DayCount = 0
ZShelter.Modifiers.Register("Less skillpoints", {
	category = "Increase Difficulty",
	categoryColor = Color(255, 55, 55, 255),
	desc = "Gain skilpoints every 2 days",
	scoreMul = 1.2,

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

ZShelter.Modifiers.Register("Less resource spawn", {
	category = "Increase Difficulty",
	categoryColor = Color(255, 55, 55, 255),
	desc = "-40% Resource spawns",
	scoreMul = 1.1,

	hooks = {
		ZShelterGameStarted = function()
			SetGlobalFloat("ResourceMul", GetGlobalFloat("ResourceMul", 1) * 0.4)
		end,
	},
})

ZShelter.Modifiers.Register("Less resource spawn", {
	category = "Increase Difficulty",
	categoryColor = Color(255, 55, 55, 255),
	desc = "-40% Resource spawns",
	scoreMul = 1.125,

	hooks = {
		ZShelterGameStarted = function()
			SetGlobalFloat("ResourceMul", GetGlobalFloat("ResourceMul", 1) * 0.4)
		end,
	},
})

ZShelter.Modifiers.Register("Less player damage", {
	category = "Increase Difficulty",
	categoryColor = Color(255, 55, 55, 255),
	desc = "-25% Player Damage",
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

ZShelter.Modifiers.Register("Less time", {
	category = "Increase Difficulty",
	categoryColor = Color(255, 55, 55, 255),
	desc = "-25% Day and night time",
	scoreMul = 1.1,

	hooks = {
		ZShelterGameStarted = function()
			SetGlobalFloat("TimeMul", 0.75)
		end,
	},
})

ZShelter.Modifiers.Register("Increased enemy attack damage", {
	category = "Increase Difficulty",
	categoryColor = Color(255, 55, 55, 255),
	desc = "+50% Enemy attack damage",
	scoreMul = 1.1,

	hooks = {
		OnEntityCreated = function(ent)
			timer.Simple(0, function()
				if(!IsValid(ent) || ent:IsPlayer() || ent.IsBuilding) then return end
				ZShelter.ApplyDamageMul(ent, "ModifierBuff_Enemy", 1.5, 32767, true)
			end)
		end,
	},
})

ZShelter.Modifiers.Register("Enemy running on day", {
	category = "Increase Difficulty",
	categoryColor = Color(255, 55, 55, 255),
	desc = "All enemies will be running no matter it's night or day",
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

ZShelter.Modifiers.Register("Hardcore mode", {
	category = "Increase Difficulty",
	categoryColor = Color(255, 55, 55, 255),
	desc = "Ultimate aids game experience",
	scoreMul = 1.65,

	hooks = {
		ZShelterGameStarted = function()
			for k,v in ipairs(player.GetAll()) do
				v:SetNWInt("SkillPoints", 0)
				ZShelter.ApplyDamageMul(v, "Hardcore_Debuff", 0.9, 32767, true)
			end
			SetGlobalInt("Time", 150)

			SetGlobalFloat("EnemySpawnMul", GetGlobalFloat("EnemySpawnMul", 1) * 1.75)
			SetGlobalFloat("EnemySpawnTimeMul", GetGlobalFloat("EnemySpawnTimeMul", 1) * 0.75)
			SetGlobalFloat("ResourceMul", GetGlobalFloat("ResourceMul", 1) * 0.5)
			GetConVar("zshelter_difficulty"):SetInt(9)
			ZShelter.StartedDifficulty = GetConVar("zshelter_difficulty"):GetInt()
		end,

		PlayerSpawn = function(ply)
			ZShelter.ApplyDamageMul(ply, "Hardcore_Debuff", 0.9, 32767, true)
		end,

		PostPlayerDeath = function(ply)
			ply:SetNWFloat("RespawnTime", CurTime() + GetGlobalInt("Time"))
		end
	},
})