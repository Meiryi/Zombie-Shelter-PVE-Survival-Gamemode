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
	任何形式的编辑是不被允许的 (包括模式的名称), 若有问题请在Steam上联络我!
]]

GM.Name = "Zombie Shelter"
GM.Author = "Meiryi"
GM.Email = "None"
GM.Website = "None"

DeriveGamemode("sandbox")

CreateConVar("zshelter_difficulty", 1, FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_ARCHIVE, "Difficulty of game", 1, 9)

CreateConVar("zshelter_enable_music", 1, FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_ARCHIVE, "Enable music", 0, 1)
CreateConVar("zshelter_music_night", "sound/shigure/ost_night.mp3", FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_ARCHIVE, "Music to play on night")
CreateConVar("zshelter_music_countdown", "sound/shigure/ost_start.mp3", FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_ARCHIVE, "Music to play on countdown")
CreateConVar("zshelter_music_horde", "sound/shigure/ost_panic.mp3", FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_ARCHIVE, "Music to play on hordes")

CreateConVar("zshelter_enable_director", 0, FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_ARCHIVE, "Enable map director, it dynamicly increases difficulty depends on current situation (Experimental)", 0, 1)
CreateConVar("zshelter_enable_ranks", 0, FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_ARCHIVE, "Enable ranks", 0, 1)
CreateConVar("zshelter_enable_fog", 1, FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_ARCHIVE, "Enable fogs (Restart required)", 0, 1)
CreateConVar("zshelter_build_in_shelter", 0, FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_ARCHIVE, "Allow players to build inside of shelter", 0, 1)

CreateConVar("zshelter_display_name", 0, FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_ARCHIVE, "Display teammate's name even it's not visible", 0, 1)
CreateConVar("zshelter_public_lobby", 1, FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_ARCHIVE, "Allow players connect from server browser", 0, 1)
CreateConVar("zshelter_endless", 0, FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_ARCHIVE, "Game will never end", 0, 1)

CreateConVar("zshelter_director_push_failed_limit", 3, FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_ARCHIVE, "Maximum times zombie failed to push in order to spawn a stronger enemy", 1, 6)
CreateConVar("zshelter_director_check_interval", 10, FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_ARCHIVE, "Interval of director check the state of game, lower will make the game harder", 2, 15)
CreateConVar("zshelter_director_expected_first_hit_time", 3, FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_ARCHIVE, "Expected first hit time on night", 15, 30)

CreateConVar("zshelter_snap_to_grid", 0, FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_ARCHIVE, "Make buildings on grid", 0, 1)
CreateConVar("zshelter_snap_to_grid_size", 32, FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_ARCHIVE, "Grid size", 8, 128)
CreateConVar("zshelter_path_validate", 1, FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_ARCHIVE, "Check if a path is blocked or not, this will modify enemy's pathfinding", 0, 1)

CreateConVar("zshelter_config_name", "", FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_ARCHIVE, "Name of the config")
CreateConVar("zshelter_default_enemy_config", 1, FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_ARCHIVE, "Use default enemy config", 0, 1)
CreateConVar("zshelter_default_item_config", 1, FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_ARCHIVE, "Use default item config", 0, 1)

CreateConVar("zshelter_friendly_fire", 0, FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_ARCHIVE, "Friendly fire", 0, 1)
CreateConVar("zshelter_start_with_resources", 0, FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_ARCHIVE, "Start with full resources", 0, 1)
CreateConVar("zshelter_shared_skillbox", 0, FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_ARCHIVE, "Skillpoints will be shared with every player when this is turned on", 0, 1)

CreateConVar("zshelter_debug_enable_sandbox", 0, FCVAR_NOTIFY + FCVAR_REPLICATED, "Enable sandbox", 0, 1)
CreateConVar("zshelter_debug_disable_sanity", 0, FCVAR_NOTIFY + FCVAR_REPLICATED, "Disable sanity system", 0, 1)
CreateConVar("zshelter_debug_disable_skill_checks", 0, FCVAR_NOTIFY + FCVAR_REPLICATED, "Disable skill checks", 0, 1)
CreateConVar("zshelter_debug_disable_build_checks", 0, FCVAR_NOTIFY + FCVAR_REPLICATED, "Disable build checks", 0, 1)
CreateConVar("zshelter_debug_disable_upgrade_checks", 0, FCVAR_NOTIFY + FCVAR_REPLICATED, "Disable shelter upgrade checks", 0, 1)
CreateConVar("zshelter_debug_disable_building_upgrade_checks", 0, FCVAR_NOTIFY + FCVAR_REPLICATED, "Disable building upgrade checks", 0, 1)
CreateConVar("zshelter_debug_disable_craft_checks", 0, FCVAR_NOTIFY + FCVAR_REPLICATED, "Disable crafting checks", 0, 1)
CreateConVar("zshelter_debug_disable_building_damage", 0, FCVAR_NOTIFY + FCVAR_REPLICATED, "Disable damage to buildings", 0, 1)
CreateConVar("zshelter_debug_instant_build", 0, FCVAR_NOTIFY + FCVAR_REPLICATED, "Instant build stuffs", 0, 1)

