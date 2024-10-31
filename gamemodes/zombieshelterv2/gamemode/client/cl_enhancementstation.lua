net.Receive("ZShelter-OpenEnhancementStation", function()
	ZShelter.EnhancementStationOpen()
end)

surface.CreateFont("ZShelter-Enhancement-Title", {
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

surface.CreateFont("ZShelter-Enhancement-Title-2x", {
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

surface.CreateFont("ZShelter-Enhancement-Desc", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(12),
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

local resources = {
	[1] = "Woods",
	[2] = "Irons",
}
function ZShelter.CreateEnhancementPanel(parent, wep)
	local smargin = 0
	local yoffset = ScreenScaleH(3)
	local sidemargin = ScreenScaleH(20)
	local sx = ScreenScaleH(32)
	local outlineSize = 1
	local dockmargin = ScreenScaleH(4)
	local innermargin = ScreenScaleH(2)
	local textmargin = ScreenScaleH(1)
	local ui = ZShelter.CreatePanel(parent, 0, 0, parent:GetWide(), parent:GetTall(), Color(30, 30, 30, 255))
	ui.Alpha = 0
	ui.Think = function()
		if(!ui.Exiting) then
			ui.Alpha = math.Clamp(ui.Alpha + ZShelter.GetFixedValue(15), 0, 255)
		else
			ui.Alpha = math.Clamp(ui.Alpha - ZShelter.GetFixedValue(15), 0, 255)
			if(ui.Alpha <= 0) then
				ui:Remove()
			end
		end
		ui:SetAlpha(ui.Alpha)
	end

	local _, _, title = ZShelter.CreateLabel(ui, dockmargin, dockmargin, "Upgrading : "..wep:GetPrintName(), "ZShelter-Enhancement-Title", Color(200, 200, 200, 255))
	local upperSpace = title:GetY() + title:GetTall() + dockmargin
	local upgradeScroll = ZShelter.CreateScroll(ui, dockmargin, upperSpace, ui:GetWide() - dockmargin * 2, ui:GetTall() - (upperSpace + dockmargin + ScreenScaleH(32)), Color(10, 10, 10, 85))

	local squareRadius = ScreenScaleH(10)
	local outline = ScreenScaleH(1)
	local sx = ScreenScaleH(16)

	for index, enh in ipairs(ZShelter.Enhancements.Buffs) do
		if(enh.condfunc && !enh.condfunc(wep)) then continue end
		local basepnl = ZShelter.CreatePanel(upgradeScroll, 0, 0, upgradeScroll:GetWide(), upgradeScroll:GetTall() * 0.2, Color(10, 10, 10, 255))
		basepnl:Dock(TOP)
		basepnl:DockMargin(0, 0, 0, dockmargin)

		local nextX = upgradeScroll:GetWide() - sx - dockmargin * 2
		local pnl = ZShelter.CreatePanel(basepnl, 0, 0, upgradeScroll:GetWide(), upgradeScroll:GetTall() * 0.1, Color(20, 20, 20, 255))
		local basey = pnl:GetTall()
		local _, _, title = ZShelter.CreateLabel(pnl, dockmargin, pnl:GetTall() * 0.5, enh.name, "ZShelter-Enhancement-Title-2x", Color(200, 200, 200, 255))
		local _, _, desc = ZShelter.CreateLabel(basepnl, dockmargin, basey + (basepnl:GetTall() - pnl:GetTall()) * 0.5, enh.desc, "ZShelter-Enhancement-Desc", Color(200, 200, 200, 255))
		title.CentVer()
		desc.CentVer()
		local resourcesCostX = title:GetX() + title:GetWide() + dockmargin
		local upgradeCount = wep:GetNWInt("UG_"..enh.name, 0)

		local y = pnl:GetTall() * 0.5 - (squareRadius * 0.5)
		local btn = ZShelter.InvisButton(pnl, 0, 0, pnl:GetWide(), pnl:GetTall(), function()
			net.Start("ZShelter-EnhancementStationUpgrade")
				net.WriteInt(index, 32)
				net.WriteEntity(wep)
			net.SendToServer()
		end)
		local costLabels = {}
		local cost = ZShelter.Enhancements.CalculateCost(wep, enh)

		for xpos, res in next, resources do
			local icon = ZShelter.CreateImage(basepnl, nextX, basey, sx, sx, "zsh/icon/"..string.lower(res)..".png")
			local _, _, _cost = ZShelter.CreateLabel(basepnl, nextX + (sx / 2), basey + sx, cost, "ZShelter-MenuSmall", Color(200, 200, 200, 255))
			_cost:CentHor()
			_cost.Think = function()
				if(GetGlobalInt(res, 0) < cost) then
					_cost:SetTextColor(Color(255, 55, 55, 255))
				else
					_cost:SetTextColor(Color(255, 255, 255, 255))
				end
			end
			table.insert(costLabels, _cost)
			nextX = nextX - sx - dockmargin * 2
		end

		btn.Alpha = 0
		btn.Paint = function()
			upgradeCount = wep:GetNWInt("UG_"..enh.name, 0)
			cost = ZShelter.Enhancements.CalculateCost(wep, enh)
			if(btn:IsHovered()) then
				btn.Alpha = math.Clamp(btn.Alpha + ZShelter.GetFixedValue(2), 0, 20)
			else
				btn.Alpha = math.Clamp(btn.Alpha - ZShelter.GetFixedValue(2), 0, 20)
			end
			draw.RoundedBox(0, 0, 0, btn:GetWide(), btn:GetTall(), Color(255, 255, 255, btn.Alpha))

			for _, l in ipairs(costLabels) do
				l.UpdateText(cost)
			end

			local startX = btn:GetWide() - (squareRadius + dockmargin)
			surface.SetDrawColor(255, 255, 255, 255)
			for i = 1, enh.maxUpgrade do
				if(i > upgradeCount) then
					surface.DrawOutlinedRect(startX, y, squareRadius, squareRadius, outline)
				else
					draw.RoundedBox(0, startX, y, squareRadius, squareRadius, color_white)
				end
				startX = startX - (squareRadius + dockmargin)
			end
		end
	end

	local type = "Close"
	local base = ZShelter.CreatePanel(ui, dockmargin, ui:GetTall() - (ui:GetTall() * 0.065 + dockmargin), ui:GetWide() * 0.125, ui:GetTall() * 0.065, Color(40, 40, 40, 255))
	local w, h = base:GetSize()
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
			ui.Exiting = true
		end)
end

function ZShelter.EnhancementStationOpen()
	if(IsValid(ZShelter.EnhancementStation)) then
		return
	end
	local ui = ZShelter.CreatePanel(nil, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 120))
	ui:MakePopup()
	local tall = ScreenScaleH(32)
	local scl = 0.25
	ui.ResourceDisplayer = ZShelter.CreatePanel(ui, ScrW() * ((1 - scl) / 2), ScrH() - tall, ScrW() * scl, tall, Color(0, 0, 0, 200))
	local smargin = 0
	local yoffset = ScreenScaleH(3)
	local sidemargin = ScreenScaleH(20)
	local sx = ScreenScaleH(32)
	local outlineSize = 1
	local dockmargin = ScreenScaleH(4)
	local innermargin = ScreenScaleH(2)
	local textmargin = ScreenScaleH(1)

	local scl = 0.15
	local scroll = ZShelter.CreateScroll(ui, ScrW() * scl, ScrH() * scl, ScrW() * (1 - (scl * 2)), ScrH() * (1 - (scl * 2)), Color(30, 30, 30, 85))

	for k,v in ipairs(LocalPlayer():GetWeapons()) do
		local pnl = ZShelter.CreatePanel(scroll, 0, 0, scroll:GetWide(), scroll:GetTall() * 0.1, Color(30, 30, 30, 255))
		pnl:Dock(TOP)
		pnl:DockMargin(0, 0, 0, dockmargin)

		local _, _, title = ZShelter.CreateLabel(pnl, dockmargin, pnl:GetTall() * 0.5, v:GetPrintName(), "ZShelter-Enhancement-Title", Color(200, 200, 200, 255))
		title.CentVer()

		local btn = ZShelter.InvisButton(pnl, 0, 0, pnl:GetWide(), pnl:GetTall(), function()
			ZShelter.CreateEnhancementPanel(scroll, v)
		end)
		btn.Alpha = 0
		btn.Paint = function()
			if(btn:IsHovered()) then
				btn.Alpha = math.Clamp(btn.Alpha + ZShelter.GetFixedValue(5), 0, 50)
			else
				btn.Alpha = math.Clamp(btn.Alpha - ZShelter.GetFixedValue(5), 0, 50)
			end
			draw.RoundedBox(0, 0, 0, btn:GetWide(), btn:GetTall(), Color(255, 255, 255, btn.Alpha))
		end
	end

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
	local type = "Close"
	local base = ZShelter.CreatePanel(ui, dockmargin, ui:GetTall() * 0.75, ui:GetWide() * 0.125, ui:GetTall() * 0.065, Color(40, 40, 40, 255))
	local w, h = base:GetSize()
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

	ZShelter.EnhancementStation = ui
end