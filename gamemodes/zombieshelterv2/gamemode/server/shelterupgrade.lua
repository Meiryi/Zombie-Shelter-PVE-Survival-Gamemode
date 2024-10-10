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

util.AddNetworkString("ZShelter-UpgradeShelter")

net.Receive("ZShelter-UpgradeShelter", function(len, ply)
	local level = net.ReadInt(32)
	local data = ZShelter.ShelterUpgrade[level]
	if(!data || !ZShelter.Shelter) then return end
	local scaling = 1 + (math.max(player.GetCount() - 1, 0) * 0.5)
	if(!ZShelter.CanUpgradeShelter(level, math.floor(data.woods * scaling), math.floor(data.irons * scaling), data.powers, data.required_building)) then return end
	ZShelter.Shelter:SetMaxHealth(math.floor(ZShelter.Shelter:GetMaxHealth() * 1.8))
	ZShelter.Shelter:SetNWBool("Completed", false)
	ZShelter.Shelter:SetRenderMode(RENDERMODE_TRANSCOLOR)
	ZShelter.Shelter:SetColor(Color(255, 255, 255, 120))
	ZShelter.Shelter:SetModel(data.sheltermodel)
	ZShelter.Shelter:SetNWString("Name", "Shelter")
	SetGlobalInt("ShelterLevel", level)

	SetGlobalInt("Woods", math.max(GetGlobalInt("Woods") - math.floor(data.woods * scaling), 0))
	SetGlobalInt("Irons", math.max(GetGlobalInt("Irons") - math.floor(data.irons * scaling), 0))
	SetGlobalInt("Powers", math.max(GetGlobalInt("Powers") - data.powers, 0))

	for k,v in pairs(ents.GetAll()) do
		if(!v.__ou) then continue end
		v.__ou(v)
	end
end)