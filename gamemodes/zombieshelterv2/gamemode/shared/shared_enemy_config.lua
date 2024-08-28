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

ZShelter.EnemyConfig = {}

function ZShelter.AddEnemy(day, night_or_day, isboss, noclear, class, mutation, chance, attack, hp, end_day, maxamount, hp_boost_day, color, max_exists, min_difficulty, max_difficulty, weaponclass)
	if(!max_exists) then max_exists = -1 end
	if(!min_difficulty) then min_difficulty = -1 end
	if(!max_difficulty) then max_difficulty = -1 end
	if(!weaponclass) then weaponclass = "none" end
	table.insert(ZShelter.EnemyConfig, {
		day = day,
		night_or_day = night_or_day, -- true = night, false = day
		class = class,
		hp = hp,
		noclear = noclear,
		attack = attack,
		mutation = mutation,
		weaponclass = weaponclass,
		isboss = isboss, -- Boss for treasure area
		min_difficulty = min_difficulty,
		max_difficulty = max_difficulty,
		chance = chance, -- 1 ~ 100
		end_day = end_day, -- Leave -1 to spawn everyday
		max_amount = maxamount, -- Means how much this enemy can be spawn, leave -1 for no limit
		hp_boost_day = hp_boost_day,
		color = color,
		max_exists = max_exists,
	})
end