CreateConVar("zshelter_server_category_name", "", FCVAR_NOTIFY + FCVAR_ARCHIVE, "Name for server listing category, leave empty for default one")
CreateConVar("zshelter_weapon_balance", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE + FCVAR_REPLICATED, "Enable weapon balancing", 0, 1)

if(CLIENT) then
	CreateConVar("zshelter_enable_hud", 1, FCVAR_LUA_CLIENT + FCVAR_ARCHIVE, "Enable zombie shelter hud?")
	CreateConVar("zshelter_enable_afk_bot", 1, FCVAR_LUA_CLIENT + FCVAR_ARCHIVE, "Enable AFK bot?")
	CreateConVar("zshelter_client_enable_music", 1, FCVAR_LUA_CLIENT + FCVAR_ARCHIVE, "Enable music?")
	CreateConVar("zshelter_enable_menu_keys", 1, FCVAR_LUA_CLIENT + FCVAR_ARCHIVE, "Enable keys to toggle menu?")

	CreateConVar("zshelter_damage_number", 1, FCVAR_LUA_CLIENT + FCVAR_ARCHIVE, "Enable damage number", 0, 1)
	CreateConVar("zshelter_damage_popup", 1, FCVAR_LUA_CLIENT + FCVAR_ARCHIVE, "Enable popup effect on damage numbers", 0, 1)
	CreateConVar("zshelter_damage_dps", 0, FCVAR_LUA_CLIENT + FCVAR_ARCHIVE, "Show the DPS on the damage number", 0, 1)
	CreateConVar("zshelter_damage_stay_time", 0.5, FCVAR_LUA_CLIENT + FCVAR_ARCHIVE, "Time for damage number to disappear", 0.25, 10)

	CreateConVar("zshelter_thirdperson_distance", 128, FCVAR_LUA_CLIENT + FCVAR_ARCHIVE, "Distance for thirdperson", 32, 512)
	CreateConVar("zshelter_thirdperson_offset", 16, FCVAR_LUA_CLIENT + FCVAR_ARCHIVE, "Offset for thirdperson", -64, 64)
	CreateConVar("zshelter_thirdperson_fade_distance", 32, FCVAR_LUA_CLIENT + FCVAR_ARCHIVE, "Minimum distance for playermodel to fadeout", 0, 64)
end

