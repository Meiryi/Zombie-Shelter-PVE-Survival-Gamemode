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

ZShelter.Director = {}

-- Fixed values
ZShelter.Director.MaximumBreakCount = ZShelter.Director.MaximumBreakCount || 3

-- Next check timer
ZShelter.Director.NextCheck = ZShelter.Director.NextCheck || 0

-- Buildings
ZShelter.Director.TurretsBeforeNightSwitch = ZShelter.Director.TurretsBeforeNightSwitch || 0

-- Damage related variables
ZShelter.Director.FirstHitOccurred = ZShelter.Director.FirstHitOccurred || false
ZShelter.Director.ExpectedFirstHitOccurrTime = ZShelter.Director.ExpectedFirstHitOccurrTime || 0
ZShelter.Director.ExpectedDamage = ZShelter.Director.ExpectedDamage || 0
ZShelter.Director.TotalDamage = ZShelter.Director.TotalDamage || 0
ZShelter.Director.PushUnseccussfulTime = ZShelter.Director.PushUnseccussfulTime || 0

-- Buffs
ZShelter.Director.HealthScaling = ZShelter.Director.HealthScaling || 1

function ZShelter.Director_GetTurretCount()
	local count = 0
	for k,v in pairs(ents.GetAll()) do
		if(!v.IsTurret) then continue end
		count = count + 1
	end
	return count
end

function ZShelter.Director_AddDamage(building, damage)
	if(!GetGlobalBool("Night")) then return end
	if(!building.IsTurret && !building.IsShelter) then return end
	if(!ZShelter.Director.FirstHitOccurred) then
		ZShelter.Director.NextCheck = CurTime() + 15
		ZShelter.Director.FirstHitOccurred = true
	end
	ZShelter.Director.TotalDamage = ZShelter.Director.TotalDamage + damage
end

function ZShelter.Director_CalcExtendedTime()
	local time = GetGlobalInt("Time", 0)
	local diff = math.max(ZShelter.Director.TurretsBeforeNightSwitch - ZShelter.Director_GetTurretCount(), 0)
	if(diff <= 3) then
		diff = 0
	else
		diff = diff - 2
	end
	local extend = math.Clamp(diff * 8, 0, 120)
	SetGlobalInt("Time", GetGlobalInt("Time") + extend)
end

function ZShelter.Director_ResetStats()
	ZShelter.Director.NextCheck = 0

	ZShelter.Director.FirstHitOccurred = false
	ZShelter.Director.ExpectedFirstHitOccurrTime = CurTime() + GetConVar("zshelter_director_expected_first_hit_time"):GetInt()
	ZShelter.Director.ExpectedDamage = 50 * (1 + (GetConVar("zshelter_difficulty"):GetInt() * 0.085))
	ZShelter.Director.TotalDamage = 0
	ZShelter.Director.PushUnseccussfulTime = 0

	ZShelter.Director.HealthScaling = 1

	ZShelter.Director.TurretsBeforeNightSwitch = ZShelter.Director_GetTurretCount()
end

hook.Add("ZShelter-NightSwitch", "ZShelter-ResetDirectorVariables", function()
	if(GetConVar("zshelter_enable_director"):GetInt() != 1) then return end
	ZShelter.Director_ResetStats()
end)


hook.Add("ZShelter-DayPassed", "ZShelter-DirectorCalcExtendDayTime", function()
	if(GetConVar("zshelter_enable_director"):GetInt() != 1) then return end
	ZShelter.Director_ResetStats()
	ZShelter.Director_CalcExtendedTime()
end)

hook.Add("ZShelter-EnemyCreated", "ZShelter-ApplyDirectorBuff", function(enemy, night)
	if(GetConVar("zshelter_enable_director"):GetInt() != 1) then return end
	if(!night) then return end
	local scale = math.max(ZShelter.Director.HealthScaling, 1)
	local newhp = enemy:GetMaxHealth() * scale
	enemy:SetMaxHealth(newhp)
	enemy:SetHealth(newhp)
end)

function ZShelter.Director_SpawnHighHPEnemy()
	local data = ZShelter.FiltedNightHighHPEnemies
	local pos = ZShelter.ValidRaiderSpawnPoints[math.random(1, #ZShelter.ValidRaiderSpawnPoints)]
	if(!pos) then return end
	if(!data) then return end
	if(data.maxamount && data.maxamount != -1 && ZShelter.EnemyExistCounter[data.index] && data.maxamount <= ZShelter.EnemyExistCounter[data.index]) then return end
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
			return
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
		ZShelter.EnemyExistCounter[data.index] = ZShelter.EnemyExistCounter[data.index] + 1
		if(data.noclear) then
			enemy.ImmunityNightDamage = true
		end
	hook.Run("ZShelter-EnemyCreated", enemy, true)
end

hook.Add("ZShelter-SecondPassed", "ZShelter-RunMapDirector", function()
	--[[
	if(GetConVar("zshelter_enable_director"):GetInt() != 1 || !GetGlobalBool("Night")) then return end
	if(!ZShelter.Director.FirstHitOccurred) then
		if(ZShelter.Director.ExpectedFirstHitOccurrTime < CurTime()) then
			local diff = 1 + (GetConVar("zshelter_difficulty"):GetInt() * 0.055)
			local count = math.max(math.floor((GetGlobalInt("Day", 1) * 0.25) * diff), 1)
			for i = 1, (4 + count) do -- Spawn small horde of enemies
				ZShelter.SpawnNightEnemiesNoLimit()
			end
			ZShelter.Director.NextCheck = CurTime() + 10
			ZShelter.Director.FirstHitOccurred = true
		end
	else
		if(ZShelter.Director.NextCheck < CurTime()) then
			local damage = ZShelter.Director.TotalDamage
			local expected = ZShelter.Director.ExpectedDamage
			if(damage < expected) then
				if(damage < expected * 0.4) then -- Barely reaching the turret / base, make everything harder
					ZShelter.SpawnNightEnemiesNoLimit()
				end
				if(damage < expected) then
					ZShelter.Director.PushUnseccussfulTime = ZShelter.Director.PushUnseccussfulTime + 1
				end
				if(damage < expected * 0.8) then
					ZShelter.Director.HealthScaling = math.Clamp(ZShelter.Director.HealthScaling + 0.1, 1, 1.25)
				end
			else
				local scale = math.max(damage / expected, 1)
				ZShelter.Director.HealthScaling = math.Clamp(ZShelter.Director.HealthScaling - (0.1 * scale), 1, 1.25)
				ZShelter.Director.PushUnseccussfulTime = math.max(ZShelter.Director.PushUnseccussfulTime - 1, 0)
			end

			if(ZShelter.Director.PushUnseccussfulTime >= GetConVar("zshelter_director_push_failed_limit"):GetInt()) then
				if(table.Count(ZShelter.FiltedNightHighHPEnemies) > 0) then
					ZShelter.Director_SpawnHighHPEnemy()
				end
				ZShelter.Director.PushUnseccussfulTime = 0
			end

			ZShelter.Director.TotalDamage = 0
			ZShelter.Director.NextCheck = CurTime() + GetConVar("zshelter_director_check_interval"):GetInt()
		end
	end
	]]
end)