function ZShelter.CreateDefaultEnemies()
--[[
	ZShelter.AddEnemy(1, false, true, false, "npc_vj_zshelter_heavy_boss", "none", 100, 50, 5000, -1, -1, 350, Color(255, 255, 255, 255), -1, -1, -1)

	ZShelter.AddEnemy(1, false, false, false, "npc_vj_zshelter_common_h", "none", 100, 10, 100, -1, -1, 4, Color(255, 255, 255, 255), -1, -1, -1)
	ZShelter.AddEnemy(1, true, false, false, "npc_vj_zshelter_common_h", "none", 100, 15, 130, -1, -1, 4, Color(255, 255, 255, 255), -1, -1, -1)

	ZShelter.AddEnemy(3, false, false, false, "npc_vj_zshelter_common_o", "none", 100, 13, 150, -1, -1, 5, Color(255, 255, 255, 255), -1, -1, -1)
	ZShelter.AddEnemy(3, true, false, false, "npc_vj_zshelter_common_o", "none", 100, 20, 150, -1, -1, 7, Color(255, 255, 255, 255), -1, -1, -1)

	ZShelter.AddEnemy(4, true, false, false, "npc_vj_zshelter_deimos_h", "none", 100, 35, 2000, 5, 2, 20, Color(255, 255, 255, 255), -1, -1, -1)

	ZShelter.AddEnemy(4, false, false, false, "npc_vj_zshelter_light_h", "none", 100, 20, 80, -1, -1, 5, Color(255, 255, 255, 255), -1, -1, -1)
	ZShelter.AddEnemy(4, true, false, false, "npc_vj_zshelter_light_h", "none", 100, 25, 80, -1, -1, 5, Color(255, 255, 255, 255), -1, -1, -1)

	ZShelter.AddEnemy(5, false, false, false, "npc_vj_zshelter_light_o", "none", 100, 20, 80, -1, -1, 7, Color(255, 255, 255, 255), -1, -1, -1)
	ZShelter.AddEnemy(5, true, false, false, "npc_vj_zshelter_light_o", "none", 100, 25, 80, -1, -1, 7, Color(255, 255, 255, 255), -1, -1, -1)

	ZShelter.AddEnemy(5, true, false, false, "npc_vj_zshelter_heavy_boss", "none", 100, 40, 6500, 6, 1, 20, Color(255, 255, 255, 255), -1, -1, -1)

	ZShelter.AddEnemy(6, false, false, false, "npc_vj_zshelter_pycho", "none", 100, 15, 200, -1, -1, 5, Color(255, 255, 255, 255), -1, -1, -1)
	ZShelter.AddEnemy(6, true, false, false, "npc_vj_zshelter_pycho", "none", 100, 25, 200, -1, -1, 5, Color(255, 255, 255, 255), -1, -1, -1)
	ZShelter.AddEnemy(6, true, false, false, "npc_vj_zshelter_deimos_o", "none", 30, 35, 1500, 8, -1, 0, Color(255, 255, 255, 255), 1, -1, -1)

	ZShelter.AddEnemy(7, false, false, false, "npc_vj_zshelter_hooker", "none", 100, 15, 200, -1, -1, 5, Color(255, 255, 255, 255), -1, -1, -1)
	ZShelter.AddEnemy(7, true, false, false, "npc_vj_zshelter_hooker", "none", 100, 25, 200, -1, -1, 5, Color(255, 255, 255, 255), -1, -1, -1)
	ZShelter.AddEnemy(7, false, false, false, "npc_vj_zshelter_dog", "none", 100, 20, 120, -1, -1, 5, Color(255, 255, 255, 255), -1, -1, -1)
	ZShelter.AddEnemy(7, true, false, false, "npc_vj_zshelter_dog", "none", 100, 30, 120, -1, -1, 5, Color(255, 255, 255, 255), -1, -1, -1)
	ZShelter.AddEnemy(7, false, false, false, "npc_vj_zshelter_boomer_h", "none", 100, 35, 95, -1, -1, 5, Color(255, 255, 255, 255), -1, -1, -1)
	ZShelter.AddEnemy(7, true, false, false, "npc_vj_zshelter_boomer_h", "none", 100, 35, 95, -1, -1, 5, Color(255, 255, 255, 255), -1, -1, -1)
	ZShelter.AddEnemy(7, true, false, false, "npc_vj_zshelter_heavy_h", "none", 100, 25, 600, -1, -1, 5, Color(255, 255, 255, 255), -1, -1, -1)
	ZShelter.AddEnemy(7, true, false, false, "npc_vj_zshelter_boss_prototype_phobos_siege", "none", 100, 55, 8500, 8, 1, 0, Color(255, 255, 255, 255), -1, -1, -1)

	ZShelter.AddEnemy(8, false, false, false, "npc_vj_zshelter_heavy_o", "none", 100, 20, 500, -1, -1, 5, Color(255, 255, 255, 255), -1, -1, -1)
	ZShelter.AddEnemy(8, false, false, false, "npc_vj_zshelter_heavy_h", "none", 100, 20, 500, -1, -1, 5, Color(255, 255, 255, 255), -1, -1, -1)
	ZShelter.AddEnemy(8, true, false, false, "npc_vj_zshelter_heavy_o", "none", 100, 25, 650, -1, -1, 5, Color(255, 255, 255, 255), -1, -1, -1)
	ZShelter.AddEnemy(8, true, false, false, "npc_vj_zshelter_heavy_boss", "none", 100, 30, 7500, 9, 1, 20, Color(255, 255, 255, 255), -1, -1, -1)
	ZShelter.AddEnemy(8, true, false, false, "npc_vj_zshelter_deimos_o", "none", 30, 35, 2050, 12, -1, 0, Color(255, 255, 255, 255), 2, -1, -1)

	ZShelter.AddEnemy(9, false, false, false, "npc_vj_zshelter_boomer_o", "none", 100, 35, 95, -1, -1, 5, Color(255, 255, 255, 255), -1, -1, -1)
	ZShelter.AddEnemy(9, true, false, false, "npc_vj_zshelter_boomer_o", "none", 100, 35, 95, -1, -1, 5, Color(255, 255, 255, 255), -1, -1, -1)
	ZShelter.AddEnemy(9, true, false, false, "npc_vj_zshelter_heavy_boss", "none", 100, 40, 9000, 10, 2, 20, Color(255, 255, 255, 255), -1, -1, -1)
	ZShelter.AddEnemy(9, false, true, true, "npc_vj_zshelter_boss_prototype_phobos", "none", 100, 85, 20000, -1, -1, 1200, Color(255, 255, 255, 255), -1, -1, -1)
	ZShelter.AddEnemy(10, true, false, false, "npc_vj_zshelter_heavy_boss", "none", 10, 35, 5250, 12, 2, 0, Color(255, 255, 255, 255), 1, -1, -1)
	ZShelter.AddEnemy(10, true, false, false, "npc_vj_zshelter_dog", "none", 100, 30, 150, -1, -1, 5, Color(255, 255, 255, 255), -1, -1, -1)
	ZShelter.AddEnemy(10, true, false, false, "npc_vj_zshelter_boss_prototype_phobos_siege", "none", 100, 55, 11000, 11, 1, 0, Color(255, 255, 255, 255), -1, -1, -1)

	ZShelter.AddEnemy(12, true, false, false, "npc_vj_zshelter_deimos_o", "none", 30, 35, 2750, 16, -1, 0, Color(255, 255, 255, 255), 3, -1, -1)

	ZShelter.AddEnemy(13, true, false, false, "npc_vj_zshelter_boss_prototype_phobos_siege", "none", 100, 60, 12000, 14, 1, 0, Color(255, 255, 255, 255), -1, -1, -1)
	ZShelter.AddEnemy(13, true, false, false, "npc_vj_zshelter_heavy_boss", "none", 15, 35, 6250, 15, 3, 0, Color(255, 255, 255, 255), 2, -1, -1)

	ZShelter.AddEnemy(15, true, false, false, "npc_vj_zshelter_boss_prototype_phobos_siege", "none", 100, 40, 14500, 16, 1, 0, Color(255, 255, 255, 255), -1, -1, -1)
	ZShelter.AddEnemy(15, false, true, true, "npc_vj_zshelter_boss_prototype_phobos_siege", "none", 100, 85, 16500, -1, -1, 150, Color(255, 255, 255, 255), -1, -1, -1)
	ZShelter.AddEnemy(15, true, false, false, "npc_vj_zshelter_common_h", "none", 3, 35, 350, -1, -1, 4, Color(125, 40, 255, 255), -1, -1, -1)
	ZShelter.AddEnemy(15, true, false, false, "npc_vj_zshelter_heavy_boss", "none", 15, 35, 6250, 20, 4, 0, Color(255, 255, 255, 255), 2, -1, -1)

	ZShelter.AddEnemy(16, true, false, false, "npc_vj_zshelter_deimos_o", "none", 30, 35, 2750, 20, -1, 0, Color(255, 255, 255, 255), 4, -1, -1)
	ZShelter.AddEnemy(17, true, false, false, "npc_vj_zshelter_boss_prototype_phobos_siege", "none", 100, 70, 12500, 18, 1, 0, Color(255, 255, 255, 255), -1, -1, -1)

	ZShelter.AddEnemy(20, true, false, false, "npc_vj_zshelter_deimos_o", "none", 30, 35, 3000, 30, -1, 0, Color(255, 255, 255, 255), 5, -1, -1)
	ZShelter.AddEnemy(20, true, false, false, "npc_vj_zshelter_boss_prototype_phobos_siege", "none", 100, 70, 10500, -1, 2, 0, Color(255, 255, 255, 255), -1, -1, -1)
	ZShelter.AddEnemy(20, true, false, false, "npc_vj_zshelter_heavy_boss", "none", 15, 35, 6250, 31, 6, 0, Color(255, 255, 255, 255), 2, -1, -1)
]]

	--[[
		npc_vj_zshelter_common_h
		npc_vj_zshelter_common_o

		npc_vj_zshelter_light_h
		npc_vj_zshelter_light_o
		
		npc_vj_zshelter_heavy_h
		npc_vj_zshelter_heavy_o

		npc_vj_zshelter_deimos_h
		npc_vj_zshelter_deimos_o

		npc_vj_zshelter_pycho
		npc_vj_zshelter_hooker
		npc_vj_zshelter_dog

		npc_vj_zshelter_boomer_o
		npc_vj_zshelter_boomer_h

		npc_vj_zshelter_heavy_boss
		npc_vj_zshelter_boss_prototype_phobos
		npc_vj_zshelter_boss_prototype_phobos_siege
	]]

	-- day, night_or_day, isboss, noclear, class, mutation, chance, attack, hp, end_day, maxamount, hp_boost_day, color, max_exists, min_difficulty, max_difficulty

	-- Easy to Normal
	local CurMinDifficulty, CurMaxDifficulty = -1, 2

	ZShelter.AddEnemy(1, false, true, false, "npc_vj_zshelter_heavy_boss", "none", 100, 15, 1500, -1, -1, 100, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(1, false, false, false, "npc_vj_zshelter_common_h", "none", 100, 5, 55, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(1, true, false, false, "npc_vj_zshelter_common_h", "none", 100, 5, 55, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(3, false, false, false, "npc_vj_zshelter_common_o", "none", 100, 7, 75, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(3, true, false, false, "npc_vj_zshelter_common_o", "none", 100, 7, 85, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(4, false, false, false, "npc_vj_zshelter_light_h", "none", 100, 8, 95, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(4, true, false, false, "npc_vj_zshelter_light_h", "none", 100, 8, 95, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(5, false, false, false, "npc_vj_zshelter_light_o", "none", 100, 8, 95, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(5, true, false, false, "npc_vj_zshelter_light_o", "none", 100, 8, 95, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(15, true, false, false, "npc_vj_zshelter_boss_prototype_phobos", "none", 100, 10, 4500, 16, 1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)

	ZShelter.AddEnemy(10, false, true, false, "npc_vj_zshelter_boss_oberon", "none", 100, 25, 3200, -1, -1, 100, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)

	-- Normal
	CurMinDifficulty, CurMaxDifficulty = 2, 2

	ZShelter.AddEnemy(6, false, false, false, "npc_vj_zshelter_pycho", "none", 100, 10, 120, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(6, true, false, false, "npc_vj_zshelter_pycho", "none", 100, 10, 120, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(6, false, false, false, "npc_vj_zshelter_hooker", "none", 100, 12, 120, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(6, true, false, false, "npc_vj_zshelter_hooker", "none", 100, 12, 120, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(7, false, false, false, "npc_vj_zshelter_heavy_h", "none", 100, 10, 200, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(7, true, false, false, "npc_vj_zshelter_heavy_h", "none", 100, 10, 200, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(7, false, false, false, "npc_vj_zshelter_heavy_o", "none", 100, 10, 240, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(7, true, false, false, "npc_vj_zshelter_heavy_o", "none", 100, 10, 240, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(10, true, false, false, "npc_vj_zshelter_deimos_h", "none", 15, 4, 1000, 11, 2, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)

	-- Hard to Insane
	CurMinDifficulty, CurMaxDifficulty = 3, 5
	ZShelter.AddEnemy(1, false, true, false, "npc_vj_zshelter_heavy_boss", "none", 100, 15, 4500, -1, -1, 200, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(1, false, false, false, "npc_vj_zshelter_common_h", "none", 100, 8, 100, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(1, true, false, false, "npc_vj_zshelter_common_h", "none", 100, 8, 100, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(3, false, false, false, "npc_vj_zshelter_common_o", "none", 100, 10, 110, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(3, true, false, false, "npc_vj_zshelter_common_o", "none", 100, 10, 110, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(4, false, false, false, "npc_vj_zshelter_light_h", "none", 100, 11, 100, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(4, true, false, false, "npc_vj_zshelter_light_h", "none", 100, 11, 100, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(5, false, false, false, "npc_vj_zshelter_light_o", "none", 100, 11, 120, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(5, true, false, false, "npc_vj_zshelter_light_o", "none", 100, 11, 120, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(6, false, false, false, "npc_vj_zshelter_pycho", "none", 100, 12, 140, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(6, true, false, false, "npc_vj_zshelter_pycho", "none", 100, 12, 140, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(6, false, false, false, "npc_vj_zshelter_hooker", "none", 100, 12, 150, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(6, true, false, false, "npc_vj_zshelter_hooker", "none", 100, 12, 150, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(7, false, false, false, "npc_vj_zshelter_heavy_h", "none", 100, 10, 270, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(7, true, false, false, "npc_vj_zshelter_heavy_h", "none", 100, 10, 270, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(7, false, false, false, "npc_vj_zshelter_heavy_o", "none", 100, 10, 300, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(7, true, false, false, "npc_vj_zshelter_heavy_o", "none", 100, 10, 300, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)

	ZShelter.AddEnemy(5, true, false, false, "npc_vj_zshelter_deimos_h", "none", 15, 15, 1500, 6, 3, 0, Color(255, 255, 255, 255), 2, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(10, false, true, false, "npc_vj_zshelter_boss_oberon", "none", 100, 25, 8500, -1, -1, 100, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(10, true, false, false, "npc_vj_zshelter_boss_prototype_phobos", "none", 100, 10, 6500, 11, 1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(15, true, false, false, "npc_vj_zshelter_boss_prototype_phobos", "none", 100, 10, 6500, 16, 1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)

	-- Expert to Insane
	CurMinDifficulty, CurMaxDifficulty = 4, 5
	ZShelter.AddEnemy(7, false, false, false, "npc_vj_zshelter_boomer_o", "none", 100, 12, 100, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(7, true, false, false, "npc_vj_zshelter_boomer_o", "none", 100, 12, 100, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(7, false, false, false, "npc_vj_zshelter_boomer_o", "none", 100, 12, 110, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(7, true, false, false, "npc_vj_zshelter_boomer_o", "none", 100, 12, 110, -1, -1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)

	-- Expert
	CurMinDifficulty, CurMaxDifficulty = 4, 4
	ZShelter.AddEnemy(8, true, false, false, "npc_vj_zshelter_deimos_h", "none", 100, 15, 1500, 9, 2, 0, Color(255, 255, 255, 255), 2, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(15, true, false, false, "npc_vj_zshelter_deimos_h", "none", 15, 15, 1500, -1, -1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)

	-- Insane
	CurMinDifficulty, CurMaxDifficulty = 5, 5
	ZShelter.AddEnemy(7, true, false, false, "npc_vj_zshelter_deimos_h", "none", 100, 15, 1500, 8, 2, 0, Color(255, 255, 255, 255), 2, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(10, false, true, true, "npc_vj_zshelter_boss_prototype_phobos", "none", 100, 35, 7500, -1, -1, 100, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(10, true, false, false, "npc_vj_zshelter_deimos_h", "none", 35, 15, 1500, -1, -1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)

	-- Nightmare
	CurMinDifficulty, CurMaxDifficulty = 6, 6
	ZShelter.AddEnemy(1, false, true, false, "npc_vj_zshelter_heavy_boss", "none", 100, 15, 6500, -1, -1, 200, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(1, false, false, false, "npc_vj_zshelter_common_h", "none", 100, 10, 100, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(1, true, false, false, "npc_vj_zshelter_common_h", "none", 100, 10, 100, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(3, false, false, false, "npc_vj_zshelter_common_o", "none", 100, 12, 110, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(3, true, false, false, "npc_vj_zshelter_common_o", "none", 100, 12, 110, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(4, false, false, false, "npc_vj_zshelter_light_h", "none", 100, 13, 110, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(4, true, false, false, "npc_vj_zshelter_light_h", "none", 100, 13, 110, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(5, false, false, false, "npc_vj_zshelter_light_o", "none", 100, 13, 140, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(5, true, false, false, "npc_vj_zshelter_light_o", "none", 100, 13, 140, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(6, false, false, false, "npc_vj_zshelter_pycho", "none", 100, 12, 150, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(6, true, false, false, "npc_vj_zshelter_pycho", "none", 100, 12, 150, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(6, false, false, false, "npc_vj_zshelter_hooker", "none", 100, 12, 150, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(6, true, false, false, "npc_vj_zshelter_hooker", "none", 100, 12, 150, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(7, false, false, false, "npc_vj_zshelter_heavy_h", "none", 100, 10, 330, -1, -1, 5, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(7, true, false, false, "npc_vj_zshelter_heavy_h", "none", 100, 10, 330, -1, -1, 5, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(7, false, false, false, "npc_vj_zshelter_heavy_o", "none", 100, 10, 300, -1, -1, 5, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(7, true, false, false, "npc_vj_zshelter_heavy_o", "none", 100, 10, 300, -1, -1, 5, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(7, false, false, false, "npc_vj_zshelter_boomer_h", "none", 100, 12, 100, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(7, true, false, false, "npc_vj_zshelter_boomer_h", "none", 100, 12, 100, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(7, false, false, false, "npc_vj_zshelter_boomer_o", "none", 100, 12, 110, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(7, true, false, false, "npc_vj_zshelter_boomer_o", "none", 100, 12, 110, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(8, true, false, false, "npc_vj_zshelter_dog", "none", 100, 15, 140, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)

	ZShelter.AddEnemy(7, false, true, true, "npc_vj_zshelter_boss_prototype_phobos", "none", 100, 45, 7500, -1, -1, 100, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(10, false, true, false, "npc_vj_zshelter_boss_oberon", "none", 100, 40, 10500, -1, -1, 100, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(4, true, false, false, "npc_vj_zshelter_deimos_h", "none", 100, 15, 1600, 5, 2, 0, Color(255, 255, 255, 255), 2, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(5, true, false, false, "npc_vj_zshelter_heavy_boss", "none", 100, 15, 4000, 6, 1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(7, true, false, false, "npc_vj_zshelter_heavy_boss", "none", 100, 15, 4000, 8, 1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(10, true, false, false, "npc_vj_zshelter_boss_prototype_phobos_siege", "none", 100, 10, 5500, 11, 1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(8, true, false, false, "npc_vj_zshelter_deimos_h", "none", 100, 15, 1600, -1, -1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(12, true, false, false, "npc_vj_zshelter_deimos_o", "none", 100, 20, 2300, -1, -1, 0, Color(255, 255, 255, 255), 2, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(15, true, false, false, "npc_vj_zshelter_boss_prototype_phobos_siege", "none", 100, 10, 5500, 16, 1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(16, true, false, false, "npc_vj_zshelter_deimos_o", "none", 100, 20, 2300, -1, -1, 0, Color(255, 255, 255, 255), 2, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(18, true, false, false, "npc_vj_zshelter_boss_prototype_phobos_siege", "none", 100, 10, 6500, -1, 1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)

	-- Apocalypse to Apocalpyse+
	CurMinDifficulty, CurMaxDifficulty = 7, 8
	ZShelter.AddEnemy(1, false, true, false, "npc_vj_zshelter_heavy_boss", "none", 100, 15, 6800, -1, -1, 200, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(1, false, false, false, "npc_vj_zshelter_common_h", "none", 100, 10, 110, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(1, true, false, false, "npc_vj_zshelter_common_h", "none", 100, 10, 110, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(2, false, false, false, "npc_vj_zshelter_common_o", "none", 100, 12, 160, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(2, true, false, false, "npc_vj_zshelter_common_o", "none", 100, 12, 160, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(3, false, false, false, "npc_vj_zshelter_light_h", "none", 100, 13, 110, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(3, true, false, false, "npc_vj_zshelter_light_h", "none", 100, 13, 110, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(3, false, false, false, "npc_vj_zshelter_light_o", "none", 100, 13, 140, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(3, true, false, false, "npc_vj_zshelter_light_o", "none", 100, 13, 140, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(4, false, false, false, "npc_vj_zshelter_pycho", "none", 100, 12, 150, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(4, true, false, false, "npc_vj_zshelter_pycho", "none", 100, 12, 150, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(5, false, false, false, "npc_vj_zshelter_hooker", "none", 100, 12, 150, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(5, true, false, false, "npc_vj_zshelter_hooker", "none", 100, 12, 150, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(6, false, false, false, "npc_vj_zshelter_heavy_h", "none", 100, 10, 400, -1, -1, 5, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(6, true, false, false, "npc_vj_zshelter_heavy_h", "none", 100, 10, 400, -1, -1, 5, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(6, false, false, false, "npc_vj_zshelter_heavy_o", "none", 100, 10, 400, -1, -1, 5, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(6, true, false, false, "npc_vj_zshelter_heavy_o", "none", 100, 10, 400, -1, -1, 5, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(7, false, false, false, "npc_vj_zshelter_boomer_h", "none", 100, 25, 150, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(7, true, false, false, "npc_vj_zshelter_boomer_h", "none", 100, 25, 150, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(7, false, false, false, "npc_vj_zshelter_boomer_o", "none", 100, 25, 150, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(7, true, false, false, "npc_vj_zshelter_boomer_o", "none", 100, 25, 150, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(7, true, false, false, "npc_vj_zshelter_dog", "none", 100, 15, 150, -1, -1, 2, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)

	ZShelter.AddEnemy(7, false, true, true, "npc_vj_zshelter_boss_prototype_phobos", "none", 100, 65, 7800, -1, -1, 300, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(10, false, true, false, "npc_vj_zshelter_boss_oberon", "none", 100, 35, 12000, -1, -1, 100, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(4, true, false, false, "npc_vj_zshelter_deimos_h", "none", 100, 15, 2000, 5, 2, 0, Color(255, 255, 255, 255), 2, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(5, true, false, false, "npc_vj_zshelter_heavy_boss", "none", 100, 15, 5000, 6, 1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(7, true, false, false, "npc_vj_zshelter_boss_prototype_phobos_siege", "none", 100, 10, 5500, 8, 1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(10, true, false, false, "npc_vj_zshelter_boss_prototype_phobos_siege", "none", 100, 10, 6500, 11, 1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(8, true, false, false, "npc_vj_zshelter_deimos_h", "none", 100, 15, 1600, -1, -1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(10, true, false, false, "npc_vj_zshelter_deimos_o", "none", 100, 20, 2300, -1, -1, 0, Color(255, 255, 255, 255), 2, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(15, true, false, false, "npc_vj_zshelter_boss_prototype_phobos_siege", "none", 100, 10, 5500, 16, 1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(13, true, false, false, "npc_vj_zshelter_deimos_o", "none", 100, 20, 2300, -1, -1, 0, Color(255, 255, 255, 255), 2, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(16, true, false, false, "npc_vj_zshelter_boss_prototype_phobos_siege", "none", 100, 10, 5500, -1, 1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)

	-- Hell
	CurMinDifficulty, CurMaxDifficulty = 9, 9
	ZShelter.AddEnemy(1, false, true, false, "npc_vj_zshelter_heavy_boss", "none", 100, 15, 7000, -1, -1, 200, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(1, false, false, false, "npc_vj_zshelter_common_h", "none", 100, 12, 110, -1, -1, 8, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(1, true, false, false, "npc_vj_zshelter_common_h", "none", 100, 12, 110, -1, -1, 8, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(2, false, false, false, "npc_vj_zshelter_common_o", "none", 100, 14, 170, -1, -1, 3, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(2, true, false, false, "npc_vj_zshelter_common_o", "none", 100, 14, 170, -1, -1, 3, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(2, false, false, false, "npc_vj_zshelter_light_h", "none", 100, 13, 110, -1, -1, 3, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(2, true, false, false, "npc_vj_zshelter_light_h", "none", 100, 13, 110, -1, -1, 3, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(2, false, false, false, "npc_vj_zshelter_light_o", "none", 100, 13, 140, -1, -1, 3, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(2, true, false, false, "npc_vj_zshelter_light_o", "none", 100, 13, 140, -1, -1, 3, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(3, false, false, false, "npc_vj_zshelter_pycho", "none", 100, 12, 170, -1, -1, 3, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(3, true, false, false, "npc_vj_zshelter_pycho", "none", 100, 12, 170, -1, -1, 3, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(3, false, false, false, "npc_vj_zshelter_hooker", "none", 100, 12, 170, -1, -1, 3, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(3, true, false, false, "npc_vj_zshelter_hooker", "none", 100, 12, 170, -1, -1, 3, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(5, false, false, false, "npc_vj_zshelter_heavy_h", "none", 100, 10, 550, -1, -1, 35, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(5, true, false, false, "npc_vj_zshelter_heavy_h", "none", 100, 10, 550, -1, -1, 35, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(5, false, false, false, "npc_vj_zshelter_heavy_o", "none", 100, 10, 550, -1, -1, 35, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(5, true, false, false, "npc_vj_zshelter_heavy_o", "none", 100, 10, 550, -1, -1, 35, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(5, true, false, false, "npc_vj_zshelter_dog", "none", 100, 15, 150, -1, -1, 8, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(6, false, false, false, "npc_vj_zshelter_boomer_h", "none", 100, 25, 170, -1, -1, 3, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(6, true, false, false, "npc_vj_zshelter_boomer_h", "none", 100, 25, 170, -1, -1, 3, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(6, false, false, false, "npc_vj_zshelter_boomer_o", "none", 100, 25, 170, -1, -1, 3, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(6, true, false, false, "npc_vj_zshelter_boomer_o", "none", 100, 25, 170, -1, -1, 3, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)

	ZShelter.AddEnemy(6, false, true, true, "npc_vj_zshelter_boss_prototype_phobos_siege", "none", 100, 90, 21500, -1, -1, 500, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(9, false, true, false, "npc_vj_zshelter_boss_oberon", "none", 100, 95, 32500, -1, -1, 1000, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)

	ZShelter.AddEnemy(3, true, false, false, "npc_vj_zshelter_deimos_h", "none", 100, 15, 2300, 4, 1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(4, true, false, false, "npc_vj_zshelter_deimos_o", "none", 100, 25, 2600, 5, 2, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(5, true, false, false, "npc_vj_zshelter_deimos_o", "none", 100, 25, 3000, -1, -1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(5, true, false, false, "npc_vj_zshelter_heavy_boss", "none", 100, 15, 6300, 6, 1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(6, true, false, false, "npc_vj_zshelter_deimos_o", "none", 100, 20, 1800, 8, -1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(7, true, false, false, "npc_vj_zshelter_boss_prototype_phobos_siege", "none", 100, 35, 9000, 8, 1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(7, true, false, false, "npc_vj_zshelter_deimos_o", "none", 100, 20, 2500, 10, -1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(8, true, false, false, "npc_vj_zshelter_heavy_boss", "none", 100, 15, 5800, -1, -1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(8, true, false, false, "npc_vj_zshelter_dog", "none", 100, 30, 150, -1, -1, 8, Color(255, 0, 0, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(9, true, false, false, "npc_vj_zshelter_boss_prototype_phobos_siege", "none", 100, 10, 10000, 10, 1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(10, true, false, false, "npc_vj_zshelter_heavy_o", "none", 100, 35, 550, -1, -1, 35, Color(255, 0, 0, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(10, true, false, false, "npc_vj_zshelter_heavy_boss", "none", 40, 35, 4000, -1, -1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(10, true, false, false, "npc_vj_zshelter_deimos_o", "none", 100, 20, 2500, -1, -1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(11, true, false, false, "npc_vj_zshelter_deimos_o", "none", 100, 45, 4500, -1, -1, 0, Color(255, 0, 0, 255), 1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(10, true, false, false, "npc_vj_zshelter_boss_oberon", "none", 100, 90, 16000, 11, 1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(12, true, false, false, "npc_vj_zshelter_boss_prototype_phobos_siege", "none", 100, 13, 11500, 10, 1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(12, true, false, false, "npc_vj_zshelter_boss_oberon", "none", 100, 90, 18000, 13, 1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(12, true, false, false, "npc_vj_zshelter_deimos_o", "none", 100, 20, 2500, -1, -1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(13, true, false, false, "npc_vj_zshelter_deimos_o", "none", 100, 45, 5500, -1, -1, 0, Color(255, 0, 0, 255), 2, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(16, true, false, false, "npc_vj_zshelter_deimos_o", "none", 100, 20, 2000, -1, -1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(16, true, false, false, "npc_vj_zshelter_boss_oberon", "none", 100, 90, 20000, 17, 1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(10, true, false, false, "npc_vj_zshelter_heavy_boss", "none", 10, 35, 4000, -1, -1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(12, true, false, false, "npc_vj_zshelter_heavy_boss", "none", 40, 35, 4000, -1, -1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(14, true, false, false, "npc_vj_zshelter_boss_prototype_phobos_siege", "none", 100, 10, 8500, 15, 1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(15, true, false, false, "npc_vj_zshelter_boss_prototype_phobos_siege", "none", 100, 10, 8500, -1, 1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(16, true, false, false, "npc_vj_zshelter_deimos_o", "none", 100, 45, 5500, -1, -1, 0, Color(255, 0, 0, 255), 2, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(18, true, false, false, "npc_vj_zshelter_heavy_boss", "none", 40, 35, 4000, -1, -1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(18, true, false, false, "npc_vj_zshelter_boss_oberon", "none", 100, 100, 24000, -1, -1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(18, true, false, false, "npc_vj_zshelter_deimos_o", "none", 100, 45, 5500, -1, -1, 0, Color(255, 0, 0, 255), 2, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(17, true, false, false, "npc_vj_zshelter_deimos_o", "none", 100, 20, 2500, -1, -1, 0, Color(255, 255, 255, 255), 1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(19, true, false, false, "npc_vj_zshelter_boss_prototype_phobos_siege", "none", 100, 10, 8500, -1, 1, 0, Color(255, 255, 255, 255), -1, CurMinDifficulty, CurMaxDifficulty)
	ZShelter.AddEnemy(20, true, false, false, "npc_vj_zshelter_deimos_o", "none", 100, 45, 5500, -1, -1, 0, Color(255, 0, 0, 255), 5, CurMinDifficulty, CurMaxDifficulty)

	if(!file.Exists("zombie shelter v2/enemy.txt", "DATA")) then
		ZShelter.WriteEnemyConfig()
	end
end

function ZShelter.WriteEnemyConfig()
	file.Write("zombie shelter v2/enemy.txt", util.TableToJSON(ZShelter.EnemyConfig, true))
end

function ZShelter.CheckLocalEnemyConfig()
	if(file.Exists("zombie shelter v2/enemy.txt", "DATA")) then
		local ret = util.JSONToTable(file.Read("zombie shelter v2/enemy.txt", "DATA"))
		if(ret) then
			if(table.Count(ret) > 0) then
				ZShelter.EnemyConfig = ret
			else
				ZShelter.CreateDefaultEnemies()
			end
		else
			ZShelter.CreateDefaultEnemies()
		end
	else
		ZShelter.CreateDefaultEnemies()
	end
end

if(GetConVar("zshelter_default_enemy_config"):GetInt() == 1) then -- default config
	ZShelter.CreateDefaultEnemies()
else
	local configdir = GetConVar("zshelter_config_name"):GetString()
	if(configdir != "") then
		local load = false
		for k,v in ipairs(ZShelter.ConfigCheckOrder) do
			local ctx = file.Read(v.."/zombie shelter v2/config/"..configdir.."/enemy.txt", "GAME")
			if(ctx) then
				local ret = util.JSONToTable(ctx)
				if(ret && table.Count(ret) > 0) then
					ZShelter.EnemyConfig = ret
					load = true
					print("[Zombie Shelter] Custom enemy config loaded! : ", configdir)
					break
				end
			end
		end
		if(!load) then
			ZShelter.CheckLocalEnemyConfig()
		end
	else
		ZShelter.CheckLocalEnemyConfig()
	end
end