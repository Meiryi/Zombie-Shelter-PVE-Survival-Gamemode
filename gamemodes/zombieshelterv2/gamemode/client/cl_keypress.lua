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

ZShelter.Menus = {}
ZShelter.KeyStates = {}
ZShelter.ChatOpened = false

local keys = {
	["BuildMenu"] = 12,
	["SkillMenu"] = 24,
	["ConfigMenu"] = 97,
	["Ready"] = 95,
	["GameUI"] = 93,
}

function ZShelter.DropGun()
	RunConsoleCommand("zshelter_drop_weapon")
end

function ZShelter.ClearMenus()
	for k,v in pairs(ZShelter.Menus) do
		if(!IsValid(v)) then
			table.remove(ZShelter.Menus, k)
		else
			v:Remove()
			table.remove(ZShelter.Menus, k)
		end
	end
end

function ZShelter.AddMenu(ui)
	table.insert(ZShelter.Menus, ui)
end

hook.Add("Think", "ZShelter-KeyPressHandler", function()
	if(gui.IsConsoleVisible() || IsValid(ZShelter.GamePanel) || ZShelter.BlockMenu || ZShelter.ChatOpened || GetConVar("zshelter_enable_menu_keys"):GetInt() != 1) then return end
	for k,v in next, ZShelter.Keybinds do
		if(input.IsKeyDown(v)) then
			if(!ZShelter.KeyStates[v]) then
				if(ZShelter[k]) then
					ZShelter[k]()
				end
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