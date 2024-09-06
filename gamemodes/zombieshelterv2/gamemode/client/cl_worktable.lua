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

surface.CreateFont("ZShelter-WorktableBig", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(24),
	weight = 1000,
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

surface.CreateFont("ZShelter-WorktableTitle", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(14),
	weight = 1000,
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

surface.CreateFont("ZShelter-WorktableDesc", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(10),
	weight = 1000,
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


net.Receive("ZShelter-OpenWorktable", function()
	ZShelter.OpenWorktable()
end)

function ZShelter.OpenWorktable()
	if(IsValid(ZShelter.WorktableUI)) then
		return
	end
	local ui = ZShelter.CreatePanel(nil, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 120))

	ui.PersonalResources = false

	ui:MakePopup()
	ui:Center()

	ui.oPaint = ui.Paint
	ui.Paint = function()
		ZShelter.DrawBlur(ui, 2)
		ui.oPaint(ui)
	end

	local tall = ScreenScaleH(32)
	local scl = 0.25
	ui.ResourceDisplayer = ZShelter.CreatePanel(ui, ScrW() * ((1 - scl) / 2), ScrH() - tall, ScrW() * scl, tall, Color(0, 0, 0, 200))

	local smargin = 0
	local yoffset = ScreenScaleH(3)
	local sidemargin = ScreenScaleH(20)
	local sx = ScreenScaleH(32)

	ui.ResourceDisplayer.Wood = ZShelter.CreateImage(ui.ResourceDisplayer, sidemargin, smargin, sx, sx, "zsh/icon/woods.png")
	local w, h, num = ZShelter.CreateLabel(ui.ResourceDisplayer, ui.ResourceDisplayer.Wood:GetX() + sx, ui.ResourceDisplayer.Wood:GetY() + sx, 0, "ZShelter-MenuLarge", Color(200, 200, 200, 255), false, Color(100, 100, 100, 255))
	num:SetY(num:GetY() - (h + yoffset))
	num.Think = function()
		if(ui.PersonalResources) then
			num.UpdateText(LocalPlayer():GetNWInt("Woods", 0))
		else
			num.UpdateText(GetGlobalInt("Woods", 0))
		end
	end
	ui.ResourceDisplayer.Iron = ZShelter.CreateImage(ui.ResourceDisplayer, ui.ResourceDisplayer:GetWide() / 2 - (sx / 2), smargin, sx, sx, "zsh/icon/irons.png")
	local w, h, num = ZShelter.CreateLabel(ui.ResourceDisplayer, ui.ResourceDisplayer.Iron:GetX() + sx + ScreenScaleH(3), ui.ResourceDisplayer.Iron:GetY() + sx, 0, "ZShelter-MenuLarge", Color(200, 200, 200, 255), false, Color(100, 100, 100, 255))
	num:SetY(num:GetY() - (h + yoffset))
	num.Think = function()
		if(ui.PersonalResources) then
			num.UpdateText(LocalPlayer():GetNWInt("Irons", 0))
		else
			num.UpdateText(GetGlobalInt("Irons", 0))
		end
	end

	ui.ResourceDisplayer.Power = ZShelter.CreateImage(ui.ResourceDisplayer, ui.ResourceDisplayer:GetWide() - (sidemargin + sx), smargin, sx, sx, "zsh/icon/powers.png")
	local w, h, num = ZShelter.CreateLabel(ui.ResourceDisplayer, ui.ResourceDisplayer.Power:GetX() + sx - ScreenScaleH(8), ui.ResourceDisplayer.Power:GetY() + sx, 0, "ZShelter-MenuLarge", Color(200, 200, 200, 255), false, Color(100, 100, 100, 255))
	num:SetY(num:GetY() - (h + yoffset))
	num.Think = function()
		num.UpdateText(GetGlobalInt("Powers", 0))
	end

	local _t = ScreenScaleH(10)
	local hint = ZShelter.CreatePanel(ui, ScrW() * ((1 - scl) / 2), ScrH() - (ui.ResourceDisplayer:GetTall() + _t), ScrW() * scl, _t, Color(0, 0, 20, 200))
	local str = ZShelter_GetTranslate("#PublicStorageHint")
	hint.Paint = function()
		if(ui.PersonalResources) then return end
		draw.RoundedBox(0, 0, 0, hint:GetWide(), hint:GetTall(), Color(150, 182, 255, 150))
		draw.DrawText(str, "ZShelter-MenuSmall", hint:GetWide() * 0.5, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	end

	local margin = ScreenScaleH(16)
	ui.cate = ZShelter.CreateScroll(ui, margin, margin, ScrW() * 0.175, ScrH() * 0.7, Color(0, 0, 0, 0))
	ui.cate:SetY(ScrH() / 2 - ui.cate:GetTall() / 2)
	local scl = 0.215
	ui.container = ZShelter.CreatePanelContainer(ui, (ScrW() * 1.6) * scl, ScrH() * 0.15, (ScrW() * 0.65) * (1 - scl) - margin, ScrH() * 0.7 - (margin), Color(0, 0, 0, 0))

	local runorder = {
		["Pistol"] = 1,
		["SMG"] = 2,
		["Shotgun"] = 3,
		["Rifle"] = 4,
		["Heavy"] = 5,
		["Misc"] = 6,
	}
	
	local sort = {}
	local order = {}
	local types = {}

	local LoadOrder = {}
	local count = 1
	for k,v in next, ZShelter.ItemConfig do
		if(!sort[v.category]) then
			sort[v.category] = count
		end
		count = count + 1
	end

	for k,v in pairs(sort) do
		if(runorder[k]) then
			order[runorder[k]] = v
			types[runorder[k]] = k
			sort[k] = nil
		end
	end

	for k,v in pairs(sort) do
		table.insert(order, v)
		table.insert(types, k)
	end

	local resources = {
		[1] = "Woods",
		[2] = "Irons",
		[3] = "Powers",
	}

	local outlineSize = 1
	local dockmargin = ScreenScaleH(4)
	local innermargin = ScreenScaleH(2)
	local textmargin = ScreenScaleH(1)
	local listPos = {}
	for k,v in next, order do
		local base = ZShelter.CreatePanel(ui.cate, 0, 0, ui.cate:GetWide(), ui.cate:GetTall() * 0.1, Color(40, 40, 40, 255))
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
			local type = types[k]

--[[
			local isx = base:GetTall() - dockmargin * 2
			local image = "zsh/icon/questionmark.png"
			if(file.Exists("materials/zsh/worktable/"..string.lower(string.Replace(type, " ", "_"))..".png", "GAME")) then
				image = "zsh/worktable/"..string.lower(string.Replace(type, " ", "_"))..".png"
			end
			local img = ZShelter.CreateImage(base, dockmargin, dockmargin, isx, isx, image)
]]
			local tw, th, title = ZShelter.CreateLabel(base, dockmargin, h / 2, ZShelter_GetTranslate("#"..type), "ZShelter-MenuLarge", Color(200, 200, 200, 255))
			title.CentVer()
			title:SetX((outlineSize + innermargin) + dockmargin)

			local pa = ZShelter.CreatePanel(ui.container, 0, 0, ui.container:GetWide(), ui.container:GetTall(), Color(0, 0, 0, 0))
			local list = ZShelter.CreateScroll(pa, 0, 0, pa:GetWide(), pa:GetTall(), Color(0, 0, 0, 0))

			for k,v in pairs(ZShelter.ItemConfig) do
				if(v.category != type) then continue end
				local w, h = pa:GetWide(), pa:GetTall() * 0.165
				local panel = ZShelter.CreatePanel(list, 0, 0, w, h, Color(30, 30, 30, 120))
					panel:Dock(TOP)
					panel:DockMargin(0, 0, 0, dockmargin)

					local tw, th, title = ZShelter.CreateLabel(panel, dockmargin, textmargin, v.title, "ZShelter-WorktableTitle", Color(200, 200, 200, 255))
					panel.Paint = function()
						draw.RoundedBox(0, 0, 0, panel:GetWide(), panel:GetTall(), Color(30, 30, 30, 150))
						draw.RoundedBox(0, 0, 0, panel:GetWide(), innermargin + th, Color(0, 0, 0, 220))
					end
					local size = ScreenScaleH(32)
					local currentX = pa:GetWide() - (dockmargin + size)

					local path = "zsh/icon/common.png"
					if(v.icon && v.icon != "") then
						if(file.Exists("materials/"..v.icon, "GAME")) then
							path = v.icon
						end
					else
						if(file.Exists("materials/arccw/weaponicons/"..v.class..".vtf", "GAME")) then
							path = "arccw/weaponicons/"..v.class..".vtf"
						end
					end
					local imgW, imgH = panel:GetWide() * 0.2, panel:GetTall() - th
					ZShelter.CreateImage(panel, dockmargin, th, imgW, imgH, path, Color(255, 255, 255, 255))

					local list = {
						[1] = "Woods",
						[2] = "Irons",
					}

					local size = h * 0.4
					local yaxis = (h / 2) - (size / 2)
					local nextX = w - (size + dockmargin * 2)
					for x,y in pairs(list) do
						ZShelter.CreateImage(panel, nextX, yaxis, size, size, "zsh/icon/"..string.lower(y)..".png", Color(255, 255, 255, 255))
						local tw, th, cost = ZShelter.CreateLabel(panel, nextX + size / 2, (yaxis + size) - innermargin, v[string.lower(y)], "ZShelter-WorktableDesc", Color(200, 200, 200, 255))
						cost:CentHor()
						nextX = nextX - (size + dockmargin * 2)
					end

					yaxis = yaxis + dockmargin
					size = size + innermargin
					for _, skill in pairs(v.requiredskills) do
						local data = ZShelter.SkillDatas[skill]
						if(!data) then continue end
						ZShelter.CreateImage(panel, nextX, yaxis, size, size, data.iconpath, Color(255, 255, 255, 255))
						nextX = nextX - (size + dockmargin * 2)
					end
				panel.CanCraft = false
				panel.NextCheck = 0
				local btn = ZShelter.InvisButton(panel, 0, 0, w, h, function()
					if(!panel.CanCraft) then return end
					net.Start("ZShelter-Worktable")
					net.WriteInt(k, 32)
					net.SendToServer()
				end)
				btn.Think = function()
					if(panel.NextCheck > CurTime()) then return end
					panel.CanCraft = ZShelter.CanCraftWeapon(LocalPlayer(), v)
					panel.NextCheck = CurTime() + 0.15
				end
				btn.Paint = function()
					if(panel.CanCraft) then return end
					draw.RoundedBox(0, 0, 0, w, h, Color(80, 30, 30, 30))
				end
			end

			ui.container.AddPanel(pa)

			local btn = ZShelter.InvisButton(base, 0, 0, w, h, function()
				ui.container.CurrentPanel = pa
				ui.PersonalResources = false
			end)
	end

	local type = "Close"
	local base = ZShelter.CreatePanel(ui.cate, 0, 0, ui.cate:GetWide(), ui.cate:GetTall() * 0.1, Color(40, 40, 40, 255))
	local w, h = base:GetSize()
		base:Dock(TOP)
		base:DockMargin(0, dockmargin * 8, 0, 0)
		base.oPaint = base.Paint
		base.Paint = function()
			local sx = outlineSize * 2
				draw.RoundedBox(0, outlineSize, outlineSize, w - sx, h - sx, Color(30, 30, 30, 180))
				surface.SetDrawColor(255, 255, 255, 255)
				surface.DrawOutlinedRect(0, 0, w, h, outlineSize)
		end
		local isx = base:GetTall() - dockmargin * 2
		local image = "zsh/worktable/twitter.png"
		local img = ZShelter.CreateImage(base, dockmargin, dockmargin, isx, isx, image)
		local tw, th, title = ZShelter.CreateLabel(base, dockmargin + isx, h / 2, ZShelter_GetTranslate("#"..type), "ZShelter-MenuLarge", Color(200, 200, 200, 255))
		title.CentVer()
		title:SetX((outlineSize + innermargin) + dockmargin + isx)
		local btn = ZShelter.InvisButton(base, 0, 0, w, h, function()
			ui:Remove()
		end)

	ZShelter.WorktableUI = ui
end