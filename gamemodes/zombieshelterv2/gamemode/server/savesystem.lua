ZShelter.GameSave = ZShelter.GameSave || {}
ZShelter.LoadedSave = ZShelter.LoadedSave || false

function ZShelter.SaveGame()
	local shelter = ZShelter.Shelter
	if(!IsValid(shelter)) then return end
	local data = {
		map = game.GetMap(),
		day = GetGlobalInt("Day", 0),
		woods = GetGlobalInt("Woods", 0),
		irons = GetGlobalInt("Irons", 0),
		powers = GetGlobalInt("Powers", 0),
		shelterlevel = GetGlobalInt("ShelterLevel", 0),
		capacity = GetGlobalInt("Capacity", 0),
		playerdata = {},
		shelterdata = {
			pos = shelter:GetPos(),
			ang = shelter:GetAngles(),
			health = shelter:Health(),
			maxhealth = shelter:GetMaxHealth(),
			model = shelter:GetModel(),
		},
	}

	for _, ply in pairs(player.GetAll()) do
		local weps = {}
		for _, wep in ipairs(ply:GetWeapons()) do
			table.insert(weps, wep:GetClass())
		end
		data.playerdata[ply:SteamID()] = {
			health = ply:Health(),
			maxhealth = ply:GetMaxHealth(),
			armor = ply:Armor(),
			maxarmor = ply:GetMaxArmor(),
			weapons = weps,
			woods = ply:GetNWInt("Woods", 0),
			irons = ply:GetNWInt("Irons", 0),
			skillpoints = ply:GetNWInt("SkillPoints", 0),
			skilldata = {
				skillpointSpent = {}, 
				skills = {},
			},
			nwvars = {},
			ownedbuilding = {},
		}

		for class, skilldata in pairs(ZShelter.SkillList) do
			local index = class.."SkillSpent"
			local totalSpent = 0
			for tier, skills in pairs(skilldata) do
				for idx, skill in pairs(skills) do
					local spent = ply:GetNWInt("SK_"..skill.title, 0)
					data.playerdata[ply:SteamID()].skilldata.skills[skill.title] = {
						spent = spent,
						tier = tier,
					}
					totalSpent = totalSpent + spent
				end
			end
			data.playerdata[ply:SteamID()].skilldata.skillpointSpent[index] = totalSpent
		end
		data.playerdata[ply:SteamID()].nwvars = ply:GetNWVarTable()
		for _, ent in ipairs(ents.GetAll()) do
			if(!ent.IsBuilding || ent.Builder != ply) then continue end
			table.insert(data.playerdata[ply:SteamID()].ownedbuilding, {
				pos = ent:GetPos(),
				ang = ent:GetAngles(),
				model = ent:GetModel(),
				class = ent:GetClass(),
				health = ent:Health(),
				attackdamage = ent.AttackDamage || 0,
				completed = ent:GetNWBool("Completed", false),
				nooffsetpos = ent:GetNWVector("NoOffsetPos"),
				maxhealth = ent:GetMaxHealth(),
				nwvars = ent:GetNWVarTable(),
				index = ent:GetNWString("Name", "nil").."/"..ent:GetClass().."/"..ent:GetModel(),
			})
		end
	end

	local ctx = util.TableToJSON(data, true)
	print("Save file created with "..#ctx.." Bytes")
	file.Write("zombie shelter v2/saves/"..game.GetMap()..".dat", ctx)
end

ZShelter.BuildingsFromSave = {}
function ZShelter.LoadSave()
	local save = file.Read("zombie shelter v2/saves/"..game.GetMap()..".dat", "DATA")
	if(!save) then return end
	local data = util.JSONToTable(save)
	if(!data) then return end
	for steamid, plydata in pairs(data.playerdata) do
		local dummyEnt = ents.Create("obj_internal_thinker")
		dummyEnt:Spawn()
		dummyEnt.Think = function() end
		for nwindex, nwvar in pairs(plydata.nwvars) do
			dummyEnt:SetNWString(nwindex, nwvar)
		end
		for _, building in pairs(plydata.ownedbuilding) do
			local data = ZShelter.BuildingData_Class[building.index]
			if(!data) then continue end
			if(!ZShelter.BuildingsFromSave[steamid]) then
				ZShelter.BuildingsFromSave[steamid] = {}
			end
			local ent = ZShelter.CreateBuilding(dummyEnt, data, building.nooffsetpos, building.ang.y)
			if(building.completed) then
				ent:SetNWBool("Completed", true)
				ent:SetColor(Color(255, 255, 255, 255))
				ent:NextThink(CurTime())
			else
				ent:SetColor(Color(255, 255, 255, 180))
			end
			ent.AttackDamage = building.attackdamage
			ent:SetHealth(building.health)
			ent:SetMaxHealth(building.maxhealth)
			for nwindex, nwvar in pairs(building.nwvars) do
				ent:SetNWString(nwindex, nwvar)
			end

			table.insert(ZShelter.BuildingsFromSave[steamid], ent)
		end
		dummyEnt:Remove()
		ZShelter.GameSave = data
	end

	ZShelter.CreateSaveShelter(data.shelterdata)

	SetGlobalInt("Day", data.day)
	SetGlobalInt("Woods", data.woods)
	SetGlobalInt("Irons", data.irons)
	SetGlobalInt("Powers", data.powers)
	SetGlobalInt("ShelterLevel", data.shelterlevel)
	SetGlobalInt("Capacity", data.capacity)
end

function ZShelter.LoadPlayerSaveData(player)
	local steamid = player:SteamID()

	-- restore owners
	if(ZShelter.BuildingsFromSave[steamid]) then
		for _, ent in pairs(ZShelter.BuildingsFromSave[steamid]) do
			ent.Builder = player
			if(!ent.NoOwner || ent.ForceOwner) then
				ent:SetOwner(player)
			end
		end
	end

	-- restore player data
	if(!ZShelter.GameSave.playerdata || !ZShelter.GameSave.playerdata[steamid]) then return end
	local plydata = ZShelter.GameSave.playerdata[steamid]
	--[[
		health = ply:Health(),
		maxhealth = ply:GetMaxHealth(),
		armor = ply:Armor(),
		maxarmor = ply:GetMaxArmor(),
		weapons = weps,
		skillpoints = ply:GetNWInt("SkillPoints", 0),
		skilldata = {
			skillpointSpent = {}, 
			skills = {},
		},
	]]

	player:SetHealth(plydata.health)
	player:SetMaxHealth(plydata.maxhealth)
	player:SetArmor(plydata.armor)
	player:SetMaxArmor(plydata.maxarmor)
	player:SetNWInt("SkillPoints", plydata.skillpoints)
	player:SetNWInt("Woods", plydata.woods)
	player:SetNWInt("Irons", plydata.irons)

	for skillSpent, value in pairs(plydata.skilldata.skillpointSpent) do
		player:SetNWInt(skillSpent, value)
	end

	for title, skilldata in pairs(plydata.skilldata.skills) do
		local skill = ZShelter.SkillDatas[title]
		if(!skill || skilldata.spent <= 0) then continue end
		for i = 1, skilldata.spent do
			ZShelter.ApplySkill(player, skilldata.tier, skill)
		end
	end
end

function ZShelter.CreateSaveShelter(shelterData)
	pos = shelterData.pos
	angle = shelterData.ang

	local hitpos = util.QuickTrace(pos,  Vector(0, 0, -32767)).HitPos

	local shelter = ents.Create("prop_physics")
		shelter:SetPos(hitpos)
		shelter:SetAngles(angle)
		shelter:SetModel("models/shigure/shelter_b_shelter02.mdl")

		shelter:Spawn()

		shelter:SetMaxHealth(1250)
		shelter:SetHealth(1250)
		shelter:SetNWBool("IsBuilding", true)
		shelter:SetNWBool("NoPlayerDamage", true)
		shelter:SetNWBool("Completed", true)
		shelter:SetNWString("Name", "Shelter")

		shelter.Level = 1
		shelter.IsShelter = true
		shelter.IsPlayerBarricade = true

		shelter.bait = ents.Create("npc_vj_zshelter_shelter_hitbox")
			shelter.bait:SetPos(shelter:GetPos())
			shelter.bait:SetAngles(shelter:GetAngles())
			shelter.bait:Spawn()
			shelter.bait:SetCollisionGroup(1)
			shelter.bait:SetNWBool("IsBuilding", true)
			shelter.bait:SetNWBool("NoPlayerDamage", true)
			shelter.bait:SetNWBool("Completed", true)
			shelter.bait:SetNoDraw(true)
			shelter.bait:SetOwner(shelter)
		local e = shelter.bait
		shelter.bait.Think = function()
			if(!IsValid(shelter)) then
				e:Remove()
				return
			end
			for k,v in pairs(ents.FindInSphere(shelter:GetPos(), 1024)) do
				if(!v:IsPlayer() || !v:Alive()) then continue end
				ZShelter.AddSanity(v, 15)
				v:SetNWFloat("SanityCostImmunityTime", CurTime() + 3)
			end
			shelter.bait:NextThink(CurTime() + 1)
			return true
		end

		local phys = shelter:GetPhysicsObject()

		if(IsValid(phys)) then
			phys:EnableMotion(false)
		end

		shelter:SetModel(shelterData.model)
		shelter:SetHealth(shelterData.health)
		shelter:SetMaxHealth(shelterData.maxhealth)

		ZShelter.Shelter = shelter
		ZShelter.ShelterInited = true
		ZShelter.Shelter.IsBuilding = true
		ZShelter.SpawnPos = shelter:GetPos() + (ZShelter.Shelter:GetAngles():Right() * 25 - ZShelter.Shelter:GetAngles():Forward() * 175)
		SetGlobalEntity("ShelterEntity", ZShelter.Shelter)

		ZShelter.CreateStorageEntity(ZShelter.Shelter)

		ZShelter.CreateBarricades()
		ZShelter.ForceReloadPoints()
end