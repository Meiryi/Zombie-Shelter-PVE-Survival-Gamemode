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

util.AddNetworkString("ZShelter-BroadcastBlueprintHint")

ZShelter.Blueprints = {}

function ZShelter.BlueprintHint(title)
	net.Start("ZShelter-BroadcastBlueprintHint")
	net.WriteString(title)
	net.Broadcast()
end

function ZShelter.FilteBlueprint()
	ZShelter.Blueprints = {}
	local day = GetGlobalInt("Day", 1)
	for k,v in pairs(ZShelter.IngredientConfig) do
		if(!v.day || v.day > day || GetGlobalBool("BP_"..v.id, false)) then continue end
		table.insert(ZShelter.Blueprints, {
			model = v.model,
			id = v.id,
		})
	end
end

function ZShelter.SpawnBlueprints()
	for k,v in pairs(ZShelter.Blueprints) do
		local spawn = math.random(0, 100) <= 40
		if(!spawn) then continue end
		ZShelter.CreateBlueprint(v.id, v.model)
	end
end

function ZShelter.CreateBlueprint(id, model)
	local pos = ZShelter.ResourceSpawnPoint[math.random(1, #ZShelter.ResourceSpawnPoint)]
	if(!pos) then return end
	local bp = ents.Create("obj_resource_blueprint")
		bp:SetPos(pos + Vector(0, 0, 1))
		bp:SetAngles(Angle(0, math.random(-180, 180), 0))

		bp:Spawn()

		bp:SetNWString("BlueprintModel", model)
		bp:SetNWString("BlueprintID", id)

	ZShelter.ResourceList[bp:EntIndex()] = bp
end