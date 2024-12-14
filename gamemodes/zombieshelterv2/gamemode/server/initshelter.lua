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

ZShelter.Shelter = ZShelter.Shelter || nil
ZShelter.ShelterIndex = ZShelter.ShelterIndex || -1
ZShelter.SpawnPos = ZShelter.SpawnPos || nil
ZShelter.FogController = ZShelter.FogController || nil
ZShelter.MapEntitiesCreatedBySystem = ZShelter.MapEntitiesCreatedBySystem || {}
ZShelter.ShelterInited = false

function ZShelter.CreateStorageEntity(shelter)
	local storages = {
		(shelter:GetPos() + shelter:GetRight() * 210 - shelter:GetForward() * 40),
		(shelter:GetPos() + shelter:GetRight() * 210 - shelter:GetForward() * 280)
	}
	local mins, maxs = Vector(-40, -40, 0), Vector(40, 40, 120)
	for k,v in ipairs(storages) do
		local storageEnt = ents.Create("obj_internal_storage")
			storageEnt:SetPos(v)
			storageEnt:SetOwner(shelter)
			storageEnt:Spawn()
			storageEnt:SetAngles(shelter:GetAngles())
			storageEnt:SetCollisionGroup(2)
			storageEnt:SetCollisionBounds(mins, maxs)
			storageEnt:PhysicsInitBox(mins, maxs)
			storageEnt.Position = v
	end
end

