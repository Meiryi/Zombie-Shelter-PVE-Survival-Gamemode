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

surface.CreateFont("ZShelter-ConfigFontBig", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(16),
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})
surface.CreateFont("ZShelter-ConfigFont", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(10),
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})
surface.CreateFont("ZShelter-ConfigBig", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(48),
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

local enemyElem = {
	[1] = {
		hint = "Class for enemy",
		id = "class",
		type = "textentry",
	},
	[2] = {
		hint = "Class for weapon",
		id = "weaponclass",
		type = "textentry",
	},
	[3] = {
		hint = "Health for enemy",
		id = "hp",
		type = "textentry",
		format = "int",
	},
	[4] = {
		hint = "Health increase per day",
		id = "hp_boost_day",
		type = "textentry",
		format = "int",
	},
	[5] = {
		hint = "Attack damage",
		id = "attack",
		type = "textentry",
		format = "int",
	},
	[6] = {
		hint = "Chance to spawn",
		id = "chance",
		type = "textentry",
		format = "int",
	},
	[7] = {
		hint = "Day for enemy to start spawning",
		id = "day",
		type = "textentry",
		format = "int",
	},
	[8] = {
		hint = "Day for enemy to stop spawning (-1 to spawn forever)",
		id = "end_day",
		type = "textentry",
		format = "int",
	},
	[9] = {
		hint = "Maximum amount per day (-1 for infinite)",
		id = "max_amount",
		type = "textentry",
		format = "int",
	},
	[10] = {
		hint = "Maximum amount alive (-1 for unlimited)",
		id = "max_exists",
		type = "textentry",
		format = "int",
	},
	[11] = {
		hint = "Minimum difficulty to spawn (-1 for all difficulty)",
		id = "min_difficulty",
		type = "textentry",
		format = "int",
	},
	[12] = {
		hint = "Maximum difficulty to spawn (-1 for all difficulty)",
		id = "max_difficulty",
		type = "textentry",
		format = "int",
	},

	[13] = {
		hint = "Mutation",
		id = "mutation",
		type = "textentry",
	},
	[14] = {
		hint = "Color",
		id = "color",
		type = "textentry",
		format = "color",
	},
	[15] = {
		hint = "Only spawn at night",
		id = "night_or_day",
		type = "button",
	},
	[16] = {
		hint = "Do not clear on night",
		id = "noclear",
		type = "button",
	},
	[17] = {
		hint = "Is treasure area boss",
		id = "isboss",
		type = "button",
	},
}

local itemElem = {
	[1] = {
		hint = "Name of weapon",
		id = "title",
		type = "textentry",
	},
	[2] = {
		hint = "Category",
		id = "category",
		type = "textentry",
	},
	[3] = {
		hint = "Weapon class",
		id = "class",
		type = "textentry",
	},
	[4] = {
		hint = "Icon path for weapon",
		id = "icon",
		type = "textentry",
	},
	[5] = {
		hint = "Required woods",
		id = "woods",
		type = "textentry",
		format = "int",
	},
	[6] = {
		hint = "Required irons",
		id = "irons",
		type = "textentry",
		format = "int",
	},
	[7] = {
		hint = "Damage multiplier",
		id = "dmgscale",
		type = "textentry",
		format = "int",
	},
	[8] = {
		hint = "Required skills (use comma for multiple skills)",
		id = "requiredskills",
		type = "textentry",
		format = "table",
	},
	[9] = {
		hint = "Can get ammo from ammo supply crate?",
		id = "ammo_supply",
		type = "button",
	},
}

local newEnemy = {
	day = 1,
	night_or_day = false,
	class = "npc_vj_zshelter_common_h",
	hp = 100,
	noclear = false,
	attack = 10,
	mutation = "none",
	weaponclass = "none",
	isboss = false,
	chance = 100,
	end_day = -1,
	min_difficulty = -1,
	max_difficulty = 9,
	max_exists = -1,
	max_amount = -1,
	hp_boost_day = 0,
	color = Color(255, 255, 255, 255),
}

local bgmat = Material("zsh/icon/tools.png", "smooth")
local func = {
	Enemy = function(ui, pa)
		local outlineSize = 1
		local dockmargin = ScreenScaleH(4)
		local innermargin = ScreenScaleH(2)
		local textmargin = ScreenScaleH(1)

		local margin = ScreenScaleH(16)

		local list = ZShelter.CreateScroll(pa, dockmargin, dockmargin, pa:GetWide() * 0.65 - dockmargin * 2, pa:GetTall() - dockmargin * 2, Color(30, 30, 30, 200))

		ui.EnemyConfigElems = {}

		local NextY = dockmargin
		local XPos = list:GetX() + list:GetWide() + dockmargin * 2
		local wide = pa:GetWide() * 0.33
		local tall = pa:GetTall() * 0.0475
		local tall2 = pa:GetTall() * 0.03

		for k,v in ipairs(enemyElem) do
			if(v.type == "textentry") then
				ui.EnemyConfigElems[v.id] = ZShelter.CreateTextEntry(pa, XPos, NextY, wide, tall, "ZShelter-ConfigFont", Color(30, 30, 30, 255), Color(200, 200, 200, 255), v.hint, v.format)
				NextY = NextY + tall + innermargin
			elseif(v.type == "button") then
				ui.EnemyConfigElems[v.id] = ZShelter.CreateCFGButton(pa, XPos, NextY, wide, tall2, "ZShelter-ConfigFont", Color(200, 200, 200, 255), v.hint, v.format)
				NextY = NextY + tall2 + dockmargin
			end
		end

		local btn = ZShelter.CreateButton(pa, XPos, NextY, wide, tall2, "Save Current Enemy", "ZShelter-ConfigFont", Color(200, 200, 200, 255), Color(30, 30, 30, 255), function()
			if(ui.CurrentEnemyIndex == -1) then return end
			for k,v in pairs(newEnemy) do
				if(ZShelter.EnemyConfig[ui.CurrentEnemyIndex][k] != nil) then continue end
				ZShelter.EnemyConfig[ui.CurrentEnemyIndex][k] = v
			end
			for k,v in pairs(ZShelter.EnemyConfig[ui.CurrentEnemyIndex]) do
				if(ui.EnemyConfigElems[k]) then
					ZShelter.EnemyConfig[ui.CurrentEnemyIndex][k] = ui.EnemyConfigElems[k]:GetVal()
				end
			end
			ui.ReloadEnemyList()
			ZShelter.SyncEnemy()
		end)
		btn.Paint = function()
			if(ui.CurrentEnemyIndex == -1) then
				draw.RoundedBox(0, 0, 0, btn:GetWide(), btn:GetTall(), Color(10, 10, 10, 100))
			else
				draw.RoundedBox(0, 0, 0, btn:GetWide(), btn:GetTall(), Color(30, 30, 30, 255))
			end
		end

		NextY = NextY + tall2 + dockmargin

		local btn = ZShelter.CreateButton(pa, XPos, NextY, wide, tall2, "Remove Selected Enemy", "ZShelter-ConfigFont", Color(200, 200, 200, 255), Color(30, 30, 30, 255), function()
			if(ui.CurrentEnemyIndex == -1) then return end
			for k,v in pairs(ui.EnemyConfigElems) do
				v:ResetVal()
			end
			table.remove(ZShelter.EnemyConfig, ui.CurrentEnemyIndex)
			ui.CurrentEnemyIndex = -1
			ui.ReloadEnemyList()
			ZShelter.SyncEnemy()
		end)
		btn.Paint = function()
			if(ui.CurrentEnemyIndex == -1) then
				draw.RoundedBox(0, 0, 0, btn:GetWide(), btn:GetTall(), Color(10, 10, 10, 100))
			else
				draw.RoundedBox(0, 0, 0, btn:GetWide(), btn:GetTall(), Color(30, 30, 30, 255))
			end
		end
		NextY = NextY + tall2 + dockmargin

		ZShelter.CreateButton(pa, XPos, NextY, wide, tall2, "Add a new enemy", "ZShelter-ConfigFont", Color(200, 200, 200, 255), Color(30, 30, 30, 255), function()
			ui.CurrentEnemyIndex = table.insert(ZShelter.EnemyConfig, newEnemy)
			ui.RefreshEnemyInfo(newEnemy)
			ui.ReloadEnemyList()
		end)

		ui.RefreshEnemyInfo = function(v)
		for key, val in pairs(newEnemy) do
			if(v[key] != nil) then continue end
			v[key] = val
		end
			for index, var in pairs(v) do
				if(ui.EnemyConfigElems[index]) then
					if(index == "color") then
							ui.EnemyConfigElems[index]:SetValue(var.r..","..var.g..","..var.b)
						else
							ui.EnemyConfigElems[index]:SetValue(var)
						end
					end
				end
		end

		ui.CurrentEnemyIndex = -1
		ui.ReloadEnemyList = function()
		list:Clear()
			for k,v in pairs(ZShelter.EnemyConfig) do
				local base = ZShelter.CreatePanel(list, 0, 0, list:GetWide(), list:GetTall() * 0.075, Color(40, 40, 40, 255))
					base:Dock(TOP)
					base:DockMargin(0, 0, 0, innermargin)
					local _, _, text = ZShelter.CreateLabel(base, innermargin, base:GetTall() / 2, "Day "..v.day.." | "..v.class, "ZShelter-ConfigFontBig", Color(200, 200, 200, 255))
						text:CentVer()
					base.Paint = function()
						if(ui.CurrentEnemyIndex == k) then
							draw.RoundedBox(0, 0, 0, base:GetWide(), base:GetTall(), Color(219, 130, 22, 255))
						else
							draw.RoundedBox(0, 0, 0, base:GetWide(), base:GetTall(), Color(40, 40, 40, 255))
						end
					end
					local btn = ZShelter.InvisButton(base, 0, 0, base:GetWide(), base:GetTall(), function()
						ui.CurrentEnemyIndex = k
						ui.RefreshEnemyInfo(v)
					end)
			end
		end

		ui.ReloadEnemyList()

		if(LocalPlayer():IsAdmin() || LocalPlayer():IsListenServerHost()) then
			if(GetConVar("zshelter_default_enemy_config"):GetInt() == 1) then
				ZShelter.CreatePanel(pa, 0, 0, pa:GetWide(), pa:GetTall(), Color(40, 0, 0, 80))
				local _, _, text = ZShelter.CreateLabel(pa, pa:GetWide() / 2, pa:GetTall() / 2, "You're using default enemy config!", "ZShelter-MenuLarge", Color(200, 200, 200, 255))
				text.CentPos()
			end
		else
			ZShelter.CreatePanel(pa, 0, 0, pa:GetWide(), pa:GetTall(), Color(40, 0, 0, 80))
			local _, _, text = ZShelter.CreateLabel(pa, pa:GetWide() / 2, pa:GetTall() / 2, "You don't have permission to edit config!", "ZShelter-MenuLarge", Color(200, 200, 200, 255))
			text.CentPos()
		end
	end,
	Weapons = function(ui, pa)

		local outlineSize = 1
		local dockmargin = ScreenScaleH(4)
		local dockmargin2 = ScreenScaleH(2)
		local innermargin = ScreenScaleH(2)
		local textmargin = ScreenScaleH(1)
		local margin = ScreenScaleH(16)
		local list = ZShelter.CreateScroll(pa, dockmargin, dockmargin, pa:GetWide() * 0.65 - dockmargin * 2, pa:GetTall() - dockmargin * 2, Color(30, 30, 30, 200))

		local NextY = dockmargin
		local XPos = list:GetX() + list:GetWide() + dockmargin * 2
		local wide = pa:GetWide() * 0.33
		local tall = pa:GetTall() * 0.065
		local tall2 = pa:GetTall() * 0.03

		ui.ItemConfigElems = {}

		ui.CurrentItemIndex = -1

		for k,v in ipairs(itemElem) do
			if(v.type == "textentry") then
				ui.ItemConfigElems[v.id] = ZShelter.CreateTextEntry(pa, XPos, NextY, wide, tall, "ZShelter-ConfigFont", Color(30, 30, 30, 255), Color(200, 200, 200, 255), v.hint, v.format)
				NextY = NextY + tall + dockmargin
			elseif(v.type == "button") then
				ui.ItemConfigElems[v.id] = ZShelter.CreateCFGButton(pa, XPos, NextY, wide, tall2, "ZShelter-ConfigFont", Color(200, 200, 200, 255), v.hint, v.format)
				NextY = NextY + tall2 + dockmargin
			end
		end

		local btn = ZShelter.CreateButton(pa, XPos, NextY, wide, tall2, "Save Current Item", "ZShelter-ConfigFont", Color(200, 200, 200, 255), Color(30, 30, 30, 255), function()
			if(ui.CurrentItemIndex == -1) then return end
			for k,v in pairs(ZShelter.ItemConfig[ui.CurrentItemIndex]) do
				if(ui.ItemConfigElems[k]) then
					ZShelter.ItemConfig[ui.CurrentItemIndex][k] = ui.ItemConfigElems[k]:GetVal()
				end
			end
			ui.ReloadItemList()
			ZShelter.SyncItem()
		end)
		btn.Paint = function()
			if(ui.CurrentItemIndex == -1) then
				draw.RoundedBox(0, 0, 0, btn:GetWide(), btn:GetTall(), Color(10, 10, 10, 100))
			else
				draw.RoundedBox(0, 0, 0, btn:GetWide(), btn:GetTall(), Color(30, 30, 30, 255))
			end
		end

		NextY = NextY + tall2 + dockmargin

		local btn = ZShelter.CreateButton(pa, XPos, NextY, wide, tall2, "Remove Selected Item", "ZShelter-ConfigFont", Color(200, 200, 200, 255), Color(30, 30, 30, 255), function()
			if(ui.CurrentItemIndex == -1) then return end
			for k,v in pairs(ui.ItemConfigElems) do
				v:ResetVal()
			end
			table.remove(ZShelter.ItemConfig, ui.CurrentItemIndex)
			ui.CurrentItemIndex = -1
			ui.ReloadItemList()
			ZShelter.SyncItem()
		end)
		btn.Paint = function()
			if(ui.CurrentItemIndex == -1) then
				draw.RoundedBox(0, 0, 0, btn:GetWide(), btn:GetTall(), Color(10, 10, 10, 100))
			else
				draw.RoundedBox(0, 0, 0, btn:GetWide(), btn:GetTall(), Color(30, 30, 30, 255))
			end
		end

		NextY = NextY + tall2 + dockmargin

		ZShelter.CreateButton(pa, XPos, NextY, wide, tall2, "Add a new weapon", "ZShelter-ConfigFont", Color(200, 200, 200, 255), Color(30, 30, 30, 255), function()
			local newWeapon = {
				category = "New Category",
				title = "Weapon Name",
				class = "Weapon Class",
				dmgscale = 1,
				icon = "",
				woods = 1,
				irons = 1,
				ammo_supply = true,
				requiredskills = {},
			}
			ui.CurrentItemIndex = table.insert(ZShelter.ItemConfig, newWeapon)
			ui.RefreshItemInfo(newWeapon)
			ui.ReloadItemList()
		end)

		ui.RefreshItemInfo = function(v)
			for index, var in pairs(v) do
				if(ui.ItemConfigElems[index]) then
					if(index == "requiredskills") then
						local str = ""
						for k,v in pairs(var) do
							if(k == 1) then
								str = v
								else
								str = str..","..v
							end
						end
							ui.ItemConfigElems[index]:SetValue(str)
						else
							ui.ItemConfigElems[index]:SetValue(var)
						end
					end
				end
		end

		ui.ReloadItemList = function()
		list:Clear()
		for k,v in pairs(ZShelter.ItemConfig) do
				local base = ZShelter.CreatePanel(list, 0, 0, list:GetWide(), list:GetTall() * 0.075, Color(40, 40, 40, 255))
					base:Dock(TOP)
					base:DockMargin(0, 0, 0, innermargin)
					local _, _, text = ZShelter.CreateLabel(base, innermargin, base:GetTall() / 2, v.category.." | "..v.title, "ZShelter-ConfigFontBig", Color(200, 200, 200, 255))
						text:CentVer()
					base.Paint = function()
						if(ui.CurrentItemIndex == k) then
							draw.RoundedBox(0, 0, 0, base:GetWide(), base:GetTall(), Color(219, 130, 22, 255))
						else
							draw.RoundedBox(0, 0, 0, base:GetWide(), base:GetTall(), Color(40, 40, 40, 255))
						end
					end
					local btn = ZShelter.InvisButton(base, 0, 0, base:GetWide(), base:GetTall(), function()
						ui.CurrentItemIndex = k
						ui.RefreshItemInfo(v)
					end)
		end
	end

		ui.ReloadItemList()

		if(LocalPlayer():IsAdmin() || LocalPlayer():IsListenServerHost()) then
			if(GetConVar("zshelter_default_item_config"):GetInt() == 1) then
				ZShelter.CreatePanel(pa, 0, 0, pa:GetWide(), pa:GetTall(), Color(40, 0, 0, 80))
				local _, _, text = ZShelter.CreateLabel(pa, pa:GetWide() / 2, pa:GetTall() / 2, "You're using default item config!", "ZShelter-MenuLarge", Color(200, 200, 200, 255))
				text.CentPos()
			end
		else
			ZShelter.CreatePanel(pa, 0, 0, pa:GetWide(), pa:GetTall(), Color(40, 0, 0, 80))
			local _, _, text = ZShelter.CreateLabel(pa, pa:GetWide() / 2, pa:GetTall() / 2, "You don't have permission to edit config!", "ZShelter-MenuLarge", Color(200, 200, 200, 255))
			text.CentPos()
		end
	end,
	Export = function(ui, pa)
		local outlineSize = 1
		local dockmargin = ScreenScaleH(4)
		local dockmargin2 = ScreenScaleH(2)
		local innermargin = ScreenScaleH(2)
		local textmargin = ScreenScaleH(1)
		local margin = ScreenScaleH(16)

		local tw, th, tx = ZShelter.CreateLabel(pa, margin, dockmargin, "Export Configs", "ZShelter-ConfigBig", Color(200, 200, 200, 255))
		local cfgname = ZShelter.CreateTextEntry(pa, margin, th + margin, pa:GetWide() * 0.6, pa:GetTall() * 0.1, "ZShelter-MenuLarge", Color(30, 30, 30, 255), Color(200, 200, 200, 255), "Enter your config name")
		ZShelter.CreateButton(pa, margin, th + margin + pa:GetTall() * 0.1 + dockmargin, pa:GetWide() * 0.15, pa:GetTall() * 0.08, "Export config", "ZShelter-ConfigFont", Color(200, 200, 200, 255), Color(30, 30, 30, 255), function()
			local val = cfgname:GetVal()
			if(val == "") then
				ZShelter.CenterMessage("You need to put atleast one character to export config!", ui)
			else
				local ok = false
				for i = 1, #val do
					if(val[i] != " ") then
						ok = true
						break
					end
				end
				if(ok) then
					local ctx1 = util.TableToJSON(ZShelter.ItemConfig)
					local ctx2 = util.TableToJSON(ZShelter.EnemyConfig)
					local path = "zombie shelter v2/config/"..val.."/"
					file.CreateDir(path)
					file.Write(path.."item.txt", ctx1)
					file.Write(path.."enemy.txt", ctx2)
					ZShelter.CenterMessage("Config has been saved to [data/zombie shelter v2/config/"..val.."/]", ui)
				else
					ZShelter.CenterMessage("You need at enter atleast one non-space character", ui)
				end
			end
		end, ScreenScaleH(4))
	end,
}

function ZShelter.ConfigMenu()
	if(IsValid(ZShelter.CFGMenu) || GetGlobalBool("GameStarted", false)) then
		if(IsValid(ZShelter.CFGMenu)) then
			ZShelter.CFGMenu:Remove()
		end
		return
	end
	ZShelter.ClearMenus()
	local sx = ScreenScaleH(300)
	local ui = ZShelter.CreateFrame(nil, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 120))
	ui:MakePopup()
	ui:Center()
	ui.oPaint = ui.Paint
	ui.Paint = function()
		ZShelter.DrawBlur(ui, 2)
		surface.SetMaterial(bgmat)
		surface.SetDrawColor(255, 255, 255, 5)
		surface.DrawTexturedRect(0, ScrH() - sx, sx, sx)
		ui.oPaint(ui)
	end

	local outlineSize = 1
	local dockmargin = ScreenScaleH(4)
	local innermargin = ScreenScaleH(2)
	local textmargin = ScreenScaleH(1)

	local margin = ScreenScaleH(16)
	ui.cate = ZShelter.CreateScroll(ui, margin, margin, ScrW() * 0.175, ScrH() * 0.7, Color(0, 0, 0, 0))
	ui.cate:SetY(ScrH() / 2 - ui.cate:GetTall() / 2)
	local scl = 0.215
	ui.container = ZShelter.CreatePanelContainer(ui, ScrW() * scl, ScrH() * 0.05, ScrW() * (1 - scl) - margin, ScrH() * 0.9, Color(0, 0, 0, 100))

	local config = {
		"Enemy", "Weapons", "Export"
	}

	for k,v in next, config do
		local base = ZShelter.CreateFrame(ui.cate, 0, 0, ui.cate:GetWide(), ui.cate:GetTall() * 0.1, Color(40, 40, 40, 255))
		local w, h = base:GetSize()
			base:Dock(TOP)
			base:DockMargin(0, 0, 0, dockmargin)
			base.oPaint = base.Paint
			base.Paint = function()
				local sx = outlineSize * 2
					draw.RoundedBox(0, outlineSize, outlineSize, w - sx, h - sx, Color(30, 30, 30, 180))
					surface.SetDrawColor(255, 255, 255, 255)
					surface.DrawOutlinedRect(0, 0, w, h, outlineSize)
			end
			local type = v
			local tw, th, title = ZShelter.CreateLabel(base, dockmargin, h / 2, type, "ZShelter-MenuLarge", Color(200, 200, 200, 255))
			title.CentVer()
			title:SetX((outlineSize + innermargin) + dockmargin)
			local pa = ZShelter.CreateFrame(ui.container, 0, 0, ui.container:GetWide(), ui.container:GetTall(), Color(0, 0, 0, 0))
			func[v](ui, pa)
			ui.container.AddPanel(pa)
			local btn = ZShelter.InvisButton(base, 0, 0, w, h, function()
				ui.container.CurrentPanel = pa
			end)
	end

	ZShelter.CFGMenu = ui
	ZShelter.AddMenu(ui)
end