if(GetConVar("zshelter_server_category_name"):GetString() != "") then
	local str = GetConVar("zshelter_server_category_name"):GetString()
	local _ok = false
	for i = 1, #str do -- check for space
		if(#str != " ") then
			_ok = true
			break
		end
	end
	if(_ok) then
		GM.Name = str
	end
end

if(ArcCWInstalled)then
    -- Broken ass garbage
    ArcCW.AttachmentBlacklistTable["go_perk_headshot"] = true
    ArcCW.AttachmentBlacklistTable["go_perk_ace"] = true
    ArcCW.AttachmentBlacklistTable["go_perk_last"] = true
    ArcCW.AttachmentBlacklistTable["go_perk_refund"] = true
end

print("Changed server category name to -->", GM.Name)

file.CreateDir("zombie shelter v2/")
file.CreateDir("zombie shelter v2/config/")
file.CreateDir("zombie shelter v2/mapconfig/")
file.CreateDir("zombie shelter v2/avatars/")
file.CreateDir("zombie shelter v2/multiplayer/")
file.CreateDir("zombie shelter v2/exps/")
file.CreateDir("zombie shelter v2/leaderboard/")
file.CreateDir("zombie shelter v2/saves/")
file.CreateDir("zombie shelter v2/playerdata/")

ZShelter.GameVersion = "1.1.0"
ZShelter.ConfigVersion = "1.1.0" -- DANGER, MODIFY THIS WILL RESET CONFIGS
ZShelter.KeybindVersion = "1.1.0"
ZShelter.BasePath = "zombieshelterv2/gamemode/"
ZShelter.MaximumDifficulty = 9
ZShelter.BossTriggerDistance = 512

ZShelter.ClientLoadOrder = {
	[1] = "gui",
	[2] = "client",
}

ZShelter.ServerLoadOrder = {
	[1] = "server",
}

ZShelter.SharedLoadOrder = {
	[1] = "shared",
}

ZShelter.ConfigCheckOrder = {
	[1] = "data",
	[2] = "data_static",
}

if(SERVER) then
	include("server/ainodes.lua")
end

local removeList = {
	"enemy.txt",
	"item.txt",
}
function ZShelter.CheckConfigVersion()
	local ver = file.Read("zombie shelter v2/version.txt", "DATA")
	if(ver != ZShelter.ConfigVersion) then
		for k,v in pairs(removeList) do
			file.Delete("zombie shelter v2/"..v)
		end
	end

	file.Write("zombie shelter v2/version.txt", ZShelter.ConfigVersion)
end

ZShelter.CheckConfigVersion()

for k,v in pairs(ZShelter.SharedLoadOrder) do
	local fn = file.Find(ZShelter.BasePath..v.."/*", "LUA")
	for x,y in pairs(fn) do
		if(SERVER) then
			AddCSLuaFile(v.."/"..y)
		end
		include(v.."/"..y)
	end
end

for k,v in pairs(ZShelter.ClientLoadOrder) do
	local fn = file.Find(ZShelter.BasePath..v.."/*", "LUA")
	for x,y in pairs(fn) do
		if(SERVER) then
			AddCSLuaFile(v.."/"..y)
		end
		if(CLIENT) then
			include(v.."/"..y)
		end
	end
end

for k,v in pairs(ZShelter.ServerLoadOrder) do
	local fn = file.Find(ZShelter.BasePath..v.."/*", "LUA")
	for x,y in pairs(fn) do
		if(SERVER) then
			include(v.."/"..y)
		end
	end
end

function GM:PlayerLoadout()
	return
end
function GM:HandlePlayerArmorReduction()
	return
end
function GM:FinishMove()
	return
end
function GM:Move()
	return
end

function SBoxEnabled()
	return GetConVar("zshelter_debug_enable_sandbox"):GetInt() == 1
end

function GM:PlayerSpawnVehicle(ply, model, name, table) return SBoxEnabled() end
function GM:PlayerSpawnVehicle(ply,model,name,table) return SBoxEnabled() end
function GM:PlayerSpawnSWEP(ply,weapon,info) return SBoxEnabled() end
function GM:PlayerSpawnSENT(ply,class) return SBoxEnabled() end
function GM:PlayerSpawnRagdoll(ply,model) return SBoxEnabled() end
function GM:PlayerSpawnProp(ply,model) return SBoxEnabled() end
function GM:PlayerSpawnObject(ply,model,skin) return SBoxEnabled() end
function GM:PlayerSpawnNPC(ply,npc_type,weapon) return SBoxEnabled() end
function GM:PlayerSpawnEffect(ply,model) return SBoxEnabled() end
function GM:PlayerGiveSWEP(ply,weapon,swep) return SBoxEnabled() end
function GM:HUDAmmoPickedUp(item, amount) return SBoxEnabled() end
function GM:ContextMenuOpen() return SBoxEnabled() end
hook.Add("SpawnMenuOpen", "ZShelter_SpawnMenuOpen", SBoxEnabled)
hook.Add( "PlayerNoClip", "ZShelter_Noclip", function(ply, desiredNoClipState)
	return SBoxEnabled()
end)


local cvar = GetConVar("zshelter_friendly_fire")
hook.Add("ShouldCollide", "ZShelter-Collide", function(ent1, ent2)
	if(cvar:GetInt() == 0) then
		if(ent1:IsPlayer() && ent2:IsPlayer()) then return false end
	end
	if(ent1:GetNWBool("IsTurret", false) && ent2:IsPlayer()) then
		return false
	end
	if(ent2:GetNWBool("IsTurret", false) && ent1:IsPlayer()) then
		return false
	end
	if(CLIENT) then
		if(ent1:IsPlayer() && ZShelter.IsAFKing && ent2:GetNWBool("IsBuilding")) then return false end
		if(ent2:IsPlayer() && ZShelter.IsAFKing && ent1:GetNWBool("IsBuilding")) then return false end
		return
	end
	if(ent1.IsHugeEnemy) then
		if(ent2:IsPlayer() || ent2.IsTurret || ent2.IsPlayerBarricade) then
			return true
		else
			if(ent2.IsBarricade) then
				return false
			end
		end
	end
	if(ent2.IsHugeEnemy) then
		if(ent1:IsPlayer() || ent1.IsTurret || ent1.IsPlayerBarricade) then
			return true
		else
			if(ent1.IsBarricade) then
				return false
			end
		end
	end
	if(ent1.PathHelper) then
		if(ent2.IsPlayerBarricade || ent2.IsBarricade || (ent2 == ent1:GetOwner())) then
			return true
		else
			return false
		end
	end
	if(ent2.PathHelper) then
		if(ent1.IsPlayerBarricade || ent1.IsBarricade || (ent1 == ent2:GetOwner())) then
			return true
		else
			return false
		end
	end
	if(ent1.PathTester) then
		if(ent2.IsPlayerBarricade) then
			return true
		else
			return false
		end
	end
	if(ent2.PathTester) then
		if(ent1.IsPlayerBarricade) then
			return true
		else
			return false
		end
	end
	if(ent1.IsTurret && ent2.IsTurret) then
		return false
	end
	if(ent2.IsTurret && ent1.IsTurret) then
		return false
	end
	if((ent1.ForceNoCollide || ent1.AFKing) && (ent2.IsBarricade || ent2.IsBuilding)) then
		return false
	end
	if((ent2.ForceNoCollide || ent2.AFKing) && (ent1.IsBarricade || ent1.IsBuilding)) then
		return false
	end
	if(ent1.AFKing && ent2.IsPlayerBarricade) then
		return false
	end
	if(ent2.AFKing && ent1.IsPlayerBarricade) then
		return false
	end
	if(ent1.OnlyCollideToBarricade || ent1.AFKing) then
		if(!ent2.IsPlayerBarricade && ent1.IsShelter) then
			return false
		else
			if(ent2.IsShelter) then
				return false
			else
				return true
			end
		end
	end
	if(ent2.OnlyCollideToBarricade || ent2.AFKing) then
		if(!ent1.IsPlayerBarricade && ent1.IsShelter) then
			return false
		else
			if(ent1.IsShelter) then
				return false
			else
				return true
			end
		end
	end
	if(ent1.IgnoreCollision && ent2:IsNPC()) then
		return false
	end
	if(ent2.IgnoreCollision && ent1:IsNPC()) then
		return false
	end
	if(ent1.NoCollide && ent2.IsTurret) then
		return false
	end
	if(ent2.NoCollide && ent1.IsTurret) then
		return false
	end
	if(ent1.NoShelterCollide && ent2.IsShelter) then
		return false
	end
	if(ent2.NoShelterCollide && ent1.IsShelter) then
		return false
	end
end)

hook.Add("DrawDeathNotice", "HideDefKF", function(x, y)
    return false 
end)

RunConsoleCommand("sbox_godmode", "0")
RunConsoleCommand("vj_npc_addfrags", "0")
RunConsoleCommand("vj_npc_knowenemylocation", "1")
RunConsoleCommand("vj_npc_bleedenemyonmelee", "0")
RunConsoleCommand("vj_npc_processtime", "2")

if(SERVER) then
	local fn = file.Find(ZShelter.BasePath.."/addons/*", "LUA")
	for x,y in pairs(fn) do
		include("addons/"..y)
	end
	local fn = file.Find(ZShelter.BasePath.."/addons_client/*", "LUA")
	for x,y in pairs(fn) do
		AddCSLuaFile("addons_client/"..y)
	end
else
	local fn = file.Find(ZShelter.BasePath.."/addons_client/*", "LUA")
	for x,y in pairs(fn) do
		include("addons_client/"..y)
	end
end

RunConsoleCommand("gmod_mcore_test", "1")
RunConsoleCommand("r_queued_ropes", "1")
RunConsoleCommand("cl_threaded_bone_setup", "1")
RunConsoleCommand("cl_threaded_client_leaf_system", "1")
RunConsoleCommand("mat_queue_mode", "-1")
RunConsoleCommand("r_threaded_particles", "1")
RunConsoleCommand("r_decals", "128")

RunConsoleCommand("sv_tfa_attachments_enabled", "0")
RunConsoleCommand("sv_tfa_bullet_penetration_power_mul", "0.3")
RunConsoleCommand("sv_tfa_sprint_enabled", "0")
RunConsoleCommand("sv_tfa_dynamicaccuracy", "0")

local meta = FindMetaTable("Entity")

function meta:CollisionRulesChanged()
	if not self.m_OldCollisionGroup then self.m_OldCollisionGroup = self:GetCollisionGroup() end
	self:SetCollisionGroup( self.m_OldCollisionGroup == COLLISION_GROUP_DEBRIS and COLLISION_GROUP_WORLD or COLLISION_GROUP_DEBRIS )
	self:SetCollisionGroup( self.m_OldCollisionGroup )
	self.m_OldCollisionGroup = nil
end