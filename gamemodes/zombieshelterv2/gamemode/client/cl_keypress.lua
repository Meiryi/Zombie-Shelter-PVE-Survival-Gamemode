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

ZShelter.KeyStates = {}
ZShelter.ChatOpened = false

local keys = {
	["BuildMenu"] = 12,
	["SkillMenu"] = 24,
	["ConfigMenu"] = 97,
	["Ready"] = 95,
	["GameUI"] = 93,
}

hook.Add("Think", "ZShelter-KeyPressHandler", function()
	if(gui.IsConsoleVisible() || ZShelter.BlockMenu || ZShelter.ChatOpened) then return end
	for k,v in next, keys do
		if(input.IsKeyDown(v)) then
			if(!ZShelter.KeyStates[v]) then
				ZShelter[k]()
				ZShelter.KeyStates[v] = true
			end
		else
			ZShelter.KeyStates[v] = false
		end
	end
end)

hook.Add("StartChat", "ZShelter-ChatOpened", function()
	ZShelter.ChatOpened = true
end)

hook.Add("FinishChat", "ZShelter-ChatClosed", function()
	ZShelter.ChatOpened = false
end)