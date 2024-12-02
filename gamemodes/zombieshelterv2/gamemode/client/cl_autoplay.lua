ZShelter.IsAFKing = ZShelter.IsAFKing || false
ZShelter.CurrentPath = {}
ZShelter.CurrentFollowingIndex = ZShelter.CurrentFollowingIndex || 1
ZShelter.FollowPath = true
ZShelter.MinDistanceToStart = 32

concommand.Add("zshelter_afk", function()
	if(ZShelter.IsAFKing) then return end
	ZShelter.SyncAFK(true)
end)

local offs = Vector(0, 0, 1)
local tr = {collisiongroup = COLLISION_GROUP_WORLD, output = {}}
function util.IsInWorld(pos)
	tr.start = pos
	tr.endpos = pos + offs
	return !util.TraceLine(tr).HitWorld
end

-- ZShelter.GeneratePath(GetGlobalEntity("ShelterEntity"):GetPos())
local prev_vec = nil
local path_interrupted = false
local nextpathfindtime = 0
function ZShelter.GeneratePath(dest)
	if(nextpathfindtime > SysTime()) then return end
	if(dest == prev_vec && !path_interrupted && #ZShelter.CurrentPath > 0) then return end
	net.Start("ZShelter_PathFinder_GetPath")
	net.WriteVector(dest)
	net.SendToServer()
	path_interrupted = false
	prev_vec = dest
end

function ZShelter.SyncAFK(afk)
	ZShelter.IsAFKing = afk
	net.Start("ZShelter_AFK_Sync")
	net.WriteBool(afk)
	net.SendToServer()
end

function ZShelter.GetClosestNode()
	local pos = LocalPlayer():GetPos()
	local dst = -1
	local index = -1
	local vec = nil
	for k, v in pairs(navmesh.GetAllNavAreas()) do
		local center = v:GetCenter()
		local dist = center:Distance(pos)
		if(dst == -1 || dist < dst) then
			index = k
			dst = dist
			vec = center
		end
	end
	return vec, index
end

function ZShelter.GetEmptyWeapon()
	local ret = nil
	for _, wep in ipairs(LocalPlayer():GetWeapons()) do
		if(wep:GetNWBool("zsh_shootable_weapon") && wep:Clip1() == 0 && LocalPlayer():GetAmmoCount(wep:GetPrimaryAmmoType()) <= 0) then
			return wep
		end
	end
end

function ZShelter.CompareTraceEntity(player, target)
	local eyepos = player:EyePos()
	return util.TraceLine({
		start = eyepos,
		endpos = eyepos + player:EyeAngles():Forward() * 4096,
		filter = function(ent)
			return (!ent:GetNWBool("IsTurret") && ent != player)
		end,
	}).Entity == target
end

local vis = function(ent1, ent2)
	return util.TraceLine({
		start = ent1:EyePos(),
		endpos = ent2:GetPos() + ent2:OBBCenter(),
		filter = {ent1, ent2},
		collisiongroup = COLLISION_GROUP_DEBRIS,
	}).Fraction
end

local bvis = function(ent1, ent2)
	return util.TraceLine({
		start = ent1:EyePos(),
		endpos = ent2:GetPos() + ent2:OBBCenter(),
		filter = function(ent)
			return ent:GetNWBool("IsMapBarricade")
		end,
	}).Fraction == 1
end

local vvis = function(ent1, ent2)
	return util.TraceLine({
		start = ent1:EyePos(),
		endpos = ent2:GetPos() + ent2:OBBCenter(),
		filter = function(ent)
			return (!ent:GetNWBool("IsTurret") && ent != ent2 && ent != ent1)
		end,
	}).Fraction == 1
end

local tracepath = function(ply, start, endpos)
	return util.TraceEntity({
		start = start,
		endpos = endpos,
		filter = function(ent)
			return ent:GetNWBool("IsZShelterEnemy")
		end,
	}, ply)
end

local hitworld = function(ply, start, endpos)
	return util.TraceEntity({
		start = start,
		endpos = endpos,
		filter = ply,
		collisiongroup = COLLISION_GROUP_DEBRIS,
	}, ply)
end

net.Receive("ZShelter_PathFinder_GetPath", function()
	local len = net.ReadUInt(32)
	local data = net.ReadData(len)
	local path = ZShelter.DecompressTable(data)

	if(#path >= 2) then
		local start = path[1]
		local goal = path[#path]
		local ppos = LocalPlayer():GetPos()
		if(#path > 2) then
			if(start:Distance(goal) > ppos:Distance(goal)) then
				path[1] = LocalPlayer():GetPos()
			end
		else
			if(start:Distance(goal) > ppos:Distance(goal) || ppos:Distance(goal) < ppos:Distance(start)) then
				path[1] = LocalPlayer():GetPos()
			end
		end
	end

	ZShelter.CurrentPath = path
	ZShelter.CurrentFollowingIndex = 1
end)

local resources = {
	obj_resource_wood = "Woods",
	obj_resource_iron = "Irons",
}

local target_enemy = nil
local target_enemy_melee = nil
local target_resource = nil
local target_storage = nil
local target_building = nil
local target_building_any = nil
local target_workbench = nil
local target_ammocrate = nil

local refill_sanity = false
local refill_health = false
local refill_ammo_weapon = nil

local blacklistedresource = {}
local blacklistedbuilding = {}
local nextfindres = 0
local nextresourcedesposit = 0
local nextfindbuildingtime = 0
local timeoutresourcetime = 0
local timeoutbuildingtime = 0

local offset = Vector(0, 0.1, 0)

local distance_tolerance = 16
local distance_z_tolerance = 32
local distance_tolerance_resource = 86
local dodge_distance = 128
local dodge_think_timeout = 0.1
local dodge_render = true
local attempt_dodge = false
local boundscale = 5

local lastmovevec = Vector(0, 0, 0)
local lastmovingtime = 0
local lastmoving_timeout = 5

--[[
	IsHealingStation
	IsArmorBox
	IsAmmoSupplyCreate
	IsStorage
	IsWorktable
]]

local nextSwitchTime = 0
function ZShelter.ArrivedDestination(ppos, pos)
	local dst = ppos:Distance(pos)
	local dst_noz = Vector(ppos.x, ppos.y, 0):Distance(Vector(pos.x, pos.y, 0))
	return dst < distance_tolerance || (dst_noz < distance_tolerance && math.abs(ppos.z - pos.z) <= distance_z_tolerance)
end

function ZShelter.SwitchToMelee(ucmd)
	if(nextSwitchTime > SysTime()) then return end
	nextSwitchTime = SysTime() + 0.2
	local ply = LocalPlayer()
	local wep = ply:GetActiveWeapon()
	if(wep.IsZShelterMeleeWeapon) then return end
	for _, wep in ipairs(ply:GetWeapons()) do
		if(wep.IsZShelterMeleeWeapon) then
			ucmd:SelectWeapon(wep)
			return
		end
	end
end

function ZShelter.SwitchToGun(ucmd)
	if(nextSwitchTime > SysTime()) then return end
	nextSwitchTime = SysTime() + 0.2
	local ply = LocalPlayer()
	local wep = ply:GetActiveWeapon()
	if(wep:GetNWBool("zsh_shootable_weapon")) then return end
	for _, wep in ipairs(ply:GetWeapons()) do
		if(wep:GetNWBool("zsh_shootable_weapon")) then
			ucmd:SelectWeapon(wep)
			return
		end
	end
end

local nextdecidecraft = 0
local nextcraftweapon = 0
local wantedtocraft = -1
local togglereloadtime = 0
function ZShelter.DecideWhatToCraft(player)
	local woods = GetGlobalInt("Woods")
	local metals = GetGlobalInt("Irons")
	local ret = -1
	local max_budget_woods, max_budget_metals = math.floor(woods * 0.5), math.floor(metals * 0.5)

	for index, data in ipairs(ZShelter.ItemConfig) do
		if(!ZShelter.CanCraftWeapon(player, data)) then continue end
		if(data.woods > max_budget_woods || data.irons > max_budget_metals) then continue end
		ret = index
	end

	return ret
end

function ZShelter.HaveShootableWeapon()
	for _, wep in ipairs(LocalPlayer():GetWeapons()) do
		if(wep:GetNWBool("zsh_shootable_weapon")) then
			return true
		end
	end
	return false
end

ZShelter.AFKCheckKeys = {
	IN_ATTACK,
	IN_ATTACK2,
	IN_RELOAD,

	IN_FORWARD,
	IN_BACK,
	IN_MOVELEFT,
	IN_MOVERIGHT,

	IN_SPEED,
	IN_USE,
	IN_DUCK,
	IN_JUMP,
}

-- x = right, y = forward, z = up
ZShelter.BuildingOriginFix = {
	Worktable = Vector(0, -32, 0)
}

function ZShelter.GetFixedOrigin(ent)
	local name = ent:GetNWString("Name")
	local pos = ent:GetPos() + Vector(0, 0, math.min(ent:OBBCenter().z * 0.5, distance_z_tolerance))
	if(!ZShelter.BuildingOriginFix[name]) then return pos end
	local offset = ZShelter.BuildingOriginFix[name]
		pos = pos + ent:GetRight() * offset.x
		pos = pos + ent:GetForward() * offset.y
		pos = pos + ent:GetUp() * offset.z
	return pos
end

local nextcheckAFKTime = 0
local checkunafk = true
local lastmovetime = SysTime()
hook.Add("CreateMove", "ZShelter_Player_Controller", function(ucmd)
	if(!ZShelter.IsAFKing) then
		local ply = LocalPlayer()
		if(ucmd:GetMouseX() != 0 || ucmd:GetMouseY() != 0) then
			lastmovetime = SysTime()
		end

		if(nextcheckAFKTime < SysTime()) then
			for _, key in ipairs(ZShelter.AFKCheckKeys) do
				if(moved) then break end
				if(ucmd:KeyDown(key)) then
					lastmovetime = SysTime()
					break
				end
			end
			local inactive = SysTime() - lastmovetime
			if(inactive > 120) then
				ZShelter.SyncAFK(true)
			end
			nextcheckAFKTime = SysTime() + 0.5
		end
		return
	end

	if(checkunafk) then
		if(ucmd:GetMouseX() != 0 || ucmd:GetMouseY() != 0) then
			ZShelter.SyncAFK(false)
			return
		end
		for _, key in ipairs(ZShelter.AFKCheckKeys) do
			if(moved) then break end
			if(ucmd:KeyDown(key)) then
				ZShelter.SyncAFK(false)
				return
			end
		end
	end

	--if(!ZShelter.CurrentPath) then return end
	local systime = SysTime()
	local ply = LocalPlayer()
	local ppos = ply:GetPos()
	local pepos = ply:EyePos()
	local pang = ply:EyeAngles()
	local health = ply:Health()
	local sanity = ply:GetNWInt("Sanity", 0)
	local woods, metals, capacity = ply:GetNWInt("Woods"), ply:GetNWInt("Irons"), ply:GetNWInt("ResourceCapacity")
	local woods_storage, metals_storage, storage_capacity = GetGlobalInt("Woods"), GetGlobalInt("Irons"), GetGlobalInt("Capacity")
	local full = woods >= capacity && metals >= capacity
	local full_storage = woods_storage >= storage_capacity && metals_storage >= storage_capacity

	local time = GetGlobalInt("Time")
	local night = GetGlobalBool("Night")

	local node = ZShelter.CurrentPath[ZShelter.CurrentFollowingIndex]
	local maxspeed = ply:GetRunSpeed()
	local tick_interval = engine.TickInterval()
	local ping = 1 + ply:Ping() / 1000

	target_enemy_melee = nil

	local ents_inrange = ents.FindInSphere(ppos, 190)
	local shelter_entity = GetGlobalEntity("ShelterEntity")
	local shelter_valid = false
	local near_shelter = false
	local in_shelter = false

	if(!ply:Alive()) then
		ZShelter.CurrentPath = {}
		ZShelter.CurrentFollowingIndex = 1

		target_enemy = nil
		target_enemy_melee = nil
		target_resource = nil
		target_storage = nil
		target_building = nil
		target_building_any = nil
		target_workbench = nil
		target_ammocrate = nil

		refill_sanity = false
		refill_health = false
		refill_ammo_weapon = nil

		blacklistedresource = {}
		blacklistedbuilding = {}

		return
	end

	if(IsValid(shelter_entity)) then
		near_shelter = shelter_entity:GetPos():Distance(ppos) < 1024
		in_shelter = shelter_entity:GetPos():Distance(ppos) < 150
		shelter_valid = true
	end

	if(in_shelter) then
		if(nextresourcedesposit < systime) then
			for _, restype in ipairs({"Woods", "Irons"}) do
				net.Start("ZShelter-Storage")
				net.WriteString(restype)
				net.WriteBool(false)
				net.WriteInt(capacity, 8)
				net.SendToServer()
			end
			nextresourcedesposit = systime + 0.33
		end
	end

	if(#ents_inrange > 0) then
		local dst = -1
		local pre_range = 190
		local melee_range = 150
		local back_range = 120
		for k, v in pairs(ents_inrange) do
			if(!v:GetNWBool("IsZShelterEnemy") || v:Health() <= 0) then continue end
			if(v:GetNWBool("ZShelterBoss") && !v:GetNWBool("ZShelterBossAwake")) then continue end
			local dist = v:GetPos():Distance(ppos)
			if(dist > pre_range || (!bvis(ply, v))) then continue end
			if(dst == -1 || dist < dst) then
				dst = dist
				target_enemy_melee = v
			end
		end

		if(IsValid(target_enemy_melee)) then
			local dist = target_enemy_melee:GetPos():Distance(ppos)
			local enemy_pos = target_enemy_melee:GetPos() + target_enemy_melee:OBBCenter()
			local ang = (enemy_pos - pepos):Angle()
			local lerp = LerpAngle(tick_interval * 2.5, pang, ang)
			ucmd:SetViewAngles(Angle(lerp.x, lerp.y, 0))
			if(dist < melee_range) then
				ucmd:SetButtons(IN_ATTACK)
				if(dist < back_range && !attempt_dodge) then
					ucmd:SetForwardMove(-maxspeed)
				end
				if(!attempt_dodge) then
					path_interrupted = true
					return
				end
			end
		end
	end

	if(node && ZShelter.FollowPath) then
		local dst = node:Distance(ppos)
		local targetvec = node

		local tr = tracepath(ply, ppos, targetvec)
		if(IsValid(tr.Entity)) then
			local maxs, mins = tr.Entity:OBBMaxs(), tr.Entity:OBBMins()
			local _ok = false
			local angle = (targetvec - ppos):Angle()
			local left, right = Angle(0, angle.y - 90, 0), Angle(0, angle.y + 90, 0)
			local offsetpos = Vector(0, 0, 0)
			if(!_ok) then
				offsetpos = targetvec + left:Forward() * (Vector(mins.x, mins.y, 0):Distance(Vector(maxs.x, mins.y, 0)) * boundscale)
				local trace = tracepath(LocalPlayer(), ppos, offsetpos).Entity
				if(!IsValid(trace.Entity)) then
					_ok = true
				end
			end
			if(!_ok) then
				offsetpos = targetvec + right:Forward() * (Vector(mins.x, mins.y, 0):Distance(Vector(maxs.x, mins.y, 0)) * boundscale)
				local trace = tracepath(LocalPlayer(), ppos, offsetpos).Entity
				if(!IsValid(trace.Entity)) then
					_ok = true
				end
			end
			if(_ok) then
				targetvec = offsetpos
				attempt_dodge = true
			end
		end

		local forward = targetvec - ppos
		local yaw = pang.y
		local pi = math.pi
		local vel = Vector(
			forward.x  * math.cos(yaw / 180 * pi) + forward.y * math.sin(yaw / 180 * pi),
			forward.y * math.cos(yaw / 180 * pi) - forward.x * math.sin(yaw / 180 * pi),
			0
		)
		ucmd:SetForwardMove(vel.x * maxspeed)
		ucmd:SetSideMove(-vel.y * maxspeed)

		local ang = forward:Angle()
		local lerp = LerpAngle(tick_interval, pang, Angle(0, ang.y, 0))
		ucmd:SetViewAngles(Angle(lerp.x, lerp.y, 0))

		local mdst = ppos:Distance(lastmovevec)
		local vel = ply:GetVelocity():Length2D()
		
		if(vel > 10) then
			lastmovingtime = systime
		end

		if(systime - lastmovingtime > lastmoving_timeout) then
			if(IsValid(target_resource)) then
				if(!target_resource.UniqueID) then
					target_resource.UniqueID = math.random(1, 214000000)
				end
				blacklistedresource[target_resource.UniqueID] = true
				target_resource = nil
			end
			if(IsValid(target_building)) then
				if(!target_building.UniqueID) then
					target_building.UniqueID = math.random(1, 214000000)
				end
				blacklistedbuilding[target_building.UniqueID] = true
				target_building = nil
			end
			ZShelter.CurrentPath = {}
			return
		end

		lastmovevec = ppos

		if(ZShelter.ArrivedDestination(ppos, targetvec)) then
			attempt_dodge = false
			ZShelter.CurrentFollowingIndex = ZShelter.CurrentFollowingIndex + 1
			if(ZShelter.CurrentFollowingIndex > #ZShelter.CurrentPath) then
				ucmd:SetForwardMove(-ucmd:GetForwardMove())
				ucmd:SetSideMove(-ucmd:GetSideMove())
				ZShelter.CurrentPath = {}
				ZShelter.CurrentFollowingIndex = 1
			end
		end
	else
		lastmovingtime = systime
	end

	if(sanity >= 100) then
		refill_sanity = false
	end

	if(refill_health) then
		if(health >= ply:GetMaxHealth()) then
			refill_health = false
		end
		if(!IsValid(target_building_any)) then
			if(nextfindbuildingtime < systime) then
				local dst = -1
				local shelterpos = shelter_entity:GetPos()
				for _, building in ipairs(ents.GetAll()) do
					local pos = building:GetPos()
					if(!building:GetNWBool("IsBuilding") || !building:GetNWBool("Completed") || building:GetNWBool("IsBait") || !building:GetNWBool("IsHealingStation") || pos:Distance(shelterpos) > 1024) then continue end
					local dist = pos:Distance(ppos)
					if(dst == -1 || dist < dst) then
						dst = dist
						target_building_any = building
					end
				end
				nextfindbuildingtime = systime + 0.33
			end
		else
			if(!ZShelter.ArrivedDestination(ppos, target_building_any:GetPos())) then
				ZShelter.GeneratePath(target_building_any:GetPos())
			end
			return
		end
	end

	if(health <= 50) then
		refill_health = true
	end

	if(!night) then
		if(sanity < 40 || time <= 35 || refill_sanity) then
			if(shelter_valid && !in_shelter) then
				ZShelter.GeneratePath(shelter_entity:GetPos())
			end
			if(sanity < 40) then
				refill_sanity = true
			end
		else
			if(full) then
				if(!full_storage) then
					local dst = -1
					for _, storage in ipairs(ents.FindByClass("obj_internal_storage")) do
						local dist = storage:GetPos():Distance(ppos)
						if(dst == -1 || dist < dst) then
							dst = dist
							target_storage = storage
						end
					end
					if(IsValid(target_storage)) then
						ZShelter.GeneratePath(target_storage:GetPos())
						if(nextresourcedesposit < systime && target_storage:GetPos():Distance(ppos) < distance_tolerance_resource) then
							for _, restype in ipairs({"Woods", "Irons"}) do
								net.Start("ZShelter-Storage")
								net.WriteString(restype)
								net.WriteBool(false)
								net.WriteInt(capacity, 8)
								net.SendToServer()
							end
							nextpathfindtime = systime + 2
							nextresourcedesposit = systime + 0.25
						end
					end
				else
					if(!in_shelter) then
						ZShelter.GeneratePath(shelter_entity:GetPos() + offset)
					end
				end
			else
				if(near_shelter && shelter_valid) then
					local shelterpos = shelter_entity:GetPos()
					for _, building in ipairs(ents.GetAll()) do
						if(!building:GetNWBool("IsBuilding") || building:GetNWBool("IsBait")) then continue end
						local origin = ZShelter.GetFixedOrigin(building)
						local dst = origin:Distance(shelterpos)
						if(dst > 1024) then continue end
						if(blacklistedbuilding[building.UniqueID]) then continue end
						if(building:Health() >= building:GetMaxHealth()) then continue end
						if(!util.IsInWorld(origin)) then continue end
						target_building = building
						break
					end
				else
					target_building = nil
				end

				if(!IsValid(target_building)) then
					if(nextfindres < systime) then
						local triggerrange = ZShelter.BossTriggerDistance
						local dst = -1
						for _, res in ipairs(ents.GetAll()) do
							local type = resources[res:GetClass()]
							if(type == nil || blacklistedresource[res.UniqueID] || ply:GetNWInt(type) >= capacity) then continue end
							local respos = res:GetPos()
							local dist = respos:Distance(ppos)
							if(!vis(ply, res)) then
								dist = dist * 2
							end
							local nearboss = false
							for _, boss in ipairs(ents.GetAll()) do
								if(!boss:GetNWBool("ZShelterBoss") || boss:GetNWBool("ZShelterBossAwake")) then continue end
								if(respos:Distance(boss:GetPos()) <= triggerrange) then
									nearboss = true
									break
								end
							end
							if(nearboss) then continue end
							if(dst == -1 || dist < dst) then
								dst = dist
								target_resource = res
							end
						end
						ZShelter.SwitchToMelee(ucmd)
						nextfindres = systime + 0.33
					end
					if(IsValid(target_resource)) then
						local dst = target_resource:GetPos():Distance(ppos)
						if(dst > distance_tolerance_resource) then
							ZShelter.GeneratePath(target_resource:GetPos())
						else
							local ang = (target_resource:GetPos() - pepos):Angle()
							local offset = ang.x
							if(target_building == shelter_entity) then
								offset = -89
							end
							local newang = Angle(offset, ang.y, 0)
							local lerp = LerpAngle(tick_interval * 2.5, pang, newang)
							ucmd:SetViewAngles(Angle(lerp.x, lerp.y, 0))
							if(ply:GetNWInt(resources[target_resource:GetClass()]) > capacity) then
								target_resource = nil
								return
							end
							local aiment = ply:GetEyeTrace().Entity
							if(IsValid(aiment)) then
								if(aiment == target_resource) then
									ucmd:SetButtons(IN_ATTACK)
									timeoutresourcetime = systime
								else
									if(systime - timeoutresourcetime > 3) then
										if(!target_resource.UniqueID) then
											target_resource.UniqueID = math.random(1, 214000000)
										end
										blacklistedresource[target_resource.UniqueID] = true
										target_resource = nil
									end
								end
							else
								timeoutresourcetime = systime
							end
						end
					end
				else
					if(ZShelter.ArrivedDestination(ppos, ZShelter.GetFixedOrigin(target_building))) then
						ZShelter.SwitchToMelee(ucmd)
						local ang = (target_building:GetPos() - pepos):Angle()
						local lerp = LerpAngle(tick_interval * 2.5, pang, ang)
						ucmd:SetViewAngles(Angle(lerp.x, lerp.y, 0))
						if(target_building:Health() >= target_building:GetMaxHealth()) then
							target_building = nil
							return
						end
						local aiment = ply:GetEyeTrace().Entity
						if(IsValid(aiment)) then
							if(aiment == target_building) then
								ucmd:SetButtons(IN_ATTACK)
								timeoutbuildingtime = systime
							else
								if(!aiment:GetNWBool("IsBuilding")) then
									if(systime - timeoutbuildingtime > 3) then
										if(!target_building.UniqueID) then
											target_building.UniqueID = math.random(1, 214000000)
										end
										blacklistedbuilding[target_building.UniqueID] = true
										target_building = nil
										return
									end
								else
									if(aiment:Health() >= aiment:GetMaxHealth()) then
										if(systime - timeoutbuildingtime > 3) then
											if(!target_building.UniqueID) then
												target_building.UniqueID = math.random(1, 214000000)
											end
											blacklistedbuilding[target_building.UniqueID] = true
											target_building = nil
											return
										end
									else
										ucmd:SetButtons(IN_ATTACK)
										timeoutbuildingtime = systime
									end
								end
							end
						else
							timeoutbuildingtime = systime
						end
					else
						timeoutbuildingtime = systime
						ZShelter.GeneratePath(ZShelter.GetFixedOrigin(target_building))
					end
				end
			end
		end
	else
		if(near_shelter && shelter_valid) then
			local shelterpos = shelter_entity:GetPos()
			for _, building in ipairs(ents.GetAll()) do
				if(!building:GetNWBool("IsBuilding") || building:GetNWBool("IsBait")) then continue end
				local origin = ZShelter.GetFixedOrigin(building)
				local dst = origin:Distance(shelterpos)
				if(dst > 1024) then continue end
				if(blacklistedbuilding[building.UniqueID]) then continue end
				if(building:Health() >= building:GetMaxHealth()) then continue end
				if(!util.IsInWorld(origin)) then continue end
				target_building = building
				break
			end
		else
			target_building = nil
		end
		if(!IsValid(target_building)) then
			local hasweapon = ZShelter.HaveShootableWeapon()
			if(GetGlobalInt("Build_Worktable") > 0) then
				local capacity_half = storage_capacity * 0.5
				local shouldcraft_res = woods_storage >= capacity_half && metals_storage >= capacity_half

				if(nextdecidecraft < systime) then
					if(shouldcraft_res && !hasweapon) then
						wantedtocraft = ZShelter.DecideWhatToCraft(ply)
					else
						target_workbench = nil
						wantedtocraft = -1
					end
					nextdecidecraft = systime + 0.33
				end

				if(hasweapon) then
					target_workbench = nil
				end

				if(wantedtocraft != -1) then
					if(!IsValid(target_workbench)) then
						local dst = -1
						if(nextfindbuildingtime < systime) then
							for _, ent in ipairs(ents.GetAll()) do
								if(!ent:GetNWBool("IsWorktable")) then continue end
								local dist = ent:GetPos():Distance(ppos)
								if(dst == -1 || dist < dst) then
									dst = dist
									target_workbench = ent
								end
							end
							nextfindbuildingtime = systime + 1
						end
					else
						if(!ZShelter.ArrivedDestination(ppos, target_workbench:GetPos())) then
							ZShelter.GeneratePath(target_workbench:GetPos())
						else
							if(nextcraftweapon < systime) then
								net.Start("ZShelter-Worktable")
								net.WriteInt(wantedtocraft, 32)
								net.SendToServer()
								target_workbench = nil
								nextdecidecraft = systime + 10
								nextcraftweapon = systime + 5 + (ply:Ping() * 0.001) * 2
							end
						end
					end
				end
			end
			if(hasweapon) then
				local emptywep = ZShelter.GetEmptyWeapon()
				if(IsValid(emptywep)) then
					refill_ammo_weapon = emptywep
				end

				if(IsValid(refill_ammo_weapon)) then
					if(!IsValid(target_ammocrate)) then
						local dst = -1
						if(nextfindbuildingtime < systime) then
							for _, ent in ipairs(ents.GetAll()) do
								if(!ent:GetNWBool("IsAmmoSupplyCreate") || !ent:GetNWBool("Completed")) then continue end
								local dist = ent:GetPos():Distance(ppos)
								if(dst == -1 || dist < dst) then
									dst = dist
									target_ammocrate = ent
								end
							end
							nextfindbuildingtime = systime + 1
						end
					else
						if(!ZShelter.ArrivedDestination(ppos, target_ammocrate:GetPos())) then
							ZShelter.GeneratePath(target_ammocrate:GetPos())
						else
							ucmd:SelectWeapon(refill_ammo_weapon)
							if(refill_ammo_weapon:Clip1() < refill_ammo_weapon:GetMaxClip1()) then
								if(togglereloadtime < systime) then
									togglereloadtime = systime + 0.4
								else
									if(togglereloadtime - systime > 0.2) then
										ucmd:SetButtons(IN_RELOAD)
									end
								end
							end
							if(ply:GetAmmoCount(refill_ammo_weapon:GetPrimaryAmmoType()) >= 300) then
								target_ammocrate = nil
								refill_ammo_weapon = nil
								return
							end
						end
						return
					end
				end

				local ents_inrange = ents.FindInSphere(ppos, 2048)
				local enemy = nil
				local dst = -1
				for _, ent in ipairs(ents_inrange) do
					if(!ent:GetNWBool("IsZShelterEnemy") || ent:Health() <= 0 || !vvis(ply, ent)) then continue end
					local dist = ent:GetPos():Distance(ppos)
					if(dst == -1 || dist < dst) then
						dst = dist
						enemy = ent
					end
				end
				if(IsValid(enemy)) then
					ZShelter.SwitchToGun(ucmd)
					local punchangle = ply:GetViewPunchAngles()
					local aimangle = ((enemy:GetPos() + enemy:OBBCenter()) - pepos):Angle() - punchangle * 0.5
					local lerp = LerpAngle(tick_interval * 3, pang, aimangle)
					ucmd:SetViewAngles(Angle(lerp.x, lerp.y, 0))
					if(ZShelter.CompareTraceEntity(ply, enemy)) then
						local wep = ply:GetActiveWeapon()
						if(IsValid(wep)) then
							if(wep:Clip1() > 0 && wep:GetNextPrimaryFire() < CurTime()) then
								ucmd:SetButtons(IN_ATTACK)
							end
							if(wep:Clip1() <= 0) then
								if(togglereloadtime < systime) then
									togglereloadtime = systime + 0.4
								else
									if(togglereloadtime - systime > 0.2) then
										ucmd:SetButtons(IN_RELOAD)
									end
								end
							end
						end
					end
				end
			end
		else
			if(ZShelter.ArrivedDestination(ppos, ZShelter.GetFixedOrigin(target_building))) then
				ZShelter.SwitchToMelee(ucmd)
				local ang = (target_building:GetPos() - pepos):Angle()
				local newang = Angle(-89, ang.y, 0)
				local offset = ang.x
				if(target_building == shelter_entity) then
					offset = -89
				end
				local newang = Angle(offset, ang.y, 0)
				local lerp = LerpAngle(tick_interval * 2.5, pang, newang)
				ucmd:SetViewAngles(Angle(lerp.x, lerp.y, 0))
				if(target_building:Health() >= target_building:GetMaxHealth()) then
					target_building = nil
					return
				end
				local aiment = ply:GetEyeTrace().Entity
				if(IsValid(aiment)) then
					if(aiment == target_building) then
						ucmd:SetButtons(IN_ATTACK)
						timeoutbuildingtime = systime
					else
						if(!aiment:GetNWBool("IsBuilding")) then
							if(systime - timeoutbuildingtime > 3) then
								if(!target_building.UniqueID) then
									target_building.UniqueID = math.random(1, 214000000)
								end
								blacklistedbuilding[target_building.UniqueID] = true
								target_building = nil
								return
							end
						else
							if(aiment:Health() >= aiment:GetMaxHealth()) then
								if(systime - timeoutbuildingtime > 3) then
									if(!target_building.UniqueID) then
										target_building.UniqueID = math.random(1, 214000000)
									end
									blacklistedbuilding[target_building.UniqueID] = true
									target_building = nil
									return
								end
							else
								ucmd:SetButtons(IN_ATTACK)
								timeoutbuildingtime = systime
							end
						end
					end
				else
					timeoutbuildingtime = systime
				end
			else
				timeoutbuildingtime = systime
				ZShelter.GeneratePath(ZShelter.GetFixedOrigin(target_building))
			end
		end
	end
end)

local path_mat = Material("zsh/autoplay/node_path.png")
local bounds = Vector(4, 4, 4)
local pathclr = Color(255, 255, 255, 100)
local nodeclr = Color(255, 255, 255, 255)
local alpha = 0
local time = 2
hook.Add("HUDPaint", "ZShelter_AFK_HUDPaint", function()
	if(alpha > 0) then
		local scrw, scrh = ScrW(), ScrH()
		draw.RoundedBox(0, 0, 0, scrw, scrh, Color(0, 0, 0, alpha * 0.75))
		local fraction = math.max(alpha, 1) / 255
		local mul = (SysTime() % time) / time
		if(mul > 0.5) then
			mul = 1 - mul
		end
		local alp = 25 + 230 * mul
		ZShelter.ShadowText("You're AFK\nBot is taking control", "ZShelter-HUDFont", scrw * 0.5, scrh * 0.575, Color(255, 255, 255, alp), Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, 1)
	end
	if(!ZShelter.IsAFKing) then
		alpha = math.Clamp(alpha - ZShelter.GetFixedValue(20), 0, 255)
		return
	end
	alpha = math.Clamp(alpha + ZShelter.GetFixedValue(20), 0, 255)
	if(#ZShelter.CurrentPath > 0) then
		cam.Start3D()
		for k, v in pairs(ZShelter.CurrentPath) do
			local next = ZShelter.CurrentPath[k+1]
			if(next) then
				render.SetMaterial(path_mat)
				render.DrawBeam(v, next, 4, 0, 1, pathclr)
			end
			render.DrawBox(v, angle_zero, bounds, -bounds, nodeclr)
		end
		cam.End3D()
	end
end)