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

surface.CreateFont("ZShelter-WorktableRefundTitle", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(18),
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

function ZShelter.RefundTab(category, container)
	local outlineSize = 1
	local tall = ScreenScaleH(32)
	local smargin = 0
	local yoffset = ScreenScaleH(3)
	local sidemargin = ScreenScaleH(20)
	local sx = ScreenScaleH(32)
	local margin = ScreenScaleH(16)
	local dockmargin = ScreenScaleH(4)
	local innermargin = ScreenScaleH(2)
	local textmargin = ScreenScaleH(1)
	local econ = ZShelter.EconomyEnabled()

	local type = "Uncraft Weapons"
	local base = ZShelter.CreatePanel(category, 0, 0, category:GetWide(), category:GetTall() * 0.08, Color(40, 40, 40, 255))
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

			local tw, th, title = ZShelter.CreateLabel(base, dockmargin, h / 2, ZShelter_GetTranslate("#"..type), "ZShelter-MenuLarge", Color(200, 200, 200, 255))
			title.CentVer()
			title:SetX((outlineSize + innermargin) + dockmargin)

			local pa = ZShelter.CreateScroll(container, 0, 0, container:GetWide(), container:GetTall(), Color(0, 0, 0, 0))
			container.AddPanel(pa)

			pa.ReloadList = function()
				pa:Clear()
				local wep = LocalPlayer():GetWeapons()
				for k,v in ipairs(wep) do
					if(v:GetNWInt("zsh_index", -1) == -1) then continue end
					local pnl = ZShelter.CreatePanel(pa, 0, 0, pa:GetWide(), pa:GetTall() * 0.125, Color(30, 30, 30, 120))
						pnl:Dock(TOP)
						pnl:DockMargin(0, 0, 0, dockmargin)
						pnl.Alpha = 0
						pnl.Paint = function()
							if(pnl.Hovered) then
								pnl.Alpha = math.Clamp(pnl.Alpha + ZShelter.GetFixedValue(20), 130, 255)
							else
								pnl.Alpha = math.Clamp(pnl.Alpha - ZShelter.GetFixedValue(20), 130, 255)
							end
							draw.RoundedBox(0, 0, 0, pnl:GetWide(), pnl:GetTall(), Color(30, 30, 30, pnl.Alpha))
							surface.SetDrawColor(255, 255, 255, pnl.Alpha)
							surface.DrawOutlinedRect(0, 0, pnl:GetWide(), pnl:GetTall(), outlineSize)
						end
						local class = v:GetClass()
						pnl.Think = function()
							if(!LocalPlayer():HasWeapon(class)) then
								pnl:Remove()
							end
						end
						local data = ZShelter.ItemConfig[v:GetNWInt("zsh_index")]
						local refundScale = 0.5
						local _, _, gunName = ZShelter.CreateLabel(pnl, dockmargin, pnl:GetTall() / 2, data.title, "ZShelter-WorktableRefundTitle", Color(200, 200, 200, 255))
						gunName.CentVer()

						local list = {
							[1] = "Woods",
							[2] = "Irons",
						}
						if(!econ) then
							local tw, th = ZShelter.GetTextSize("ZShelter-WorktableDesc", "dummy")
							local w, h = pnl:GetSize()
							local size = h * 0.5
							local yaxis = (h / 2) - (size / 2) - th / 2
							local nextX = w - (size + dockmargin * 2)
							for x,y in pairs(list) do
								ZShelter.CreateImage(pnl, nextX, yaxis, size, size, "zsh/icon/"..string.lower(y)..".png", Color(255, 255, 255, 255))
								local tw, th, cost = ZShelter.CreateLabel(pnl, nextX + size / 2, (yaxis + size) - innermargin, math.floor(data[string.lower(y)] * refundScale), "ZShelter-WorktableDesc", Color(200, 200, 200, 255))
								cost:CentHor()
								nextX = nextX - (size + dockmargin * 2)
							end
						else
							local costs = 0
							for x,y in pairs(list) do
								costs = costs + data[string.lower(y)] * (refundScale * 0.5)
							end
							local refund = math.floor(math.Round(costs, 2) * ZShelter.ResourceToMoney)
							local tw, th, cost = ZShelter.CreateLabel(pnl, pnl:GetWide(), pnl:GetTall() * 0.5, "$"..refund, "ZShelter-WorktableBig", Color(200, 200, 200, 255))
							cost:CentVer()
							cost:SetX(pnl:GetWide() - (tw + dockmargin))
						end

						local invisbutton = ZShelter.InvisButton(pnl, 0, 0, pnl:GetWide(), pnl:GetTall(), function()
							net.Start("ZShelter-UncraftWeapon")
							net.WriteEntity(v)
							net.SendToServer()
						end)
				
				end
			end

			listpnl = pa

			pa.ReloadList()

			local btn = ZShelter.InvisButton(base, 0, 0, w, h, function()
				pa.ReloadList()
				container.CurrentPanel = pa
			end)
end

local shelter = Material("zsh/buildui/shelter.png", "smooth")
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
	ui.cate = ZShelter.CreateScroll(ui, margin, margin, ScrW() * 0.175, ScrH() * 0.8, Color(0, 0, 0, 0))
	ui.cate:SetY(ScrH() / 2 - ui.cate:GetTall() / 2)
	local scl = 0.215
	ui.container = ZShelter.CreatePanelContainer(ui, ScrW() * scl, ScrH() * 0.15, ScrW() * (1 - scl) - margin, ScrH() * 0.75 - (margin), Color(0, 0, 0, 0))

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

	local filted = {}

	for k,v in ipairs(ZShelter.ItemConfig) do
		if(!filted[v.category]) then
			filted[v.category] = {}
		end
		v.__index = k
		table.insert(filted[v.category], v)
	end

	ZShelter.RefundTab(ui.cate, ui.container)

	local outlineSize = 1
	local dockmargin = ScreenScaleH(4)
	local innermargin = ScreenScaleH(2)
	local textmargin = ScreenScaleH(1)
	local listPos = {}
	local econ = ZShelter.EconomyEnabled()
	for k,v in next, order do
		local base = ZShelter.CreatePanel(ui.cate, 0, 0, ui.cate:GetWide(), ui.cate:GetTall() * 0.08, Color(40, 40, 40, 255))
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
			local tw, th, title = ZShelter.CreateLabel(base, dockmargin, h / 2, ZShelter_GetTranslate("#"..type), "ZShelter-MenuLarge", Color(200, 200, 200, 255))
			title.CentVer()
			title:SetX((outlineSize + innermargin) + dockmargin)

			local pa = ZShelter.CreatePanel(ui.container, 0, 0, ui.container:GetWide(), ui.container:GetTall(), Color(0, 0, 0, 0))

			ui.container.AddPanel(pa)

			local inited = {}
			local query = {}
			local _height = ScreenScaleH(30)
			local first = false
			local container = ZShelter.CreatePanelContainer(pa, 0, _height, pa:GetWide(), pa:GetTall() - _height, Color(0, 0, 0, 0))

			for k,v in pairs(filted[type] || {}) do
				if(v.category != type) then continue end
				v.shelterlevel = v.shelterlevel || 1
				if(!inited[v.shelterlevel]) then
					local panel = ZShelter.CreateScroll(container, 0, 0, container:GetWide(), container:GetTall(), Color(0, 0, 0, 0))
					container.AddPanel(panel)
					local btn = ZShelter.CreateButton(pa, 0, 0, 100, _height, "", "ZShelter-MenuLarge", Color(200, 200, 200, 255), Color(30, 30, 30, 255), function()
						container.CurrentPanel = panel
						lastlevel = v.shelterlvl
					end)
					btn.Selected = false
					btn.shelterlvl = v.shelterlevel
					btn.Think = function()
						btn.Selected = container.CurrentPanel == panel
					end
					table.insert(query, btn)
					if(!first) then
						container.CurrentPanel = panel
						first = true
					end
					inited[v.shelterlevel] = panel
				end
				local list = inited[v.shelterlevel]

				local w, h = pa:GetWide(), pa:GetTall() * 0.165
				local panel = ZShelter.CreatePanel(list, 0, 0, w, h, Color(30, 30, 30, 120))
					panel:Dock(TOP)
					panel:DockMargin(0, 0, 0, dockmargin)
					local tw, th, vol = ZShelter.CreateLabel(panel, panel:GetWide(), textmargin, ((v.volume || 1) * 100).."%", "ZShelter-WorktableTitle", Color(200, 200, 200, 255))
					vol:SetX(vol:GetX() - (tw + dockmargin))
					local img = ZShelter.CreateImage(panel, dockmargin + tw + innermargin, textmargin, th, th, "zsh/icon/volume.png", Color(255, 255, 255, 255))
					img:SetX(vol:GetX() - (th + innermargin))
					local regensp = v.ammoregen || 1
					if(regensp == -1) then
						regensp = 1
					end
					local tw, th, regen = ZShelter.CreateLabel(panel, panel:GetWide(), textmargin, regensp.."s", "ZShelter-WorktableTitle", Color(200, 200, 200, 255))
					regen:SetX(img:GetX() - (tw + dockmargin))
					local ammoimg = ZShelter.CreateImage(panel, dockmargin + tw + innermargin, textmargin, th, th, "zsh/icon/ammoregen.png", Color(255, 255, 255, 255))
					ammoimg:SetX(regen:GetX() - (th + innermargin))
					local capa = v.ammo_capacity || "inf"
					if(capa == -1) then
						capa = "inf"
					end
					local tw, th, capacity = ZShelter.CreateLabel(panel, panel:GetWide(), textmargin, capa, "ZShelter-WorktableTitle", Color(200, 200, 200, 255))
					capacity:SetX(ammoimg:GetX() - (tw + dockmargin))
					local ammoimg = ZShelter.CreateImage(panel, dockmargin + tw + innermargin, textmargin, th, th, "zsh/class/combat.png", Color(255, 255, 255, 255))
					ammoimg:SetX(capacity:GetX() - (th + innermargin))
					local tw, th, title = ZShelter.CreateLabel(panel, dockmargin, textmargin, v.title, "ZShelter-WorktableTitle", Color(200, 200, 200, 255))
					panel.Paint = function()
						draw.RoundedBox(0, 0, 0, panel:GetWide(), panel:GetTall(), Color(30, 30, 30, 150))
						draw.RoundedBox(0, 0, 0, panel:GetWide(), innermargin + th, Color(0, 0, 0, 220))
					end
					local size = ScreenScaleH(32)
					local currentX = pa:GetWide() - (dockmargin + size)

					local path = "zsh/icon/common.png"
					local default = v.icon == "default"
					if(v.icon && v.icon != "") then
						if(default) then
							local t = (panel:GetTall() - th)
							local size = t * 2
							local offset = size - t
							ZShelter.CreateImage(panel, dockmargin, panel:GetTall() * 0.5 - (offset * 0.5 + th), size, size, "entities/"..string.Replace(v.class, "zsh_", "")..".png", Color(255, 255, 255, 255))
							path = ""
						else
							if(file.Exists("materials/"..v.icon, "GAME")) then
								path = v.icon
							end
						end
					else
						if(file.Exists("materials/arccw/weaponicons/"..v.class..".vtf", "GAME")) then
							path = "arccw/weaponicons/"..v.class..".vtf"
						end
						if(v.class && string.sub(v.class, 1, 5) != "arccw") then
							path = ""
						end
					end
					if(path != "") then
						local imgW, imgH = panel:GetWide() * 0.2, panel:GetTall() - th
						ZShelter.CreateImage(panel, dockmargin, th, imgW, imgH, path, Color(255, 255, 255, 255))
					end

					local list = {
						[1] = "Woods",
						[2] = "Irons",
					}
					local size = h * 0.4
					local yaxis = (h / 2) - (size / 2)
					local nextX = w - (size + dockmargin * 2)
					if(!econ) then
						for x,y in pairs(list) do
							ZShelter.CreateImage(panel, nextX, yaxis, size, size, "zsh/icon/"..string.lower(y)..".png", Color(255, 255, 255, 255))
							local tw, th, cost = ZShelter.CreateLabel(panel, nextX + size / 2, (yaxis + size) - innermargin, v[string.lower(y)], "ZShelter-WorktableDesc", Color(200, 200, 200, 255))
							cost:CentHor()
							nextX = nextX - (size + dockmargin * 2)
						end
					else
						local costs = 0
						for x,y in pairs(list) do
							costs = costs + v[string.lower(y)]
						end
						costs = math.floor(costs * ZShelter.ResourceToMoney)
						local tw, th, cost = ZShelter.CreateLabel(panel, panel:GetWide(), panel:GetTall() * 0.5 + title:GetTall() * 0.5, "$"..costs, "ZShelter-WorktableBig", Color(200, 200, 200, 255))
						cost:CentVer()
						cost:SetX(panel:GetWide() - (tw + dockmargin))
						nextX = nextX	- tw - dockmargin
					end

					yaxis = yaxis + dockmargin
					size = size + innermargin
					for _, str in pairs(v.requiredskills) do
						local val = string.Explode(",", str)
						if(#val > 1) then
							v.requiredskills = val
						end
					end
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
					net.WriteInt(v.__index, 32)
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

			local nx = 0
			local co = #query
			local sizes = (container:GetWide() / co)
			for k,v in pairs(query) do
				v:SetX(nx)
				v:SetWide(sizes)

				local sx = ScreenScaleH(16)
				local pos = v:GetWide() / 2
				v.alpha = 0
				v.Paint = function()
					if(v.Selected) then
						v.alpha = math.Clamp(v.alpha + ZShelter.GetFixedValue(20), 150, 255)
					else
						v.alpha = math.Clamp(v.alpha - ZShelter.GetFixedValue(20), 150, 255)
					end
					draw.RoundedBox(0, 0, 0, v:GetWide(), v:GetTall(), Color(30, 30, 30, v.alpha))
					surface.SetDrawColor(255, 255, 255, v.alpha)
					draw.DrawText(v.shelterlvl, "ZShelter-MenuLarge", pos + dockmargin, dockmargin * 2, Color(255, 255, 255, v.alpha), TEXT_ALIGN_CENTER)
					surface.SetMaterial(shelter)
					surface.DrawTexturedRect(pos - sx, dockmargin * 1.5, sx, sx)
				end

				nx = nx + (sizes + innermargin)
			end

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