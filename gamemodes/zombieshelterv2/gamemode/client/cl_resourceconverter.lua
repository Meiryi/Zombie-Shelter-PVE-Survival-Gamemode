local currentResourceConverterEntity = nil

surface.CreateFont("ZShelter-ResourceConverterArrow", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(32),
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

surface.CreateFont("ZShelter-ResourceConverterDesposit", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(32),
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

net.Receive("ZShelter_ResourceConverterUI", function()
	local ent = net.ReadEntity()
	if(!IsValid(ent)) then return end
	currentResourceConverterEntity = ent
	ZShelter.ResourceConverterUI()
end)

local elems = {
	{
		source = "Woods",
		target = "Irons",
		require = 2,
		produce = 1,
	},
	{
		source = "Irons",
		target = "Woods",
		require = 2,
		produce = 1,
	},
}

function ZShelter.ResourceConverterUI()
	if(IsValid(ZShelter.ResourceConverterPanel)) then
		return
	end
	local ui = ZShelter.CreatePanel(nil, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 120))
	ui:MakePopup()
	local tall = ScreenScaleH(32)
	local scl = 0.25
	ui.Think = function()
		if(!IsValid(currentResourceConverterEntity)) then
			ui:Remove()
		end
	end
	ui.PersonalResources = true
	ui.ResourceDisplayer = ZShelter.CreatePanel(ui, ScrW() * ((1 - scl) / 2), ScrH() - tall, ScrW() * scl, tall, Color(0, 0, 0, 200))
	local smargin = 0
	local yoffset = ScreenScaleH(3)
	local sidemargin = ScreenScaleH(20)
	local sx = ScreenScaleH(32)
	local outlineSize = 1
	local dockmargin = ScreenScaleH(4)
	local innermargin = ScreenScaleH(2)
	local textmargin = ScreenScaleH(1)

	local scl = 0.2
	local inner = ZShelter.CreatePanel(ui, ScrW() * scl, ScrH() * scl, ScrW() * (1 - (scl * 2)), ScrH() * (1 - (scl * 2)), Color(30, 30, 30, 85))

	local linemargin = ScreenScaleH(32)
	local nextgap = ScreenScaleH(16)
	local linetall = ScreenScaleH(64)
	local linewide = inner:GetWide() - (linemargin * 2)

	local totalTall = #elems * linetall + (nextgap * (#elems - 1))
	local startY = (inner:GetTall() - totalTall) / 2

	local imagesize = ScreenScaleH(28)
	local bartall = ScreenScaleH(8)
	local desposit_amount = {
		2, 4, 8
	}
	for _, resdata in ipairs(elems) do
		local line = ZShelter.CreatePanel(inner, linemargin, startY, linewide, linetall, Color(30, 30, 30, 200))
		local img1 = ZShelter.CreateImage(line, dockmargin, dockmargin, imagesize, imagesize, "zsh/icon/"..resdata.source:lower()..".png")
		local _, _, requirement = ZShelter.CreateLabel(line, img1:GetX() + imagesize * 0.5, img1:GetY() + img1:GetTall() + innermargin, "x"..resdata.require, "ZShelter-MenuLarge", Color(200, 200, 200, 255), false, Color(100, 100, 100, 255))
		requirement:CentHor()
		local img2 = ZShelter.CreateImage(line, linewide - (imagesize + dockmargin), dockmargin, imagesize, imagesize, "zsh/icon/"..resdata.target:lower()..".png")
		local _, _, requirement = ZShelter.CreateLabel(line, img2:GetX() + imagesize * 0.5, img2:GetY() + img2:GetTall() + innermargin, "x"..resdata.produce, "ZShelter-MenuLarge", Color(200, 200, 200, 255), false, Color(100, 100, 100, 255))
		requirement:CentHor()

		local _, _, arrow = ZShelter.CreateLabel(line, linewide * 0.5, line:GetTall() * 0.5 - dockmargin, ">>", "ZShelter-ResourceConverterArrow", Color(200, 200, 200, 255))
		arrow:CentPos()
		local _, _, count = ZShelter.CreateLabel(line, dockmargin * 2 + imagesize, dockmargin, "(x"..(0)..")", "ZShelter-MenuLarge", Color(200, 200, 200, 255))
		local progressBar = ZShelter.CreatePanel(line, dockmargin, line:GetTall() - (bartall + dockmargin), linewide - dockmargin * 2, bartall, Color(0, 0, 0, 200))
		local start_x = count:GetX()
		local start_y = count:GetY() + count:GetTall() + dockmargin
		local buttonwide, buttontall = ScreenScaleH(30), ScreenScaleH(16)
		for _, count in ipairs(desposit_amount) do
			local btn = ZShelter.CreatePanel(line, start_x, start_y, buttonwide, buttontall, Color(40, 40, 40, 255))
			btn.Paint = function()
				surface.SetDrawColor(255, 255, 255, 255)
				surface.DrawOutlinedRect(0, 0, buttonwide, buttontall, outlineSize)
			end
			local _, _, str = ZShelter.CreateLabel(btn, buttonwide * 0.5, buttontall * 0.5, "+"..count, "ZShelter-MenuLarge", Color(200, 200, 200, 255))
			str:CentPos()
			function btn:OnMousePressed()
				net.Start("ZShelter_DepositResources")
				net.WriteEntity(currentResourceConverterEntity)
				net.WriteInt(count, 8)
				net.WriteString(resdata.source)
				net.SendToServer()
			end
			start_x = start_x + buttonwide + dockmargin
		end
		local nwstr = "r_"..resdata.source
		progressBar.Paint = function()
			count.UpdateText("("..currentResourceConverterEntity:GetNWInt(nwstr, 0).." / "..currentResourceConverterEntity:GetNWInt("Capacity", 20)..")")
			local wide = progressBar:GetWide()
			local fraction = currentResourceConverterEntity:GetNWFloat(resdata.source.."_"..resdata.target.."_fraction", 0)
			if(fraction > 0) then
				fraction = 1 - fraction
			end
			draw.RoundedBox(0, 0, 0, wide, progressBar:GetTall(), Color(15, 15, 15, 255))
			draw.RoundedBox(0, 0, 0, wide * fraction, progressBar:GetTall(), Color(255, 255, 255, 255))
		end
		startY = startY + (linetall + nextgap)
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

	ZShelter.ResourceConverterPanel = ui
end