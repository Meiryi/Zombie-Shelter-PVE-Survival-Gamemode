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

util.AddNetworkString("ZShelter-SendPoints")

ZShelter.BossRecord = ZShelter.BossRecord || {}
ZShelter.EnemyCounter = ZShelter.EnemyCounter || {}
ZShelter.FiltedDayEnemies = ZShelter.FiltedDayEnemies || {}
ZShelter.FiltedNightEnemies = ZShelter.FiltedNightEnemies || {}
ZShelter.FiltedNightHighHPEnemies = ZShelter.FiltedNightHighHPEnemies || {}
ZShelter.EnemyExistCounter = ZShelter.EnemyExistCounter || {}
ZShelter.TreasureAreaEnemy = ZShelter.TreasureAreaEnemy || {}

ZShelter.AiNodes = {}
ParseFile()

ZShelter.ResourceSpawnPoint = ZShelter.ResourceSpawnPoint || {}

ZShelter.TreasureArea = ZShelter.TreasureArea || {}
ZShelter.ValidRaiderSpawnPoints = ZShelter.ValidRaiderSpawnPoints || {}
ZShelter.ValidRoamerSpawnPoints = ZShelter.ValidRoamerSpawnPoints || {}
ZShelter.ValidSpawnPointsAll = ZShelter.ValidSpawnPointsAll || {}
ZShelter.SpawnPointsInited = ZShelter.SpawnPointsInited || false

ZShelter.PanicEnemySpawnTime = 0
ZShelter.PanicEnemySpawnInterval = 0
ZShelter.OverrideSpawnTimer = 0
ZShelter.OverrideSpawnValue = 1

ZShelter.CurrentDayEnemy = ZShelter.CurrentDayEnemy || 0
ZShelter.CurrentNightEnemy = ZShelter.CurrentNightEnemy || 0

ZShelter.MaximumDayEnemy = 20
ZShelter.MaximumNightEnemy = 6

local dcheck = {
	Vector(0, 0, 10),
	Vector(0, 250, 10),
	Vector(0, -250, 10),
	Vector(250, 0, 10),
	Vector(-250, 0, 10),
}
function qtrace(a, b)
	for k,v in pairs(dcheck) do
		local tr = {
			start = a,
			endpos = b + v,
			mask = 16395,
		}
		if(util.TraceLine(tr).Fraction == 1) then return true end
	end
end

function ctrace(a)
	local tr = {
		start = a,
		endpos = a,
		mins = Vector(-32, -32, 0),
		maxs = Vector(32, 32, 72),
		mask = 16395,
	}
	return util.TraceHull(tr).HitWorld
end

local mins, maxs = Vector(-15, -15, 0), Vector(15, 15, 15)
function vrespos(vec)
	local tr = {
		start = vec,
		endpos = vec,
		mins = mins,
		maxs = maxs,
		mask = MASK_SHOT,
	}
	local ret = util.TraceHull(tr)
	return ret.HitWorld
end

function ZShelter.ForceReset()
	ZShelter.ShelterInited = false
	local shelter = ZShelter.Shelter
	SetGlobalEntity("ShelterEntity", nil)
	ZShelter.Shelter = nil
	if(IsValid(shelter)) then
		shelter:Remove()
	end

	ZShelter.SpawnPointsInited = false
	ZShelter.TreasureArea = {}
	ZShelter.ValidRaiderSpawnPoints = {}
	ZShelter.ValidRoamerSpawnPoints = {}
	ZShelter.ValidSpawnPointsAll = {}
	ZShelter.ResourceSpawnPoint = {}

	ZShelter.InitShelter()
end

function ZShelter.ForceReloadPoints()
	ZShelter.SpawnPointsInited = false
	ZShelter.TreasureArea = {}
	ZShelter.ValidRaiderSpawnPoints = {}
	ZShelter.ValidRoamerSpawnPoints = {}
	ZShelter.ValidSpawnPointsAll = {}
	ZShelter.ResourceSpawnPoint = {}

	ZShelter.SetupSpawnPoints()
end

