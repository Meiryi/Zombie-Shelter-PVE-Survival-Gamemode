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

ZShelter.ResourceList = ZShelter.ResourceList || {}

function ZShelter.RemoveFromResList(index)
	ZShelter.ResourceList[index] = nil
end

local resourceToSpawn = {
	"obj_resource_wood", "obj_resource_iron"
}
local resClasses = {
	obj_resource_wood = true,
	obj_resource_iron = true,
}
function ZShelter.ClearResources()
	local day = GetGlobalInt("Day", 1)
	for k,v in pairs(ZShelter.ResourceList) do
		if(!IsValid(v)) then
			ZShelter.ResourceList[k] = nil
			continue
		end
		if(v.IsLootbox) then
			if(v.NextRemoveDay && v.NextRemoveDay >= day) then
				continue
			else
				v:Remove()
				ZShelter.ResourceList[k] = nil
			end
		else
			v:Remove()
			ZShelter.ResourceList[k] = nil
		end
	end

	for _, res in ipairs(ents.GetAll()) do
		if(resClasses[res:GetClass()]) then
			res:Remove()
		end
	end
end

ZShelter.ClearResources()

local resourceMaxAmount = {
	obj_resource_wood = 6,
	obj_resource_iron = 4,
}

function ZShelter.SpawnBonusResource()
	for k,v in pairs(ents.FindByClass("info_zshelter_resource_bonus_area")) do
		ZShelter.RandomResourceVec(v:GetPos() + Vector(0, 0, 5), 10)
	end
end

function ZShelter.DebugSpawnResource(player, amount)
		local pos = player:GetEyeTrace().HitPos
		local type = resourceToSpawn[math.random(1, #resourceToSpawn)]
		local max = resourceMaxAmount[type]
		if(!max) then max = 8 end
		local res = ents.Create(type)
			res:SetPos(pos)
			res:SetAngles(Angle(0, math.random(-180, 180), 0))
			res:Spawn()
			res.Amount = amount
			res.IsResource = true
			res:SetNWBool("IsResource", true)

		ZShelter.ResourceList[res:EntIndex()] = res
end

function ZShelter.SpawnResources(amount)
	if(table.Count(ZShelter.ResourceList) >= 75) then return end
	amount = math.floor(amount * GetGlobalFloat("ResourceMul", 1))
	if(#ZShelter.ResourceSpawnPoint <= 0) then -- Something goes very wrong
		ZShelter.SetupSpawnPoints()
	end
	for i = 1, amount do
		local pos = ZShelter.ResourceSpawnPoint[math.random(1, #ZShelter.ResourceSpawnPoint)]
		local type = resourceToSpawn[math.random(1, #resourceToSpawn)]
		local max = resourceMaxAmount[type]
		if(!max) then max = 8 end
		local amount = math.random(1, max)
		local res = ents.Create(type)
			res:SetPos(pos)
			res:SetAngles(Angle(0, math.random(-180, 180), 0))
			res:Spawn()
			res.Amount = amount
			res.IsResource = true
			res:SetNWBool("IsResource", true)

		ZShelter.ResourceList[res:EntIndex()] = res
	end
end

function ZShelter.SpawnLootboxVec(vec)
	local pos = vec
	if(!pos) then return end
	local amount = math.random(1, 5)
	local type = "obj_resource_lootbox"
	local res = ents.Create(type)
		res:SetPos(pos)
		res:SetAngles(Angle(0, math.random(-180, 180), 0))
		res:Spawn()
		res:SetNWBool("IsResource", true)
		res.IsResource = true
		res.NextRemoveDay = GetGlobalInt("Day", 1) + 1
		res.IsLootbox = true

	ZShelter.ResourceList[res:EntIndex()] = res
end

function ZShelter.RespawnLootbox()
	for k,v in pairs(ZShelter.ResourceList) do
		if(!IsValid(v)) then ZShelter.ResourceList[k] = nil continue end
		if(v.IsLootbox) then
			v:Remove()
			ZShelter.ResourceList[k] = nil
		end
	end
	ZShelter.SpawnLootbox()
end

function ZShelter.SpawnLootbox()
	if(#ZShelter.ResourceSpawnPoint <= 0) then -- Something goes very wrong
		ZShelter.SetupSpawnPoints()
	end

	for i = 1, GetGlobalInt("SkillBoxAmount", 1) do
		local pos = ZShelter.ResourceSpawnPoint[math.random(1, #ZShelter.ResourceSpawnPoint)]
		if(!pos) then return end
		local amount = math.random(1, 5)
		local type = "obj_resource_lootbox"
		local res = ents.Create(type)
			res:SetPos(pos)
			res:SetAngles(Angle(0, math.random(-180, 180), 0))
			res:Spawn()
			res:SetNWBool("IsResource", true)
			res.NextRemoveDay = GetGlobalInt("Day", 1) + 1
			res.IsResource = true
			res.IsLootbox = true

		ZShelter.ResourceList[res:EntIndex()] = res
	end
end

local rand = 350
function ZShelter.RandomResourceVec(vec, amount)
	for i = 1, amount do
		local pos = util.QuickTrace(vec + Vector(math.random(-rand, rand), math.random(-rand, rand), 16), Vector(0, 0, -256)).HitPos

		if(!util.IsInWorld(pos)) then continue end
		local type = resourceToSpawn[math.random(1, #resourceToSpawn)]
		local max = resourceMaxAmount[type]
		if(!max) then max = 8 end
		local amount = math.random(1, max)
		local res = ents.Create(type)
			res:SetPos(pos)
			res:SetAngles(Angle(0, math.random(-180, 180), 0))
			res:Spawn()
			res.Amount = amount
			res.IsResource = true
			res:SetNWBool("IsResource", true)
	end
end

hook.Add("EntityRemoved", "ZShelter-HandleResourceRemovel", function(ent)
	ZShelter.ResourceList[ent:EntIndex()] = nil
end)