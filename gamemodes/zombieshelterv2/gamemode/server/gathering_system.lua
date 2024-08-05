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

function ZShelter.CreateBackpack(pos, wood, iron)
	if(wood <= 0 && iron <= 0) then return end
	local ent = ents.Create("obj_resource_backpack")
		ent:SetPos(pos)
		ent:SetAngles(Angle(0, math.random(-180, 180), 0))
		ent:Spawn()
		ent.Woods = wood
		ent.Irons = iron
end

function ZShelter.AddResourceToPlayer(player, resource, amount)
	player:SetNWInt(resource, math.min(player:GetNWInt(resource, 1) + amount, player:GetNWFloat("ResourceCapacity", 10)))
end

function ZShelter.GatheringSystem(player, resource, nocallback) 
	if(!IsValid(resource)) then return end
	local type = resource.ResourceType
	local capacity = player:GetNWFloat("ResourceCapacity", 10)
	local current = player:GetNWFloat(type, 0)
	local add = player:GetNWFloat("GatheringAmount", 1)
	local full = current >= capacity

	if(!full) then
		player:AddFrags(add * 2)
	end

	SetGlobalInt("T"..type, GetGlobalInt("T"..type, 0) + add)
	player:SetNWInt("T"..type, player:GetNWInt("T"..type, 0) + add)

	if(player.Callbacks.OnGatheringResources) then
		for k,v in pairs(player.Callbacks.OnGatheringResources) do
			v(player, resource, type, add, full, nocallback)
		end
	end

	hook.Run("OnGatheringResources", player, resource)

	if(full) then
		return
	end

	if(resource.Amount) then
		resource.Amount = resource.Amount - 1
		if(resource.Amount <= 0) then
			resource:Remove()
		end
	end
	player:SetNWInt(type, math.min(player:GetNWInt(type, 1) + add, capacity))
end