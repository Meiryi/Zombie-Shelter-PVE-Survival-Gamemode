-- Make crowbar a registered melee weapon so it'll be cleared when player upgraded their melee
ZShelter.RegisterMeleeWeapon("weapon_crowbar")

--[[ 
	
	-- Set day 15's message
	ZShelter.SetDayMessage(15, "Comm Tower can be used now!", Color(255, 255, 255, 255), true)

	-- Make plasma turret doesn't require any skills to build and deal ridiculous amount of damage
	ZShelter.AddBuildItem("Turret",  "Plasma Turret",  35,  35,  45,  1000,  "npc_vj_zshelter_plasma_turret",  "models/zshelter/shelter_b_laser_tower.mdl",  3,  Vector(0, 0, 0), 4, {
		damage = 16000,
	}, {}) 
]]