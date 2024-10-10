ZShelter.AirDropDays = {
	[2] = 50,
	[5] = 25,
	[8] = 25,
	[10] = 25,
	[12] = 25,
	[14] = 25,
	[18] = 25,
	[20] = 30,
	[22] = 30,
	[26] = 35,
	[27] = 35,
	[28] = 35,
	[29] = 35,
	[30] = 35,
}

function ZShelter.MakePath(mins, maxs)
	local side = math.random(1, 4)
	if(side == 1) then
		return Vector(math.random(mins.x, maxs.x), mins.y, maxs.z)
	elseif(side == 2) then
		return Vector(math.random(mins.x, maxs.x), maxs.y, maxs.z)
	elseif(side == 3) then
		return Vector(mins.x, math.random(mins.y, maxs.y), maxs.z)
	else
		return Vector(maxs.x, math.random(mins.y, maxs.y), maxs.z)
	end
end

function ZShelter.SpawnAirdrop()
	local pos = ZShelter.ResourceSpawnPoint[math.random(1, #ZShelter.ResourceSpawnPoint)]
	local mins, maxs = game.GetWorld():GetModelBounds()
	local p = ZShelter.MakePath(mins, maxs)
	p.z = pos.z + 1500
	local destination = pos
	destination.z = p.z
	local angle = (destination - p):Angle()
	local ent = ents.Create("obj_internal_helicopter")
		ent:SetPos(p)
		ent:SetAngles(angle)
		ent:Spawn()
		ent.destination = destination
		ent.actualPosition = pos - Vector(0, 0, 1500)

	ZShelter.PlayMusic("sound/shigure/spawn.wav")
end

function ZShelter.ShouldSpawnAirdrop()
	local day = GetGlobalInt("Day", 0)
	local spawn = false
	local chance = ZShelter.AirDropDays[day] || 3
	if(math.random(0, 100) <= chance) then
		spawn = true
	end
	if(!spawn) then return end
	ZShelter.SpawnAirdrop()
end

hook.Add("ZShelter-DaySwitch", "ZShelter-Airdrop", function()
	ZShelter.ShouldSpawnAirdrop()
end)