function ZShelter.ForceReloadPoints_Debug()
	ZShelter.SpawnPointsInited = false
	ZShelter.TreasureArea = {}
	ZShelter.ValidRaiderSpawnPoints = {}
	ZShelter.ValidRoamerSpawnPoints = {}
	ZShelter.ValidSpawnPointsAll = {}
	ZShelter.ResourceSpawnPoint = {}

	ZShelter.SetupSpawnPoints()
	ZShelter.BroadcastPoints()
end

local chunkSize = 512
local safeDistance = 1800
local maximumDistance = 3072
function ZShelter.SetupSpawnPoints()
	if(ZShelter.SpawnPointsInited || !IsValid(ZShelter.Shelter)) then return end
	if(table.Count(ZShelter.AiNodes)) then
		ParseFile()
	end
	local st = SysTime()
	local shelterPos = ZShelter.Shelter:GetPos()
	local aa, bb = shelterPos + Vector(-safeDistance, -safeDistance, -safeDistance), shelterPos + Vector(safeDistance, safeDistance, safeDistance)
	for k,v in pairs(ZShelter.AiNodes) do
		v = v + Vector(0, 0, 3)
		if(qtrace(shelterPos, v)) then continue end
		if(ctrace(v)) then continue end
		local dst = shelterPos:Distance(v)
		if(!v:WithinAABox(bb, aa) && dst < maximumDistance) then
			table.insert(ZShelter.ValidRaiderSpawnPoints, v)
		else
			table.insert(ZShelter.ValidRoamerSpawnPoints, v)
		end
		table.insert(ZShelter.ValidSpawnPointsAll, v)
	end

	for k,v in pairs(ents.FindByClass("info_zshelter_extra_enemy_spawn")) do
		local vpos = v:GetPos()
		if(vpos:Distance(shelterPos) > maximumDistance) then continue end
		table.insert(ZShelter.ValidRaiderSpawnPoints, vpos)
	end

	local dedicated = ents.FindByClass("info_zshelter_dedicated_enemy_spawn")
	if(#dedicated > 0) then
		print("---- Dedicated spawnpoints found ----")
		ZShelter.ValidRaiderSpawnPoints = {}
		for k,v in pairs(dedicated) do
			print("Added spawn point", v:GetPos())
			table.insert(ZShelter.ValidRaiderSpawnPoints, v:GetPos())
		end
	end

	for k,v in pairs(ents.FindByClass("info_zshelter_treasure_area")) do
		table.insert(ZShelter.TreasureArea, v:GetPos())
	end
	print("---- Resource Spawn Points ----")
	for k,v in pairs(ZShelter.ValidSpawnPointsAll) do
		table.insert(ZShelter.ResourceSpawnPoint, v)
		for i = 1, 5 do
			local rand = v + Vector(math.random(-200, 200), math.random(-200, 200), 0)
			if(vrespos(rand)) then print("[Resource] Precalc position hitworld!, skipping : ", rand) continue end
			local result = util.QuickTrace(rand, Vector(0, 0, -512)).HitPos + Vector(0, 0, 5)
			if(!util.IsInWorld(result)) then print("[Resource] Position OOB!, skipping : ", result) continue end
			table.insert(ZShelter.ResourceSpawnPoint, result)
		end
	end
	print("Spawn point generation took "..math.Round(SysTime() - st, 4).."s")
	ZShelter.SpawnPointsInited = true
end

function ZShelter.BroadcastPoints()
	local data, len = ZShelter.CompressTable(ZShelter.ValidRaiderSpawnPoints)
	net.Start("ZShelter-SendPoints")
	net.WriteUInt(len, 32)
	net.WriteData(data, len)
	net.Broadcast()
end

function ZShelter.CalcAttackBoost()
	local boost = math.max(1, 1 + ((player.GetCount() - 1) * 0.05))
	return boost
end

function ZShelter.CalcPlayerHPScaling_Debug(playercount)
	local boost = math.max(1, 1 + ((playercount - 1) * 0.08))
	return boost
end

function ZShelter.CalcPlayerHPScaling()
	local boost = math.max(1, 1 + ((player.GetCount() - 1) * 0.05))
	return boost
end

function ZShelter.FilteEnemy(ignoreDay)
	ZShelter.EnemyCounter = {}
	ZShelter.FiltedDayEnemies = {}
	ZShelter.FiltedNightEnemies = {}
	ZShelter.TreasureAreaEnemy = {}
	ZShelter.FiltedNightHighHPEnemies = {}
	ZShelter.EnemyExistCounter = {}
	--[[
		day = day,
		night_or_day = night_or_day, -- true = night, false = day
		class = class,
		hp = hp,
		attack = attack,
		mutation = mutation,
		isboss = isboss, -- Boss for treasure area
		chance = chance, -- 1 ~ 100
		end_day = end_day, -- Leave -1 to spawn everyday
		roamer = roamer, -- Does nothing to enemies on day, this makes enemies spawn at far place from shelter
		max_amount = maxamount, -- Means how much this enemy can be spawn, leave -1 for no limit
		hp_boost_day = hp_boost_day,
	]]
	local dmgscale = ZShelter.CalcAttackBoost()
	local plyscale = ZShelter.CalcPlayerHPScaling()
	local difficulty = GetConVar("zshelter_difficulty"):GetInt()
	local diffScale = (1 + ((difficulty - 1) * 0.02))
	local day = GetGlobalInt("Day", 0)
	local bossday = -65536
	for k,v in pairs(ZShelter.EnemyConfig) do
		if(v.min_difficulty > difficulty) then continue end
		if(v.max_difficulty && v.max_difficulty < difficulty) then continue end -- check it for backward compatibility
		if(!ignoreDay && v.day > day) then continue end
		if(v.end_day <= day && v.end_day != -1) then continue end
		local randIndex = bit.tohex(math.random(1, 65536), 4)
		ZShelter.EnemyCounter[randIndex] = 0
		ZShelter.EnemyExistCounter[randIndex] = 0
		if(v.isboss) then
			if(v.day > bossday) then
				ZShelter.TreasureAreaEnemy = {
					class = v.class,
					hp = ((v.hp * diffScale) * plyscale) + (day * v.hp_boost_day),
					noclear = v.noclear,
					attack = v.attack,
					mutation = v.mutation,
					color = v.color,
					index = randIndex,
					weaponclass = v.weaponclass,
				}
				bossday = v.day
			end
			continue
		end
		if(v.night_or_day) then
			table.insert(ZShelter.FiltedNightEnemies, {
				class = v.class,
				hp = ((v.hp * diffScale) * plyscale) + (day * v.hp_boost_day),
				attack = v.attack * dmgscale,
				noclear = v.noclear,
				chance = v.chance,
				max = v.max_amount,
				mutation = v.mutation,
				color = v.color,
				index = randIndex,
				maxamount = v.max_exists,
				weaponclass = v.weaponclass,
			})
		else
			table.insert(ZShelter.FiltedDayEnemies, {
				class = v.class,
				hp = ((v.hp * diffScale) * plyscale) + (day * v.hp_boost_day),
				attack = v.attack * dmgscale,
				noclear = v.noclear,
				chance = v.chance,
				max = v.max_amount,
				mutation = v.mutation,
				color = v.color,
				index = randIndex,
				maxamount = v.max_exists,
				weaponclass = v.weaponclass,
			})
		end
	end
	local highesthp = {}
	local tmp = {}
	local tmphp = -1
	for k,v in pairs(ZShelter.FiltedNightEnemies) do
		if(v.max != -1) then continue end
		if(tmphp == -1) then
			tmp = v
			tmphp = v.hp
		else
			if(tmphp < v.hp) then
				tmp = v
				tmphp = v.hp
			end
		end
	end
	ZShelter.FiltedNightHighHPEnemies = tmp
end


function ZShelter.SpawnDayEnemies()
	if(ZShelter.CurrentDayEnemy > ZShelter.MaximumDayEnemy) then return end
	local night = GetGlobalBool("Night")
	if(GetGlobalBool("Rescuing")) then
		night = true
	end
	local diff = GetConVar("zshelter_difficulty"):GetInt()
	local amount = 10 + diff
	for i = 1, amount do
		local pos = ZShelter.ValidSpawnPointsAll[math.random(1, #ZShelter.ValidSpawnPointsAll)]
		if(!pos) then continue end
		local seed = math.random(1, 100)
		local dataIndex = math.random(1, table.Count(ZShelter.FiltedDayEnemies))
		local data = ZShelter.FiltedDayEnemies[dataIndex]
		if(!data) then continue end
		if(data.chance < seed) then continue end
		if(data.maxamount && data.maxamount != -1 && data.maxamount <= ZShelter.EnemyExistCounter[data.index]) then continue end

		local enemy = ents.Create(data.class)
			enemy:Spawn()
			local mins, maxs = enemy:GetCollisionBounds()
			local tr = {
				start = pos,
				endpos = pos,
				mins = mins,
				maxs = maxs,
			}
			if(util.TraceHull(tr).Hit) then
				enemy:Remove()
				continue
			end
			enemy:SetPos(pos)
			enemy:SetMaxHealth(data.hp)
			enemy:SetHealth(data.hp)
			enemy:SetRenderMode(RENDERMODE_TRANSCOLOR)
			enemy:SetColor(data.color)
			enemy.damage = data.attack
			enemy.IsZShelterEnemy = true
			enemy.DayEnemy = true
			enemy.eIndex = data.index
			enemy.WepClass = data.weaponclass
			enemy.MutationClass = data.mutation
			ZShelter.EnemyExistCounter[data.index] = ZShelter.EnemyExistCounter[data.index] + 1
			ZShelter.CurrentDayEnemy = ZShelter.CurrentDayEnemy + 1

			if(data.noclear) then
				enemy.ImmunityNightDamage = true
			end

			if(!night) then
				enemy.AnimTbl_Walk = {ACT_WALK}
				enemy.AnimTbl_Run = {ACT_WALK}
			end
			
		hook.Run("ZShelter-EnemyCreated", enemy, false)

		if(data.max != -1) then
			if(!ZShelter.EnemyCounter[data.index]) then
				ZShelter.EnemyCounter[data.index] = 0
			end
			ZShelter.EnemyCounter[data.index] = ZShelter.EnemyCounter[data.index] + 1
			if(ZShelter.EnemyCounter[data.index] >= data.max) then
				ZShelter.FiltedDayEnemies[dataIndex] = nil
			end
		end
	end
end

function ZShelter.CalcSpawnAmount_Debug(day, diff, ply)
	local day = day
	local diffScale = 1 + (diff * 0.15)
	local plyScale = 1 + ((ply - 1) * 0.15)
	return math.max(math.floor((6 + ((day * 0.34) * diffScale)) * plyScale), 1) -- make sure it's more than 0
end

function ZShelter.CalcSpawnAmount()
	local day = GetGlobalInt("Day", 1)
	local diffScale = 1 + (GetConVar("zshelter_difficulty"):GetInt() * 0.15)
	local plyScale = 1 + ((player.GetCount() - 1) * 0.15)
	return math.max(math.floor((6 + ((day * 0.34) * diffScale)) * plyScale), 1) -- make sure it's more than 0
end

function ZShelter.CalcMaxAmount_Debug(day)
	local day = day
	local diffScale = 1 + (GetConVar("zshelter_difficulty"):GetInt() * 0.25)
	return math.min(50, math.floor(1 + ((day * 3) * diffScale)))
end

function ZShelter.CalcMaxAmount()
	local day = GetGlobalInt("Day", 1)
	local diffScale = 1 + ((GetConVar("zshelter_difficulty"):GetInt() - 1) * 0.3)
	return math.min(50, math.floor(1 + ((day * 2.25) * diffScale)))
end

function ZShelter.SpawnPanicEnemies()
	local diff = GetConVar("zshelter_difficulty"):GetInt()
	local amount = 4
	for i = 1, amount do
		local pos = ZShelter.ValidSpawnPointsAll[math.random(1, #ZShelter.ValidSpawnPointsAll)]
		if(!pos) then continue end
		local seed = math.random(1, 100)
		local dataIndex = math.random(1, table.Count(ZShelter.FiltedDayEnemies))
		local data = ZShelter.FiltedDayEnemies[dataIndex]
		if(!data) then continue end
		if(data.chance < seed) then continue end
		if(data.maxamount && data.maxamount != -1 && data.maxamount <= ZShelter.EnemyExistCounter[data.index]) then continue end

		local enemy = ents.Create(data.class)
			enemy:Spawn()
			local mins, maxs = enemy:GetCollisionBounds()
			local tr = {
				start = pos,
				endpos = pos,
				mins = mins,
				maxs = maxs,
			}
			if(util.TraceHull(tr).Hit) then
				enemy:Remove()
				continue
			end
			enemy:SetPos(pos)
			enemy:SetMaxHealth(data.hp)
			enemy:SetHealth(data.hp)
			enemy:SetRenderMode(RENDERMODE_TRANSCOLOR)
			enemy:SetColor(data.color)
			enemy.damage = data.attack
			enemy.IsZShelterEnemy = true
			enemy.DayEnemy = true
			enemy.ForceNoCollide = true
			enemy.eIndex = data.index
			enemy.WepClass = data.weaponclass
			enemy.MutationClass = data.mutation
			ZShelter.EnemyExistCounter[data.index] = ZShelter.EnemyExistCounter[data.index] + 1

		hook.Run("ZShelter-EnemyCreated", enemy, true)

		if(data.max != -1) then
			if(!ZShelter.EnemyCounter[data.index]) then
				ZShelter.EnemyCounter[data.index] = 0
			end
			ZShelter.EnemyCounter[data.index] = ZShelter.EnemyCounter[data.index] + 1
			if(ZShelter.EnemyCounter[data.index] >= data.max) then
				ZShelter.FiltedDayEnemies[dataIndex] = nil
			end
		end
	end
end

function ZShelter.SpawnNightEnemies()
	local amount = ZShelter.CalcSpawnAmount()
	local limit = ZShelter.CalcMaxAmount()
	if(ZShelter.CurrentNightEnemy > limit) then return end
	for i = 1, amount do
		local pos = ZShelter.ValidRaiderSpawnPoints[math.random(1, #ZShelter.ValidRaiderSpawnPoints)]
		if(!pos) then continue end
		local seed = math.random(1, 100)
		local dataIndex = math.random(1, table.Count(ZShelter.FiltedNightEnemies))
		local data = ZShelter.FiltedNightEnemies[dataIndex]
		if(!data) then continue end
		if(data.chance < seed) then continue end
		if(data.maxamount && data.maxamount != -1 && data.maxamount <= ZShelter.EnemyExistCounter[data.index]) then continue end

		local enemy = ents.Create(data.class)
			enemy:Spawn()
			local mins, maxs = enemy:GetCollisionBounds()
			local tr = {
				start = pos,
				endpos = pos,
				mins = mins,
				maxs = maxs,
			}
			if(util.TraceHull(tr).Hit) then
				enemy:Remove()
				continue
			end
			enemy:SetPos(pos)
			enemy:SetMaxHealth(data.hp)
			enemy:SetHealth(data.hp)
			enemy:SetRenderMode(RENDERMODE_TRANSCOLOR)
			enemy:SetColor(data.color)
			enemy.damage = data.attack
			enemy.IsZShelterEnemy = true
			enemy.NightEnemy = true
			enemy.eIndex = data.index
			enemy.WepClass = data.weaponclass
			enemy.MutationClass = data.mutation
			ZShelter.EnemyExistCounter[data.index] = ZShelter.EnemyExistCounter[data.index] + 1
			ZShelter.CurrentNightEnemy = ZShelter.CurrentNightEnemy + 1

			if(data.noclear) then
				enemy.ImmunityNightDamage = true
			end

		hook.Run("ZShelter-EnemyCreated", enemy, true)

		if(data.max != -1) then
			if(!ZShelter.EnemyCounter[data.index]) then
				ZShelter.EnemyCounter[data.index] = 0
			end
			ZShelter.EnemyCounter[data.index] = ZShelter.EnemyCounter[data.index] + 1
			if(ZShelter.EnemyCounter[data.index] >= data.max) then
				ZShelter.FiltedNightEnemies[dataIndex] = nil
			end
		end
	end
end

function ZShelter.SpawnNightEnemiesNoLimit()
	local amount = ZShelter.CalcSpawnAmount()
	local limit = ZShelter.CalcMaxAmount()
	if(ZShelter.CurrentNightEnemy > limit * 1.35) then return end
	for i = 1, amount do
		local pos = ZShelter.ValidRaiderSpawnPoints[math.random(1, #ZShelter.ValidRaiderSpawnPoints)]
		if(!pos) then continue end
		local seed = math.random(1, 100)
		local dataIndex = math.random(1, table.Count(ZShelter.FiltedNightEnemies))
		local data = ZShelter.FiltedNightEnemies[dataIndex]
		if(!data) then continue end
		if(data.chance < seed) then continue end
		if(data.maxamount && data.maxamount != -1 && data.maxamount <= ZShelter.EnemyExistCounter[data.index]) then continue end

		local enemy = ents.Create(data.class)
			enemy:Spawn()
			local mins, maxs = enemy:GetCollisionBounds()
			local tr = {
				start = pos,
				endpos = pos,
				mins = mins,
				maxs = maxs,
			}
			if(util.TraceHull(tr).Hit) then
				enemy:Remove()
				continue
			end
			enemy:SetPos(pos)
			enemy:SetMaxHealth(data.hp)
			enemy:SetHealth(data.hp)
			enemy:SetRenderMode(RENDERMODE_TRANSCOLOR)
			enemy:SetColor(data.color)
			enemy.damage = data.attack
			enemy.IsZShelterEnemy = true
			enemy.NightEnemy = true
			enemy.eIndex = data.index
			enemy.WepClass = data.weaponclass
			enemy.MutationClass = data.mutation
			ZShelter.EnemyExistCounter[data.index] = ZShelter.EnemyExistCounter[data.index] + 1
			ZShelter.CurrentNightEnemy = ZShelter.CurrentNightEnemy + 1

			if(data.noclear) then
				enemy.ImmunityNightDamage = true
			end

		hook.Run("ZShelter-EnemyCreated", enemy, true)

		if(data.max != -1) then
			if(!ZShelter.EnemyCounter[data.index]) then
				ZShelter.EnemyCounter[data.index] = 0
			end
			ZShelter.EnemyCounter[data.index] = ZShelter.EnemyCounter[data.index] + 1
			if(ZShelter.EnemyCounter[data.index] >= data.max) then
				ZShelter.FiltedNightEnemies[dataIndex] = nil
			end
		end
	end
end

function ZShelter.AddAwakeThinker(boss)
	local thinker = ents.Create("obj_internal_thinker")
		thinker:SetOwner(boss)
		thinker:Spawn()
		thinker.Think = function()
			if(!IsValid(boss) || boss.Awake) then
				thinker:Remove()
				return
			end
			for k,v in pairs(player.GetAll()) do
				if(!ZShelter.ValidatePlayerDistance(boss, v, 380)) then continue end
				boss:NextThink(CurTime())
				boss.Awake = true
			end
			thinker:NextThink(CurTime() + 0.2)
			return true
		end
end

function ZShelter.SetupTreasureArea() 
	if(table.Count(ZShelter.TreasureAreaEnemy) > 0) then
		local bossdata = ZShelter.TreasureAreaEnemy
		for k,v in pairs(ZShelter.TreasureArea) do
			ZShelter.RandomResourceVec(v, 10)
			if(table.Count(bossdata) <= 0) then return end
			if(ZShelter.BossRecord[k] && IsValid(ZShelter.BossRecord[k])) then continue end
			local boss = ents.Create(bossdata.class)
				boss.damage = bossdata.attack
				boss:Spawn()
				boss:SetPos(v)
				boss:SetMaxHealth(bossdata.hp)
				boss:SetHealth(bossdata.hp)
				boss:SetRenderMode(RENDERMODE_TRANSCOLOR)
				boss:SetColor(bossdata.color)
				boss:NextThink(CurTime() + 1024000)

				ZShelter.AddAwakeThinker(boss)
				boss.IsBoss = true
				boss.Awake = false
				boss.IsZShelterEnemy = true

				boss:SetCollisionGroup(COLLISION_GROUP_NPC_SCRIPTED)
			ZShelter.BossRecord[k] = boss
			if(bossdata.noclear) then
				boss.ImmunityNightDamage = true
			end
		end
	end
end

function ZShelter.KillDayEnemies()
	for k,v in pairs(ents.GetAll()) do
		if(!v.IsZShelterEnemy || v.ImmunityNightDamage) then continue end
		v:TakeDamage(32767000, nil, nil)
	end
end

function ZShelter.CalcSpawnTime(day, diff)
	local scaling = math.max(1 - (0.1 * (player.GetCount() - 1)), 0.25)
	return math.max(((30 - diff) - (day * (diff * 0.3))) * scaling, 1.5)
end

local dayTimer = 0
local nightTimer = 0
local forceTimer = 0
local resourceSpawnTimer = 0
hook.Add("Tick", "ZShelter-Spawner", function()
	if(!GetGlobalBool("GameStarted")) then return end
	local diff = GetConVar("zshelter_difficulty"):GetInt()
	local day = GetGlobalInt("Day", 1)
	if(dayTimer < CurTime()) then
		ZShelter.SpawnDayEnemies()
		dayTimer = CurTime() + (40 - (diff * 1.5))
	end
	if(nightTimer < CurTime()) then
		if(GetGlobalBool("Night", false) || GetGlobalBool("Rescuing")) then
			ZShelter.SpawnNightEnemies()
			nightTimer = CurTime() + ZShelter.CalcSpawnTime(day, diff)
		end
	end
	if(GetGlobalBool("Rescuing")) then
		if(forceTimer < CurTime()) then
			ZShelter.SpawnNightEnemiesNoLimit()
			forceTimer = CurTime() + 5
		end
	end
	if(ZShelter.PanicEnemySpawnTime > CurTime()) then
		if(ZShelter.PanicEnemySpawnInterval < CurTime()) then
			ZShelter.SpawnPanicEnemies()
			ZShelter.PanicEnemySpawnInterval = CurTime() + 0.65
		end
	end
	if(resourceSpawnTimer < CurTime()) then
		ZShelter.SpawnResources(30)
		resourceSpawnTimer = CurTime() + 20
	end
end)

function ZShelter.ClearEnemies()
	for k,v in pairs(ents.GetAll()) do
		if(!v.IsZShelterEnemy) then continue end
		v:TakeDamage(32767000, nil, nil)
	end
end

--ZShelter.ClearEnemies()

hook.Add("ZShelter-EnemyCreated", "ZShelter-ApplyMutation", function(enemy, night)
	enemy:SetCollisionGroup(COLLISION_GROUP_NPC_SCRIPTED)
	if(enemy.WepClass && enemy.WepClass != "none") then
		enemy:Give(enemy.WepClass)
	end
	if(enemy.MutationClass && enemy.MutationClass != "none") then
		ZShelter.ApplyMutation(enemy, enemy.MutationClass)
		return
	end
	local diff = GetConVar("zshelter_difficulty"):GetInt()
	local day = GetGlobalInt("Day", 0)
	local m_id = ZShelter.MutationList[math.random(1, #ZShelter.MutationList)]
	local m = ZShelter.Mutations[m_id]
	if(!m) then return end
	if(diff < m.Difficulty) then return end
	local mul = 4 + (1 + (diff * 0.15))
	local tday = m.Day
	if(!tday) then tday = 0 end
	if(diff < 9 && day < tday) then return end
	mul = mul + (day * (0.1 + (diff * 0.05)))
	if(diff >= 8) then
		mul = mul + 8.5 -- maximum troll
		if(diff >= 9) then
			mul = mul * 2
		end
	end
	local seed = math.random(0, 100) - mul
	if(!night) then
		seed = seed * 3 -- Less mutations on day
	end
	if(seed > m.Chance) then return end
	ZShelter.ApplyMutation(enemy, m_id)
end)

hook.Add("EntityRemoved", "ZShelter-RemoveList", function(ent, fullUpdate)
	if(!ent:IsNPC() || !ent.IsZShelterEnemy) then return end

	if(ent.DayEnemy) then
		ZShelter.CurrentDayEnemy = math.max(ZShelter.CurrentDayEnemy - 1, 0)
	end
	if(ent.NightEnemy) then
		ZShelter.CurrentNightEnemy = math.max(ZShelter.CurrentNightEnemy - 1, 0)
	end
	if(ent.eIndex && ZShelter.EnemyExistCounter[ent.eIndex]) then
		ZShelter.EnemyExistCounter[ent.eIndex] = ZShelter.EnemyExistCounter[ent.eIndex] - 1
	end
end)