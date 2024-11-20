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

surface.CreateFont("ZShelter-MenuBig", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(28),
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

surface.CreateFont("ZShelter-MenuTitle", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(20),
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

surface.CreateFont("ZShelter-MenuUpgrade", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(14),
	weight = 100,
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

surface.CreateFont("ZShelter-MenuLarge", {
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

surface.CreateFont("ZShelter-MenuSmall", {
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

local lasttab = nil
local lastlevel = nil

local texture = Material("zsh/icon/footer_white.png", "smooth")
local shelter = Material("zsh/buildui/shelter.png", "smooth")
local attack = Material("zsh/icon/attack.png", "smooth")
local health_mat = Material("zsh/icon/health.png", "smooth")
local upgrade = Material("zsh/icon/building.png", "smooth")
local blueprint = Material("zsh/icon/blueprint.png")
function ZShelter.MakeShelterTab(ui)
	local outlineSize = 1
	local dockmargin = ScreenScaleH(4)
	local innermargin = ScreenScaleH(2)
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
		local type = "Shelter"

		local isx = base:GetTall() - dockmargin * 2
		local image = "zsh/icon/questionmark.png"
		if(file.Exists("materials/zsh/buildui/"..string.lower(string.Replace(type, " ", "_"))..".png", "GAME")) then
			image = "zsh/buildui/"..string.lower(string.Replace(type, " ", "_"))..".png"
		end
		local img = ZShelter.CreateImage(base, dockmargin, dockmargin, isx, isx, image)
		local tw, th, title = ZShelter.CreateLabel(base, dockmargin + isx, h / 2, ZShelter_GetTranslate("#"..type), "ZShelter-MenuLarge", Color(200, 200, 200, 255))
		title.CentVer()
		title:SetX((outlineSize + innermargin) + dockmargin + isx)

	local pa = ZShelter.CreatePanel(ui.container, 0, 0, ui.container:GetWide(), ui.container:GetTall(), Color(0, 0, 0, 0))

	local resources = {
		[1] = "Woods",
		[2] = "Irons",
		[3] = "Powers",
	}

	local scaling = 1 + (math.max(player.GetCount() - 1, 0) * 0.5)
	for k,v in pairs(ZShelter.ShelterUpgrade) do
		if(GetGlobalInt("ShelterLevel", 0) >= k && k != #ZShelter.ShelterUpgrade) then continue end
		local base = ZShelter.CreatePanel(pa, 0, 0, pa:GetWide(), ui.container:GetTall() * 0.7, Color(30, 30, 30, 255))
			base:Dock(TOP)
			base:DockMargin(0, 0, 0, dockmargin)
			local tw, th, text = ZShelter.CreateLabel(base, dockmargin, 0, ZShelter_GetTranslate_Var("#UpgradeLevel_X", (k + 1)), "ZShelter-MenuBig", Color(200, 200, 200, 255))
			base.Paint = function()
				draw.RoundedBox(0, 0, 0, base:GetWide(), base:GetTall(), Color(30, 30, 30, 150))
				draw.RoundedBox(0, 0, 0, base:GetWide(), innermargin + th, Color(0, 0, 0, 220))
			end
			local spr = base:Add("DModelPanel")
			spr:SetPos(0, th + innermargin)
				spr:SetSize(base:GetWide(), base:GetTall() * 0.675)
				spr:SetModel(v.sheltermodel)
				spr:SetCamPos(Vector(0, 0, 0) + v.CameraOffset)
				spr:SetLookAng(Angle(0, 0, 0))
				local mins, maxs = spr.Entity:GetModelBounds()

				spr.Entity:SetAngles(v.Angle)
				spr.Entity:SetPos(Vector(0, 0, 0) + v.Offset)

				function spr:LayoutEntity() return end
				spr.oPaint = spr.Paint
				spr.Paint = function(...)
					draw.RoundedBox(0, 0, 0, spr:GetWide(), spr:GetTall(), Color(40,40, 40, 120))
					spr.oPaint(...)
				end

				local sx = ScreenScaleH(40)
				local yaxis = base:GetTall() * 0.8
				local nextX = dockmargin * 3

				for xpos, res in next, resources do
					local icon = ZShelter.CreateImage(base, nextX, yaxis, sx, sx, "zsh/icon/"..string.lower(res)..".png")
					local costing = v[string.lower(res)]
					if(res != "Powers") then costing = math.floor(costing * scaling) end
					local _, _, cost = ZShelter.CreateLabel(base, nextX + (sx / 2), yaxis + sx, costing, "ZShelter-MenuSmall", Color(200, 200, 200, 255))
					cost:CentHor()

					cost.Think = function()
						if(costing) then
							if(GetGlobalInt(res, 0) < costing) then
								cost:SetTextColor(Color(255, 55, 55, 255))
							else
								cost:SetTextColor(Color(255, 255, 255, 255))
							end
						end
					end

					nextX = nextX + sx + dockmargin * 2
				end
				nextX = nextX + dockmargin
				local mvWide, mvTall = ScreenScaleH(86), ScreenScaleH(128)
				for build, datas in pairs(v.required_building) do
					local rdata = ZShelter.BuildingData[build]
					if(!rdata) then continue end
					local spr = base:Add("DModelPanel")
						spr:SetPos(nextX, base:GetTall() * 0.7)
						spr:SetSize(mvWide, mvTall - (mvTall - sx) / 2)
						spr:SetModel(rdata.model)
						spr.Entity:SetPos(spr.Entity:GetPos() + rdata.offset + datas.Offset)
						spr.Entity:SetAngles(datas.Angle)
						local mins, maxs = spr.Entity:GetModelBounds()
						local dst = mins:Distance(maxs)
						local campos = spr:GetCamPos()
						spr:SetCamPos(campos + Vector(0, math.max(dst - 60, 0), 0) + datas.CameraOffset)
						spr:SetFOV(50)
						local _, _, bname = ZShelter.CreateLabel(base, nextX + (mvWide / 2), yaxis + sx, ZShelter_GetTranslate("#"..build), "ZShelter-MenuSmall", Color(200, 200, 200, 255))
						bname.Think = function()
							if(GetGlobalInt("Build_"..build, 0) <= 0) then
								bname:SetTextColor(Color(255, 55, 55, 255))
							else
								bname:SetTextColor(Color(255, 255, 255, 255))
							end
						end
						bname:CentHor()
						spr.Entity:SetAngles(Angle(0, 35, 0))
						function spr:LayoutEntity() return end
					nextX = nextX + mvWide + dockmargin * 2
				end


			base.CanBuild = false
			base.NextCheck = 0
			base.Think = function()
				if(base.NextCheck > CurTime()) then return end
				base.CanBuild = ZShelter.CanUpgradeShelter(k, math.floor(v.woods * scaling), math.floor(v.irons * scaling), v.powers, v.required_building)
				base.NextCheck = CurTime() + 0.15
			end
			local btn = ZShelter.InvisButton(base, 0, 0, base:GetWide(), base:GetTall(), function()
				if(!base.CanBuild || GetGlobalInt("ShelterLevel", 0) >= k) then return end
				net.Start("ZShelter-UpgradeShelter")
				net.WriteInt(k, 32)
				net.SendToServer()
			end)
			btn.Paint = function()
				if(GetGlobalInt("ShelterLevel", 0) >= k) then
					local offs, w, h = base:GetTall() * 0.4, base:GetWide(), base:GetTall() * 0.2
					local tall = ScreenScaleH(3)
					draw.RoundedBox(0, 0, 0, base:GetWide(), base:GetTall(), Color(0, 0, 0, 110))
					draw.RoundedBox(0, 0, offs, w, h, Color(10, 10, 10, 220))

					surface.SetDrawColor(255, 255, 255, 10)
					surface.SetMaterial(texture)
					surface.DrawTexturedRect(0, offs, w, tall)
					surface.DrawTexturedRect(0, offs + h - tall, w, tall)

					draw.DrawText(ZShelter_GetTranslate("#ShelterUpgradeDone"), "ZShelter-MenuBig", base:GetWide() / 2, base:GetTall() * 0.45, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
				end
			end
			break
	end

	ui.container.AddPanel(pa)
	local btn = ZShelter.InvisButton(base, 0, 0, w, h, function()
		ui.container.CurrentPanel = pa
		ui.PersonalResources = false
	end)
end

local warning = Material("zsh/icon/warning.png", "smooth")
function ZShelter.BuildMenu()
	if(ZShelter.Building || IsValid(ZShelter.CFGMenu)) then return end
	if(IsValid(ZShelter.BuildUI)) then
		ZShelter.BuildUI:Remove()
		return
	end
	ZShelter.ClearMenus()
	local ui = ZShelter.CreatePanel(nil, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 120))

	ui.PersonalResources = true

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
	local str2 = ZShelter_GetTranslate("#PersonalStorageHint")
	hint.Paint = function()
		if(ui.PersonalResources) then
			draw.RoundedBox(0, 0, 0, hint:GetWide(), hint:GetTall(), Color(150, 182, 255, 150))
			draw.DrawText(str2, "ZShelter-MenuSmall", hint:GetWide() * 0.5, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		else
			draw.RoundedBox(0, 0, 0, hint:GetWide(), hint:GetTall(), Color(150, 255, 152, 150))
			draw.DrawText(str, "ZShelter-MenuSmall", hint:GetWide() * 0.5, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		end
	end

	local margin = ScreenScaleH(16)
	ui.cate = ZShelter.CreateScroll(ui, margin, margin, ScrW() * 0.175, ScrH() * 0.7, Color(0, 0, 0, 0))
	ui.cate:SetY(ScrH() / 2 - ui.cate:GetTall() / 2)
	local scl = 0.215
	ui.container = ZShelter.CreatePanelContainer(ui, ScrW() * scl, ScrH() * 0.15, ScrW() * (1 - scl) - margin, ScrH() * 0.75 - (margin), Color(0, 0, 0, 0))

	local order = {
		[1] = "Barricade",
		[2] = "Trap",
		[3] = "Turret",
		[4] = "Generator",
		[5] = "Recovery",
		[6] = "Storage",
		[7] = "Public Construction",
	}

	local LoadOrder = {}
	for k,v in next, order do
		if(!ZShelter.BuildingConfig[v]) then continue end
		table.insert(LoadOrder, ZShelter.BuildingConfig[v])
	end

	for k,v in next, ZShelter.BuildingConfig do
		if(table.HasValue(order, k)) then continue end -- This is not good
		table.insert(order, k)
		table.insert(LoadOrder, v)
	end

	ZShelter.MakeShelterTab(ui)

	local resources = {
		[1] = "Woods",
		[2] = "Irons",
		[3] = "Powers",
	}
	local costscl = {
		Woods = "ResCost",
		Irons = "ResCost",
		Powers = "PowerCost",
	}
	local outlineSize = 1
	local dockmargin = ScreenScaleH(4)
	local innermargin = ScreenScaleH(2)
	local textmargin = ScreenScaleH(1)
	local listPos = {}
	for k,v in next, LoadOrder do
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
			local type = order[k]

			local isx = base:GetTall() - dockmargin * 2
			local image = "zsh/icon/questionmark.png"
			if(file.Exists("materials/zsh/buildui/"..string.lower(string.Replace(type, " ", "_"))..".png", "GAME")) then
				image = "zsh/buildui/"..string.lower(string.Replace(type, " ", "_"))..".png"
			end
			local img = ZShelter.CreateImage(base, dockmargin, dockmargin, isx, isx, image)
			local tw, th, title = ZShelter.CreateLabel(base, dockmargin + isx, h / 2, ZShelter_GetTranslate("#"..type), "ZShelter-MenuLarge", Color(200, 200, 200, 255))
			title.CentVer()
			title:SetX((outlineSize + innermargin) + dockmargin + isx)

			local pa = ZShelter.CreatePanel(ui.container, 0, 0, ui.container:GetWide(), ui.container:GetTall(), Color(0, 0, 0, 0))
			local elemWide, elemTall = (ui.container:GetWide() / 3) - (dockmargin * 2), ui.container:GetTall() * 0.175
			local shouldReset = false
			local lastSort = 0
			local pos = 0
			local inited = {}
			local query = {}
			local _height = ScreenScaleH(30)
			local first = false
			local container = ZShelter.CreatePanelContainer(pa, 0, _height, pa:GetWide(), pa:GetTall() - _height, Color(0, 0, 0, 0))

			for x,y in next, v do
				if(!inited[y.shelterlvl]) then
					local _pa = ZShelter.CreateScroll(container, 0, 0, container:GetWide(), container:GetTall(), Color(0, 0, 0, 0))
					container.AddPanel(_pa)
					local btn = ZShelter.CreateButton(pa, 0, 0, 100, _height, "", "ZShelter-MenuLarge", Color(200, 200, 200, 255), Color(30, 30, 30, 255), function()
						container.CurrentPanel = _pa
						lastlevel = y.shelterlvl
					end)
					btn.Selected = false
					btn.Think = function()
						btn.Selected = container.CurrentPanel == _pa
					end
					btn.shelterlvl = y.shelterlvl + 1
					table.insert(query, btn)
					if(!first) then
						container.CurrentPanel = _pa
						first = true
					end
					inited[y.shelterlvl] = _pa
				end
				local basepanel = inited[y.shelterlvl]

				if(k == lasttab && y.shelterlvl == lastlevel) then
					container.CurrentPanel = basepanel
				end

				if(!IsValid(basepanel)) then continue end
				local elem = ZShelter.CreatePanel(basepanel, 0, 0, basepanel:GetWide(), basepanel:GetTall() * 0.25, Color(0, 0, 0, 100))
					elem:Dock(TOP)
					elem:DockMargin(0, dockmargin, 0, 0)
					elem.NextCheck = 0
					elem.CanBuild = false
					elem.Think = function()
						if(elem.NextCheck > CurTime()) then return end
						elem.CanBuild = ZShelter.IsRequirementMeet(LocalPlayer(), y)
						elem.NextCheck = CurTime() + 0.15
					end
					local modelViewer = elem:Add("DModelPanel")

						modelViewer:SetPos(0, (innermargin))
						modelViewer:SetSize(elem:GetWide() * 0.25, elem:GetTall() - innermargin)
						modelViewer:SetModel(y.model)
						modelViewer.Entity:SetPos(modelViewer.Entity:GetPos() + y.offset)
						local mins, maxs = modelViewer.Entity:GetModelBounds()
						local dst = mins:Distance(maxs)
						local campos = modelViewer:GetCamPos()
						modelViewer:SetCamPos(campos + Vector(0, math.max(dst, -20), 0))
						modelViewer.oPaint = modelViewer.Paint
						modelViewer.Paint = function(...)
							draw.RoundedBox(0, 0, 0, elem:GetWide(), elem:GetTall(), Color(35, 35, 35, 200))
							modelViewer.oPaint(...)
						end

					local _text = ZShelter_GetTranslate("#"..y.title)
					local current, maximum = 0, -1
					local tw, th, text = ZShelter.CreateLabel(elem, modelViewer:GetWide() + innermargin, dockmargin, ZShelter_GetTranslate("#"..y.title), "ZShelter-MenuTitle", Color(200, 200, 200, 255))
					if(y.tdata) then
						if(y.tdata.maxamount) then
							maximum = y.tdata.maxamount
						end
						if(y.tdata.playercount) then
							maximum = player.GetCount()
						end
					end
					if(maximum != -1) then
						local idx = "Build_"..y.title
						text.Think = function()
							current = GetGlobalInt(idx)
							text.UpdateText(_text.." ["..current.."/"..maximum.."]")
						end
					end

					local twide = elem:GetWide() - (dockmargin * 2)
					local nextX = elem:GetWide() - dockmargin * 3
					local yaxis = elem:GetTall() * 0.25
					local icosize = ScreenScaleH(40)
					for xpos, res in next, table.Reverse(resources) do
						nextX = nextX - (icosize + dockmargin * 2)
						local icon = ZShelter.CreateImage(elem, nextX, yaxis, sx, sx, "zsh/icon/"..string.lower(res)..".png")
						local nwstr = costscl[res]	
						local scale = 1
						if(nwstr) then
							scale = LocalPlayer():GetNWFloat(nwstr, 1)
						end
						local costs = math.floor(math.max(y[string.lower(res)] * scale, 1))
						if(res == "Powers" && y[string.lower(res)] <= 0) then
							costs = 0
						end
						local _, _, cost = ZShelter.CreateLabel(elem, nextX + (icosize / 3), yaxis + icosize * 0.8, costs, "ZShelter-MenuLarge", Color(200, 200, 200, 255))
						cost:CentHor()
					end

					local _sx = ScreenScaleH(26)
					local _sx2 = ScreenScaleH(16)
					local _x = modelViewer:GetWide() + innermargin
					local damage = y.tdata.damage || 0
					local upgradecount = y.tdata.upgradecount || 0
					elem.Paint = function()
						draw.RoundedBox(0, 0, 0, elem:GetWide(), elem:GetTall(), Color(30, 30, 30, 100))
						surface.SetDrawColor(255, 255, 255, 255)

						local _y = th + dockmargin * 1.5
						surface.SetMaterial(health_mat)
						surface.DrawTexturedRect(_x, _y, _sx2, _sx2)
						draw.DrawText(y.health, "ZShelter-MenuUpgrade", _x + _sx2, _y, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)

						_y = _y + _sx2
						surface.SetMaterial(attack)
						surface.DrawTexturedRect(_x, _y, _sx2, _sx2)
						draw.DrawText(damage, "ZShelter-MenuUpgrade", _x + _sx2, _y, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)

						_y = _y + _sx2

						surface.SetMaterial(upgrade)
						surface.DrawTexturedRect(_x, _y, _sx2, _sx2)
						draw.DrawText(upgradecount, "ZShelter-MenuUpgrade", _x + _sx2, _y, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
					end

				local btn = ZShelter.InvisButton(elem, 0, 0, elem:GetWide(), elem:GetTall(), function()
					if(!elem.CanBuild) then return end
					ZShelter.IsRequirementMeet(LocalPlayer(), y)
					ZShelter:CreatePreview(y.model, y.offset, order[k], x, y.tdata)
					ZShelter.PlaySound("sound/shigure/build_select.wav")
					ui:Remove()
				end)
				btn.Paint = function()
					if(current >= maximum && maximum != -1) then
						draw.RoundedBox(0, 0, 0, elem:GetWide(), elem:GetTall(), Color(0, 0, 0, 200))
						return
					end
					if(!elem.CanBuild) then
						draw.RoundedBox(0, 0, 0, elem:GetWide(), elem:GetTall(), Color(60, 20, 20, 120))
					end

					local _x = innermargin
					if(y.finddata) then
						surface.SetMaterial(blueprint)
						if(GetGlobalBool("BP_"..y.title, false)) then
							surface.SetDrawColor(255, 255, 255, 255)
						else
							surface.SetDrawColor(255, 50, 50, 255)
						end
						surface.DrawTexturedRect(_x, elem:GetTall() - (innermargin + _sx), _sx, _sx)
						_x = _x + (_sx + innermargin)
					end
					surface.SetDrawColor(255, 255, 255, 255)
					if(y.specialreq) then
						for _, skill in pairs(y.specialreq) do
							if(!ZShelter.SkillDatas[skill]) then
								surface.SetMaterial(warning)
								surface.DrawTexturedRect(_x, elem:GetTall() - (innermargin + _sx), _sx, _sx)
							else
								surface.SetMaterial(ZShelter.SkillDatas[skill].icon)
								surface.DrawTexturedRect(_x, elem:GetTall() - (innermargin + _sx), _sx, _sx)
							end
							_x = _x + (_sx + innermargin)
						end
					end
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

--[[
			for x,y in next, v do
				if(!listPos[k][y.sort]) then
					listPos[k][y.sort] = 0
				end
				local elem = ZShelter.CreatePanel(pa, listPos[k][y.sort] * (elemWide + dockmargin), y.sort * (elemTall + dockmargin), elemWide, elemTall, Color(0, 0, 0, 100))
				elem.NextCheck = 0
				elem.CanBuild = false
				elem.Think = function()
					if(elem.NextCheck > CurTime()) then return end
					elem.CanBuild = ZShelter.IsRequirementMeet(LocalPlayer(), y)
					elem.NextCheck = CurTime() + 0.15
				end
				local _text = ZShelter_GetTranslate("#"..y.title)
				local current, maximum = 0, 1
				local tw, th, text = ZShelter.CreateLabel(elem, innermargin, innermargin, _text, "ZShelter-MenuSmall", Color(200, 200, 200, 255))
				if(y.tdata && y.tdata.maxamount) then
					maximum = y.tdata.maxamount
					local idx = "Build_"..y.title
					text.Think = function()
						current = GetGlobalInt(idx)
						text.UpdateText(_text.." ["..current.."/"..maximum.."]")
					end
				end
				local modelViewer = elem:Add("DModelPanel")
					modelViewer:SetPos(0, (th + innermargin))
					modelViewer:SetSize(elem:GetWide() * 0.33, elem:GetTall() - (th + innermargin))
					modelViewer:SetModel(y.model)
					modelViewer.Entity:SetPos(modelViewer.Entity:GetPos() + y.offset)
					local mins, maxs = modelViewer.Entity:GetModelBounds()
					local dst = mins:Distance(maxs)
					local campos = modelViewer:GetCamPos()
					modelViewer:SetCamPos(campos + Vector(0, math.max(dst - 80, 0), 0))
					modelViewer.oPaint = modelViewer.Paint
					modelViewer.Paint = function(...)
						draw.RoundedBox(0, 0, 0, elem:GetWide(), elem:GetTall(), Color(50, 50, 50, 120))
						modelViewer.oPaint(...)
					end

					local _sx = ScreenScaleH(14)
					elem.Paint = function()
						draw.RoundedBox(0, 0, 0, elemWide, elemTall, Color(40, 40, 40, 150))
						draw.RoundedBox(0, 0, 0, elemWide, th + innermargin, Color(0, 0, 0, 220))
						surface.SetDrawColor(255, 255, 255, 255)
						local _x = modelViewer:GetWide() + innermargin
						if(y.specialreq) then
							for _, skill in pairs(y.specialreq) do
								if(!ZShelter.SkillDatas[skill]) then
									surface.SetMaterial(warning)
									surface.DrawTexturedRect(_x, elem:GetTall() - (innermargin + _sx), _sx, _sx)
								else
									surface.SetMaterial(ZShelter.SkillDatas[skill].icon)
									surface.DrawTexturedRect(_x, elem:GetTall() - (innermargin + _sx), _sx, _sx)
								end
								_x = _x + (_sx + innermargin)
							end
						end
						if(y.shelterlvl > 0) then
							draw.DrawText(y.shelterlvl, "ZShelter-MenuSmall", elem:GetWide() - ((innermargin * 2) + th), textmargin, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)
							surface.SetMaterial(shelter)
							surface.DrawTexturedRect(elem:GetWide() - (innermargin + th), textmargin, th, th)
						end
					end

					if(y.finddata) then
						local sx = ScreenScaleH(16)
						local img = ZShelter.CreateImage(elem, modelViewer:GetWide() - sx, modelViewer:GetY() + modelViewer:GetTall() - sx, sx, sx, "zsh/icon/blueprint.png")
						img.Think = function()
							if(GetGlobalBool("BP_"..y.title, false)) then
								img:SetImageColor(Color(255, 255, 255, 255))
							else
								img:SetImageColor(Color(255, 50, 50, 255))
							end
						end
					end

					local twide = elem:GetWide() - (dockmargin * 2)
					local nextX = modelViewer:GetWide() + ScreenScaleH(6)
					local yaxis = elem:GetTall() * 0.25
					local icosize = ScreenScaleH(28)
					for xpos, res in next, resources do
						local icon = ZShelter.CreateImage(elem, nextX, yaxis, sx, sx, "zsh/icon/"..string.lower(res)..".png")
						local nwstr = costscl[res]	
						local scale = 1
						if(nwstr) then
							scale = LocalPlayer():GetNWFloat(nwstr, 1)
						end
						local costs = math.floor(math.max(y[string.lower(res)] * scale, 1))
						if(res == "Powers" && y[string.lower(res)] <= 0) then
							costs = 0
						end
						local _, _, cost = ZShelter.CreateLabel(elem, nextX + (icosize / 2), yaxis + icosize, costs, "ZShelter-MenuSmall", Color(200, 200, 200, 255))
						cost:CentHor()
						nextX = nextX + icosize + dockmargin * 2
					end

				local btn = ZShelter.InvisButton(elem, 0, 0, elem:GetWide(), elem:GetTall(), function()
					if(!elem.CanBuild) then return end
					ZShelter.IsRequirementMeet(LocalPlayer(), y)
					ZShelter:CreatePreview(y.model, y.offset, order[k], x, y.tdata)
					ui:Remove()
				end)
				btn.Paint = function()
					if(current >= maximum) then
						draw.RoundedBox(0, 0, 0, elem:GetWide(), elem:GetTall(), Color(0, 0, 0, 200))
						return
					end
					if(!elem.CanBuild) then
						draw.RoundedBox(0, 0, 0, elem:GetWide(), elem:GetTall(), Color(60, 20, 20, 120))
					end
				end
				listPos[k][y.sort] = listPos[k][y.sort] + 1
			end
]]
			ui.container.AddPanel(pa)

			local btn = ZShelter.InvisButton(base, 0, 0, w, h, function()
				ui.container.CurrentPanel = pa
				ui.PersonalResources = !(k == #order)

				lasttab = k
			end)

		if(k == lasttab) then
			ui.container.CurrentPanel = pa
		end
	end

	ZShelter.BuildUI = ui
	ZShelter.AddMenu(ui)
end