function ZShelter.InitShelter()
	if(IsValid(ZShelter.Shelter) || ZShelter.ShelterInited) then return end

	for k,v in pairs(ZShelter.MapEntitiesCreatedBySystem) do
		if(IsValid(v)) then
			print("Removing previous created map entities : ", v)
			v:Remove()
		end
		ZShelter.MapEntitiesCreatedBySystem[k] = nil
	end
	if(!ZShelter.IsCurrentMapSupported()) then
		local cfg = ZShelter.GetCurrentMapConfig()
		if(!cfg) then
			ZShelter.BroadcastMapStats(true)
			ZShelter.UnsupportedMap = true
			GetConVar("zshelter_debug_enable_sandbox"):SetInt(1)
			return
		else
			ZShelter.BroadcastMapStats(false)
			ZShelter.UnsupportedMap = false
			for k,v in pairs(cfg) do
				for x,y in pairs(v) do
					if(!y.vec || !y.yaw || !y.class) then continue end
					local ent = ents.Create(y.class)
						ent:SetPos(y.vec)
						ent:SetAngles(Angle(0, y.yaw, 0))
					table.insert(ZShelter.MapEntitiesCreatedBySystem, ent)
				end
			end
		end
	end

	local pos = Vector(0, 0, 0)
	local angle = Angle(0, 0, 0)
	local index = -1
	local lists = {}
	for k,v in pairs(ents.FindByClass("info_zshelter_shelter_position")) do
		table.insert(lists, v)
	end
	if(#lists <= 0) then return end

	local selected = lists[math.random(1, #lists)]
	pos = selected:GetPos()
	angle = selected:GetAngles()
	index = selected.ShelterIndex

	if(pos == Vector(0, 0, 0)) then return end

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
			for k,v in pairs(ents.FindInSphere(shelter:GetPos(), 1500)) do
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

		ZShelter.Shelter = shelter
		ZShelter.ShelterIndex = index
		ZShelter.ShelterInited = true
		ZShelter.Shelter.IsBuilding = true
		ZShelter.SpawnPos = shelter:GetPos() + (ZShelter.Shelter:GetAngles():Right() * 25 - ZShelter.Shelter:GetAngles():Forward() * 175)
		SetGlobalEntity("ShelterEntity", ZShelter.Shelter)

		ZShelter.CreateStorageEntity(ZShelter.Shelter)

		ZShelter.CreateBarricades()
		ZShelter.ForceReloadPoints()
end

function ZShelter.SetupFog()
	if(IsValid(ZShelter.FogController) || GetConVar("zshelter_enable_fog"):GetInt() != 1) then return end
	local fog = ents.Create("env_fog_controller")
	fog:SetKeyValue("farz", 2100)
	ZShelter.FogController = fog
end

function ZShelter.RecreateBarricades()
	local hp = 25000 * (1 + (GetConVar("zshelter_difficulty"):GetInt() * 0.15))
	for k,v in pairs(ents.FindByClass("prop_zshelter_obstacle")) do
		if(IsValid(ZShelter.Barricades[k])) then
			ZShelter.Barricades[k]:Remove()
		end
		local barricade = ents.Create("prop_physics")
			barricade:SetPos(v:GetPos())
			barricade:SetAngles(v:GetAngles())
			barricade:SetModel("models/props_wasteland/cargo_container01.mdl")

			barricade:Spawn()

			barricade:SetMaxHealth(hp)
			barricade:SetHealth(hp)
			barricade:SetNWBool("IsBuilding", true)
			barricade:SetNWBool("IsBait", true)
			barricade:SetNWBool("IsMapBarricade", true)
			barricade:SetNWBool("Completed", true)
			barricade:SetNWString("Name", "Barricade")
			barricade:SetRenderMode(RENDERMODE_TRANSCOLOR)

			barricade.IsBarricade = true
			barricade.IgnoreCollision = false

			barricade:AddFlags(65536)
			barricade:SetCollisionGroup(COLLISION_GROUP_BREAKABLE_GLASS)
			barricade:SetCustomCollisionCheck(true)

			local barricade2x = ents.Create("prop_physics")
				barricade2x:SetPos(barricade:GetPos() + Vector(0, 0, 128))
				barricade2x:SetAngles(barricade:GetAngles())
				barricade2x:SetModel(barricade:GetModel())
				barricade2x.IsBarricade = true
				barricade2x.IgnoreCollision = false
				barricade2x:AddFlags(65536)
				barricade2x:SetCollisionGroup(COLLISION_GROUP_BREAKABLE_GLASS)
				barricade2x:SetCustomCollisionCheck(true)
				barricade2x:Spawn()
				barricade2x:SetMaxHealth(2147483647)
				barricade2x:SetHealth(2147483647)
				barricade2x:SetNoDraw(true)
				local phys = barricade2x:GetPhysicsObject()
				if(IsValid(phys)) then
					phys:EnableMotion(false)
				end
				barricade2x:SetNWBool("Completed", true)
				ZShelter.CreateRemovelThinker(barricade2x, function()
					if(!IsValid(barricade)) then
						barricade2x:Remove()
					end
				end, 0.33)

			local phys = barricade:GetPhysicsObject()
			if(IsValid(phys)) then
				phys:EnableMotion(false)
			end

			ZShelter.Barricades[k] = barricade
	end
end

ZShelter.Barricades = ZShelter.Barricades || {}
function ZShelter.CreateBarricades()
	local scale = (1 + (GetConVar("zshelter_difficulty"):GetInt() * 0.15))
	local scale_breakable = (1 + (GetConVar("zshelter_difficulty"):GetInt() * 0.175))
	local hp = 25000 * scale

	for _, barricade in ipairs(ents.FindByClass("func_breakable")) do
		if(!barricade.OriginalHealth) then
			barricade.OriginalHealth = barricade:GetMaxHealth()
		end
		local health = barricade.OriginalHealth * scale_breakable
		barricade:SetMaxHealth(health)
		barricade:SetHealth(health)
	end

	for k,v in pairs(ents.FindByClass("prop_zshelter_obstacle")) do
		if(IsValid(ZShelter.Barricades[k])) then continue end
		local barricade = ents.Create("prop_physics")
			barricade:SetPos(v:GetPos())
			barricade:SetAngles(v:GetAngles())
			barricade:SetModel("models/props_wasteland/cargo_container01.mdl")

			barricade:Spawn()

			barricade:SetMaxHealth(hp)
			barricade:SetHealth(hp)
			barricade:SetNWBool("IsBuilding", true)
			barricade:SetNWBool("Completed", true)
			barricade:SetNWString("Name", "Barricade")
			barricade:SetRenderMode(RENDERMODE_TRANSCOLOR)

			barricade.IsBarricade = true
			barricade.IgnoreCollision = false

			barricade:AddFlags(65536)
			barricade:SetCollisionGroup(COLLISION_GROUP_BREAKABLE_GLASS)
			barricade:SetCustomCollisionCheck(true)

			local barricade2x = ents.Create("prop_physics")
				barricade2x:SetPos(barricade:GetPos() + Vector(0, 0, 128))
				barricade2x:SetAngles(barricade:GetAngles())
				barricade2x:SetModel(barricade:GetModel())
				barricade2x.IsBarricade = true
				barricade2x.IgnoreCollision = false
				barricade2x:AddFlags(65536)
				barricade2x:SetCollisionGroup(COLLISION_GROUP_BREAKABLE_GLASS)
				barricade2x:SetCustomCollisionCheck(true)
				barricade2x:Spawn()
				barricade2x:SetMaxHealth(2147483647)
				barricade2x:SetHealth(2147483647)
				barricade2x:SetNoDraw(true)
				local phys = barricade2x:GetPhysicsObject()
				if(IsValid(phys)) then
					phys:EnableMotion(false)
				end
				barricade2x:SetNWBool("Completed", true)
				ZShelter.CreateRemovelThinker(barricade2x, function()
					if(!IsValid(barricade)) then
						barricade2x:Remove()
					end
				end, 0.33)

			local phys = barricade:GetPhysicsObject()
			if(IsValid(phys)) then
				phys:EnableMotion(false)
			end


			ZShelter.Barricades[k] = barricade
	end
end

hook.Add("EntityRemoved", "ZShelter-HandleFail", function(ent)
	if(ent == GetGlobalEntity("ShelterEntity")) then
		ZShelter.AddFailCount(GetGlobalInt("Day", 1), GetConVar("zshelter_difficulty"):GetInt())
		ZShelter.BroadcastEnd(false, "#Defeat", "#ShelterDestroyed")
		hook.Run("ZShelter-OnLosingRound")
	end
end)

function ZShelter.ShouldLoadSave()
	local ctx = file.Read("zombie shelter v2/loadsave.txt", "DATA")
	if(ctx == "true" && math.abs(file.Time("zombie shelter v2/loadsave.txt", "DATA") - os.time()) < 150) then
		local save = file.Read("zombie shelter v2/saves/"..game.GetMap()..".dat", "DATA")
		if(!save) then return end
		local data = util.JSONToTable(save)
		if(!data) then return end
		return true
	end
end

local loaded = false
hook.Add( "PlayerInitialSpawn", "ZShelter-InitShelter", function(ply)
	if(!ZShelter.LoadedSave) then
		ZShelter.LoadedSave = ZShelter.ShouldLoadSave()
		file.Delete("zombie shelter v2/loadsave.txt")
	end
	if(!ZShelter.LoadedSave) then
		ZShelter.InitShelter()
	else
		if(!loaded) then
			ZShelter.LoadSave()
			loaded = true
		end
	end
end)

hook.Add("PlayerSpawn", "ZShelter-SetEntity", function()
	SetGlobalEntity("ShelterEntity", ZShelter.Shelter)
end)

hook.Add("OnEntityCreated", "ZShelter-SetBreakables", function(ent)
	if(ent:GetClass() == "func_breakable") then
		ent.IsBarricade = true
		ent:SetCustomCollisionCheck(true)
	end
end)

ZShelter.SetupFog()